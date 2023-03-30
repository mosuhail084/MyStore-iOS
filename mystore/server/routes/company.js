const express = require('express')
const db = require('../db')
const utils = require('../utils')
const router = express.Router()

router.get('/', (request, response) => {
  db.pool.query(
    'select id, companyName, address, phone from companies',
    [],
    (error, companies) => {
      response.send(utils.createResult(error, companies))
    }
  )
})

router.post('/', (request, response) => {
  const { companyName, address, phone } = request.body

  db.pool.query(
    'insert into companies (companyName, address, phone) values (?, ?, ?)',
    [companyName, address, phone],
    (error, companies) => {
      response.send(utils.createResult(error, companies))
    }
  )
})

module.exports = router
