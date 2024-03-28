const bcrypt = require("bcrypt")
const ApiError = require("../error/ApiError")
const {User, Basket} = require("../models/models");
const jwt = require("jsonwebtoken");



class UserController {

    static generateJwt = (id, email, role) => {
        return  jwt.sign(
            {id, email, role},
            process.env.SECRET_KEY,
            {expiresIn: "24h"})
    }

    async registration(req, res, next){
        const {email, password, name, role} = req.body
        if(!email || !password  || !name) {
            return next(ApiError.badRequest({info: "Email, name or password is empty", state: "invalidCredentials"}))
        }
        const candidate = await  User.findOne({where: {email}})
        if(candidate){
            return next(ApiError.badRequest({info: "User with this email has already created", state: "invalidCredentials"} ))
        }
        const hashPassword = await bcrypt.hash(password, 5)
        const user = await User.create({email, name, role, password: hashPassword})
        const basket = await Basket.create({userId: user.id})
        const token = UserController.generateJwt(user.id,  user.email, user.role)
        return res.json({message: { token: token, state: "granted" }});
    }

    async login(req, res, next){
        const {email, password} = req.body;
        console.log(req.body);
        const user = await  User.findOne({where: {email}})
        if(!user) {

            return next({info: "User didn`t find", state: "invalidCredentials"})
        }
        let comparePassword = bcrypt.compareSync(password, user.password);
        if (!comparePassword) {
            return next(ApiError.badRequest({info: "Wrong password", state: "invalidCredentials"}))
            // return next(ApiError.badRequest("Wrong password"), {state: "invalidCredentials"});
        }
        const token = UserController.generateJwt(user.id, user.email, user.role)

        return  res.json({message: { token: token, state: "granted", userId: user.id}})
    }

    async check(req, res, next){
        const token = UserController.generateJwt(req.user.id, req.user.email, req.user.role)
        return res.json({token: token});
    }
}

module.exports = new UserController();