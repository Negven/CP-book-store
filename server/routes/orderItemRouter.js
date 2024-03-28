const Router = require("express");
const router = new Router();
const orderItemController = require("../controllers/orderItemController")
const authMiddleware = require("../middleware/authMiddleware")

router.get('/:id', authMiddleware, orderItemController.getAllByOrderId);
router.post('/', authMiddleware, orderItemController.create);

module.exports = router;