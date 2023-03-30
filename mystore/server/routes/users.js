const express = require('express')
const router = express.Router()
const db = require('../db')
const utils = require('../utils')
const cryptoJs = require('crypto-js')
const mailer = require('../mailer')
const multer = require('multer')
const upload = multer({ dest: 'images' })

router.post('/signup', (request, response) => {
  const { firstName, lastName, email, password } = request.body
  const encryptedPassword = String(cryptoJs.MD5(password))

  db.pool.query(
    `insert into users (firstName, lastName, email, password) values (?, ?, ?, ?)`,
    [firstName, lastName, email, encryptedPassword],
    (error, result) => {
      const body = `
        <html>
          <body>
            Hi ${firstName},
            <br/>
            <br/>
            Welcome to MyStore. We hope this would be your wonderful journey with us.
            Blah Blah Blah...

            <br/>
            <br/>
            Thank you.
          </body>
        </html>
      `
      mailer.sendEmail(email, 'Welcome to MyStore', body, () => {
        response.send(utils.createResult(error, result))
      })
    }
  )
})

router.post('/signin', (request, response) => {
  const { email, password } = request.body
  const encryptedPassword = String(cryptoJs.MD5(password))

  db.pool.query(
    `select id, firstName, lastName from users where email = ? and password = ?`,
    [email, encryptedPassword],
    (error, users) => {
      if (error) {
        response.send(utils.createErrorResult(error))
      } else {
        // check if user exists
        if (users.length == 0) {
          // user does not exist
          response.send(utils.createErrorResult('user does not exist'))
        } else {
          // get the user details
          const user = users[0]
          response.send(utils.createSuccessResult(user))
        }
      }
    }
  )
})

router.post(
  '/upload-image/:id',
  upload.single('image'),
  (request, response) => {
    const { id } = request.params
    const image = request.file.filename

    db.pool.query(
      `update users set image = ? where id = ?`,
      [image, id],
      (error, result) => {
        response.send(utils.createResult(error, result))
      }
    )
  }
)

router.get('/profile/:id', (request, response) => {
  const { id } = request.params
  db.pool.query(
    `select id, firstName, lastName, email, image, address1, address2, address3, city, zipcode from users where id = ?`,
    [id],
    (error, users) => {
      if (error) {
        response.send(utils.createErrorResult(error))
      } else {
        // check if user exists
        if (users.length == 0) {
          // user does not exist
          response.send(utils.createErrorResult('user does not exist'))
        } else {
          // get the user details
          const user = users[0]
          response.send(utils.createSuccessResult(user))
        }
      }
    }
  )
})

router.post('/profile-image', (request, response) => { })

router.post('/reset-password', (request, response) => {
  const { email, password } = request.body
  const encryptedPassword = String(cryptoJs.MD5(password))

  db.pool.query(
    `update users set password = ? where email = ?`,
    [encryptedPassword, email],
    (error, result) => {
      const body = `
        <html>
          <body>
            Hi,
            <br/>
            <br/>
            We have successfully changed your password in our App.
            <br/>
            <br/>
            Thank you.
          </body>
        </html>
      `
      mailer.sendEmail(email, 'Password changed successfully', body, () => {
        response.send(utils.createResult(error, result))
      })
    }
  )
})

router.post('/forgot-password', (request, response) => {
  const { email } = request.body
  const otp = '12345'
  const body = `
    <html>
      <body>
        Hi,
        <br/>
        <br/>
        Following is your OTP to reset the password
        <br/>
        OTP: ${otp}

        <br/>
        <br/>
        Thank you.
      </body>
    </html>
  `
  mailer.sendEmail(email, 'OTP to reset your password', body, () => {
    response.send(utils.createSuccessResult({ otp }))
  })
})

module.exports = router
