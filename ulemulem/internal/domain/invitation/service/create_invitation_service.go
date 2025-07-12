package invitation_service

import (
	"context"
	"strings"
	"time"

	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	invitation_errors "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/errors"
	invitation_repository "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/repository"
	invitation_specification "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/specification"
	"github.com/fikrirnurhidayat/x/exists"
	"github.com/fikrirnurhidayat/x/text"
)

type CreateInvitationParams struct {
	RecipientName string
	Code          string
}

type CreateInvitationResult struct {
	Invitation invitation_entity.Invitation
}

type CreateInvitationService interface {
	Call(ctx context.Context, params *CreateInvitationParams) (*CreateInvitationResult, error)
}

type CreateInvitationServiceImpl struct {
	InvitationRepository invitation_repository.InvitationRepository
}

func (m *CreateInvitationServiceImpl) Call(ctx context.Context, params *CreateInvitationParams) (*CreateInvitationResult, error) {
	invitation := invitation_entity.NewInvitation()

	invitation.RecipientName = params.RecipientName

	if exists.String(params.Code) {
		invitation.Code = params.Code
	} else {
		invitation.Code = strings.ToLower(text.ToKebabCase(params.RecipientName))
	}

	if exist, err := m.InvitationRepository.Exist(ctx, invitation_specification.CodeIs(invitation.Code)); err != nil {
		return nil, err
	} else if exist {
		return nil, invitation_errors.ErrInvitationCodeAlreadyExist
	}

	now := time.Now()
	invitation.CreatedAt = now
	invitation.UpdatedAt = now

	if err := m.InvitationRepository.Save(ctx, invitation); err != nil {
		return nil, err
	}

	return &CreateInvitationResult{Invitation: invitation}, nil
}

func NewCreateInvitationService(invitationRepository invitation_repository.InvitationRepository) CreateInvitationService {
	return &CreateInvitationServiceImpl{
		InvitationRepository: invitationRepository,
	}
}
