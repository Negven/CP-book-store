const uuid = require('uuid')
const path = require("path")
const {Book, Author, Genre} = require("../models/models")
const ApiError = require("../error/ApiError")
class BookController {
    async create(req, res, next){
        try {
            const {name, price, authorId, genreId, info} = req.body;
            const {img} = req.files
            let fileName = uuid.v4() + ".jpg"
            img.mv(path.resolve(__dirname, '..', 'static', fileName))
            const book = await  Book.create({name, price, authorId, genreId, img: fileName, info})
            return res.json(book);
        } catch (e) {
            next(ApiError.badRequest(e.message));
        }
    }

    async getAll(req, res){
        let {authorId, genreId, limit, page} = req.query
        page = page || 1
        limit = limit || 9
        let offset = page * limit - limit
        let books;
        if (!authorId && !genreId) {
            books = await Book.findAndCountAll({limit, offset})
        }
        if (authorId && !genreId) {
            books = await Book.findAndCountAll({where:{authorId: authorId}, limit, offset})
        }
        if (!authorId && genreId) {
            books = await Book.findAndCountAll({where:{genreId: genreId}, limit, offset})
        }
        if (authorId && genreId) {
            books = await Book.findAndCountAll({where:{genreId: genreId, authorId: authorId}, limit, offset})
        }
        for (const book of books.rows) {
            const author = await Author.findOne({where: {id: book.dataValues.authorId}})
            const genre = await Genre.findOne({where: {id: book.dataValues.genreId}})
            book.dataValues.authorName =author.dataValues.name
            book.dataValues.genreName = genre.dataValues.name
        }
        books["page"] = page;
        books["limit"] = limit;
        return res.json(books);
    }

    async getOne(req, res) {
        const {id} = req.params
        const book = await Book.findOne({where: {id}})
        const author = await Author.findOne({where: {id: book.dataValues.authorId}})
        const genre = await Genre.findOne({where: {id: book.dataValues.genreId}})
        book.dataValues.authorName =author.dataValues.name
        book.dataValues.genreName = genre.dataValues.name
        return res.json(book)
    }
}

module.exports = new BookController();