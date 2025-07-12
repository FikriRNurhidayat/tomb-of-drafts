import PropTypes from "prop-types";
import Control from "../Components/Control";

import "./Date.css";

/**
 * @param {Object} props 
 * @param {string} props.id
 * @param {string} props.previousLink
 * @param {string} props.nextLink
 * @param {string} props.reminderLink
 */
function Date(props) {
  return (
    <section className="date" id={props.id}>
      <div className="date__info">
        <div className="date__text field" data-aos="zoom-in-up">
          Hari dan Tanggal
        </div>

        <time className="date__date decorative" data-aos="zoom-in-up" dateTime="2024-08-24T12:00:00.000Z">Sabtu, 24 Agustus 2024</time>

        <div className="date__time description" data-aos="zoom-in-up">
          <span className="date__time-field">Pukul </span><span className="date__time-value">Tujuh Malam</span>
        </div>

        <Control
          previousLink={props.previousLink}
          middleName="Simpan Tanggal di Kalender"
          middleLink={props.reminderLink}
          middleIcon="bi-calendar"
          nextLink={props.nextLink}
        />
      </div>
    </section>
  );
}

Date.propTypes = {
  id: PropTypes.string.isRequired,
  previousLink: PropTypes.string.isRequired,
  nextLink: PropTypes.string.isRequired,
  reminderLink: PropTypes.string.isRequired,
}

export default Date;
