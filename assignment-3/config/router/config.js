sh.addShard(
    "shardsvr1/mongo-shard1-svr1:27018,mongo-shard1-svr2:27018"
);
sh.addShard(
    "shardsvr2/mongo-shard2-svr1:27019,mongo-shard2-svr2:27019"
);

sh.shardCollection("twitter.tweets", { _id: "hashed" })
