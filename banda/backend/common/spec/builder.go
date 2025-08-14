package spec

type Builder interface {
	Equal(field string, value any)
	Gt(field string, value any)
	Gte(field string, value any)
	Lt(field string, value any)
	Lte(field string, value any)
	Prefix(field string, value string)
	Suffix(field string, value string)
	Contain(field string, value string)
	Like(field string, value string)
	In(field string, values []any)
	Between(field string, a any, b any)
	And(...Block)
	Or(...Block)
	Not(Block)
}

type specBuilder struct {
	specs []Spec
}

func (s *specBuilder) Contain(field string, value string) {
	s.specs = append(s.specs, Contain(field, value))
}

func (s *specBuilder) Equal(field string, value any) {
	s.specs = append(s.specs, Equal(field, value))
}

func (s *specBuilder) Gt(field string, value any) {
	s.specs = append(s.specs, Gt(field, value))
}

func (s *specBuilder) Gte(field string, value any) {
	s.specs = append(s.specs, Gte(field, value))
}

func (s *specBuilder) Like(field string, value string) {
	s.specs = append(s.specs, Like(field, value))
}

func (s *specBuilder) Lt(field string, value any) {
	s.specs = append(s.specs, Lt(field, value))
}

func (s *specBuilder) Lte(field string, value any) {
	s.specs = append(s.specs, Lte(field, value))
}

func (s *specBuilder) Prefix(field string, value string) {
	s.specs = append(s.specs, Prefix(field, value))
}

func (s *specBuilder) Suffix(field string, value string) {
	s.specs = append(s.specs, Suffix(field, value))
}

func (s *specBuilder) In(field string, values []any) {
	s.specs = append(s.specs, In(field, values))
}

func (s *specBuilder) Between(field string, a any, b any) {
	s.specs = append(s.specs, Between(field, a, b))
}

func (s *specBuilder) And(blocks ...Block) {
	specs := []Spec{}
	for _, block := range blocks {
		specs = append(specs, Specify(block))
	}
	s.specs = append(s.specs, And(specs...))
}

func (s *specBuilder) Or(blocks ...Block) {
	specs := []Spec{}
	for _, block := range blocks {
		specs = append(specs, Specify(block))
	}
	s.specs = append(s.specs, Or(specs...))
}

func (s *specBuilder) Not(block Block) {
	s.specs = append(s.specs, Not(Specify(block)))
}

func (s *specBuilder) Combine() Spec {
	if len(s.specs) == 0 {
		return &EmptySpec{}
	}

	if len(s.specs) == 1 {
		return s.specs[0]
	}

	return And(s.specs...)
}

type Block func(Builder)

func Specify(block Block) Spec {
	builder := &specBuilder{}
	block(builder)
	return builder.Combine()
}
