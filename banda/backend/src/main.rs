use std::net::SocketAddr;

use axum::{
    Json, Router,
    extract::{Path, State},
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::get,
};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, SqlitePool};
use uuid::Uuid;

#[tokio::main]
async fn main() {
    let pool = SqlitePool::connect("sqlite::memory:").await.unwrap();

    setup_database(&pool).await;

    let app = Router::new()
        .route(
            "/v1/categories",
            get(search_categories).post(create_category),
        )
        .route(
            "/v1/categories/:id",
            get(get_category)
                .put(update_category)
                .delete(delete_category),
        )
        .route("/v1/sources", get(search_sources).post(create_source))
        .route(
            "/v1/sources/:id",
            get(get_source).put(update_source).delete(delete_source),
        )
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
    CREATE TABLE IF NOT EXISTS categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
    )
    "#,
    )
    .execute(pool)
    .await
    .unwrap();

    sqlx::query(
        r#"
    CREATE TABLE IF NOT EXISTS sources (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
    )
    "#,
    )
    .execute(pool)
    .await
    .unwrap();

    sqlx::query(
        r#"
    CREATE TABLE IF NOT EXISTS transactions (
        id TEXT PRIMARY KEY,
        code TEXT NOT NULL,
        description TEXT NOT NULL,
        amount INTEGER NOT NULL,
        frequency TEXT NOT NULL,
        kind TEXT NOT NULL,
        category_id TEXT NOT NULL REFERENCES categories (id),
        category_name TEXT NOT NULL,
        source_id TEXT NOT NULL REFERENCES sources (id),
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

// Common
struct AppError(anyhow::Error);

impl<E: Into<anyhow::Error>> From<E> for AppError {
    fn from(err: E) -> Self {
        AppError(err.into())
    }
}

// Tell axum how to convert `AppError` into a response.
impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        eprintln!("Internal error: {:?}", self.0);
        (StatusCode::NOT_IMPLEMENTED, ()).into_response()
    }
}

// Category
#[derive(Serialize, Deserialize, FromRow)]
struct Category {
    id: String,
    name: String,
    created_at: String,
    updated_at: String,
}

#[derive(Deserialize)]
struct CategoryRequest {
    name: String,
}

async fn search_categories(
    State(pool): State<SqlitePool>,
) -> Result<Json<Vec<Category>>, AppError> {
    let categories = sqlx::query_as::<_, Category>("SELECT * FROM categories")
        .fetch_all(&pool)
        .await?;
    Ok(Json(categories))
}

async fn create_category(
    State(pool): State<SqlitePool>,
    Json(payload): Json<CategoryRequest>,
) -> Result<Json<Category>, AppError> {
    let id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();

    sqlx::query(
        r#"INSERT INTO categories (
            id,
            name,
            created_at,
            updated_at
        ) VALUES (
            ?,
            ?,
            ?,
            ?
        )"#,
    )
    .bind(&id)
    .bind(&payload.name)
    .bind(&now)
    .bind(&now)
    .execute(&pool)
    .await?;

    let category = sqlx::query_as::<_, Category>("SELECT * FROM categories WHERE id = ?")
        .bind(&id)
        .fetch_one(&pool)
        .await?;

    Ok(Json(category))
}

async fn get_category(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
) -> Result<Json<Option<Category>>, AppError> {
    let category = sqlx::query_as::<_, Category>("SELECT * FROM categories WHERE id = ?")
        .bind(&id)
        .fetch_optional(&pool)
        .await?;

    Ok(Json(category))
}

async fn update_category(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
    Json(payload): Json<CategoryRequest>,
) -> Result<Json<Option<Category>>, AppError> {
    let now = Utc::now().to_rfc3339();

    let res = sqlx::query(
        r#"
    UPDATE categories
    SET name = ?,
        updated_at = ?
    WHERE id = ?"#,
    )
    .bind(&payload.name)
    .bind(&now)
    .bind(&id)
    .execute(&pool)
    .await?;

    if res.rows_affected() == 0 {
        Ok(Json(None))
    } else {
        let categories = sqlx::query_as::<_, Category>("SELECT * FROM categories WHERE id = ?")
            .bind(id)
            .fetch_one(&pool)
            .await?;
        Ok(Json(Some(categories)))
    }
}

async fn delete_category(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
) -> Result<(), AppError> {
    sqlx::query("DELETE FROM categories WHERE id = ?")
        .bind(id)
        .execute(&pool)
        .await?;
    Ok(())
}

// Source
#[derive(Serialize, Deserialize, FromRow)]
struct Source {
    id: String,
    name: String,
    created_at: String,
    updated_at: String,
}

#[derive(Deserialize)]
struct SourceRequest {
    name: String,
}

async fn search_sources(State(pool): State<SqlitePool>) -> Result<Json<Vec<Source>>, AppError> {
    let sources = sqlx::query_as::<_, Source>("SELECT * FROM sources")
        .fetch_all(&pool)
        .await?;
    Ok(Json(sources))
}

