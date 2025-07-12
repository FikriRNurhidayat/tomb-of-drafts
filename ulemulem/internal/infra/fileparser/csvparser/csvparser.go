package csvparser

import (
	"encoding/csv"
	"os"
)

type ScanFunc[T any] func(record []string) (T, error)

type CSVParser[T any] interface {
	FromFile(filePath string) ([]T, error)
}

type CSVParserImpl[T any] struct {
	Scan ScanFunc[T]
}

// FromFile implements CSVParser.
func (c *CSVParserImpl[T]) FromFile(filePath string) ([]T, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		return nil, err
	}

	var rows []T

	for _, record := range records {
		row, err := c.Scan(record)
		if err != nil {
			return nil, err
		}

		rows = append(rows, row)
	}

	return rows, nil
}

func NewCSVParser[T any](scanFunc ScanFunc[T]) CSVParser[T] {
	return &CSVParserImpl[T]{
		Scan: scanFunc,
	}
}
