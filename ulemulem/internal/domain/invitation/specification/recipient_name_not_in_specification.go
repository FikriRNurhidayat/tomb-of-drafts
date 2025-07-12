package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
)

type RecipientNameNotInSpecification struct {
	RecipientNameNotIn []string
}

func (c RecipientNameNotInSpecification) Call(invitation invitation_entity.Invitation) bool {
	for _, recipientName := range c.RecipientNameNotIn {
		if recipientName == invitation.RecipientName {
			return false
		}
	}

	return true
}

func RecipientNameNotIn(recipientNameNotIn []string) InvitationSpecification {
	return RecipientNameNotInSpecification{
		RecipientNameNotIn: recipientNameNotIn,
	}
}
