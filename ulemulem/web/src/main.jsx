import React from "react";
import ReactDOM from "react-dom/client";
import Invitation from "./Invitation";

import "aos/dist/aos.css";
import "normalize.css";
import "./main.css";
import "bootstrap-icons/font/bootstrap-icons.css";
import "leaflet/dist/leaflet.css";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <Invitation />
  </React.StrictMode>,
);
