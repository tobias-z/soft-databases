// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import { getConnection } from "@/connection";
import type { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse<any>
) {
    if (req.method === "POST") {
        const db = await getConnection();
        const result = await db.collection("tweets").insertOne({
            entities: {
                hashtags: [{text: JSON.parse(req.body).hashtag}]
            }
        });
        res.status(200).json(result);
    } else {
        res.status(404);
    }
}
