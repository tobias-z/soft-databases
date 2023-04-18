require("dotenv").config();
const { MongoClient } = require("mongodb");
const express = require("express");
const app = express();
const port = 3000;

app.get("/data", async (_, res) => {
    const connection = await getConnection();
    const db = connection.db("test");
    await db.collection("users").insertMany([
        { name: "bob", email: "bob@thebuilder.dk" },
        { name: "jens", email: "jens@thebuilder.dk" },
        { name: "tobias", email: "tobias@thebuilder.dk" },
    ]);
    res.send("Created sample data");
});

app.get("/users/:email", async (req, res) => {
    const email = req.params.email;
    const connection = await getConnection();
    const db = connection.db("test");
    return res.json(
        await db.collection("users").findOne(
            {
                email,
            },
            { projection: { name: 1 } }
        )
    );
});

app.get("/users", async (req, res) => {
    const connection = await getConnection();
    const db = connection.db("test");
    return res.json(await db.collection("users").find().toArray());
});

app.get("/data/movies", async (req, res) => {
    const connection = await getConnection();
    const db = connection.db("test");
    await db.collection("movies").insertMany([
        { name: "bad", rating: 4, genre: "building" },
        { name: "great", rating: 16, genre: "scary" },
        { name: "middle", rating: 10, genre: "scary" },
    ]);
    res.send("Created sample data");
});

app.get("/movies/average", async (req, res) => {
    const connection = await getConnection();
    const db = connection.db("test");
    const result = await db
        .collection("movies")
        .aggregate([
            {
                $group: {
                    _id: "$genre",
                    averageRating: {
                        $avg: "$rating",
                    },
                },
            },
            {
                $sort: { _id: 1 },
            },
        ])
        .toArray();
    res.json(result);
});

app.get("/data/pages", async (req, res) => {
    const connection = await getConnection();
    const db = connection.db("test");
    await db.collection("pages").insertMany([
        { url: "https://something.com", views: 15 },
        { url: "https://google.com", views: 10 },
        { url: "https://bob.com", views: 100 },
    ]);
    res.send("Created sample data");
});

app.get("/data/productthing", async (req, res) => {
    const connection = await getConnection();
    const db = connection.db("test");
    await db.collection("products").insertMany([
        { _id: 1, name: "burger", price: 60 },
        { _id: 2, name: "pizza", price: 70 },
        { _id: 3, name: "pasta", price: 50 },
    ]);

    await db.collection("orders").insertMany([
        {
            order_date: "10",
            customer_id: 1,
            products: [
                {
                    product_id: 1,
                    quantity: 4,
                    price: 4 * 60,
                },
            ],
        },
        {
            order_date: "10",
            customer_id: 2,
            products: [
                {
                    product_id: 1,
                    quantity: 5,
                    price: 5 * 60,
                },
            ],
        }
    ]);
    res.send("Created sample data");
});

/*
Unwind does this
{
    order_date: "10",
    customer_id: 1,
    products: [
        {
            product_id: 1,
            quantity: 4,
            price: 4 * 60,
        },
        {
            product_id: 2,
            quantity: 1,
            price: 1 * 70,
        },
    ],
}

{
    order_date: "10",
    customer_id: 1,
    products: {
            product_id: 1,
            quantity: 4,
            price: 4 * 60,
    },
},
{
    order_date: "10",
    customer_id: 1,
    products: {
            product_id: 2,
            quantity: 1,
            price: 1 * 70,
    },
}
*/

app.get("/orders/total-sales", async (req, res) => {
    const connection = await getConnection();
    const db = connection.db("test");
    const result = await db
        .collection("orders")
        .aggregate([
            {
                $group: {
                    _id: "$genre",
                    averageRating: {
                        $avg: "$rating",
                    },
                },
            },
            {
                $sort: { _id: 1 },
            },
        ])
        .toArray();
    res.json(result);
})

app.listen(port, () => {
    console.log(`App listening on port ${port}`);
});

async function getConnection() {
    if (!process.env.MONGODB_URI) {
        throw new Error('Invalid environment variable: "MONGODB_URI"');
    }

    const uri = process.env.MONGODB_URI;
    const options = {};

    return await new MongoClient(uri, options).connect();
}
