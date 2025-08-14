package operator

type Type int

const (
	And Type = iota
	Or
	Not
	Equal
	Gt
	Gte
	Lt
	Lte
	Prefix
	Suffix
	Contain
	Like
	In
	Between
)

func (t Type) String() string {
	switch t {
	case And:
		return "And"
	case Or:
		return "Or"
	case Not:
		return "Not"
	case Equal:
		return "Equal"
	case Gt:
		return "Gt"
	case Gte:
		return "Gte"
	case Lt:
		return "Lt"
	case Lte:
		return "Lte"
	case Prefix:
		return "Prefix"
	case Suffix:
		return "Suffix"
	case Contain:
		return "Contain"
	case Like:
		return "Like"
	case In:
		return "In"
	case Between:
		return "Between"
	default:
		return ""
	}
}
