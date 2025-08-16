package exception

import "fmt"

type Exception struct {
	code    int
	reason  string
	message string
	details Details
}

type Details map[string]any

func (e *Exception) Code() int {
	return e.code
}

func (e *Exception) Reason() string {
	return e.reason
}

func (e *Exception) Message() string {
	return e.message
}

func (e *Exception) Details() Details {
	return e.details
}

func (e *Exception) Error() string {
	return e.message
}

type Builder struct {
	err      *Exception
	template string
}

func New() *Builder {
	return &Builder{err: &Exception{details: make(Details)}}
}

func Code(code int) *Builder {
	b := New()
	b.err.code = code
	return b
}

func Reason(reason string) *Builder {
	b := New()
	b.err.reason = reason
	return b
}

func (b *Builder) Code(code int) *Builder {
	b.err.code = code
	return b
}

func (b *Builder) Reason(reason string) *Builder {
	b.err.reason = reason
	return b
}

func (b *Builder) Template(template string) *Builder {
	b.template = template
	return b
}

func (b *Builder) Message(message string) *Builder {
	b.err.message = message
	return b
}

func (b *Builder) Detail(key string, value any) *Builder {
	b.err.details[key] = value
	return b
}

func (b *Builder) Error(args ...any) *Exception {
	if b.template != "" {
		b.err.message = fmt.Sprintf(b.template, args...)
	}

	return b.err
}
