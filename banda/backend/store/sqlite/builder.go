package sqlitestore

import (
	"database/sql"
	"github.com/fikrirnurhidayat/banda/backend/common/spec/marshaler/sqlmarshaler"
)

type Builder[E any] struct {
	table         string
	attr          map[string]string
	db            *sql.DB
	marshalRow    MarshalRowFunc[E]
	marshalEntity MarshalEntityFunc[E]
}

func Init[E any]() *Builder[E] {
	b := &Builder[E]{}
	return b
}

func (b *Builder[E]) Connection(db *sql.DB) *Builder[E] {
	b.db = db
	return b
}

func (b *Builder[E]) Row(row MarshalRowFunc[E]) *Builder[E] {
	b.marshalRow = row
	return b
}

func (b *Builder[E]) Entity(entity MarshalEntityFunc[E]) *Builder[E] {
	b.marshalEntity = entity
	return b
}

func (b *Builder[E]) Attr(attr map[string]string) *Builder[E] {
	b.attr = attr
	return b
}

func (b *Builder[E]) Table(table string) *Builder[E] {
	b.table = table
	return b
}

func (b *Builder[E]) Build() *SQLiteStore[E] {
	return &SQLiteStore[E]{
		db:            b.db,
		table:         b.table,
		marshalSQL:    sqlmarshaler.New(b.attr).Call,
		marshalRow:    b.marshalRow,
		marshalEntity: b.marshalEntity,
	}
}
