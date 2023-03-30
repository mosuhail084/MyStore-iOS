const express = require('express')
const db = require('../db')
const utils = require('../utils')
const router = express.Router()
const multer = require('multer')

// upload the files in the images directory
const upload = multer({ dest: 'images' })

router.get('/', (request, response) => {
  db.pool.query(
    'select p.id, p.title, p.description, price, categoryId, companyId, image, companies.companyName, categories.title as categoryTitle from products p, companies, categories  where companies.id = p.companyId and categories.id  = p.categoryId;',
    [],
    (error, products) => {
      response.send(utils.createResult(error, products))
    }
  )
})


router.post('/', upload.single('image'), (request, response) => {
  const { title, description, price, categoryId, companyId } = request.body

  // when multer uploads the file, it generates a unique file
  const image = request.file.filename

  db.pool.query(
    'insert into products (title, description, price, categoryId, companyId, image) values (?, ?, ?, ?, ?, ?)',
    [title, description, price, categoryId, companyId, image],
    (error, products) => {
      response.send(utils.createResult(error, products))
    }
  )
})

router.put('/:id', (request, response) => { })
router.delete('/:id', (request, response) => { })

router.post('/search', (request, response) => { })

module.exports = router
