use neo4rs::{query, Graph};

async fn get_graph() -> Graph {
    let host = std::env::var("NEO4J_HOST").expect("Unable to find env value of 'NEO4J_HOST'");
    let username =
        std::env::var("NEO4J_USERNAME").expect("Unable to find env value of 'NEO4J_USERNAME'");
    let password =
        std::env::var("NEO4J_PASSWORD").expect("Unable to find env value of 'NEO4J_PASSWORD'");
    let uri = format!("{}:7687", host);
    eprintln!("{} {} {}", uri, username, password);
    Graph::new(&uri, &username, &password)
        .await
        .expect("unable to connect to neo4j database")
}

pub async fn initialize_data() -> Result<(), neo4rs::Error> {
    let graph = get_graph().await;
    graph
        .run(query(
            "
LOAD CSV WITH HEADERS FROM 'file:///web-Stanford.csv' as row
MERGE (f:Page {id: row.FromNodeId})
MERGE (s:Page {id: row.ToNodeId})
MERGE (f)-[l:Link]->(s);",
        ))
        .await
}
