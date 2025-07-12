package invitation_repository

import (
	"github.com/fikrirnurhidayat/dhasar"
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	invitation_specification "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/specification"
)

type InvitationRepository dhasar.Repository[invitation_entity.Invitation, invitation_specification.InvitationSpecification]
