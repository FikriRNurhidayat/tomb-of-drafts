package spec

type Spec interface {
	And(Spec) Spec
	Or(Spec) Spec
}

type EmptySpec struct{}
func (*EmptySpec) And(s Spec) Spec { return s }
func (*EmptySpec) Or(s Spec) Spec  { return &EmptySpec{} }
