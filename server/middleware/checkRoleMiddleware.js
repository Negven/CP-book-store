const jwt = require("jsonwebtoken")

module.exports = function(role) {
    return function (req, res, next) {
        if (req.method === "OPTIONS") {
            next()
        }
        try {
            const token = req.headers.authorization.split(" ")[1]
            if(!token) {
                return res.status(401).json({message: "Not authorization"})
            }
            req.user = jwt.verify(token, process.env.SECRET_KEY)
            if(req.user.role !== role) {
                return  res.status(403).json({message: "Not available action fot this role"})
            }
            next();
        }catch (e) {
            return res.status(401).json({message: "Not authorization"})
        }
    }
}



