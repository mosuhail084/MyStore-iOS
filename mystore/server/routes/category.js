const express = require('express')
const db = require('../db')
const utils = require('../utils')
const router = express.Router()

router.get('/', (request, response) => {
  db.pool.query(
    'select id, title, description from categories',
    [],
    (error, categories) => {
      response.send(utils.createResult(error, categories))
    }
  )
})

router.post('/', (request, response) => {
  const { title, description } = request.body

  db.pool.query(
    'insert into categories (title, description) values (?, ?)',
    [title, description],
    (error, categories) => {
      response.send(utils.createResult(error, categories))
    }
  )
})

module.exports = router
