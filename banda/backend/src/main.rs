use std::net::SocketAddr;

use axum::{
    Json, Router,
    extract::{Path, State},
    routing::get,
};
use chrono::Utc;
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, SqlitePool};
use uuid::Uuid;

#[tokio::main]
async fn main() {
    let pool = SqlitePool::connect("sqlite::memory:").await.unwrap();

    setup_database(&pool).await;

    let app = Router::new()
        .route(
            "/v1/transactions",
            get(search_transactions).post(create_transaction),
        )
        .route(
            "/v1/transactions/:id",
            get(get_transaction)
                .put(update_transaction)
                .delete(delete_transaction),
        )
        .with_state(pool);

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    println!("Listening on {}", addr);
    axum::serve(tokio::net::TcpListener::bind(addr).await.unwrap(), app)
        .await
        .unwrap();
}

async fn setup_database(pool: &SqlitePool) {
    sqlx::query(
        r#"
    CREATE TABLE IF NOT EXISTS transactions (
        id TEXT PRIMARY KEY,
        code TEXT NOT NULL,
        description TEXT NOT NULL,
        amount INTEGER NOT NULL,
        frequency TEXT NOT NULL,
        kind TEXT NOT NULL,
        category_id TEXT NOT NULL,
        category_name TEXT NOT NULL,
        source_id TEXT NOT NULL,
        source_name TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
    )
    "#,
    )
    .execute(pool)
    .await
    .unwrap();
}

#[derive(Serialize, Deserialize, FromRow)]
struct Transaction {
    id: String,
    code: String,
    description: String,
    amount: i64,
    frequency: String,
    kind: String,
    category_id: String,
    category_name: String,
    source_id: String,
    source_name: String,
    timestamp: String,
    created_at: String,
    updated_at: String,
}

#[derive(Deserialize)]
struct TransactionRequest {
    code: String,
    description: String,
    amount: i64,
    frequency: String,
    kind: String,
    category_id: String,
    category_name: String,
    source_id: String,
    source_name: String,
    timestamp: String,
}

async fn search_transactions(State(pool): State<SqlitePool>) -> Json<Vec<Transaction>> {
    let transactions = sqlx::query_as::<_, Transaction>("SELECT * FROM transactions")
        .fetch_all(&pool)
        .await
        .unwrap();
    Json(transactions)
}

async fn create_transaction(
    State(pool): State<SqlitePool>,
    Json(payload): Json<TransactionRequest>,
) -> Json<Transaction> {
    let id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();
    sqlx::query(
        r#"INSERT INTO transactions (
            id,
            code,
            description,
            amount,
            frequency,
            kind,
            category_id,
            category_name,
            source_id,
            source_name,
            timestamp,
            created_at,
            updated_at
        ) VALUES (
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?
        )"#,
    )
    .bind(&id)
    .bind(&payload.code)
    .bind(&payload.description)
    .bind(&payload.amount)
    .bind(&payload.frequency)
    .bind(&payload.kind)
    .bind(&payload.category_id)
    .bind(&payload.category_name)
    .bind(&payload.source_id)
    .bind(&payload.source_name)
    .bind(&payload.timestamp)
    .bind(&now)
    .bind(&now)
    .bind(&now)
    .execute(&pool)
    .await
    .unwrap()
    .last_insert_rowid();

    let transaction = sqlx::query_as::<_, Transaction>("SELECT * FROM transactions WHERE id = ?")
        .bind(&id)
        .fetch_one(&pool)
        .await
        .unwrap();

    Json(transaction)
}

async fn get_transaction(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
) -> Json<Option<Transaction>> {
    let transaction = sqlx::query_as::<_, Transaction>("SELECT * FROM transactions WHERE id = ?")
        .bind(&id)
        .fetch_optional(&pool)
        .await
        .unwrap();

    Json(transaction)
}

async fn update_transaction(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
    Json(payload): Json<TransactionRequest>,
) -> Json<Option<Transaction>> {
    let now = Utc::now().to_rfc3339();

    let res = sqlx::query(
        r#"
    UPDATE transactions
    SET code = ?,
        description = ?,
        amount = ?,
        frequency = ?,
        kind = ?,
        category_id = ?,
        category_name = ?,
        source_id = ?,
        source_name = ?,
        timestamp = ?,
        updated_at = ?
    WHERE id = ?"#,
    )
    .bind(&payload.code)
    .bind(&payload.description)
    .bind(&payload.amount)
    .bind(&payload.frequency)
    .bind(&payload.kind)
    .bind(&payload.category_id)
    .bind(&payload.category_name)
    .bind(&payload.source_id)
    .bind(&payload.source_name)
    .bind(&payload.timestamp)
    .bind(&now)
    .bind(&id)
    .execute(&pool)
    .await
    .unwrap();

    if res.rows_affected() == 0 {
        Json(None)
    } else {
        let transactions =
            sqlx::query_as::<_, Transaction>("SELECT * FROM transactions WHERE id = ?")
                .bind(id)
                .fetch_one(&pool)
                .await
                .unwrap();
        Json(Some(transactions))
    }
}

async fn delete_transaction(State(pool): State<SqlitePool>, Path(id): Path<String>) -> Json<bool> {
    let res = sqlx::query("DELETE FROM transactions WHERE id = ?")
        .bind(id)
        .execute(&pool)
        .await
        .unwrap();
    Json(res.rows_affected() > 0)
}
