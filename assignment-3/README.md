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

## Assignment Questions

### a) What is sharding in MongoDB?

Sharding is typically a technique that is often used when you want to try to partition out data across multiple servers. This is done in order to scale the servers horizontally. Using sharding you are trying to split out the data in smaller partitions called “shards”, which is then distributed out across multiple servers and called “shardservers”. Each shardserver should contain a subset of the total data and as long as the data keeps growing, the more servers are able to be added to the cluster in order to handle the increasing load. In order to use sharding you need to create a sharded cluster that should consist of a configuration server and more shard servers with one or more mongos instances running. The configuration server is in charge of storing the metadata about the sharded cluster while the mongos instances will be acting as proxies between the application that request data and the shardservers.

### b) What are the different components required to implement sharding?

You need a number of things in order to do sharding in MongoDB:
i.	Shard: A single computer or node that houses a subset of the data in a cluster that is sharded.
ii.	Config servers: A group of nodes that look after the sharded cluster's metadata and configuration data.
iii. Router or Mongos: A process that sits between an application and a sharded cluster, routing changes and queries to the proper shards.
iv.	Cluster balancer: A mechanism that redistributes data inside the cluster to ensure that it is distributed equally among the shards.
 
![Structure]([https://imgur.com/AfX86T8])
