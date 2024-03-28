const Router = require("express");
const router = new Router();
const basketController = require("../controllers/basketController")
const authMiddleware = require("../middleware/authMiddleware")

router.get('/:id', authMiddleware, basketController.getOne);

module.exports = router;