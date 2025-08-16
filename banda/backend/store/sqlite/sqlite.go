package sqlitestore

import (
	"context"
	"database/sql"

	sq "github.com/Masterminds/squirrel"
	"github.com/fikrirnurhidayat/banda/backend/common/exceptions"
	"github.com/fikrirnurhidayat/banda/backend/common/spec"
	"github.com/fikrirnurhidayat/banda/backend/common/spec/marshaler/sqlmarshaler"
	_ "github.com/mattn/go-sqlite3"
)

type SQLRow map[string]any
type SQLRows []SQLRow
type MarshalRowFunc[E any] func(E) SQLRow
type MarshalEntityFunc[E any] func(SQLRow) E

type SQLiteStore[E any] struct {
	db            *sql.DB
	table         string
	marshalSQL    sqlmarshaler.MarshalFunc
	marshalRow    MarshalRowFunc[E]
	marshalEntity MarshalEntityFunc[E]
}

func (s *SQLiteStore[E]) Destroy(ctx context.Context, spec spec.Spec) error {
	panic("unimplemented")
}

func (s *SQLiteStore[E]) Get(ctx context.Context, spec spec.Spec) (*E, error) {
	expr, err := s.marshalSQL(spec)
	if err != nil {
		return nil, err
	}

	query, args, err := sq.Select().From(s.table).Where(expr).Limit(1).ToSql()
	if err != nil {
		return nil, exceptions.SystemFailure
	}

	rows, err := s.db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, exceptions.SystemFailure
	}

	_, err := s.rows(rows)
	if err != nil {
		return nil, exceptions.SystemFailure
	}

	panic("unimplemented")
}

func (s *SQLiteStore[E]) Save(ctx context.Context, entity E) error {
	panic("unimplemented")
}

func (s *SQLiteStore[E]) Search(ctx context.Context, spec spec.Spec) ([]*E, error) {
	expr, err := s.marshalSQL(spec)
	if err != nil {
		return nil, err
	}

	sq.Select().From(s.table).Where(expr).ToSql()
	panic("unimplemented")
}

func (s *SQLiteStore[E]) rows(rows *sql.Rows) (SQLRows, error) {
	cols, err := rows.Columns()
	if err != nil {
		return nil, err
	}

	var result SQLRows
	for rows.Next() {
		values := make([]any, len(cols))
		pointers := make([]any, len(cols))

		for i := range cols {
			pointers[i] = &values[i]
		}

		if err := rows.Scan(pointers...); err != nil {
			return nil, err
		}

		m := make(map[string]any, len(cols))
		for i, col := range cols {
			m[col] = values[i]
		}
		result = append(result, m)
	}

	return result, rows.Err()
}
