const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const UserModel = require('../models/userModel');
const ResetCodeModel = require('../models/resetCodeModel');
const { generateToken } = require('../utils/jwtUtils');
const { sendPasswordResetCode } = require('../utils/emailUtils');
const { generateVerificationCode, getExpirationDate } = require('../utils/codeUtils');

const register = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ success: false, errors: errors.array() });
  }
  const { nombre, email, contrasena } = req.body;
  try {
    const existing = await UserModel.findByEmail(email);
    if (existing) {
      return res.status(409).json({ success: false, message: 'El correo ya está registrado' });
    }
    const salt = await bcrypt.genSalt(12);
    const contrasenaEncriptada = await bcrypt.hash(contrasena, salt);
    const newUser = await UserModel.create(nombre, email, contrasenaEncriptada);
    const token = generateToken({ id: newUser.id, email: newUser.email });
    res.status(201).json({
      success: true,
      message: 'Usuario registrado exitosamente',
      data: { user: { id: newUser.id, nombre: newUser.nombre, email: newUser.email }, token },
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
};

const login = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ success: false, errors: errors.array() });
  }
  const { email, contrasena } = req.body;
  try {
    const user = await UserModel.findByEmail(email);
    if (!user) {
      return res.status(401).json({ success: false, message: 'Credenciales incorrectas' });
    }
    const valid = await bcrypt.compare(contrasena, user.contrasena_encriptada);
    if (!valid) {
      return res.status(401).json({ success: false, message: 'Credenciales incorrectas' });
    }
    const token = generateToken({ id: user.id, email: user.email });
    res.json({
      success: true,
      message: 'Inicio de sesión exitoso',
      data: {
        user: { id: user.id, nombre: user.nombre, email: user.email, fecha_creacion: user.fecha_creacion },
        token,
      },
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
};

const requestPasswordReset = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ success: false, errors: errors.array() });
  }
  const { email } = req.body;
  try {
    const user = await UserModel.findByEmail(email);
    if (!user) {
      return res.json({ success: true, message: 'Si el correo existe, recibirás un código' });
    }
    const codigo = generateVerificationCode();
    const expiraEn = getExpirationDate(15);
    await ResetCodeModel.create(user.id, codigo, expiraEn);
    await sendPasswordResetCode(email, user.nombre, codigo);
    res.json({ success: true, message: 'Si el correo existe, recibirás un código' });
  } catch (error) {
    console.error('Reset request error:', error);
    res.status(500).json({ success: false, message: 'Error al procesar la solicitud' });
  }
};

const verifyResetCode = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ success: false, errors: errors.array() });
  }
  const { email, codigo } = req.body;
  try {
    const user = await UserModel.findByEmail(email);
    if (!user) {
      return res.status(400).json({ success: false, message: 'Código inválido o expirado' });
    }
    const resetCode = await ResetCodeModel.findValid(user.id, codigo);
    if (!resetCode) {
      return res.status(400).json({ success: false, message: 'Código inválido o expirado' });
    }
    const tempToken = generateToken({
      id: user.id,
      email: user.email,
      resetCodeId: resetCode.id,
      type: 'reset',
    });
    res.json({ success: true, message: 'Código verificado', data: { resetToken: tempToken } });
  } catch (error) {
    console.error('Verify code error:', error);
    res.status(500).json({ success: false, message: 'Error al verificar el código' });
  }
};

const changePassword = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ success: false, errors: errors.array() });
  }
  const { nuevaContrasena, resetToken } = req.body;
  try {
    let decoded;
    try {
      decoded = jwt.verify(resetToken, process.env.JWT_SECRET);
    } catch {
      return res.status(401).json({ success: false, message: 'Token inválido o expirado' });
    }
    if (decoded.type !== 'reset') {
      return res.status(401).json({ success: false, message: 'Token inválido' });
    }
    await ResetCodeModel.markAsUsed(decoded.resetCodeId);
    const salt = await bcrypt.genSalt(12);
    const hash = await bcrypt.hash(nuevaContrasena, salt);
    await UserModel.updatePassword(decoded.id, hash);
    res.json({ success: true, message: 'Contraseña actualizada exitosamente' });
  } catch (error) {
    console.error('Change password error:', error);
    res.status(500).json({ success: false, message: 'Error al cambiar la contraseña' });
  }
};

const getProfile = async (req, res) => {
  try {
    const user = await UserModel.findById(req.user.id);
    if (!user) return res.status(404).json({ success: false, message: 'Usuario no encontrado' });
    res.json({ success: true, data: { user } });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
};

const registerValidators = [
  body('nombre').trim().isLength({ min: 2, max: 100 }).withMessage('Nombre entre 2 y 100 caracteres'),
  body('email').isEmail().normalizeEmail().withMessage('Correo inválido'),
  body('contrasena').isLength({ min: 8 }).withMessage('Mínimo 8 caracteres')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/).withMessage('Debe tener mayúsculas, minúsculas y números'),
];

const loginValidators = [
  body('email').isEmail().normalizeEmail().withMessage('Correo inválido'),
  body('contrasena').notEmpty().withMessage('Contraseña requerida'),
];

const resetRequestValidators = [
  body('email').isEmail().normalizeEmail().withMessage('Correo inválido'),
];

const verifyCodeValidators = [
  body('email').isEmail().normalizeEmail().withMessage('Correo inválido'),
  body('codigo').isLength({ min: 6, max: 6 }).isNumeric().withMessage('Código de 6 dígitos requerido'),
];

const changePasswordValidators = [
  body('nuevaContrasena').isLength({ min: 8 }).withMessage('Mínimo 8 caracteres')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/).withMessage('Debe tener mayúsculas, minúsculas y números'),
  body('resetToken').notEmpty().withMessage('Token requerido'),
];

module.exports = {
  register, registerValidators,
  login, loginValidators,
  requestPasswordReset, resetRequestValidators,
  verifyResetCode, verifyCodeValidators,
  changePassword, changePasswordValidators,
  getProfile,
};