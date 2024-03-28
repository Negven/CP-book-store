const Router = require("express");
const router = new Router();
const orderController = require("../controllers/orderController")
const authMiddleware = require("../middleware/authMiddleware")

router.get('/:id', authMiddleware, orderController.getOne);
router.post('/', orderController.create)

module.exports = router;