async fn create_source(
    State(pool): State<SqlitePool>,
    Json(payload): Json<SourceRequest>,
) -> Result<Json<Source>, AppError> {
    let id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();

    sqlx::query(
        r#"INSERT INTO sources (
            id,
            name,
            created_at,
            updated_at
        ) VALUES (
            ?,
            ?,
            ?,
            ?
        )"#,
    )
    .bind(&id)
    .bind(&payload.name)
    .bind(&now)
    .bind(&now)
    .execute(&pool)
    .await?;

    let source = sqlx::query_as::<_, Source>("SELECT * FROM sources WHERE id = ?")
        .bind(&id)
        .fetch_one(&pool)
        .await?;

    Ok(Json(source))
}

async fn get_source(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
) -> Result<Json<Option<Source>>, AppError> {
    let source = sqlx::query_as::<_, Source>("SELECT * FROM sources WHERE id = ?")
        .bind(&id)
        .fetch_optional(&pool)
        .await?;

    Ok(Json(source))
}

async fn update_source(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
    Json(payload): Json<SourceRequest>,
) -> Result<Json<Option<Source>>, AppError> {
    let now = Utc::now().to_rfc3339();

    let res = sqlx::query(
        r#"
    UPDATE sources
    SET name = ?,
        updated_at = ?
    WHERE id = ?"#,
    )
    .bind(&payload.name)
    .bind(&now)
    .bind(&id)
    .execute(&pool)
    .await?;

    if res.rows_affected() == 0 {
        Ok(Json(None))
    } else {
        let sources = sqlx::query_as::<_, Source>("SELECT * FROM sources WHERE id = ?")
            .bind(id)
            .fetch_one(&pool)
            .await
            .unwrap();
        Ok(Json(Some(sources)))
    }
}

async fn delete_source(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
) -> Result<(), AppError> {
    sqlx::query("DELETE FROM sources WHERE id = ?")
        .bind(id)
        .execute(&pool)
        .await?;
    Ok(())
}

// Transaction

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
    source_id: String,
    timestamp: String,
}

async fn search_transactions(
    State(pool): State<SqlitePool>,
) -> Result<Json<Vec<Transaction>>, AppError> {
    let transactions = sqlx::query_as::<_, Transaction>("SELECT * FROM transactions")
        .fetch_all(&pool)
        .await?;
    Ok(Json(transactions))
}

async fn create_transaction(
    State(pool): State<SqlitePool>,
    Json(payload): Json<TransactionRequest>,
) -> Result<Json<Transaction>, AppError> {
    let id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();
    let timestamp = DateTime::parse_from_rfc3339(&payload.timestamp)?.to_rfc3339();

    let source = sqlx::query_as::<_, Source>("SELECT * FROM sources WHERE id = ?")
        .bind(&payload.source_id)
        .fetch_one(&pool)
        .await?;

    let category = sqlx::query_as::<_, Category>("SELECT * FROM categories WHERE id = ?")
        .bind(&payload.category_id)
        .fetch_one(&pool)
        .await?;

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
    .bind(&category.id)
    .bind(&category.name)
    .bind(&source.id)
    .bind(&source.name)
    .bind(&timestamp)
    .bind(&now)
    .bind(&now)
    .bind(&now)
    .execute(&pool)
    .await?;

    let transaction = sqlx::query_as::<_, Transaction>("SELECT * FROM transactions WHERE id = ?")
        .bind(&id)
        .fetch_one(&pool)
        .await?;

    Ok(Json(transaction))
}

async fn get_transaction(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
) -> Result<Json<Option<Transaction>>, AppError> {
    let transaction = sqlx::query_as::<_, Transaction>("SELECT * FROM transactions WHERE id = ?")
        .bind(&id)
        .fetch_optional(&pool)
        .await?;

    Ok(Json(transaction))
}

async fn update_transaction(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
    Json(payload): Json<TransactionRequest>,
) -> Result<Json<Option<Transaction>>, AppError> {
    let now = Utc::now().to_rfc3339();
    let source = sqlx::query_as::<_, Source>("SELECT * FROM sources WHERE id = ?")
        .bind(&payload.source_id)
        .fetch_one(&pool)
        .await?;
    let category = sqlx::query_as::<_, Category>("SELECT * FROM categories WHERE id = ?")
        .bind(&payload.category_id)
        .fetch_one(&pool)
        .await?;

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
    .bind(&category.id)
    .bind(&category.name)
    .bind(&source.id)
    .bind(&source.name)
    .bind(&payload.timestamp)
    .bind(&now)
    .bind(&id)
    .execute(&pool)
    .await?;

    if res.rows_affected() == 0 {
        Ok(Json(None))
    } else {
        let transactions =
            sqlx::query_as::<_, Transaction>("SELECT * FROM transactions WHERE id = ?")
                .bind(id)
                .fetch_one(&pool)
                .await
                .unwrap();
        Ok(Json(Some(transactions)))
    }
}

async fn delete_transaction(
    State(pool): State<SqlitePool>,
    Path(id): Path<String>,
) -> Result<(), AppError> {
    sqlx::query("DELETE FROM transactions WHERE id = ?")
        .bind(id)
        .execute(&pool)
        .await?;
    Ok(())
}
