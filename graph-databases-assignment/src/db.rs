use neo4rs::{query, Graph, Node};

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

pub async fn pages_that_link_to(page: u128) -> Result<i64, neo4rs::Error> {
    let graph = get_graph().await;
    let result = graph
        .execute(
            query(
                r#"
MATCH (p:Page {id: $id})
WITH p MATCH (p) <- [:Link] - (p_from:Page)
return COUNT(p_from) as c;"#,
            )
            .param("id", page.to_string()),
        )
        .await;
    match result {
        Ok(mut stream) => match stream.next().await {
            Ok(Some(row)) => Ok(row.get::<i64>("c").unwrap()),
            Ok(None) => Err(neo4rs::Error::UnknownMessage("unknown error".to_string())),
            Err(e) => Err(e),
        },
        Err(e) => Err(e),
    }
}
