# Centrality

## What is Graph Centrality

Centrality is a category of graph algorithms. They are used for determining which nodes are important in a graph.

## Degree Centrality

Used to find popular nodes in a graph.

Counts the number of incoming and outgoing relationships from a node.

It can be used to figure out things like popularity in friends or if someone is followed a lot.

## Closeness Centrality

Which nodes are best at spreading information through a graph. In other words, which node can most easily reach all other nodes in a graph.

## Betweenness Centrality

Used for detecting which node has the most control over flow between nodes and groups.

Used for finding bridges, such as a link between two communities. If someone is following two different people, they are bridges between the groups.

## The PageRank algorithm

Measures the transitive influence of nodes.

Example of usage:

- Recommendations of accounts they may wish to follow (twitter).
- Predicting traffic flow. It can be used to predict movement of a person, since the street you are on are connected to other streets where some are more important than others.
