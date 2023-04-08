pub mod db;

use dotenv::dotenv;
use rocket::{
    http::Status,
    launch,
    response::status::Custom,
    routes,
    serde::{json::Json, Deserialize, Serialize},
};

type ErrorResponse = Custom<Json<WebError>>;

type WebResult<T> = Result<T, ErrorResponse>;

#[derive(Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
struct WebError {
    code: u16,
    message: String,
}

impl WebError {
    fn new(status: Status, message: String) -> Self {
        Self {
            code: status.code,
            message,
        }
    }
}

impl From<WebError> for ErrorResponse {
    fn from(error: WebError) -> Self {
        Custom(Status { code: error.code }, Json(error))
    }
}

#[macro_use]
extern crate rocket;

#[get("/ping")]
async fn ping() -> String {
    "pong".to_string()
}

#[post("/init")]
async fn init() -> WebResult<String> {
    match db::initialize_data().await {
        Ok(_) => Ok("success".to_string()),
        Err(_) => Err(WebError::new(
            Status::InternalServerError,
            "unable to initialize data".to_string(),
        )
        .into()),
    }
}

#[get("/links/<page>")]
async fn pages_that_link_to(page: u128) -> WebResult<String> {
    match db::pages_that_link_to(page).await {
        Ok(count) => Ok(count.to_string()),
        Err(_) => Err(WebError::new(Status::NotFound, "Page not found".to_string()).into()),
    }
}

#[rocket::main]
async fn main() -> Result<(), rocket::Error> {
    dotenv().ok();
    rocket::build()
        .mount("/", routes![ping, init, pages_that_link_to])
        .launch()
        .await?;
    Ok(())
}
