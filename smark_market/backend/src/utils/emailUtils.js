const nodemailer = require('nodemailer');

const createTransporter = () => {
  return nodemailer.createTransport({
    host: process.env.EMAIL_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.EMAIL_PORT) || 587,
    secure: false,
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });
};

const sendPasswordResetCode = async (email, nombre, codigo) => {
  const transporter = createTransporter();

  const mailOptions = {
    from: process.env.EMAIL_FROM || 'Smart Market <noreply@smartmarket.com>',
    to: email,
    subject: 'Smart Market - Código de recuperación de contraseña',
    html: `
      <!DOCTYPE html>
      <html>
        <head><meta charset="utf-8"></head>
        <body style="font-family:Arial,sans-serif;background:#0a0a0a;color:#fff;margin:0;padding:20px;">
          <div style="max-width:500px;margin:0 auto;background:#111;border-radius:12px;padding:40px;border:1px solid #222;">
            <div style="font-size:24px;font-weight:bold;color:#00C853;margin-bottom:30px;">Smart Market</div>
            <h2>Recuperación de contraseña</h2>
            <p>Hola <strong>${nombre}</strong>,</p>
            <p>Usa el siguiente código de verificación:</p>
            <div style="background:#00C853;color:#000;font-size:36px;font-weight:bold;text-align:center;padding:20px;border-radius:8px;letter-spacing:8px;margin:30px 0;">
              ${codigo}
            </div>
            <p>Válido por <strong>15 minutos</strong>. Si no solicitaste esto, ignora este correo.</p>
          </div>
        </body>
      </html>
    `,
  };

  await transporter.sendMail(mailOptions);
};

module.exports = { sendPasswordResetCode };