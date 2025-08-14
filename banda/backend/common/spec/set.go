package spec

import (
	"github.com/fikrirnurhidayat/banda/backend/common/spec/operator"
)

type Set interface {
	Spec
	Kind() operator.Type
	Field() string
	Values() []any
}

type setSpec struct {
	kind   operator.Type
	field  string
	values []any
}

func (s *setSpec) And(spec Spec) Spec {
	return And(s, spec)
}

func (s *setSpec) Or(spec Spec) Spec {
	return Or(s, spec)
}

func (s *setSpec) Field() string {
	return s.field
}

func (s *setSpec) Kind() operator.Type {
	return s.kind
}

func (s *setSpec) Values() []any {
	return s.values
}

func Between(field string, a any, b any) Set {
	return &setSpec{
		kind:   operator.Between,
		field:  field,
		values: []any{a, b},
	}
}

func In(field string, values []any) Set {
	return &setSpec{
		kind:   operator.In,
		field:  field,
		values: values,
	}
}
