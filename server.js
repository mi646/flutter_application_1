const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { connectDB, getDB } = require('./db');
const { ObjectId } = require('mongodb'); // ✅ Fixed: Imported ObjectId
const multer = require('multer');
const path = require('path');
const chocolateProductSchema = require('./ChocolateProduct');
const beautyProductSchema = require('./beautyProduct'); // ✅ Add this




const app = express();
const PORT = process.env.PORT || 3000; // ✅ Fixed: Used consistent PORT variable

app.use(cors());
app.use(bodyParser.json());
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));
app.use('/uploads', express.static('uploads'));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// Setup Multer storage for image uploads
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'public/uploads'); // Save uploaded files to /public/uploads
    },
    filename: function (req, file, cb) {
        const uniqueName = `${Date.now()}-${file.originalname}`;
        cb(null, uniqueName);
    }
});

const upload = multer({
    storage: storage,
    fileFilter: (req, file, cb) => {
        // Only accept image files (jpg, jpeg, png)
        const filetypes = /jpeg|jpg|png/;
        const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
        const mimetype = filetypes.test(file.mimetype);

        if (extname && mimetype) {
            return cb(null, true);
        } else {
            cb('Error: Only images are allowed');
        }
    }
});

connectDB();

//add sales into database
app.post('/api/sales', async (req, res) => {
    try {
        const db = getDB();
        const { salesAmount, salesMonth, salesCategory } = req.body;

        if (!salesAmount || !salesMonth || !salesCategory) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const salesRecord = { 
            salesAmount: Number(salesAmount), 
            salesMonth, 
            salesCategory, 
            createdAt: new Date() 
        };

        // Insert sales data into the 'sales' collection
        await db.collection('sales').insertOne(salesRecord);

        // Respond with success
        res.status(201).json({ success: true, message: 'Sales data added successfully!' });
    } catch (err) {
        console.error('Error adding sales data:', err);
        res.status(500).json({ message: 'Failed to Add Sales Data' });
    }
});

// Fetch total sales
app.get('/api/sales/total', async (req, res) => {
    try {
        const db = getDB();
        const salesCollection = db.collection('sales'); // Ensure you have a collection for sales
        const totalSales = await salesCollection.aggregate([
            { $group: { _id: null, total: { $sum: '$salesAmount' } } }
        ]).toArray();

        if (totalSales.length > 0) {
            res.status(200).json({ totalSales: totalSales[0].total });
        } else {
            res.status(200).json({ totalSales: 0 });
        }
    } catch (err) {
        console.error('Error fetching total sales:', err);
        res.status(500).json({ message: 'Failed to fetch total sales' });
    }
});
//fetch data from the users collection
app.get('/api/users', async (req, res) => {
    try {
        const db = getDB();
        const users = await db.collection('users').find({}).toArray();  // Fetch all users
        res.status(200).json({ users });
    } catch (err) {
        console.error('Error fetching users:', err);
        res.status(500).json({ message: 'Failed to fetch users' });
    }
});

//delete data from the users collection
app.delete('/api/users/:id', async (req, res) => {
    const userId = req.params.id;
    
    try {
        const db = getDB();
        const result = await db.collection('users').deleteOne({ _id: new ObjectId(userId) });

        if (result.deletedCount === 1) {
            res.status(200).json({ message: 'User deleted successfully' });
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    } catch (err) {
        console.error('Error deleting user:', err);
        res.status(500).json({ message: 'Failed to delete user' });
    }
});


// ✅ Fetch total product count from multiple collections
app.get('/api/products/count', async (req, res) => {
    try {
        const db = getDB();
        const collections = ['decoration', 'electronics', 'fashion', 'furniture', 'grocery', 'products', 'sports', 'toys', 'books', 'beauty'];

        let totalProductCount = 0;
        for (let collection of collections) {
            const count = await db.collection(collection).countDocuments();
            totalProductCount += count;
        }

        res.status(200).json({ count: totalProductCount });
    } catch (err) {
        console.error('Error fetching total product count:', err);
        res.status(500).json({ message: 'Failed to Fetch Product Count' });
    }
});

//this is created for beauty but in mongodb its fashion collection
app.get('/api/products/fashion/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'fashion'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching beauty product count:', err);
        res.status(500).json({ message: 'Failed to Fetch Beauty Product Count' });
    }
});

