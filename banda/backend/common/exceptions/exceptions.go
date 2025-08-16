package exceptions

import "github.com/fikrirnurhidayat/banda/backend/common/exception"

var (
	SystemFailure = exception.Code(500).Reason("SYSTEM_FAILURE").Message("Unexpected behaviour occured on the system.").Error()
)
