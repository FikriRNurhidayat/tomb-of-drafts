package store

import (
	"context"

	"github.com/fikrirnurhidayat/banda/backend/common/exceptions"
)

const (
	limitKey = "store.Limit"
	skipKey  = "store.Skip"
	sortKey  = "store.Sort"
)

func Limit(ctx context.Context, limit int) context.Context {
	return context.WithValue(ctx, limitKey, limit)
}

func Skip(ctx context.Context, skip int) context.Context {
	return context.WithValue(ctx, skipKey, skip)
}

func Sort(ctx context.Context, sort []string) context.Context {
	return context.WithValue(ctx, sortKey, sort)
}

func GetLimit(ctx context.Context) (int, error) {
	limit, ok := ctx.Value(limitKey).(int)
	if !ok {
		return 0, exceptions.SystemFailure
	}

	return limit, nil
}

func GetSkip(ctx context.Context) (int, error) {
	skip, ok := ctx.Value(skipKey).(int)
	if !ok {
		return 0, exceptions.SystemFailure
	}

	return skip, nil
}

func GetSort(ctx context.Context) ([]string, error) {
	sort, ok := ctx.Value(sortKey).([]string)
	if !ok {
		return nil, exceptions.SystemFailure
	}

	return sort, nil
}
