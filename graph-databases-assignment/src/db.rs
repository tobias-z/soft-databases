use neo4rs::{query, Error, Graph, Row, RowStream};
use rocket::serde::{Deserialize, Serialize};

pub async fn initialize_data() -> Result<(), neo4rs::Error> {
    let graph = get_graph().await;
    graph
        .run(query(
            "
LOAD CSV WITH HEADERS FROM 'file:///web-Stanford.csv' as row
MERGE (f:Page {id: row.FromNodeId})
MERGE (s:Page {id: row.ToNodeId})
MERGE (f)-[l:Link {weight: 1.0}]->(s);",
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
    match get_single(result).await {
        Ok(row) => Ok(row.get("c").unwrap()),
        Err(e) => Err(e),
    }
}

pub async fn get_average_links() -> Result<f64, neo4rs::Error> {
    let graph = get_graph().await;
    let result = graph
        .execute(query(
            r#"
MATCH (p:Page)-[:Link]->(linkedTo:Page)
WITH p,count(linkedTo) as linkCount
RETURN avg(linkCount) as average;"#,
        ))
        .await;
    match get_single(result).await {
        Ok(row) => Ok(row.get("average").unwrap()),
        Err(e) => Err(e),
    }
}

#[derive(Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct PageScore {
    id: String,
    score: f64,
}

pub async fn get_highest_page_rank_nodes() -> Result<Vec<PageScore>, Error> {
    let graph = get_graph().await;
    if !graph_exists(&graph, "pageGraph").await {
        create_page_graph(&graph).await?;
        create_estimate(&graph).await?;
    }
    let result = graph
        .execute(query(
            r#"
CALL gds.pageRank.stream('pageGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).id AS id, score
ORDER BY score DESC, id ASC;
        "#,
        ))
        .await;

    match result {
        Ok(mut stream) => {
            let mut page_scores = vec![];
            while let Ok(Some(row)) = stream.next().await {
                let id = row.get::<String>("id").unwrap();
                let score = row.get::<f64>("score").unwrap();
                page_scores.push(PageScore { id, score });
            }
            Ok(page_scores)
        }
        Err(e) => Err(e),
    }
}

async fn create_estimate(graph: &Graph) -> Result<(), Error> {
    graph
        .run(query(
            r#"
CALL gds.pageRank.write.estimate('pageGraph', {
  writeProperty: 'pageRank',
  maxIterations: 20,
  dampingFactor: 0.85
});"#,
        ))
        .await
}

async fn create_page_graph(graph: &Graph) -> Result<(), Error> {
    graph
        .run(query(
            r#"
CALL gds.graph.project(
    'pageGraph',
    'Page',
    'Link',
    {
        relationshipProperties: 'weight'
    }
);"#,
        ))
        .await
}

async fn graph_exists(graph: &Graph, name: &str) -> bool {
    let result = graph
        .execute(
            query("RETURN gds.graph.exists($graph_name) as graph_exists;")
                .param("graph_name", name),
        )
        .await;
    match get_single(result).await {
        Ok(row) => row.get("graph_exists").unwrap_or(false),
        Err(_) => false,
    }
}

async fn get_single(result: Result<RowStream, Error>) -> Result<Row, Error> {
    match result {
        Ok(mut stream) => match stream.next().await {
            Ok(Some(row)) => Ok(row),
            Ok(None) => Err(neo4rs::Error::UnknownMessage("unknown error".to_string())),
            Err(e) => Err(e),
        },
        Err(e) => Err(e),
    }
}

async fn get_graph() -> Graph {
    let host = std::env::var("NEO4J_HOST").expect("Unable to find env value of 'NEO4J_HOST'");
    let username =
        std::env::var("NEO4J_USERNAME").expect("Unable to find env value of 'NEO4J_USERNAME'");
    let password =
        std::env::var("NEO4J_PASSWORD").expect("Unable to find env value of 'NEO4J_PASSWORD'");
    let uri = format!("{}:7687", host);
    Graph::new(&uri, &username, &password)
        .await
        .expect("unable to connect to neo4j database")
}
