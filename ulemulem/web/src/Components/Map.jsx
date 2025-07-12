import { MapContainer, TileLayer, Marker } from "react-leaflet";
import "./Map.css";
import { useMemo } from "react";
import { useTheme } from "../hooks/useTheme";
import { useCallback } from "react";

function Map(props) {
  const theme = useTheme();

  const tileUrl = useMemo(() => {
    if (theme == "dark")
      return "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png";

    return "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png";
  }, [theme]);

  const createHandlers = useCallback((marker) => {
    if (!marker.link) return;

    return {
      click: function () {
        window.open(marker.link, "_blank");
      },
    };
  }, []);

  return (
    <div className={`map ${props.className}`} data-aos="zoom-in" data-aos-delay="300">
      <MapContainer
        className="map__container"
        zoom={18}
        center={[-7.5725352, 110.8095096]}
        attributionControl={false}
        zoomControl={false}
      >
        <TileLayer url={tileUrl} maxZoom="20" />

        {props.markers.map((marker) => (
          <Marker
            key={marker.name}
            position={marker.position}
            icon={marker.icon}
            eventHandlers={createHandlers(marker)}
          />
        ))}
      </MapContainer>
    </div>
  );
}

export default Map;