app.get('/api/products/chocolate/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'chocolate'; // Specify the 'beauty' collection

        const count = await db.collection('products').countDocuments({ category: 'chocolate' });
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching beauty product count:', err);
        res.status(500).json({ message: 'Failed to Fetch Beauty Product Count' });
    }
});

app.get('/api/products/decoration/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'decoration'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching decoration product count:', err);
        res.status(500).json({ message: 'Failed to Fetch decoration Product Count' });
    }
});

app.get('/api/products/electronics/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'electronics'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching electronics product count:', err);
        res.status(500).json({ message: 'Failed to Fetch electronics Product Count' });
    }
});

app.get('/api/products/furniture/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'furniture'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching furniture product count:', err);
        res.status(500).json({ message: 'Failed to Fetch furniture Product Count' });
    }
});

app.get('/api/products/books/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'books'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching books product count:', err);
        res.status(500).json({ message: 'Failed to Fetch books Product Count' });
    }
});

app.get('/api/products/toys/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'toys'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching toys product count:', err);
        res.status(500).json({ message: 'Failed to Fetch toys Product Count' });
    }
});

app.get('/api/products/sports/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'sports'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching sports product count:', err);
        res.status(500).json({ message: 'Failed to Fetch sports Product Count' });
    }
});

app.get('/api/products/grocery/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'grocery'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching grocery product count:', err);
        res.status(500).json({ message: 'Failed to Fetch grocery Product Count' });
    }
});

app.get('/api/products/users/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'users'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching users count:', err);
        res.status(500).json({ message: 'Failed to Fetch users Count' });
    }
});

app.get('/api/products/products/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'products'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching products count:', err);
        res.status(500).json({ message: 'Failed to Fetch products Count' });
    }
});

app.get('/api/products/beauty/count', async (req, res) => {
    try {
        const db = getDB();
        const collection = 'beauty'; // Specify the 'beauty' collection

        const count = await db.collection(collection).countDocuments();
        
        res.status(200).json({ count: count });
    } catch (err) {
        console.error('Error fetching beauty count:', err);
        res.status(500).json({ message: 'Failed to Fetch beauty Count' });
    }
});
// filepath: c:\Users\Owner\Downloads\dashboard ui kit (community)-html\server.js


// ✅ Add Chocolate Product
app.post('/api/chocolate', upload.single('productImage'), async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice } = req.body;
        const productImage = req.file ? `/uploads/${req.file.filename}` : '';
        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = { 
            productName, 
            productPrice: parseFloat(productPrice),
            productImage, 
            category: 'chocolate', 
            createdAt: new Date() 
        };
       

        await db.collection('products').insertOne(product);
        console.log('✅ Inserted:', result);
        res.status(201).json({ message: 'Chocolate Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding chocolate product:', err);
        res.status(500).json({ message: 'Failed to Add Chocolate Product' });
    }
});
// ✅ Fetch Chocolate Products
app.get('/api/chocolate', async (req, res) => {
    try {
        const db = getDB();
        const chocolateProducts = await db.collection('products').find({ category: 'chocolate' }).toArray();
        res.status(200).json(chocolateProducts);
    } catch (err) {
        console.error('Error fetching chocolate products:', err);
        console.log('🔍 Fetching chocolate products...');
        console.log('🍫 Found:', chocolateProducts);

        res.status(500).json({ message: 'Failed to Fetch Chocolate Products' });
    }
});

