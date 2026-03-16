const db = require('../config/database');

class UserModel {
  static findByEmail(email) {
    return new Promise((resolve, reject) => {
      db.get(
        'SELECT * FROM users WHERE email = ? AND activo = 1',
        [email],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        }
      );
    });
  }

  static findById(id) {
    return new Promise((resolve, reject) => {
      db.get(
        'SELECT id, nombre, email, fecha_creacion FROM users WHERE id = ? AND activo = 1',
        [id],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        }
      );
    });
  }

  static create(nombre, email, contrasenaEncriptada) {
    return new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO users (nombre, email, contrasena_encriptada) VALUES (?, ?, ?)',
        [nombre, email, contrasenaEncriptada],
        function (err) {
          if (err) reject(err);
          else resolve({ id: this.lastID, nombre, email });
        }
      );
    });
  }

  static updatePassword(userId, nuevaContrasenaEncriptada) {
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE users SET contrasena_encriptada = ? WHERE id = ?',
        [nuevaContrasenaEncriptada, userId],
        function (err) {
          if (err) reject(err);
          else resolve(this.changes > 0);
        }
      );
    });
  }
}

module.exports = UserModel;