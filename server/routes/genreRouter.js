const Router = require("express");
const router = new Router();
const genreController = require('../controllers/genreController')
const checkRole = require("../middleware/checkRoleMiddleware");

router.post('/', checkRole("ADMIN"), genreController.create)
router.get('/', genreController.getAll)

module.exports = router;