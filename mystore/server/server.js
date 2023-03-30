const express = require('express')
const cors = require('cors')
const morgan = require('morgan')

const app = express()
app.use(cors('*'))
app.use(express.json({ limit: '20mb' }))
app.use(express.urlencoded({ limit: '20mb' }))
app.use(morgan('combined'))
app.use(express.static('images'))

// add all the routes
const userRouter = require('./routes/users')
const companyRouter = require('./routes/company')
const categoryRouter = require('./routes/category')
const orderRouter = require('./routes/order')
const productRouter = require('./routes/product')

app.use('/user', userRouter)
app.use('/company', companyRouter)
app.use('/category', categoryRouter)
app.use('/order', orderRouter)
app.use('/product', productRouter)

app.listen(3000, '0.0.0.0', () => {
  console.log('server started on port 3000')
})
