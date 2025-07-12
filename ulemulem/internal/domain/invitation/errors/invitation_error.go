package invitation_errors

import (
	"net/http"

	"github.com/fikrirnurhidayat/dhasar"
)

var (
	ErrInvitationCodeAlreadyExist = &dhasar.Error{
		Code:    http.StatusUnprocessableEntity,
		Reason:  "INVITATION_CODE_ALREADY_EXIST",
		Message: "Invitation code already exists. Please supply unique invitation code, or use different recipient name.",
	}

	ErrInvitationCodeNotFound = &dhasar.DynamicError{
		Code:     http.StatusNotFound,
		Reason:   "INVITATION_CODE_NOT_FOUND",
		Template: "Invitation code '%s' not found. Please supply correct invitation code.",
	}
)
