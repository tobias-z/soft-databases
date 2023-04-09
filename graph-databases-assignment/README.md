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

b.

c.

d.
