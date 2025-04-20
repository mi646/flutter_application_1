const { MongoClient } = require('mongodb');

const mongoUri = 'mongodb+srv://mitesh:xaI3rt7PAQjPMhM0@cluster0.r41tu.mongodb.net/yourdollarstore?retryWrites=true&w=majority';
let db;

async function connectDB() {
    try {
        const client = await MongoClient.connect(mongoUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        db = client.db('yourdollarstore');
        console.log('✅ MongoDB Connected Successfully');
    } catch (err) {
        console.error('❌ MongoDB Connection Failed:', err);
        process.exit(1); // Exit process if DB connection fails
    }
}

function getDB() {
    if (!db) {
        throw new Error('Database not initialized!');
    }
    return db;
}

module.exports = { connectDB, getDB };
