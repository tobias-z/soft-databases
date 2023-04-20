# Database Study point Assignment 3

## Group Members

- Mads Bryde, cph-mb870@cphbusiness.dk
- Mathias Egebjerg Jensen, cph-mj839@cphbusiness.dk
- Malthe Stefan Woschek, cph-mw202@cphbusiness.dk
- Tobias Zimmermann, cph-tz11@cphbusiness.dk

## Table of contents

- [Introduction](#introduction)

## Introduction

Something great

## Usage

Windows users can either create a PowerShell script or copy each command in the init script 🤣

```bash
docker compose up -d
sh init.sh
```

You should now be able to connect to the router on port 27017 which has the twitter database

## Assignment Questions

### a) What is sharding in MongoDB?

Sharding is typically a technique that is often used when you want to try to partition out data across multiple servers. This is done in order to scale the servers horizontally. Using sharding you are trying to split out the data in smaller partitions called “shards”, which is then distributed out across multiple servers and called “shardservers”. Each shardserver should contain a subset of the total data and as long as the data keeps growing, the more servers are able to be added to the cluster in order to handle the increasing load. In order to use sharding you need to create a sharded cluster that should consist of a configuration server and more shard servers with one or more mongos instances running. The configuration server is in charge of storing the metadata about the sharded cluster while the mongos instances will be acting as proxies between the application that request data and the shardservers.

### b) What are the different components required to implement sharding?

You need a number of things in order to do sharding in MongoDB:

  i.	Shard: A single computer or node that houses a subset of the data in a cluster that is sharded.

  ii.	Config servers: A group of nodes that look after the sharded cluster's metadata and configuration data.

  iii. Router or Mongos: A process that sits between an application and a sharded cluster, routing changes and queries to the proper shards.

  iv.	Cluster balancer: A mechanism that redistributes data inside the cluster to ensure that it is distributed equally among the shards.

![Structure](https://i.imgur.com/AfX86T8.png)

### c) Explain architecture of sharding in mongoDB?

In mongodb, a sharded cluster is made of 3 parts:

Shards - A shard contains a subset of the cluster’s data.

Mongos - Mongos is the part that handles the queries from the client applications, both read and write. It delegates the requests from the client to the correct shards and aggregates the response from the shards into a response that gets returned to the client. In other words the client connects to the mongos instead of the individual shards.

Config servers - These are the authoritative source of sharding metadata. This metadata reflects the state and organization of the sharded data. This means that all the lists of sharded collections, routing information etc. is stored in these config servers.
