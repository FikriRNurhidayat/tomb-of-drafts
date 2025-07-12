package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
)

type CodeIsSpecification struct {
	Code string
}

func (c CodeIsSpecification) Call(invitation invitation_entity.Invitation) bool {
	return invitation.Code == c.Code
}

func CodeIs(code string) InvitationSpecification {
	return CodeIsSpecification{
		Code: code,
	}
}
