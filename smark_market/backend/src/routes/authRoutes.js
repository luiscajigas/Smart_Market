const express = require('express');
const router = express.Router();
const {
  register, registerValidators,
  login, loginValidators,
  requestPasswordReset, resetRequestValidators,
  verifyResetCode, verifyCodeValidators,
  changePassword, changePasswordValidators,
  getProfile,
} = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');
const { authLimiter, resetLimiter } = require('../middleware/rateLimiter');

router.post('/register', authLimiter, registerValidators, register);
router.post('/login', authLimiter, loginValidators, login);
router.post('/password-reset/request', resetLimiter, resetRequestValidators, requestPasswordReset);
router.post('/password-reset/verify', resetLimiter, verifyCodeValidators, verifyResetCode);
router.post('/password-reset/change', resetLimiter, changePasswordValidators, changePassword);
router.get('/profile', authMiddleware, getProfile);

module.exports = router;