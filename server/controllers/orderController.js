const { Order, Genre} = require("../models/models");

class OrderController {

    async create(req, res){
        const {userId} = req.body
        const order = await  Genre.create({userId});
        return res.json(order);
    }

    async getOne(req, res){
        const {id} = req.body;
        const order = await Order.findOne({where: id})
        return res.json(order);
    }
}

module.exports = new OrderController();