// ✅ Update Chocolate Product
app.put('/api/chocolate/:id', upload.single('productImage'), async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice } = req.body;
        const productId = req.params.id;
        
        // Check if the product ID is valid
        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice) {
            return res.status(400).json({ message: 'Product Name and Price are required' });
        }

        // Check for image upload and set product image
        let productImage = req.file ? `/uploads/${req.file.filename}` : undefined;

        if (!productImage) {
            // No new image uploaded, keep the existing one
            const existingProduct = await db.collection('products').findOne({ _id: new ObjectId(productId) });
            productImage = existingProduct ? existingProduct.productImage : '';
        }

        const updateResult = await db.collection('products').updateOne(
            { _id: new ObjectId(productId), category: 'chocolate' },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Chocolate Product Not Found' });
        }

        if (updateResult.modifiedCount === 0) {
            return res.status(200).json({ message: 'No changes were made to the product' });
        }

        res.status(200).json({ message: 'Chocolate Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating chocolate product:', err);
        res.status(500).json({ message: 'Failed to Update Chocolate Product' });
    }
});

// ✅ Delete Chocolate Product
app.delete('/api/chocolate/:id', async (req, res)  => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('products').deleteOne({ _id: new ObjectId(productId), category: 'chocolate' });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Chocolate Product Not Found' });
        }

        res.status(200).json({ message: 'Chocolate Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting chocolate product:', err);
        res.status(500).json({ message: 'Failed to Delete Chocolate Product' });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});

// ✅ Add Beauty Product
app.post('/api/beauty', upload.single('productImage'), async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice } = req.body;
        const productImage = req.file ? `/uploads/${req.file.filename}` : '';
        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = { 
            productName, 
            productPrice: parseFloat(productPrice),
            productImage, 
            category: 'beauty', 
            createdAt: new Date() 
        };

        await db.collection('beauty').insertOne(product);
        console.log('✅ Inserted:', product);
        res.status(201).json({ message: 'Beauty Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding beauty product:', err);
        res.status(500).json({ message: 'Failed to Add Beauty Product' });
    }
});

// ✅ Fetch Beauty Products
app.get('/api/beauty', async (req, res) => {
    try {
        const db = getDB();
        const beautyProducts = await db.collection('beauty').find({ category: 'beauty' }).toArray();
        res.status(200).json(beautyProducts);
    } catch (err) {
        console.error('Error fetching beauty products:', err);
        res.status(500).json({ message: 'Failed to Fetch Beauty Products' });
    }
});

// ✅ Update Beauty Product
app.put('/api/beauty/:id', upload.single('productImage'), async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice } = req.body;
        const productId = req.params.id;

        // Check if the product ID is valid
        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice) {
            return res.status(400).json({ message: 'Product Name and Price are required' });
        }

        // Check for image upload and set product image
        let productImage = req.file ? `/uploads/${req.file.filename}` : undefined;

        if (!productImage) {
            // No new image uploaded, keep the existing one
            const existingProduct = await db.collection('beauty').findOne({ _id: new ObjectId(productId) });
            productImage = existingProduct ? existingProduct.productImage : '';
        }

        const updateResult = await db.collection('beauty').updateOne(
            { _id: new ObjectId(productId), category: 'beauty' },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Beauty Product Not Found' });
        }

        if (updateResult.modifiedCount === 0) {
            return res.status(200).json({ message: 'No changes were made to the product' });
        }

        res.status(200).json({ message: 'Beauty Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating beauty product:', err);
        res.status(500).json({ message: 'Failed to Update Beauty Product' });
    }
});

// ✅ Delete Beauty Product
app.delete('/api/beauty/:id', async (req, res)  => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('beauty').deleteOne({ _id: new ObjectId(productId), category: 'beauty' });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Beauty Product Not Found' });
        }

        res.status(200).json({ message: 'Beauty Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting beauty product:', err);
        res.status(500).json({ message: 'Failed to Delete Beauty Product' });
    }
});



// ✅ Fixed duplicate `app.listen` issue
app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
});

// Add Decoration Product API
app.post('/api/decoration', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage, category } = req.body;

        if (!productName || !productPrice || !productImage || !category) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = { 
            productName, 
            productPrice: Number(productPrice), // Ensures it's stored as a number
            productImage, 
            category, // Set category as 'decoration'
            createdAt: new Date() 
        };

        await db.collection('decoration').insertOne(product); // Insert into the 'decoration' collection
        res.status(200).json({ message: 'Decoration Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding decoration product:', err);
        res.status(500).json({ message: 'Failed to Add Decoration Product' });
    }
});

