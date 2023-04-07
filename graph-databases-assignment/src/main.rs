pub mod db;

use dotenv::dotenv;
use rocket::{launch, routes};

#[macro_use]
extern crate rocket;

#[get("/ping")]
async fn ping() -> String {
    "pong".to_string()
}

#[post("/init")]
async fn init() -> String {
    match db::initialize_data().await {
        Ok(_) => "success".to_string(),
        Err(_) => "unable to initialize data".to_string(),
    }
}

#[launch]
fn rocket() -> _ {
    dotenv().ok();
    rocket::build().mount("/", routes![ping, init])
}
