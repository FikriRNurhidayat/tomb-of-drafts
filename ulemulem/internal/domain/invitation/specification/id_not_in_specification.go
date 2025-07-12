package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/google/uuid"
)

type IDNotInSpecification struct {
	IDNotIn []uuid.UUID
}

func (c IDNotInSpecification) Call(invitation invitation_entity.Invitation) bool {
	for _, id := range c.IDNotIn {
		if id == invitation.ID {
			return false
		}
	}

	return true
}

func IDNotIn(idNotIn []uuid.UUID) InvitationSpecification {
	return IDNotInSpecification{
		IDNotIn: idNotIn,
	}
}
