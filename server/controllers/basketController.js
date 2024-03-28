const {Basket} = require("../models/models");

class BasketController {
    async getOne(req, res){
        const {id} = req.body;
        const basket = await Basket.findOne({where: id})
        return res.json(basket);
    }
}

module.exports = new BasketController();