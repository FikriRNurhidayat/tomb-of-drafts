package sqlserializer

import (
	"database/sql"
	"fmt"
	"strings"

	"github.com/fikrirnurhidayat/banda/backend/common/spec"
	"github.com/fikrirnurhidayat/banda/backend/common/spec/operator"

	"github.com/Masterminds/squirrel"
)

type serializer struct {
	attributes map[string]string
}

func (s *serializer) Serialize(builder squirrel.SelectBuilder, spec spec.Spec) (squirrel.SelectBuilder, error) {
	builder = s.apply(builder, spec)
	return builder, nil
}

func (s *serializer) apply(builder squirrel.SelectBuilder, v spec.Spec) squirrel.SelectBuilder {
	compare, ok := v.(spec.Compare)
	if ok {
		return s.compare(builder, compare)
	}

	logic, ok := v.(spec.Logic)
	if ok {
		return s.logic(builder, logic)
	}

	// set, ok := v.(spec.Set)
	// if ok {
	// 	return s.set(query, args, set)
	// }

	panic("SHIT!")
}

// func (s *serializer) set(query *strings.Builder, args []sql.NamedArg, set spec.Set) ([]sql.NamedArg, error) {
// 	field, ok := s.attributes[set.Field()]
// 	if ok {
// 		named := set.Field()
// 		args = append(args, sql.Named(named, set.Values()))
// 		switch set.Kind() {
// 		case operator.In:
// 			fmt.Fprintf(query, " %s IN (:%s)", field, named)
// 		case operator.Between:
// 			fmt.Fprintf(query, " %s IN (:%s)", field, named)
// 		}
// 	}
//
// 	return args, nil
// }

func (s *serializer) logic(builder squirrel.SelectBuilder, logic spec.Logic) squirrel.SelectBuilder {
	switch logic.Kind() {
	case operator.And:
		specs := logic.Specs()
		for _, spec := range specs {
			builder = s.apply(builder, spec)
		}
		return builder
	case operator.Or:
		specs := logic.Specs()
		for _, spec := range specs {
			builder = s.apply(builder, spec)
		}
		return builder
	}

	panic("Shit!")
}

func (s *serializer) compare(builder squirrel.SelectBuilder, compare spec.Compare) squirrel.SelectBuilder {
	field, ok := s.attributes[compare.Field()]
	if ok {
		switch compare.Kind() {
		case operator.Equal:
			eq := squirrel.Eq{}
			eq[field] = compare.Value()
			builder = builder.Where(eq)
		case operator.Lt:
			lt := squirrel.Lt{}
			lt[field] = compare.Value()
			builder = builder.Where(lt)
		case operator.Lte:
			lte := squirrel.LtOrEq{}
			lte[field] = compare.Value()
			builder = builder.Where(lte)
		case operator.Gt:
			gt := squirrel.Gt{}
			gt[field] = compare.Value()
			builder = builder.Where(gt)
		case operator.Gte:
			gte := squirrel.GtOrEq{}
			gte[field] = compare.Value()
			builder = builder.Where(gte)
		case operator.Prefix:
			prefix := squirrel.Like{}
			prefix[field] = fmt.Sprintf("%s%%", compare.Value())
			builder = builder.Where(prefix)
		case operator.Suffix:
			suffix := squirrel.Like{}
			suffix[field] = fmt.Sprintf("%%%s", compare.Value())
			builder = builder.Where(suffix)
		case operator.Like:
			pattern, ok := compare.Value().(string)
			if ok {
				like := squirrel.Like{}
				like[field] = Like(pattern)
				builder = builder.Where(like)
			}
		case operator.Contain:
			contain := squirrel.Like{}
			contain[field] = fmt.Sprintf("%%%s%%", compare.Value())
			builder = builder.Where(contain)
		}
	}

	return builder
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

type Serializer interface {
	Serialize(builder squirrel.SelectBuilder, spec spec.Spec) (squirrel.SelectBuilder, error)
}

func New(attributes map[string]string) Serializer {
	return &serializer{
		attributes: attributes,
	}
}
