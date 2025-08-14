package spec

import "github.com/fikrirnurhidayat/banda/backend/common/spec/operator"

type Logic interface {
	Spec
	Specs() []Spec
	Kind() operator.Type
}

type logicSpec struct {
	kind  operator.Type
	specs []Spec
}

func (c *logicSpec) Kind() operator.Type {
	return c.kind
}

func (c logicSpec) Specs() []Spec {
	return c.specs
}

func (c logicSpec) Or(spec Spec) Spec {
	return Or(c, spec)
}

func (c logicSpec) And(spec Spec) Spec {
	return And(c, spec)
}

func And(specs ...Spec) Logic {
	return &logicSpec{
		kind:  operator.And,
		specs: specs,
	}
}

func Or(specs ...Spec) Logic {
	return &logicSpec{
		kind:  operator.Or,
		specs: specs,
	}
}

func Not(s Spec) Logic {
	return &logicSpec{
		kind:  operator.Not,
		specs: []Spec{s},
	}
}
