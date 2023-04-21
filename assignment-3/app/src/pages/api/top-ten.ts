// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import { getConnection } from "@/connection";
import type { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
    _req: NextApiRequest,
    res: NextApiResponse<any>
) {
    // get connection to mongo
    // run some query and return it
    const db = await getConnection();
    const topTen = await db.collection("tweets").aggregate([
        {
            $unwind: "$entities.hashtags",
        },
        {
            $group: {
                _id: "$entities.hashtags.text",
                count: {
                    $sum: 1,
                },
            },
        },
        {
            $sort: {
                count: -1,
            },
        },
        {
            $limit: 10,
        },
    ]).toArray();

    res.status(200).json(topTen);
}
