const express = require('express')
const utils = require('../utils')
const db = require('../db')
const router = express.Router()

router.get('/my/:id', (request, response) => {})

router.post('/:id', (request, response) => {
  const { products } = request.body

  console.log(products)

  response.send(utils.createSuccessResult('done'))
})

router.put('/:id', (request, response) => {})
router.delete('/:id', (request, response) => {})

module.exports = router
