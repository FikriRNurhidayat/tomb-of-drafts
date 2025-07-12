import {
  useId,
  useCallback,
  useMemo,
  useState,
  useEffect,
  Fragment,
} from "react";
import useFetch from "./hooks/useFetch";
import useQuery from "./hooks/useQuery";
import Aos from "aos";
import Cover from "./sections/Cover";
import Greeting from "./sections/Greeting";
import NewlyWeds from "./sections/NewlyWeds";
import Date from "./sections/Date";
import Location from "./sections/Location";
import Closing from "./sections/Closing";
import Loader from "./sections/Loader";

import "./Invitation.css";
import { ThemeProvider } from "./hooks/useTheme";

const calendarUrl = "https://calendar.google.com/calendar/r/eventedit";

export default function Invitation() {
  const coverId = useId();
  const greetingId = useId();
  const newlyWedsId = useId();
  const dateId = useId();
  const locationId = useId();
  const closingId = useId();

  const [recipientName, setRecipientName] = useState(null);
  const [_error, setError] = useState(null);
  const queryParams = useQuery();

  const idLink = useCallback((id) => {
    return `#${id}`;
  }, []);

  const apiUrl = useMemo(() => import.meta.env.VITE_ULEMULEM_API_URL || window.location.origin, [window.location.origin]);
  const endpointUrl = useMemo(() => {
    const endpointUrl = new URL(`${apiUrl}/v1/invitations`);

    endpointUrl.search = new URLSearchParams({
      id_is: queryParams.get("id"),
      code_is: queryParams.get("code"),
      page_size: 1,
      page: 1,
    });

    return endpointUrl;
  }, [queryParams]);

  const reminderLink = useMemo(() => {
    const calendarParams = new URLSearchParams({
      action: "TEMPLATE",
      text: "Resepsi: Tiara & Fikri",
      details:
        "- Acara resepsi diadakan ba'da isya\n- Alamat di Jl. Bhayangkara No.55, Panularan, Kec. Laweyan, Kota Surakarta, Jawa Tengah\n- Piring terbang",
      dates: "20240824T120000Z/20240824T140000Z",
      location: "Ndalem Danar Hadi",
      trp: true,
      sprop: "website",
    });

    const reminderUrl = new URL(calendarUrl);
    reminderUrl.search = calendarParams;
    return reminderUrl.toString();
  }, []);

  const invitationFetch = useFetch(endpointUrl);

  useEffect(() => {
    Aos.init({
      duration: 1000,
    });

    if (queryParams.has("code") && queryParams.has("id")) {
      invitationFetch
        .call()
        .then((responseBody) => {
          const [invitation] = responseBody?.invitations || [];
          setRecipientName(invitation?.["recipient_name"]);
        })
        .catch((error) => {
          setError(error);
        });
    }
  }, [queryParams]);

  return !!recipientName ? (
    <ThemeProvider>
      <Cover
        id={coverId}
        nextLink={idLink(greetingId)}
        recipientName={recipientName}
      />

      <Greeting
        id={greetingId}
        previousLink={idLink(coverId)}
        nextLink={idLink(newlyWedsId)}
      />

      <NewlyWeds
        groomName="Fikri R. Nurhidayat"
        groomFatherName="Bapak Romadi Himawan"
        groomMotherName="Ibu Nur Arifiah"
        brideName="Dhea Arintiara"
        brideFatherName="Alm. Bapak Suparyono"
        brideMotherName="Ibu Sri Widosari"
        id={newlyWedsId}
        previousLink={idLink(greetingId)}
        nextLink={idLink(dateId)}
      />

      <Date
        reminderLink={reminderLink}
        id={dateId}
        previousLink={idLink(newlyWedsId)}
        nextLink={idLink(locationId)}
      />

      <Location
        locationLink="https://maps.app.goo.gl/ihwQy7xRjqegnmxU7"
        id={locationId}
        previousLink={idLink(dateId)}
        nextLink={idLink(closingId)}
      />

      <Closing
        id={closingId}
        previousLink={idLink(locationId)}
        nextLink={idLink(coverId)}
      />
    </ThemeProvider>
  ) : (
    <Loader />
  );
}
