const db = require('../config/database');

class ResetCodeModel {
  static create(userId, codigo, expiraEn) {
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE password_reset_codes SET usado = 1 WHERE user_id = ?',
        [userId],
        () => {
          db.run(
            'INSERT INTO password_reset_codes (user_id, codigo, expira_en) VALUES (?, ?, ?)',
            [userId, codigo, expiraEn],
            function (err) {
              if (err) reject(err);
              else resolve({ id: this.lastID });
            }
          );
        }
      );
    });
  }

  static findValid(userId, codigo) {
    return new Promise((resolve, reject) => {
      db.get(
        `SELECT * FROM password_reset_codes 
         WHERE user_id = ? AND codigo = ? AND usado = 0 
         AND expira_en > datetime('now')
         ORDER BY fecha_creacion DESC LIMIT 1`,
        [userId, codigo],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        }
      );
    });
  }

  static markAsUsed(id) {
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE password_reset_codes SET usado = 1 WHERE id = ?',
        [id],
        function (err) {
          if (err) reject(err);
          else resolve(this.changes > 0);
        }
      );
    });
  }
}

module.exports = ResetCodeModel;