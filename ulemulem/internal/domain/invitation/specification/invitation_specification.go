package invitation_specification

import invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"

type InvitationSpecification interface {
	Call(invitation invitation_entity.Invitation) bool
}
