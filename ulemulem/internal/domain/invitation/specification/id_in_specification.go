package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/google/uuid"
)

type IDInSpecification struct {
	IDIn []uuid.UUID
}

func (c IDInSpecification) Call(invitation invitation_entity.Invitation) bool {
	for _, id := range c.IDIn {
		if id == invitation.ID {
			return true
		}
	}

	return false
}

func IDIn(idIn []uuid.UUID) InvitationSpecification {
	return IDInSpecification{
		IDIn: idIn,
	}
}
