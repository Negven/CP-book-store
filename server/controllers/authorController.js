const {Author} = require("../models/models");

class AuthorController {
    async create(req, res){
        const {name} = req.body
        const author = await  Author.create({name});
        return res.json(author);
    }

    async getAll(req, res){
        const author = await Author.findAll()
        return res.json(author);
    }
}

module.exports = new AuthorController();