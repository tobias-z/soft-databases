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

### Mathias - `pages_that_link_to`
```sql
MATCH (p:Page {id: $id})
WITH p MATCH (p) <- [:Link] - (p_from:Page)
return COUNT(p_from) as c;
```

Short version:

This query finds all the 'Page' nodes in the graph database, which link to a specific 'Page' node determind by the `id` parameter. The query then returns a count of how many 'Page' nodes are linked to the given `id`.

Long version:

1: `MATCH (p:Page {id: $id})` : The first part of the query is matching the `id` parameter to our 'Page' node. This node is saved to the variable `p`.
2: `WITH p MATCH (p) <- [:Link] - (p_from:Page)` : This part of the query uses the variable `p` and calculates how many 'Page' nodes with a `Link` pointing at `p` - these 'Page' nodes are referanced to as `p_from`.
3: `return COUNT(p_from) as c;` : The last part of the query returns a count of how many 'Page' nodes who had a `Link` pointing towards `p` and saves this count in the variable `c`.

### Malthe - `get_average_links`
```sql
MATCH (p:Page)-[:Link]->(linkedTo:Page)
WITH p,count(linkedTo) as linkCount
RETURN avg(linkCount) as average;
```

Short version:

This query matches all ‘Page’ nodes with outgoing Link relationships, counts the number of those relationships for each ‘Page’ node, and returns the average number of outgoing ‘Link’ relationships per ‘Page’ node in the database.

Long version:

1: `MATCH (p:Page)-[:Link]->(linkedTo:Page)` : This is a pattern matching clause that matches all nodes labeled as `Page` that have an outgoing relationship labelled as `Link` to other nodes labeled as `Page`. The nodes matched by this pattern are bound to the variables `p` and `linkedTo`.
2: `WITH p,count(linkedTo) as linkCount` : This clause passes the matched nodes `p` and `linkedTo` to the next part of the query, and also calculates the number of outgoing `Link` relationships for each node `p` using the `count()` function. The result of this calculation is assigned to the variable `linkCount`.
3: `RETURN avg(linkCount) as average` : This clause returns the average of all the `linkCount` values calculated in the previous step, which gives the average number of outgoing `Link` relationships per `Page` node in the database. The result of this calculation is assigned to the variable `average`.

The purpose of this query is to help analyze the connectivity of a graph database. For example, it could help to identify pages with a high or low number of links, which might indicate important or unimportant pages respectively.

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
Advantages of using graph databases include:
* Flexibility/scalability
* Performance
* Visualization
Disadvantages of using graph databases include:
* Complexity
*	Lack of standardization
*	Limited support for ad-hoc querying

Best scenarios for using graph databases include applications that require complex relationships between data, such as social networks, recommendation engines, and fraud detection systems. They are also well-suited for applications with large and changing datasets, such as real-time data processing.
Worse scenarios for using graph databases include applications with relatively simple data structures, such as e-commerce or inventory management systems, where a relational database might be a more efficient choice.

b.
In order to code the Cypher query in SQL, we would need to create a schema that includes tables for the `Page` nodes and `Link` relationships. The `Page` table would have a primary key id, and the `Link` table would have foreign keys `from_id` and `to_id` to represent the relationship between nodes. The equivalent SQL query to calculate the average number of outgoing links per page would be something like:
```SQL
SELECT AVG(link_count) AS average
FROM ( SELECT from_id, COUNT(*) AS link_count
       FROM Link GROUP BY from_id
) AS link_counts
```

c.
With Neo4j, nodes represent entities and relationships represent connections between those entities. Typically, data is stored in a native format that is optimized for graph traversal and query execution. When a query is executed, Neo4j traverses the graph and finds the relevant nodes and relationships using algorithms such as depth-first search and breadth-first search. To improve query performance, Neo4j may use indexing and caching techniques.

d.
Methods for scaling and clustering of databases that I am familiar with include:
*	Sharding
*	Replication
*	Load balancing
*	Clustered databases

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

As far as I know running an algorithm like page rank is simply not possible with a relational database.
So the way I would achieve the goal of getting ranks on pages stored in relational database, is simply by querying the database to give me all the pages and relationships, and then create some code which would transform the pages and links into nodes and relations.
I could then run a page rank algorithm on them through some kind of page rank implementation.

c.

Data storage is done through a multitude of steps.

All Data stored on disk is a bunch of linked lists of fixed size records.

Nodes hold pointers to relationships and properties, and these "joins" are done at creation time, and not at fetch time.
This is one of the reasons why inserting into a neo4j graph is quite slow, but fetching multiple nodes also getting their relations (like a join in SQL) is very fast.

d.

- Vertical scaling

Vertical scaling refers to providing your current machine with more power, through increasing things like CPU, memory, storage, etc.

Sometimes when dealing with systems that require a lot of resources to run algorithms it might be beneficial to vertically scale your database.
Reasons for this might be: You don't really get a lot of requests, but the load happens during single requests. This makes horizontal scaling a bad choice for your use case.

- Horizontal scaling

Horizontal scaling refers to providing more copies of your machine (usually referred to as a node) to a network. This process is far from strait forward, and also introduces a lot of problems when doing so.

If we are talking about a simple application serving users, then a simple load balancer might be adequate, but it also might not, because a lot of your code has to be written in such a way that it supports data consistency in all replicas.

Databases on the other hand have other problems when it comes to distributed systems. Things like the CAP theorem has to be taken into account, and you need to make decisions about what your database is going to support. In the case of relational databases like Postgres, the choice of Consistency and Availability was chosen, but Neo4j has chosen to prioritize Consistency and Partition tolerance.

Some examples of replication methods can be:
- Primary / Secondary (Read / Write) replications.
- Sharding (partitioning) which is a way to spread data across multiple different nodes.
- And many more...

When it comes to scaling of databases, there are many different things that we have to take into account, and make choices depending on the variables of our problem.
