package invitation

import (
	"github.com/fikrirnurhidayat/dhasar"
	invitation_controller "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/controller"
	invitation_repository "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/repository"
	invitation_service "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/service"
	"github.com/fikrirnurhidayat/x/logger"
	"github.com/labstack/echo/v4"
)

func WireHTTPModule(container *dhasar.Container) error {
	logger := dhasar.GetDep[logger.Logger](container, "Logger")
	sqlDatabaseManager := dhasar.GetDep[dhasar.SQLDatabaseManager](container, "SQLDatabaseManager")

	invitationPostgresRepository, err := invitation_repository.NewInvitationPostgresRepository(logger, sqlDatabaseManager)
	if err != nil {
		return err
	}

	container.Register("InvitationRepository", invitationPostgresRepository)

	getInvitationService := invitation_service.NewGetInvitationService(invitationPostgresRepository)
	container.Register("GetInvitationService", getInvitationService)
	
	getInvitationsService := invitation_service.NewGetInvitationsService(invitationPostgresRepository)
	container.Register("GetInvitationsService", getInvitationsService)

	createInvitationService := invitation_service.NewCreateInvitationService(invitationPostgresRepository)
	container.Register("MakeInvitationService", createInvitationService)

	invitationRestController := invitation_controller.NewInvitationRestController()

	invitationRestController.WithGetInvitationService(getInvitationService)
	invitationRestController.WithGetInvitationsService(getInvitationsService)
	invitationRestController.WithCreateInvitationService(createInvitationService)

	invitationRestController.Register(dhasar.GetDep[*echo.Echo](container, "Echo"))

	return nil
}
