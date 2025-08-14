package spec

import (
	"github.com/fikrirnurhidayat/banda/backend/common/spec/operator"
)

type Compare interface {
	Spec
	Kind() operator.Type
	Field() string
	Value() any
}

type cmpSpec struct {
	kind  operator.Type
	field string
	value any
}

func (c *cmpSpec) Or(spec Spec) Spec {
	return Or(c, spec)
}

func (c *cmpSpec) And(spec Spec) Spec {
	return And(c, spec)
}

func (c *cmpSpec) Field() string {
	return c.field
}

func (c *cmpSpec) Value() any {
	return c.value
}

func (c *cmpSpec) Kind() operator.Type {
	return c.kind
}

func Equal(field string, value any) Compare {
	return &cmpSpec{
		kind:  operator.Equal,
		field: field,
		value: value,
	}
}

func Gt(field string, value any) Compare {
	return &cmpSpec{
		kind:  operator.Gt,
		field: field,
		value: value,
	}
}

func Gte(field string, value any) Compare {
	return &cmpSpec{
		kind:  operator.Gte,
		field: field,
		value: value,
	}
}

func Lt(field string, value any) Compare {
	return &cmpSpec{
		kind:  operator.Lt,
		field: field,
		value: value,
	}
}

func Lte(field string, value any) Compare {
	return &cmpSpec{
		kind:  operator.Lte,
		field: field,
		value: value,
	}
}

func Prefix(field string, value string) Compare {
	return &cmpSpec{
		kind:  operator.Prefix,
		field: field,
		value: value,
	}
}

func Suffix(field string, value string) Compare {
	return &cmpSpec{
		kind:  operator.Suffix,
		field: field,
		value: value,
	}
}

func Contain(field string, value string) Compare {
	return &cmpSpec{
		kind:  operator.Contain,
		field: field,
		value: value,
	}
}

func Like(field string, value string) Compare {
	return &cmpSpec{
		kind:  operator.Like,
		field: field,
		value: value,
	}
}