// Fetch Decoration Products API
app.get('/api/decoration', async (req, res) => {
    try {
        const db = getDB();
        const products = await db.collection('decoration').find().toArray(); // Fetch from 'decoration' collection
        res.status(200).json(products);
    } catch (err) {
        console.error('Error fetching decoration products:', err);
        res.status(500).json({ message: 'Failed to Fetch Decoration Products' });
    }
});

// Update Decoration Product API
app.put('/api/decoration/:id', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage } = req.body;
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const updateResult = await db.collection('decoration').updateOne(
            { _id: new ObjectId(productId) },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Decoration Product Not Found' });
        }

        res.status(200).json({ message: 'Decoration Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating decoration product:', err);
        res.status(500).json({ message: 'Failed to Update Decoration Product' });
    }
});

// Delete Decoration Product API
app.delete('/api/decoration/:id', async (req, res) => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('decoration').deleteOne({ _id: new ObjectId(productId) });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Decoration Product Not Found' });
        }

        res.status(200).json({ message: 'Decoration Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting decoration product:', err);
        res.status(500).json({ message: 'Failed to Delete Decoration Product' });
    }
});

// Add Electronics Product API
app.post('/api/electronics', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage, category } = req.body;

        if (!productName || !productPrice || !productImage || !category) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = { 
            productName, 
            productPrice: Number(productPrice), // Ensures it's stored as a number
            productImage, 
            category, // Set category as 'electronics'
            createdAt: new Date() 
        };

        await db.collection('electronics').insertOne(product); // Insert into the 'electronics' collection
        res.status(200).json({ message: 'Electronics Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding electronics product:', err);
        res.status(500).json({ message: 'Failed to Add Electronics Product' });
    }
});

// Fetch Electronics Products API
app.get('/api/electronics', async (req, res) => {
    try {
        const db = getDB();
        const products = await db.collection('electronics').find().toArray(); // Fetch from 'electronics' collection
        res.status(200).json(products);
    } catch (err) {
        console.error('Error fetching electronics products:', err);
        res.status(500).json({ message: 'Failed to Fetch Electronics Products' });
    }
});

// Update Electronics Product API
app.put('/api/electronics/:id', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage } = req.body;
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const updateResult = await db.collection('electronics').updateOne(
            { _id: new ObjectId(productId) },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Electronics Product Not Found' });
        }

        res.status(200).json({ message: 'Electronics Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating electronics product:', err);
        res.status(500).json({ message: 'Failed to Update Electronics Product' });
    }
});

// Delete Electronics Product API
app.delete('/api/electronics/:id', async (req, res) => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('electronics').deleteOne({ _id: new ObjectId(productId) });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Electronics Product Not Found' });
        }

        res.status(200).json({ message: 'Electronics Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting electronics product:', err);
        res.status(500).json({ message: 'Failed to Delete Electronics Product' });
    }
});

// Add Fashion Product API
app.post('/api/fashion', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage, category } = req.body;

        if (!productName || !productPrice || !productImage || !category) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = {
            productName,
            productPrice: Number(productPrice), // Ensure productPrice is stored as a number
            productImage,
            category, // Set category as 'fashion'
            createdAt: new Date()
        };

        await db.collection('fashion').insertOne(product); // Insert into 'fashion' collection
        res.status(200).json({ message: 'Fashion Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding fashion product:', err);
        res.status(500).json({ message: 'Failed to Add Fashion Product' });
    }
});

// Fetch Fashion Products API
app.get('/api/fashion', async (req, res) => {
    try {
        const db = getDB();
        const products = await db.collection('fashion').find().toArray(); // Fetch from 'fashion' collection
        res.status(200).json(products);
    } catch (err) {
        console.error('Error fetching fashion products:', err);
        res.status(500).json({ message: 'Failed to Fetch Fashion Products' });
    }
});

