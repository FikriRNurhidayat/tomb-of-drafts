package store

import (
	"context"

	"github.com/fikrirnurhidayat/banda/backend/common/spec"
)

type Reader interface {
	Limit(ctx context.Context, value uint) Reader
	Skip(ctx context.Context, value uint) Reader
	Sort(ctx context.Context, value string) Reader
	Search(ctx context.Context)
	Get(ctx context.Context, spec spec.Spec)
}

type Writer interface {
	Destroy(ctx context.Context)
	Save(ctx context.Context)
}

type Store interface {
	Reader
	Writer
}
