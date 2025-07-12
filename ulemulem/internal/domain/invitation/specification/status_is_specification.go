package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
)

type StatusIsSpecification struct {
	Status invitation_status.InvitationStatus
}

func (c StatusIsSpecification) Call(invitation invitation_entity.Invitation) bool {
	return invitation.Status == c.Status
}

func StatusIs(status invitation_status.InvitationStatus) InvitationSpecification {
	return StatusIsSpecification{
		Status: status,
	}
}
