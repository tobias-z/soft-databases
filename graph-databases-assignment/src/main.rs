use dotenv::dotenv;
use rocket::{launch, routes};

#[macro_use]
extern crate rocket;

#[get("/ping")]
async fn ping() -> String {
    "pong".to_string()
}

#[launch]
fn rocket() -> _ {
    dotenv().ok();
    rocket::build().mount("/", routes![ping])
}
