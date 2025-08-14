package main

import (
	"fmt"
	"time"

	"github.com/fikrirnurhidayat/banda/backend/common/spec"
	"github.com/fikrirnurhidayat/banda/backend/common/spec/serializer/sqlserializer"
)

func main() {
	s := spec.Specify(func(s spec.Builder) {
		s.Equal("name", "Fikri")
		s.Equal("age", 20)
		s.Gte("created_at", time.Now())
	})

	serializer := sqlserializer.New(map[string]string{
		"name":       "contacts.name",
		"age":        "contacts.age",
		"created_at": "contacts.created_at",
	})

	query, args, _ := serializer.Serialize(s)
	println(fmt.Sprintf("spec %#v\n", s))
	println(fmt.Sprintf("query %s\n", query))
	println(fmt.Sprintf("args %#v\n", args))
}
