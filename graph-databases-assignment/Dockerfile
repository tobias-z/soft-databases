FROM rust:1.68.0-slim as builder
WORKDIR /build
COPY . .
RUN rustup default nightly
RUN apt update && apt install pkg-config libssl-dev -y
RUN cargo build --release

FROM debian:11-slim
COPY --from=builder /build/target/release/graph-databases-assignment /usr/local/bin/graph-databases-assignment
CMD [ "graph-databases-assignment" ]
