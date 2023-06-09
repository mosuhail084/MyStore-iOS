const nodemailer = require('nodemailer')

function sendEmail(email, subject, body, callback) {
  // connecting to the smtp server
  const transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    secure: true,
    port: 465,
    auth: {
      user: '',
      pass: '',
    },
  })

  const mailOptions = {
    from: 'Suhail',
    to: email,
    subject: subject,
    html: body,
  }

  transporter.sendMail(mailOptions, function (error, info) {
    callback(error, info)
  })
}

module.exports = {
  sendEmail: sendEmail,
}
