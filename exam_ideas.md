# Exam Ideas

## Understanding

- Polyglot persistence - persistence not only to a single location, but in this case to multiple databases. This could mean multiple things, such as:
  1. Storing the same data in different ways on different databases, such that we are able to perform actions based on the use case of a query. If this is chosen we need to ensure data consistency through some sort of way to handle transactions going through multiple steps / services (Saga pattern).
  2. Storing some parts of the data in one model for a specific use case in one database, and other parts of the data in other databases.

- The databases are in focus!

## Objective

_The objective is providing database support to an application, where multiple diverse database models
are built and implemented for different purposes._

This means that we need to find a project that has multiple parts of things that need to be handled.

## Database ideas

- Mongodb logging:
  We can create a process that looks like this:

  - Setup logging to log to stdout.
  - Run an application which will collect the logs and send them to a second application which will store the logs in a neat way, to make them easily queryable through a simple proof of concept query language:
    e.g. `(container auth-service | level INFO | find "login" | contains "invalid" | sort date DESC | take 30)`
  - Create some sort of UI which will allow us to query the logs and see logs for specific services.
  - Create sharding, where the sharding key could be something like the container name, the date or a combination of both. This would allow us to have very performant queries on specific containers

  This will enable us to have logging for all microservices, and be scalable to the extent that if we want to create clusters of servers, all logs will still be queryable from a single place.

## To do

- [] Multiple diverse database models
- [] Large volumes of frequently collected data from multiple sources
- [] Documentation of what problems we are solving related to performance optimization and usability of both the structured and unstructured data when throwing the data into specific databases. Perhaps also a section about what problems arrive ones a polyglot database architecture is chosen.
- [] Select a business case where databases have an essential role.
- [] Define the application domain
  - [] Categories of users
  - [] Categories of use cases?
  - [] Functional requirements
  - [] No functional requirements
  - [] Various information retrieving database operations and queries for each database used
- [] Select databases based on the requirements
  - [] Minimum 3
  - [] Transformation of data in between the database models
- [] Design the databases
  - [] Large amounts of real data from the public internet
  - [] Divide the responsibilities of data handling to different databases
  - [] Data quality? (ASK)
  - [] Validation and testing of design and development process (Normal form, testing tools for performance, consider things like indexes or other performance optimization we have learned)
- [] Deploy the database
  - [] Deploy at least one database in a cluster
  - [] Demonstrate performance tuning and optimization
  - [] Consider ACID and CAP
- [] Create one or more simple client applications (either simple UI's or tools like curl and Postman)
  - [] Illustrate both usage as an end-user and as database administrator
- [] Record up to ten minutes video
- [] Store diagrams, scripts, the application code, and the data sources in a GitHub repository
- [] The application and demonstrations must be reproducible
