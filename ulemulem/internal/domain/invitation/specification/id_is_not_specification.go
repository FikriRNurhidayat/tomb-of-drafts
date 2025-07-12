package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/google/uuid"
)

type IDIsNotSpecification struct {
	ID uuid.UUID
}

func (c IDIsNotSpecification) Call(invitation invitation_entity.Invitation) bool {
	return invitation.ID != c.ID
}

func IDIsNot(id uuid.UUID) InvitationSpecification {
	return IDIsNotSpecification{
		ID: id,
	}
}
