package invitation_controller

import (
	"time"

	"github.com/fikrirnurhidayat/dhasar"
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	"github.com/google/uuid"
)

type InvitationResponseJSON struct {
	ID            uuid.UUID               `json:"id"`
	RecipientName string                  `json:"recipient_name"`
	Code          string                  `json:"code"`
	Status        string                  `json:"status"`
	CreatedAt     time.Time               `json:"created_at"`
	UpdatedAt     time.Time               `json:"updated_at"`
	OpenedAt      dhasar.Maybe[time.Time] `json:"opened_at"`
	CancelledAt   dhasar.Maybe[time.Time] `json:"cancelled_at"`
}

type InvitationRequestJSON struct {
	RecipientName string `json:"recipient_name"`
	Code          string `json:"code"`
}

type GetInvitationResponseJSON struct {
	Invitation InvitationResponseJSON `json:"invitation"`
}

type GetInvitationsResponseJSON struct {
	Pagination  dhasar.PaginationJSON    `json:"pagination"`
	Invitations []InvitationResponseJSON `json:"invitations"`
}

type CreateInvitationRequestJSON struct {
	Invitation InvitationRequestJSON `json:"invitation"`
}

type CreateInvitationResponseJSON struct {
	Invitation InvitationResponseJSON `json:"invitation"`
}

func NewInvitationResponseJSON(invitation invitation_entity.Invitation) InvitationResponseJSON {
	return InvitationResponseJSON{
		ID:            invitation.ID,
		RecipientName: invitation.RecipientName,
		Code:          invitation.Code,
		Status:        invitation.Status.String(),
		CreatedAt:     invitation.CreatedAt,
		UpdatedAt:     invitation.UpdatedAt,
		OpenedAt:      dhasar.MaybeTime(invitation.OpenedAt),
		CancelledAt:   dhasar.MaybeTime(invitation.CancelledAt),
	}
}

func NewInvitationsResponseJSON(invitations []invitation_entity.Invitation) []InvitationResponseJSON {
	invitationsJSON := []InvitationResponseJSON{}

	for _, invitation := range invitations {
		invitationsJSON = append(invitationsJSON, NewInvitationResponseJSON(invitation))
	}

	return invitationsJSON
}
