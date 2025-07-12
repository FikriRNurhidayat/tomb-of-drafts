package invitation_specification

import (
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
)

type CodeInSpecification struct {
	CodeIn []string
}

func (c CodeInSpecification) Call(invitation invitation_entity.Invitation) bool {
	for _, code := range c.CodeIn {
		if code == invitation.Code {
			return true
		}
	}

	return false
}

func CodeIn(codeIn []string) InvitationSpecification {
	return CodeInSpecification{
		CodeIn: codeIn,
	}
}
