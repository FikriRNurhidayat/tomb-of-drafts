package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
)

type RecipientNameInSpecification struct {
	RecipientNameIn []string
}

func (c RecipientNameInSpecification) Call(invitation invitation_entity.Invitation) bool {
	for _, recipientName := range c.RecipientNameIn {
		if recipientName == invitation.RecipientName {
			return true
		}
	}

	return false
}

func RecipientNameIn(recipientNameIn []string) InvitationSpecification {
	return RecipientNameInSpecification{
		RecipientNameIn: recipientNameIn,
	}
}
