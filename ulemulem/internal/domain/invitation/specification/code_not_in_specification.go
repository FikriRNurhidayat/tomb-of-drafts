package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
)

type CodeNotInSpecification struct {
	CodeNotIn []string
}

func (c CodeNotInSpecification) Call(invitation invitation_entity.Invitation) bool {
	for _, code := range c.CodeNotIn {
		if code == invitation.Code {
			return false
		}
	}

	return true
}

func CodeNotIn(codeNotIn []string) InvitationSpecification {
	return CodeNotInSpecification{
		CodeNotIn: codeNotIn,
	}
}
