package invitation_entity

import (
	"time"

	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
	"github.com/google/uuid"
)

type Invitation struct {
	ID            uuid.UUID
	Code          string
	RecipientName string
	Status        invitation_status.InvitationStatus
	CreatedAt     time.Time
	UpdatedAt     time.Time
	OpenedAt      time.Time
	CancelledAt   time.Time
}

var NoInvitation = Invitation{}

func NewInvitation() Invitation {
	return Invitation{
		ID: uuid.New(),
	}
}
