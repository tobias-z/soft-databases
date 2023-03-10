<div align="center">

# Databases Assignment 1

By Tobias Zimmermann (cph-tz11@cphbusiness.dk)

</div>

## Table of Contents

- [Introduction](#introduction)
- [Explanations](#explanations)
  - [CAP Theorem](#cap-theorem)
  - [ACID Properties](#acid-properties)
- [Designing the Database](#designing-the-database)
- [ER Diagram](#er-diagram)
- [Stored Procedures and Transactions](#stored-procedures-and-transactions)
- [Conclusion and Future Improvements](#conclusion-and-future-improvements)

## Introduction

This document briefly discusses the CAP theorem and ACID properties, and describes how they were applied during the assignment. The complete assignment can be found [here](./documents/database-assignment.pdf).

As the given task was set up in such a way that we could incrementally improve our product, multiple version of the database can be found in the [SQL](./sql) folder.

## Explanations

### CAP Theorem

The CAP theorem is a way to define how a distributed system operates. How does the system operate given specific criteria.

The three concepts in the CAP theorem are:

- **Consistency** states that the system state should always be same in all places.

Ex:
Given that you have two replicas of the same application.
When a request to update data is sent to application 1.
Then the data is updated on both application 1 and application 2, before the request is said to be OK.

If any update goes wrong anywhere the request is declined.

- **Availability** states that the system should always be available. Availability in this context means that operations should happen even if the system becomes inconsistent because of it.

Ex:
Given that you have two replicas of the same application.
When a request to update data is sent to application 1.
Then the data is updated on both application 1, if the request goes right, the system responds with OK. However, before responding, it will also tell application 2, that it should update its data, but it does not wait to see if application 2 does it correctly.

In this example, if application 2 fails to update its data, or even a request is made to application 2 before the update happens, the responding data could be inconsistent to the data of application 1.

- **Partition tolerance** states that given a partition failure, this could be a network error, the system continues to operate.

### ACID Properties

Help in making sure that we are able to perform transactions reliably.

- **Atomicity** states that the whole transaction must finish. If one part of the transaction fails, nothing in that transaction should happen.

- **Consistency** states that data should always be in the correct state. An example of this could be making sure that a constraint on a column is always kept.

- **Isolation** states that a database should be concurrent execution safe. If two requests are made to the same data, the requests should be handled synchronously.

- **Durability** states that any committed transaction should be saved, and available for rollbacks. If a transaction successfully completes, it is not said to be OK before the state is committed to memory.

## Designing the Database

*A backup of the database can be found [here](./documents/Library-backup.bak)*

For the design of the database, we were given a few entities, which had a bunch of hidden entities in them. This lead me to create a bunch of relations that were not described in the assignment.

When dealing with how to best deal with the Book / Magazine thing, it was clear that they both have a lot of the same attributes. This lead me to create what you might call a super entity, I choose this design for multiple reasons.

1. It means that we don't have to store more data than necessary for fields that are not relevant to only one library item (this would be the case if we just used a single entity with all columns in it).
2. It allows us to scale easily, since now we are able to add new items to the database without having to change already existing tables, which could be a massive help in production.

### ER Diagram

![ER Diagram](./documents/library-er-diagram.png)

## Stored Procedures and Transactions

*Multiple stored procedures were written, and can be found [here](./sql)*

Using transactions in the stored procedures, provided a way to ensure that our data is never in the wrong state. We are capable of this through the combination of transactions and rollbacks.

Stored procedures also allow us to provide relevant error messages to the users of our queries.

## Conclusion and Future Improvements

The Library is ready for customers.
However, we currently we are not handling a bunch of things such as the workers at the library.
We may also want to handle items that are sent back too late, or are never sent back, so some kind of time fee or something.
