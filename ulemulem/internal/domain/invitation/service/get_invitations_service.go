package invitation_service

import (
	"context"

	"github.com/fikrirnurhidayat/dhasar"
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	invitation_repository "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/repository"
	invitation_specification "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/specification"
	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
	"github.com/fikrirnurhidayat/x/exists"
	"github.com/google/uuid"
)

type GetInvitationsParams struct {
	IDIs               uuid.UUID
	IDIsNot            uuid.UUID
	IDIn               []uuid.UUID
	IDNotIn            []uuid.UUID
	CodeIs             string
	CodeIsNot          string
	CodeIn             []string
	CodeNotIn          []string
	StatusIs           invitation_status.InvitationStatus
	StatusIsNot        invitation_status.InvitationStatus
	StatusIn           []invitation_status.InvitationStatus
	StatusNotIn        []invitation_status.InvitationStatus
	RecipientNameIs    string
	RecipientNameIsNot string
	RecipientNameIn    []string
	RecipientNameNotIn []string
	Pagination         dhasar.PaginationParams
}

type GetInvitationsResult struct {
	Invitations []invitation_entity.Invitation
	Pagination  dhasar.PaginationResult
}

type GetInvitationsService interface {
	Call(ctx context.Context, params *GetInvitationsParams) (*GetInvitationsResult, error)
}

type GetInvitationsServiceImpl struct {
	invitationRepository invitation_repository.InvitationRepository
}

// Call implements GetInvitationsService.
func (s *GetInvitationsServiceImpl) Call(ctx context.Context, params *GetInvitationsParams) (*GetInvitationsResult, error) {	
	specs := []invitation_specification.InvitationSpecification{}

	if params.IDIs != uuid.Nil {
		specs = append(specs, invitation_specification.IDIs(params.IDIs))
	}

	if params.IDIsNot != uuid.Nil {
		specs = append(specs, invitation_specification.IDIsNot(params.IDIsNot))
	}

	if len(params.IDIn) != 0 {
		specs = append(specs, invitation_specification.IDIn(params.IDIn))
	}

	if len(params.IDNotIn) != 0 {
		specs = append(specs, invitation_specification.IDNotIn(params.IDNotIn))
	}

	if exists.String(params.CodeIs) {
		specs = append(specs, invitation_specification.CodeIs(params.CodeIs))
	}

	if exists.String(params.CodeIsNot) {
		specs = append(specs, invitation_specification.CodeIsNot(params.CodeIsNot))
	}

	if len(params.CodeIn) != 0 {
		specs = append(specs, invitation_specification.CodeIn(params.CodeIn))
	}

	if len(params.CodeNotIn) != 0 {
		specs = append(specs, invitation_specification.CodeNotIn(params.CodeNotIn))
	}

	if exists.String(params.RecipientNameIs) {
		specs = append(specs, invitation_specification.RecipientNameIs(params.RecipientNameIs))
	}

	if exists.String(params.RecipientNameIsNot) {
		specs = append(specs, invitation_specification.RecipientNameIsNot(params.RecipientNameIsNot))
	}

	if len(params.RecipientNameIn) != 0 {
		specs = append(specs, invitation_specification.RecipientNameIn(params.RecipientNameIn))
	}

	if len(params.RecipientNameNotIn) != 0 {
		specs = append(specs, invitation_specification.RecipientNameNotIn(params.RecipientNameNotIn))
	}

	if params.StatusIs != invitation_status.Nil {
		specs = append(specs, invitation_specification.StatusIs(params.StatusIs))
	}

	if params.StatusIsNot != invitation_status.Nil {
		specs = append(specs, invitation_specification.StatusIsNot(params.StatusIsNot))
	}

	if len(params.StatusIn) != 0 {
		specs = append(specs, invitation_specification.StatusIn(params.StatusIn))
	}

	if len(params.StatusNotIn) != 0 {
		specs = append(specs, invitation_specification.StatusNotIn(params.StatusNotIn))
	}

	params.Pagination = params.Pagination.Normalize()

	invitations, err := s.invitationRepository.List(ctx, dhasar.ListArgs[invitation_specification.InvitationSpecification]{
		Specifications: specs,
		Sort:           s,
		Limit:          params.Pagination.Limit(),
		Offset:         params.Pagination.Offset(),
	})
	if err != nil {
		return nil, err
	}

	invitationsSize, err := s.invitationRepository.Size(ctx, specs...)
	if err != nil {
		return nil, err
	}

	result := &GetInvitationsResult{
		Pagination:  dhasar.NewPaginationResult(params.Pagination, invitationsSize),
		Invitations: invitations,
	}

	return result, nil
}

var _ GetInvitationsService = (*GetInvitationsServiceImpl)(nil)

func NewGetInvitationsService(invitationRepository invitation_repository.InvitationRepository) GetInvitationsService {
	return &GetInvitationsServiceImpl{
		invitationRepository: invitationRepository,
	}
}
