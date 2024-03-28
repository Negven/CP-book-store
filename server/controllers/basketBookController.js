const {BasketBook, Book, Basket, Author, Genre, User} = require("../models/models");
const uuid = require("uuid");
const path = require("path");
const ApiError = require("../error/ApiError");
const {where} = require("sequelize");
const jwt = require("jsonwebtoken");

const generateJwt = (id, email, role) => {
    return  jwt.sign(
        {id, email, role},
        process.env.SECRET_KEY,
        {expiresIn: "24h"})
}

class BasketBookController {
    async getAllByBasketId(req, res){
        let {basketId, limit, page} = req.query;
        page = page || 1
        limit = limit || 9
        let basket = await BasketBook.findAndCountAll({where: {basketId}})
        for (const basketBook of basket.rows) {
            const book = await Book.findOne({where: {id: basketBook.bookId}});
            const author = await Author.findOne({where: {id: book.dataValues.authorId}})
            const genre = await Genre.findOne({where: {id: book.dataValues.genreId}})
            book.dataValues.authorName =author.dataValues.name
            book.dataValues.genreName = genre.dataValues.name
            basketBook.dataValues.book = book;
        }
        basket["page"] = page;
        basket["limit"] = limit;

        return res.json(basket);
    }

    async create(req, res, next) {
        try {
            const {bookId, basketId} = req.body;
            const book = await Book.findOne({where: bookId});
            const basket = await Basket.findOne({where: basketId});
            if(!book) {
                return next(ApiError.badRequest("Book didn`t find"))
            }
            if(!basket) {
                return next(ApiError.badRequest("Basket didn`t find"))
            }
            const basketBook = await  BasketBook.create({bookId, basketId})
            const user = await  User.findOne({where: {id: basketId}});
            const token = generateJwt(user.id, user.email, user.role)
            return res.json({message: { token: token, state: "granted", userId: user.id}});
        } catch (e) {
            next(ApiError.badRequest(e.message));
        }
    }

    async delete(req, res) {
        const {id} = req.params
        console.log(id);
        const ans = await BasketBook.destroy({where: {id}});
        return res.json({message: {state: "granted"}});
    }
}

module.exports = new BasketBookController();