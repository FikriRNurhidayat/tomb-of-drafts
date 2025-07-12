package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
)

type StatusIsNotSpecification struct {
	Status invitation_status.InvitationStatus
}

func (c StatusIsNotSpecification) Call(invitation invitation_entity.Invitation) bool {
	return invitation.Status != c.Status
}

func StatusIsNot(status invitation_status.InvitationStatus) InvitationSpecification {
	return StatusIsNotSpecification{
		Status: status,
	}
}