// Update Fashion Product API
app.put('/api/fashion/:id', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage } = req.body;
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const updateResult = await db.collection('fashion').updateOne(
            { _id: new ObjectId(productId) },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Fashion Product Not Found' });
        }

        res.status(200).json({ message: 'Fashion Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating fashion product:', err);
        res.status(500).json({ message: 'Failed to Update Fashion Product' });
    }
});

// Delete Fashion Product API
app.delete('/api/fashion/:id', async (req, res) => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('fashion').deleteOne({ _id: new ObjectId(productId) });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Fashion Product Not Found' });
        }

        res.status(200).json({ message: 'Fashion Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting fashion product:', err);
        res.status(500).json({ message: 'Failed to Delete Fashion Product' });
    }
});

// Add Furniture Product API
app.post('/api/furniture', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage, category } = req.body;

        if (!productName || !productPrice || !productImage || !category) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = {
            productName,
            productPrice: Number(productPrice), // Ensure productPrice is stored as a number
            productImage,
            category, // Set category as 'furniture'
            createdAt: new Date()
        };

        await db.collection('furniture').insertOne(product); // Insert into 'furniture' collection
        res.status(200).json({ message: 'Furniture Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding furniture product:', err);
        res.status(500).json({ message: 'Failed to Add Furniture Product' });
    }
});

// Fetch Furniture Products API
app.get('/api/furniture', async (req, res) => {
    try {
        const db = getDB();
        const products = await db.collection('furniture').find().toArray(); // Fetch from 'furniture' collection
        res.status(200).json(products);
    } catch (err) {
        console.error('Error fetching furniture products:', err);
        res.status(500).json({ message: 'Failed to Fetch Furniture Products' });
    }
});

// Update Furniture Product API
app.put('/api/furniture/:id', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage } = req.body;
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const updateResult = await db.collection('furniture').updateOne(
            { _id: new ObjectId(productId) },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Furniture Product Not Found' });
        }

        res.status(200).json({ message: 'Furniture Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating furniture product:', err);
        res.status(500).json({ message: 'Failed to Update Furniture Product' });
    }
});

// Delete Furniture Product API
app.delete('/api/furniture/:id', async (req, res) => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('furniture').deleteOne({ _id: new ObjectId(productId) });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Furniture Product Not Found' });
        }

        res.status(200).json({ message: 'Furniture Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting furniture product:', err);
        res.status(500).json({ message: 'Failed to Delete Furniture Product' });
    }
});


// Add Grocery Product API
app.post('/api/grocery', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage, category } = req.body;

        if (!productName || !productPrice || !productImage || !category) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = {
            productName,
            productPrice: Number(productPrice), // Ensure productPrice is stored as a number
            productImage,
            category, // Set category as 'grocery'
            createdAt: new Date()
        };

        await db.collection('grocery').insertOne(product); // Insert into 'grocery' collection
        res.status(200).json({ message: 'Grocery Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding grocery product:', err);
        res.status(500).json({ message: 'Failed to Add Grocery Product' });
    }
});

// Fetch Grocery Products API
app.get('/api/grocery', async (req, res) => {
    try {
        const db = getDB();
        const products = await db.collection('grocery').find().toArray(); // Fetch from 'grocery' collection
        res.status(200).json(products);
    } catch (err) {
        console.error('Error fetching grocery products:', err);
        res.status(500).json({ message: 'Failed to Fetch Grocery Products' });
    }
});

// Update Grocery Product API
app.put('/api/grocery/:id', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage } = req.body;
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const updateResult = await db.collection('grocery').updateOne(
            { _id: new ObjectId(productId) },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Grocery Product Not Found' });
        }

        res.status(200).json({ message: 'Grocery Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating grocery product:', err);
        res.status(500).json({ message: 'Failed to Update Grocery Product' });
    }
});

// Delete Grocery Product API
app.delete('/api/grocery/:id', async (req, res) => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('grocery').deleteOne({ _id: new ObjectId(productId) });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Grocery Product Not Found' });
        }

        res.status(200).json({ message: 'Grocery Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting grocery product:', err);
        res.status(500).json({ message: 'Failed to Delete Grocery Product' });
    }
});


