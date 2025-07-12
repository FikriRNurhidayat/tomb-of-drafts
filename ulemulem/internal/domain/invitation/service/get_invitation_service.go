package invitation_service

import (
	"context"

	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	invitation_errors "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/errors"
	invitation_repository "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/repository"
	invitation_specification "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/specification"
	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
	"github.com/google/uuid"
)

type GetInvitationParams struct {
	ID uuid.UUID
}

type GetInvitationResult struct {
	Invitation invitation_entity.Invitation
}

type GetInvitationService interface {
	Call(ctx context.Context, params *GetInvitationParams) (*GetInvitationResult, error)
}

type GetInvitationServiceImpl struct {
	InvitationRepository invitation_repository.InvitationRepository
}

// Call implements OpenInvitationService.
func (o *GetInvitationServiceImpl) Call(ctx context.Context, params *GetInvitationParams) (*GetInvitationResult, error) {
	invitation, err := o.InvitationRepository.Get(ctx, invitation_specification.IDIs(params.ID))
	if err != nil {
		return nil, err
	}

	if invitation == invitation_entity.NoInvitation {
		return nil, invitation_errors.ErrInvitationCodeNotFound.Format(params.ID)
	}

	invitation.Status = invitation_status.Opened

	if err := o.InvitationRepository.Save(ctx, invitation); err != nil {
		return nil, err
	}

	return &GetInvitationResult{Invitation: invitation}, nil
}

func NewGetInvitationService(invitationRepository invitation_repository.InvitationRepository) GetInvitationService {
	return &GetInvitationServiceImpl{
		InvitationRepository: invitationRepository,
	}
}
