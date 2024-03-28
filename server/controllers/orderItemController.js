const {Book, Order, OrderItem} = require("../models/models");
const uuid = require("uuid");
const path = require("path");
const ApiError = require("../error/ApiError");

class OrderItemController {
    async getAllByOrderId(req, res){
        const {orderId} = req.body;
        const order = await Order.findAll({where: {orderId}})
        return res.json(order);
    }

    async create(req, res, next) {
        try {
            const {bookId, orderId} = req.body;
            const book = await Book.findOne({where: bookId});
            const order = await Order.findOne({where: orderId});
            if(!book) {
                return next(ApiError.badRequest("Book didn`t find"))
            }
            if(!order) {
                return next(ApiError.badRequest("order didn`t find"))
            }
            const orderItem = await  OrderItem.create({bookId, orderId})
            return res.json(orderItem);
        } catch (e) {
            next(ApiError.badRequest(e.message));
        }
    }
}

module.exports = new OrderItemController();