// Add Sports Product API
app.post('/api/sports', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage, category } = req.body;

        if (!productName || !productPrice || !productImage || !category) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = {
            productName,
            productPrice: Number(productPrice), // Ensure productPrice is stored as a number
            productImage,
            category, // Set category as 'sports'
            createdAt: new Date()
        };

        await db.collection('sports').insertOne(product); // Insert into 'sports' collection
        res.status(200).json({ message: 'Sports Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding sports product:', err);
        res.status(500).json({ message: 'Failed to Add Sports Product' });
    }
});

// Fetch Sports Products API
app.get('/api/sports', async (req, res) => {
    try {
        const db = getDB();
        const products = await db.collection('sports').find().toArray(); // Fetch from 'sports' collection
        res.status(200).json(products);
    } catch (err) {
        console.error('Error fetching sports products:', err);
        res.status(500).json({ message: 'Failed to Fetch Sports Products' });
    }
});

// Update Sports Product API
app.put('/api/sports/:id', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage } = req.body;
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const updateResult = await db.collection('sports').updateOne(
            { _id: new ObjectId(productId) },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Sports Product Not Found' });
        }

        res.status(200).json({ message: 'Sports Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating sports product:', err);
        res.status(500).json({ message: 'Failed to Update Sports Product' });
    }
});

// Delete Sports Product API
app.delete('/api/sports/:id', async (req, res) => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('sports').deleteOne({ _id: new ObjectId(productId) });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Sports Product Not Found' });
        }

        res.status(200).json({ message: 'Sports Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting sports product:', err);
        res.status(500).json({ message: 'Failed to Delete Sports Product' });
    }
});

// Add Book Product API
app.post('/api/books', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage, category } = req.body;

        if (!productName || !productPrice || !productImage || !category) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const product = {
            productName,
            productPrice: Number(productPrice), // Ensure productPrice is stored as a number
            productImage,
            category, // Set category as 'books'
            createdAt: new Date()
        };

        await db.collection('books').insertOne(product); // Insert into 'books' collection
        res.status(200).json({ message: 'Book Product Added Successfully!' });
    } catch (err) {
        console.error('Error adding book product:', err);
        res.status(500).json({ message: 'Failed to Add Book Product' });
    }
});

// Fetch Books Products API
app.get('/api/books', async (req, res) => {
    try {
        const db = getDB();
        const products = await db.collection('books').find().toArray(); // Fetch from 'books' collection
        res.status(200).json(products);
    } catch (err) {
        console.error('Error fetching book products:', err);
        res.status(500).json({ message: 'Failed to Fetch Book Products' });
    }
});

// Update Book Product API
app.put('/api/books/:id', async (req, res) => {
    try {
        const db = getDB();
        const { productName, productPrice, productImage } = req.body;
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        if (!productName || !productPrice || !productImage) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const updateResult = await db.collection('books').updateOne(
            { _id: new ObjectId(productId) },
            { $set: { productName, productPrice: Number(productPrice), productImage } }
        );

        if (updateResult.matchedCount === 0) {
            return res.status(404).json({ message: 'Book Product Not Found' });
        }

        res.status(200).json({ message: 'Book Product Updated Successfully!' });
    } catch (err) {
        console.error('Error updating book product:', err);
        res.status(500).json({ message: 'Failed to Update Book Product' });
    }
});

// Delete Book Product API
app.delete('/api/books/:id', async (req, res) => {
    try {
        const db = getDB();
        const productId = req.params.id;

        if (!ObjectId.isValid(productId)) {
            return res.status(400).json({ message: 'Invalid Product ID' });
        }

        const deleteResult = await db.collection('books').deleteOne({ _id: new ObjectId(productId) });

        if (deleteResult.deletedCount === 0) {
            return res.status(404).json({ message: 'Book Product Not Found' });
        }

        res.status(200).json({ message: 'Book Product Deleted Successfully!' });
    } catch (err) {
        console.error('Error deleting book product:', err);
        res.status(500).json({ message: 'Failed to Delete Book Product' });
    }
});


