# Graph Databases Assignment

## Group Members

- Mads Bryde, cph-mb870@cphbusiness.dk
- Mathias Egebjerg Jensen, cph-mj839@cphbusiness.dk
- Malthe Stefan Woschek, cph-mw202@cphbusiness.dk
- Tobias Zimmermann, cph-tz11@cphbusiness.dk

## Table of contents

- [Introduction](#introduction)
- [Business Case](#business-case)
- [Data](#data)

## Introduction

This project was intended to make us learn about graph databases, and how to work with them in practice.

The assignment can be found [here](./documents/assignment.pdf)

## Business Case

The business case is to provide a way to view pages and their links.
We should also be able to figure out which pages are important.

## Data

The selected data is the `Stanford web graph` which is a graph of pages relevant to Stanford University.

The data was found [here](https://snap.stanford.edu/data/web-Stanford.html) and the zip containing the data can be found [here](./documents/web-Stanford.csv.tar.gz)

The data was modified into a CSV file, and is structured like this:

```
FromNodeId,ToNodeId
1,6548
1,15409
6548,57031
15409,13102
2,17794
2,25202
2,53625
2,54582
2,64930
```

## Graph operations

### Mads

### Mathias

### Malthe

### Tobias

For my graph algorithm page rank was chosen. Page rank is a centrality graph algorithm.
It is used to determine the importance of nodes in a graph, and is heavily used by google and other search engines as one of their variables when determining which pages should be shown at the top of search query.

As our data set is pretty much the same idea, with pages linking to other pages, it made sense to use the page rank algorithm to find the pages that are important in our dataset.

An implementation through neo4j looks as follows:

```cypher
CALL gds.graph.project(
    'pageGraph',
    'Page',
    'Link',
    {
        relationshipProperties: 'weight'
    }
);

CALL gds.pageRank.write.estimate('pageGraph', {
  writeProperty: 'pageRank',
  maxIterations: 20,
  dampingFactor: 0.85
});

CALL gds.pageRank.stream('pageGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).id AS id, score
ORDER BY score DESC, id ASC;
```

In the [code](https://github.com/tobias-z/soft-databases/blob/main/graph-databases-assignment/src/db.rs#L60) we are also ensuring that we only create the graph projection and estimage ones.

Let's go through some important bits of the cypher.

1. `gds.graph.project`

Here we are creating a projection of our current graph. This ensures that we are not dealing with the actual graph.
The projection is important because a lot of algorithms typically needs to be able to mutate specific data.
It also means that we can make projections of smaller subgraphs of a larger graph.
If for example we had other nodes in our graph, we would ignore them because they were not selected when creating our projection.

2. `gds.pageRank.write.estimate`

Creating an estimate of the cost of running algorithms on a projection is important because it will ensure that we do not go over our memory limitations later when running the algorithms.

Here we are also setting up an important property `dampingFactor`.
This property means that for every rank incrementation, we first test if a random number between 0 and 100 is above 85 in our case (so a 15% chance of it being above 85).
If this number is above 85.
We will choose another node in the graph randomly.
This is important to do if your graph is unconnected.
If you are sure that the graph is connected, it would be faster to not use a dampening factor at all, since then it doesn't need to do the extra calculations.

3. `gds.pageRank.stream`

Here we are executing the page rank algorithm.
The results are returned as a stream (hence the yield keyword).
We simply take the node ID and get the node from it, which allows us to return the actual page ID together with the score, ordered by the score which means that the highest score goes to the top.

> If you are interested in a code implementation of page rank, an example of it can be found [here](https://github.com/tobias-z/soft-databases/blob/main/centrality/src/page_rank.rs)

## Answers to questions under question 7.

a. What are the advantages and disadvantages of using graph databases, and which are the
best and worse scenarios for it?

b. How would you code in SQL the Cypher statements you developed for your graph-
algorithms-based query, if the same data was stored in a relational database?

c. How does the DBMS you work with organizes the data storage and the execution of the
queries?

d. Which methods for scaling and clustering of databases you are familiar with so far?

### Mads

a.
b.
c.
d.

### Mathias

a.
b.
c.
d.

### Malthe

a.
b.
c.
d.

### Tobias

a.

Graph databases are great when you are dealing with a lot of different relationships.
Examples of this could be if `some` thing is related to another thing in multiple different ways.
Graph databases would allow you to simply create as many relation types as you want.
However, if we were to do this in a relational database we would have to create a bunch of relation tables.

Situations where relational databases might be a better choice would be very structured data, where you know exactly the data you will have and their relations.

Another situation where relational databases could be better would be if you don't have a lot of relations and not a lot of data is being persisted.
In these situations a relational database with indexing might be faster.

b.
c.
d.
