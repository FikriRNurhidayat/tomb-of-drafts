package invitation_repository

import (
	"database/sql"
	"time"

	"github.com/Masterminds/squirrel"
	"github.com/fikrirnurhidayat/dhasar"
	invitation_entity "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/entity"
	invitation_specification "github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/specification"
	"github.com/fikrirnurhidayat/ulemulem/internal/domain/invitation/types/invitation_status"
	"github.com/fikrirnurhidayat/x/exists"
	"github.com/fikrirnurhidayat/x/logger"
	"github.com/google/uuid"
)

type PostgresInvitationRow struct {
	ID            string
	RecipientName string
	Code          string
	Status        string
	CreatedAt     time.Time
	UpdatedAt     time.Time
	OpenedAt      sql.NullTime
	CancelledAt   sql.NullTime
}

var NoPostgresInvitationRow = PostgresInvitationRow{}

func NewInvitationPostgresRepository(logger logger.Logger, sqldbm dhasar.SQLDatabaseManager) (InvitationRepository, error) {
	return dhasar.NewPostgresRepository(dhasar.PostgresRepositoryOption[
		invitation_entity.Invitation,
		invitation_specification.InvitationSpecification,
		PostgresInvitationRow,
	]{
		TableName: "invitations",
		Columns: []string{
			"id",
			"recipient_name",
			"code",
			"status",
			"created_at",
			"updated_at",
			"opened_at",
			"cancelled_at",
		},
		Schema: map[string]string{
			"id":             dhasar.Text,
			"recipient_name": dhasar.Text,
			"code":           dhasar.Text,
			"status":         dhasar.Text,
			"created_at":     dhasar.Text,
			"updated_at":     dhasar.Text,
			"opened_at":      dhasar.Text,
			"cancelled_at":   dhasar.Text,
		},
		PrimaryKey:         "id",
		SQLDatabaseManager: sqldbm,
		Logger:             logger,
		Filter: func(specs ...invitation_specification.InvitationSpecification) squirrel.Sqlizer {
			where := squirrel.And{}

			for _, spec := range specs {
				switch v := spec.(type) {
				case invitation_specification.IDIsSpecification:
					where = append(where, squirrel.Eq{"id": v.ID})
				case invitation_specification.IDIsNotSpecification:
					where = append(where, squirrel.NotEq{"id": v.ID})
				case invitation_specification.IDInSpecification:
					where = append(where, squirrel.Eq{"id": v.IDIn})
				case invitation_specification.IDNotInSpecification:
					where = append(where, squirrel.Eq{"id": v.IDNotIn})
				case invitation_specification.CodeIsSpecification:
					where = append(where, squirrel.Eq{"code": v.Code})
				case invitation_specification.CodeIsNotSpecification:
					where = append(where, squirrel.NotEq{"code": v.Code})
				case invitation_specification.CodeInSpecification:
					where = append(where, squirrel.Eq{"code": v.CodeIn})
				case invitation_specification.CodeNotInSpecification:
					where = append(where, squirrel.Eq{"code": v.CodeNotIn})
				case invitation_specification.RecipientNameIsSpecification:
					where = append(where, squirrel.Eq{"recipient_name": v.RecipientName})
				case invitation_specification.RecipientNameIsNotSpecification:
					where = append(where, squirrel.NotEq{"recipient_name": v.RecipientName})
				case invitation_specification.RecipientNameInSpecification:
					where = append(where, squirrel.Eq{"recipient_name": v.RecipientNameIn})
				case invitation_specification.RecipientNameNotInSpecification:
					where = append(where, squirrel.Eq{"recipient_name": v.RecipientNameNotIn})
				case invitation_specification.StatusIsSpecification:
					where = append(where, squirrel.Eq{"status": v.Status})
				case invitation_specification.StatusIsNotSpecification:
					where = append(where, squirrel.NotEq{"status": v.Status})
				case invitation_specification.StatusInSpecification:
					where = append(where, squirrel.Eq{"status": v.StatusIn})
				case invitation_specification.StatusNotInSpecification:
					where = append(where, squirrel.Eq{"status": v.StatusNotIn})
				}
			}

			return where
		},
		Scan: func(rows *sql.Rows) (PostgresInvitationRow, error) {
			row := PostgresInvitationRow{}

			if err := rows.Scan(&row.ID, &row.RecipientName, &row.Code, &row.Status, &row.CreatedAt, &row.UpdatedAt, &row.OpenedAt, &row.CancelledAt); err != nil {
				return NoPostgresInvitationRow, err
			}

			return row, nil
		},
		Entity: func(row PostgresInvitationRow) invitation_entity.Invitation {
			return invitation_entity.Invitation{
				ID:            uuid.MustParse(row.ID),
				Code:          row.Code,
				RecipientName: row.RecipientName,
				Status:        invitation_status.GetInvitationStatus(row.Status),
				CreatedAt:     row.CreatedAt,
				UpdatedAt:     row.UpdatedAt,
				OpenedAt:      row.OpenedAt.Time,
				CancelledAt:   row.CancelledAt.Time,
			}
		},
		Row: func(invitation invitation_entity.Invitation) PostgresInvitationRow {
			return PostgresInvitationRow{
				ID:            invitation.ID.String(),
				RecipientName: invitation.RecipientName,
				Code:          invitation.Code,
				Status:        invitation.Status.String(),
				CreatedAt:     invitation.CreatedAt,
				UpdatedAt:     invitation.UpdatedAt,
				OpenedAt: sql.NullTime{
					Time:  invitation.OpenedAt,
					Valid: exists.Date(invitation.OpenedAt),
				},
				CancelledAt: sql.NullTime{
					Time:  invitation.CancelledAt,
					Valid: exists.Date(invitation.CancelledAt),
				},
			}
		},
		Values: func(row PostgresInvitationRow) []any {
			return []any{
				row.ID,
				row.RecipientName,
				row.Code,
				row.Status,
				row.CreatedAt,
				row.UpdatedAt,
				row.OpenedAt,
				row.CancelledAt,
			}
		},
	})
}
