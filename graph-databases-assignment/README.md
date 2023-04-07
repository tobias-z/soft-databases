<div align="center">

# Graph Databases Assignment

By Tobias Zimmermann (cph-tz11@cphbusiness.dk)

</div>

## Table of contents

- [Introduction](#introduction)
- [Business Case](#business-case)
- [Data](#data)
- [Algorithms](#algorithms)
- [Dev Environment](#dev-environment)
  - [Server](#server)
  - [Web App](#web-app)
  - [CI and CD](#ci-and-cd)

## Introduction

This project was intended to make us learn about graph databases, and how to work with them in practice.

The assignment can be found [here](./documents/assignment.pdf)

## Business Case

The business case is to provide a way to view pages and their links.
We should also be able to figure out if a selected page is important.

## Data

The selected data is the `Stanford web graph` which is a graph of pages relevant to Stanford University.

The data was found [here](https://snap.stanford.edu/data/web-Stanford.html) and the zip containing the data can be found [here](./documents/web-Stanford.csv.gz)

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

## Algorithms

### Dijkstra's shortest path

The implementation for Dijkstra's shortest path can be found [here](./server/crates/map/src/dijkstra.rs) and some tests for it can be found [here](./server/crates/map/tests/dijkstra.rs).

The algorithm is used to find the shortest path from one node to either every other node in the graph, or to a specific node (depending on the way you implemented the algorithm)

### DFS (depth first search)

The implementation for DFS can be found [here](./server/crates/map/src/dfs.rs) and some tests for it can be found [here](./server/crates/map/tests/map.rs).

DFS is a graph searching algorithm which goes vertically down the graph, visiting all relations of a relation before visiting the other relations of that node.

It should be used over BFS when you know what you are searching for is possibly far away from your starting point.
Examples of this might be a maze, where the end of the maze could be found by following one of the paths, and you don't need to follow all paths at ones (BFS)

## Dev Environment

This section includes information about how the environment works.

### Server

A rest API allowing us to interact with the map. It consists of:

- A [main binary](./server/src/main.rs) which simply sets up some rest endpoints.
- A [DB module](./server/crates/db) which interacts with the relational database.
- A [Map module](./server/crates/map) which includes all the graph algorithms.

### Web App

A simple [react app](./web/src/App.tsx) which interacts with the server and allows us to query the map for paths to go.

In production, it is spun up in a nginx container.

### CI and CD

For continuous integration GitHub actions was used to run tests and checks on the code.

For continuous deployment, a [simple server](https://github.com/tobias-z/simple-cd) was written. This server would ensure that the configuration provided in the [conf](./conf) directory would be maintained on the server.

All that was required was that we notified the server about a change in the production ready code in our pipeline:

```yaml
- name: deploy to docker hub and server
  env:
    DOCKER_USERNAME: tobiaszimmer
    DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
    GITURL: https://github.com/${{ github.repository }}
    TOKEN: ${{ secrets.TOKEN }}
    SERVER_URL: ${{ secrets.SERVER_URL }}
  if: ${{ github.event_name != 'pull_request' }}
  run: |
    version=$(head "server/Cargo.toml" | grep version | head -n 1 | tr 'version = "' " " | xargs | awk '{print tolower($0)}')
    project_name=$(head "server/Cargo.toml" | grep name | head -n 1 | sed 's/"//g' | sed 's/name = //g' | xargs | awk '{print tolower($0)}')
    echo "$DOCKER_PASSWORD" | docker login --username $DOCKER_USERNAME --password-stdin
    server_image_name="$DOCKER_USERNAME/$project_name-server:$version"
    web_image_name="$DOCKER_USERNAME/$project_name-web:$version"
    docker build --tag "$server_image_name" server
    docker build --tag "$web_image_name" web
    docker push "$server_image_name"
    docker push "$web_image_name"

    # This notifies our server about a change and where to fetch it from.
    curl --request POST \
      --url $SERVER_URL/simple-cd/deploy \
      --header 'Content-Type: application/json' \
      --data "{\"name\": \"$project_name\", \"giturl\": \"$GITURL\", \"token\": \"$TOKEN\", \"downdir\": \"graph-project\", \"invalidate_images\": [\"$server_image_name\", \"$web_image_name\"], \"project_version\": \"$version\"}"
```
