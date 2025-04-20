const mongoose = require('mongoose');

// Define the Schema for a beauty product
const beautyProductSchema = new mongoose.Schema({
    productName: {
        type: String,
        required: true,
    },
    productPrice: {
        type: Number,
        required: true,
    },
    productImage: {
        type: String,
        required: false,
    },
    category: {
        type: String,
        default: 'beauty',
    },
    createdAt: {
        type: Date,
        default: Date.now,
    }
});

// Create the model based on the schema
const BeautyProduct = mongoose.model('BeautyProduct', beautyProductSchema);

// Export the model to use in other files
module.exports = BeautyProduct;
