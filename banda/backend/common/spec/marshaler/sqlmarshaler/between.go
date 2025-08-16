package sqlmarshaler

import "fmt"

type Between map[string][]any

func (b Between) ToSql() (string, []any, error) {
	if len(b) != 1 {
		return "", nil, fmt.Errorf("Between must have exactly one column")
	}
	for col, vals := range b {
		if len(vals) != 2 {
			return "", nil, fmt.Errorf("Between requires exactly 2 values")
		}
		return col + " BETWEEN ? AND ?", []any{vals[0], vals[1]}, nil
	}
	return "", nil, fmt.Errorf("between expr only supports 1 map key")
}
