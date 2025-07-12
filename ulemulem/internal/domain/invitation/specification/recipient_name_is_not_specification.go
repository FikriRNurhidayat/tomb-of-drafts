package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
)

type RecipientNameIsNotSpecification struct {
	RecipientName string
}

func (c RecipientNameIsNotSpecification) Call(invitation invitation_entity.Invitation) bool {
	return invitation.RecipientName != c.RecipientName
}

func RecipientNameIsNot(recipientName string) InvitationSpecification {
	return RecipientNameIsNotSpecification{
		RecipientName: recipientName,
	}
}
