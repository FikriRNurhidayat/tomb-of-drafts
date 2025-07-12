package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
)

type StatusInSpecification struct {
	StatusIn []invitation_status.InvitationStatus
}

func (c StatusInSpecification) Call(invitation invitation_entity.Invitation) bool {
	for _, status := range c.StatusIn {
		if status == invitation.Status {
			return true
		}
	}

	return false
}

func StatusIn(statusIn []invitation_status.InvitationStatus) InvitationSpecification {
	return StatusInSpecification{
		StatusIn: statusIn,
	}
}
