const mongoose = require('mongoose');

// Define the Schema for a chocolate product
const chocolateProductSchema = new mongoose.Schema({
    productName: {
        type: String, // The product name should be a string
        required: true, // This field is required
    },
    productPrice: {
        type: Number, // The product price should be a number
        required: true, // This field is required
    },
    productImage: {
        type: String, // The image URL should be a string
        required: false, // This field is optional
    },
    category: {
        type: String, // The category (e.g., chocolate) should be a string
        default: 'chocolate', // Default value if not provided
    }
});

// Create the model based on the schema
const ChocolateProduct = mongoose.model('ChocolateProduct', chocolateProductSchema);

// Export the model to use in other files
module.exports = ChocolateProduct;
