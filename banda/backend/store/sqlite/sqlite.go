package sqlitestore

import (
	"context"
	"database/sql"

	"github.com/fikrirnurhidayat/banda/backend/common/spec"
	"github.com/fikrirnurhidayat/banda/backend/store"
	_ "github.com/mattn/go-sqlite3"
)

type SQLiteStore struct {
	db *sql.DB
}

func (s *SQLiteStore) Destroy(ctx context.Context) {
	panic("unimplemented")
}

func (s *SQLiteStore) Get(ctx context.Context, spec spec.Spec) {
	panic("unimplemented")
}

func (s *SQLiteStore) Limit(ctx context.Context, value uint) store.Reader {
	panic("unimplemented")
}

func (s *SQLiteStore) Save(ctx context.Context) {
	panic("unimplemented")
}

func (s *SQLiteStore) Search(ctx context.Context) {
	panic("unimplemented")
}

func (s *SQLiteStore) Skip(ctx context.Context, value uint) store.Reader {
	panic("unimplemented")
}

func (s *SQLiteStore) Sort(ctx context.Context, value string) store.Reader {
	panic("unimplemented")
}

func New() store.Store {
	return &SQLiteStore{}
}
