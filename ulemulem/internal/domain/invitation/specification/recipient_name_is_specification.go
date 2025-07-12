package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
)

type RecipientNameIsSpecification struct {
	RecipientName string
}

func (c RecipientNameIsSpecification) Call(invitation invitation_entity.Invitation) bool {
	return invitation.RecipientName == c.RecipientName
}

func RecipientNameIs(recipientName string) InvitationSpecification {
	return RecipientNameIsSpecification{
		RecipientName: recipientName,
	}
}
