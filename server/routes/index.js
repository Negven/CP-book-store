const Router = require("express");
const router = new Router();
const bookRouter = require("./bookRouter");
const userRouter = require("./userRouter");
const authorRouter = require("./authorRouter");
const genreRouter = require("./genreRouter");
const basketRouter = require("./basketRouter");
const basketBookRouter = require("./basketBookRouter");
const orderRouter = require("./ordertRouter");
const orderItemRouter = require("./orderItemRouter");

router.use('/user', userRouter);
router.use('/author', authorRouter);
router.use('/genre', genreRouter);
router.use('/book', bookRouter);
router.use('/basket', basketRouter);
router.use('/basketBook', basketBookRouter);
router.use('/order', orderRouter);
router.use('/orderItem', orderItemRouter);

module.exports = router;