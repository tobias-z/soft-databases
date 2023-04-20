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

### b) What are the different components required to implement sharding?

You need a number of things in order to do sharding in MongoDB:
i.	Shard: A single computer or node that houses a subset of the data in a cluster that is sharded.
ii.	Config servers: A group of nodes that look after the sharded cluster's metadata and configuration data.
iii. Router or Mongos: A process that sits between an application and a sharded cluster, routing changes and queries to the proper shards.
iv.	Cluster balancer: A mechanism that redistributes data inside the cluster to ensure that it is distributed equally among the shards.
 
![Structure]([https://imgur.com/AfX86T8])
