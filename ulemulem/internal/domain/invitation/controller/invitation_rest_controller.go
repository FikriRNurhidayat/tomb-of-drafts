package invitation_controller

import (
	"fmt"
	"net/http"

	"github.com/fikrirnurhidayat/dhasar"
	invitation_service "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/service"
	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
	"github.com/google/uuid"
	echo "github.com/labstack/echo/v4"
)

type InvitationRestController interface {
	Register(*echo.Echo)
	GetInvitation(c echo.Context) error
	CreateInvitation(c echo.Context) error
	GetInvitations(c echo.Context) error
}

type InvitationRestControllerBuilder interface {
	WithGetInvitationService(invitation_service.GetInvitationService) *InvitationRestControllerImpl
	WithGetInvitationsService(invitation_service.GetInvitationsService) *InvitationRestControllerImpl
	WithCreateInvitationService(invitation_service.CreateInvitationService) *InvitationRestControllerImpl
}

type InvitationRestControllerImpl struct {
	GetInvitationService    invitation_service.GetInvitationService
	GetInvitationsService   invitation_service.GetInvitationsService
	CreateInvitationService invitation_service.CreateInvitationService
}

func (ctrl *InvitationRestControllerImpl) WithGetInvitationsService(getInvitationsService invitation_service.GetInvitationsService) *InvitationRestControllerImpl {
	ctrl.GetInvitationsService = getInvitationsService
	return ctrl
}

func (ctrl *InvitationRestControllerImpl) WithCreateInvitationService(makeInvitationService invitation_service.CreateInvitationService) *InvitationRestControllerImpl {
	ctrl.CreateInvitationService = makeInvitationService
	return ctrl
}

func (ctrl *InvitationRestControllerImpl) WithGetInvitationService(openInvitationService invitation_service.GetInvitationService) *InvitationRestControllerImpl {
	ctrl.GetInvitationService = openInvitationService
	return ctrl
}

func (ctrl *InvitationRestControllerImpl) GetInvitations(c echo.Context) error {
	params := &invitation_service.GetInvitationsParams{
		StatusIs: -1,
		StatusIsNot: -1,
		Pagination: dhasar.PaginationParams{},
	}

	if err := echo.QueryParamsBinder(c).
		Uint32("page", &params.Pagination.Page).
		Uint32("page_size", &params.Pagination.PageSize).
		String("recipient_name_is", &params.RecipientNameIs).
		String("recipient_name_is_not", &params.RecipientNameIsNot).
		Strings("recipient_name_in", &params.RecipientNameIn).
		Strings("recipient_name_not_in", &params.RecipientNameNotIn).
		String("code_is", &params.CodeIs).
		String("code_is_not", &params.CodeIsNot).
		Strings("code_in", &params.CodeIn).
		Strings("code_not_in", &params.CodeNotIn).
		CustomFunc("status_is", ctrl.InvitationStatus(&params.StatusIs)).
		CustomFunc("status_is_not", ctrl.InvitationStatus(&params.StatusIsNot)).
		CustomFunc("status_in", ctrl.InvitationStatusSlice(params.StatusIn)).
		CustomFunc("status_not_in", ctrl.InvitationStatusSlice(params.StatusNotIn)).
		CustomFunc("id_is", dhasar.UUIDBinder(&params.IDIs)).
		CustomFunc("id_is_not", dhasar.UUIDBinder(&params.IDIsNot)).
		CustomFunc("id_in", dhasar.UUIDSliceBinder(params.IDIn)).
		CustomFunc("id_not_in", dhasar.UUIDSliceBinder(params.IDNotIn)).
		FailFast(true).
		BindError(); err != nil {
		return dhasar.ErrBadRequest
	}
	

	result, err := ctrl.GetInvitationsService.Call(c.Request().Context(), params)
	if err != nil {
    fmt.Println(err.Error())
		return err
	}

	responseJSON := &GetInvitationsResponseJSON{
		Pagination:  dhasar.NewPaginationJSON(result.Pagination),
		Invitations: NewInvitationsResponseJSON(result.Invitations),
	}

	return c.JSON(http.StatusOK, responseJSON)
}

func (ctrl *InvitationRestControllerImpl) GetInvitation(c echo.Context) error {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return dhasar.ErrInvalidUUID
	}

	result, err := ctrl.GetInvitationService.Call(c.Request().Context(), &invitation_service.GetInvitationParams{
		ID: id,
	})

	if err != nil {
		return err
	}

	resJSON := &GetInvitationResponseJSON{
		Invitation: NewInvitationResponseJSON(result.Invitation),
	}

	return c.JSON(http.StatusOK, resJSON)
}

func (ctrl *InvitationRestControllerImpl) CreateInvitation(c echo.Context) error {
	requestJSON := &CreateInvitationRequestJSON{}
	if err := c.Bind(&requestJSON); err != nil {
		return dhasar.ErrBadRequest
	}

	result, err := ctrl.CreateInvitationService.Call(c.Request().Context(), &invitation_service.CreateInvitationParams{
		RecipientName: requestJSON.Invitation.RecipientName,
		Code:          requestJSON.Invitation.Code,
	})
	if err != nil {
		return err
	}

	resJSON := &CreateInvitationResponseJSON{
		Invitation: NewInvitationResponseJSON(result.Invitation),
	}

	return c.JSON(http.StatusOK, resJSON)
}

func (ctrl *InvitationRestControllerImpl) InvitationStatus(s *invitation_status.InvitationStatus) func(values []string) []error {
	return func(values []string) []error {
		*s = invitation_status.GetInvitationStatus(values[0])
		return nil
	}
}

func (ctrl *InvitationRestControllerImpl) InvitationStatusSlice(s []invitation_status.InvitationStatus) func(values []string) []error {
	return func(values []string) []error {
		for i, v := range values {
			s[i] = invitation_status.GetInvitationStatus(v)
		}

		return nil
	}
}

func (i *InvitationRestControllerImpl) Register(e *echo.Echo) {
	e.POST("/v1/invitations", i.CreateInvitation)
	e.GET("/v1/invitations", i.GetInvitations)
	e.GET("/v1/invitations/:id", i.GetInvitation)
}

func NewInvitationRestController() *InvitationRestControllerImpl {
	return &InvitationRestControllerImpl{}
}

var _ InvitationRestController = (*InvitationRestControllerImpl)(nil)
var _ InvitationRestControllerBuilder = (*InvitationRestControllerImpl)(nil)
