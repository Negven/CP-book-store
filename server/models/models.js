const sequelize =require("../db")
const {DataTypes} = require('sequelize')

const User = sequelize.define('user', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
    email: {type: DataTypes.STRING, unique: true, allowNull: false},
    name: {type: DataTypes.STRING, allowNull: false},
    password: {type: DataTypes.STRING},
    role: {type: DataTypes.STRING, defaultValue: "USER"  }
})

const Basket = sequelize.define('basket', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
})

const BasketBook = sequelize.define('basket_book', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
})

const Order = sequelize.define('order', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
})

const OrderItem = sequelize.define('order_item', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
})

const Book = sequelize.define('book', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
    name: {type: DataTypes.STRING, unique: true, allowNull: false},
    price: {type: DataTypes.INTEGER, allowNull: false},
    rating: {type: DataTypes.INTEGER, defaultValue: 0},
    img: {type: DataTypes.STRING, allowNull: false},
    info: {type: DataTypes.STRING, allowNull: false}
})

const Author = sequelize.define('author', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
    name: {type: DataTypes.STRING, unique: true, allowNull: false},
})

const Genre = sequelize.define('genre', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
    name: {type: DataTypes.STRING, unique: true, allowNull: false},
})

const Rating = sequelize.define('rating', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
    rate: {type: DataTypes.INTEGER, allowNull: false},
})

const GenreAuthor = sequelize.define('genre_author', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
})

User.hasOne(Basket);
Basket.belongsTo(User);

User.hasMany(Order);
Order.belongsTo(User);

User.hasMany(Rating);
Rating.belongsTo(User);

Basket.hasMany(BasketBook);
BasketBook.belongsTo(Basket);

Order.hasMany(OrderItem);
OrderItem.belongsTo(Order);

Genre.hasMany(Book);
Book.belongsTo(Genre);

Author.hasMany(Book);
Book.belongsTo(Author);

Basket.hasMany(BasketBook)
BasketBook.belongsTo(Basket)

Book.hasMany(BasketBook)
BasketBook.belongsTo(Book)

Book.hasMany(OrderItem)
OrderItem.belongsTo(Book)

Genre.belongsToMany(Author, {through: GenreAuthor});
Author.belongsToMany(Genre, {through: GenreAuthor});

module.exports = {
    User,
    Basket,
    BasketBook,
    Book,
    Author,
    Genre,
    Rating,
    GenreAuthor,
    Order,
    OrderItem
}
