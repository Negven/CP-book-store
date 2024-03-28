const Router = require("express");
const router = new Router();
const basketBookController = require("../controllers/basketBookController")
const authMiddleware = require("../middleware/authMiddleware")
const bookController = require("../controllers/bookController");

router.get('/', authMiddleware, basketBookController.getAllByBasketId);
router.post('/', authMiddleware, basketBookController.create);
router.delete('/:id', authMiddleware, basketBookController.delete);

module.exports = router;