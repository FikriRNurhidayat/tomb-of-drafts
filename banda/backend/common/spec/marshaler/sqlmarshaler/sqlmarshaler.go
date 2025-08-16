package sqlmarshaler

import (
	"fmt"
	"strings"

	"github.com/fikrirnurhidayat/banda/backend/common/spec"
	"github.com/fikrirnurhidayat/banda/backend/common/spec/marshaler/sqlmarshaler/exception"
	"github.com/fikrirnurhidayat/banda/backend/common/spec/operator"

	sq "github.com/Masterminds/squirrel"
)

type serializer struct {
	attributes map[string]string
}

func (s *serializer) Call(spec spec.Spec) (sq.Sqlizer, error) {
	return s.apply(spec)
}

func (s *serializer) apply(v spec.Spec) (sq.Sqlizer, error) {
	compare, ok := v.(spec.Compare)
	if ok {
		return s.compare(compare)
	}

	logic, ok := v.(spec.Logic)
	if ok {
		return s.logic(logic)
	}

	set, ok := v.(spec.Set)
	if ok {
		return s.set(set)
	}

	return nil, exception.OperationNotSupported.Error()
}

func (s *serializer) set(set spec.Set) (sq.Sqlizer, error) {
	field, ok := s.attributes[set.Field()]
	if ok {
		switch set.Kind() {
		case operator.In:
			in := sq.Eq{}
			in[field] = set.Values()
			return in, nil
		case operator.Between:
			between := Between{}
			between[field] = set.Values()
			return between, nil
		default:
			return nil, exception.OperationNotSupported.Error()
		}
	}

	return nil, exception.FieldNotAllowed.Error()
}

func (s *serializer) logic(logic spec.Logic) (sq.Sqlizer, error) {
	switch logic.Kind() {
	case operator.And:
		and := sq.And{}
		specs := logic.Specs()
		for _, spec := range specs {
			andExpr, err := s.apply(spec)
			if err != nil {
				return nil, err
			}
			and = append(and, andExpr)
		}
		return and, nil
	case operator.Or:
		or := sq.Or{}
		specs := logic.Specs()
		for _, spec := range specs {
			orExpr, err := s.apply(spec)
			if err != nil {
				return nil, err
			}
			or = append(or, orExpr)
		}
		return or, nil
	default:
		return nil, exception.OperationNotSupported.Error()
	}
}

func (s *serializer) compare(compare spec.Compare) (sq.Sqlizer, error) {
	field, ok := s.attributes[compare.Field()]
	if ok {
		switch compare.Kind() {
		case operator.Equal:
			eq := sq.Eq{}
			eq[field] = compare.Value()
			return eq, nil
		case operator.Lt:
			lt := sq.Lt{}
			lt[field] = compare.Value()
			return lt, nil
		case operator.Lte:
			lte := sq.LtOrEq{}
			lte[field] = compare.Value()
			return lte, nil
		case operator.Gt:
			gt := sq.Gt{}
			gt[field] = compare.Value()
			return gt, nil
		case operator.Gte:
			gte := sq.GtOrEq{}
			gte[field] = compare.Value()
			return gte, nil
		case operator.Prefix:
			prefix := sq.Like{}
			prefix[field] = fmt.Sprintf("%s%%", compare.Value())
			return prefix, nil
		case operator.Suffix:
			suffix := sq.Like{}
			suffix[field] = fmt.Sprintf("%%%s", compare.Value())
			return suffix, nil
		case operator.Like:
			pattern, ok := compare.Value().(string)
			if ok {
				like := sq.Like{}
				like[field] = Like(pattern)
				return like, nil
			}

			return nil, exception.ValueNotAllowed.Error()
		case operator.Contain:
			contain := sq.Like{}
			contain[field] = fmt.Sprintf("%%%s%%", compare.Value())
			return contain, nil
		}
	}

	return nil, exception.OperationNotSupported.Error()
}

func Like(pattern string) string {
	pattern = strings.TrimPrefix(pattern, "^")
	pattern = strings.TrimSuffix(pattern, "$")
	pattern = strings.ReplaceAll(pattern, ".*", "%")
	pattern = strings.ReplaceAll(pattern, ".", "_")
	pattern = strings.ReplaceAll(pattern, "%", "\\%")
	pattern = strings.ReplaceAll(pattern, "_", "\\_")
	pattern = strings.ReplaceAll(pattern, "\\%\\%", "%") // from .*
	pattern = strings.ReplaceAll(pattern, "\\_\\_", "_") // from .
	return pattern
}

type MarshalFunc func(spec.Spec) (sq.Sqlizer, error)

type Marshaler interface {
	Call(spec spec.Spec) (sq.Sqlizer, error)
}

func New(attributes map[string]string) Marshaler {
	return &serializer{
		attributes: attributes,
	}
}
