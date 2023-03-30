const mysql = require('mysql2')

const pool = mysql.createPool({
  user: 'root',
  password: 'root',
  database: 'mystore',
  port: 3306,
  host: 'localhost',
})

module.exports = {
  pool,
}
