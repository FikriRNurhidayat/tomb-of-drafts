package invitation_status

type InvitationStatus int

const (
	Created InvitationStatus = iota
	Opened
	Cancelled
)

var Nil InvitationStatus = -1

func (i InvitationStatus) String() string {
	switch i {
	case Created:
		return "Created"
	case Opened:
		return "Opened"
	case Cancelled:
		return "Cancelled"
	default:
		return ""
	}
}

func GetInvitationStatus(str string) InvitationStatus {
	switch str {
	case "Created":
		return Created
	case "Opened":
		return Opened
	case "Cancelled":
		return Cancelled
	default:
		return Nil
	}
}
