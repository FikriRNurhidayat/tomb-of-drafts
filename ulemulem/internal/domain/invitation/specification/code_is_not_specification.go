package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
)

type CodeIsNotSpecification struct {
	Code string
}

func (c CodeIsNotSpecification) Call(invitation invitation_entity.Invitation) bool {
	return invitation.Code != c.Code
}

func CodeIsNot(code string) InvitationSpecification {
	return CodeIsNotSpecification{
		Code: code,
	}
}
