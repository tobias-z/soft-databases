import { MongoClient } from "mongodb";

export async function getConnection() {
    const url = "mongodb://localhost:27017";
    const client = new MongoClient(url);
    await client.connect();
    return client.db("twitter");
}
