const crypto = require('crypto');

const generateVerificationCode = () => {
  return crypto.randomInt(100000, 999999).toString();
};

const getExpirationDate = (minutes = 15) => {
  const date = new Date();
  date.setMinutes(date.getMinutes() + minutes);
  return date.toISOString().replace('T', ' ').substring(0, 19);
};

module.exports = { generateVerificationCode, getExpirationDate };