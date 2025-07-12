import PropTypes from "prop-types";
import Control from "../Components/Control";
import Map from "../Components/Map";
import { Icon } from "leaflet";
import { useMemo } from "react";

import "./Location.css";
import { useTheme } from "../hooks/useTheme";

/**
 * @param {object} props
 * @param {string} props.id
 * @param {string} props.previousLink
 * @param {string} props.nextLink
 * @param {string} props.locationLink
 */
function Location(props) {
  const theme = useTheme();

  const mainIcon = useMemo(() => {
    return new Icon({
      iconSize: [32, 32],
      iconUrl: `/assets/main.${theme}.svg`
    })
  }, [theme])

  const pointIcon = useMemo(() => {
    return new Icon({
      iconSize: [32, 32],
      iconUrl: `/assets/point.${theme}.svg`
    })
  }, [theme])

  const markers = useMemo(() => [
    {
      name: "Ndalem Danar Hadi",
      position: [-7.5725352, 110.8095096],
      icon: mainIcon,
      link: "https://maps.app.goo.gl/966gDA8jBvbax7UVA",
    },
    {
      name: "Solo Paragon",
      position: [-7.5623686, 110.8073772],
      icon: pointIcon,
      link: "https://maps.app.goo.gl/9Wb11sRQzCmxFHmf9",
    },
    {
      name: "Kraton Surakarta Hadiningrat",
      position: [-7.577773, 110.8253182],
      icon: pointIcon,
      link: "https://maps.app.goo.gl/4urtZhJ3dFJ5ufNN7",
    },
    {
      name: "Pura Mangkunegaran",
      position: [-7.5671112, 110.8201843],
      icon: pointIcon,
      link: "https://maps.app.goo.gl/iZtBcqHmHrkLDMad8",
    },
    {
      name: "Masjid Raya Sheikh Zayed Solo Surakarta",
      position: [-7.5547331, 110.826713],
      icon: pointIcon,
      link: "https://maps.app.goo.gl/k3SevVUuUiXLub6p7",

    },
    {
      name: "Stadion Manahan",
      position: [-7.5555789, 110.787479],
      icon: pointIcon,
      link: "https://maps.app.goo.gl/MCkV4RGtCXL9k7HH6",
    },
  ], [])

  return (
    <section className="location" id={props.id}>
      <div className="location__info">
        <div className="location__text field" data-aos="zoom-in-up">
          Yang akan diselenggarakan di
        </div>

        <Map className="location__map" markers={markers} />

        <h1 className="location__name decorative" data-aos="zoom-in-up">
          Ndalem Danarhadi
        </h1>

        <div className="location__address description" data-aos="zoom-in-up">
          Jl. Bhayangkara No.55, Panularan, Kec. Laweyan, Kota Surakarta, Jawa
          Tengah
        </div>

        <Control
          previousLink={props.previousLink}
          nextLink={props.nextLink}
          middleLink={props.locationLink}
          middleIcon="bi-geo-alt-fill"
          middleName="Buka Peta"
        />
      </div>
    </section>
  );
}

Location.propTypes = {
  id: PropTypes.string.isRequired,
  previousLink: PropTypes.string.isRequired,
  nextLink: PropTypes.string.isRequired,
  locationLink: PropTypes.string.isRequired,
};

export default Location;
