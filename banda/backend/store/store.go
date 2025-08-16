package store

import (
	"context"

	"github.com/fikrirnurhidayat/banda/backend/common/spec"
)

type Reader[T any] interface {
	Search(ctx context.Context, spec spec.Spec) ([]T, error)
	Get(ctx context.Context, spec spec.Spec) (T, error)
}

type Writer[T any] interface {
	Destroy(ctx context.Context, spec spec.Spec) error
	Save(ctx context.Context, entity T) error
}

type Store[T any] interface {
	Reader[T]
	Writer[T]
}
