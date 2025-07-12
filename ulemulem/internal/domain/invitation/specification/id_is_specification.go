package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/google/uuid"
)

type IDIsSpecification struct {
	ID uuid.UUID
}

func (c IDIsSpecification) Call(invitation invitation_entity.Invitation) bool {
	return invitation.ID == c.ID
}

func IDIs(id uuid.UUID) InvitationSpecification {
	return IDIsSpecification{
		ID: id,
	}
}


