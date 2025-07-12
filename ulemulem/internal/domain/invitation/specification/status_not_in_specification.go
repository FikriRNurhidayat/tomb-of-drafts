package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
)

type StatusNotInSpecification struct {
	StatusNotIn []invitation_status.InvitationStatus
}

func (c StatusNotInSpecification) Call(invitation invitation_entity.Invitation) bool {
	for _, status := range c.StatusNotIn {
		if status == invitation.Status {
			return false
		}
	}

	return true
}

func StatusNotIn(statusNotIn []invitation_status.InvitationStatus) InvitationSpecification {
	return StatusNotInSpecification{
		StatusNotIn: statusNotIn,
	}
}
