package exception

import "github.com/fikrirnurhidayat/banda/backend/common/exception"

var (
	OperationNotSupported = exception.Reason("OPERATION_NOT_SUPPORTED")
	FieldNotAllowed       = exception.Reason("FIELD_NOT_ALLOWED")
	ValueNotAllowed       = exception.Reason("VALUE_NOT_ALLOWED")
)
