import PropTypes from "prop-types";

import "./Cover.css";
/**
 * @param {Object} props
 * @param {string} props.id
 * @param {string} props.nextLink
 * @param {string} props.previousLink
 * @param {string} props.recipientName
 */
function Cover(props) {
  return (
    <section className="cover" id={props.id}>
      <div className="cover__info">
        <div className="cover__greeting field" data-aos="fade-up">
          Kepada Yth.
        </div>

        <h1 className="cover__recipient decorative" data-aos="fade-up" data-aos-delay="300">
          {props.recipientName}
        </h1>
      </div>

      <div className="control cover__control" data-aos-delay="1000" data-aos="fade-up">
        <a href={props.nextLink} title="Buka Undangan" className="vertical">
          <span>Buka Undangan</span>
          <i className="bi bi-chevron-down" />
        </a>
      </div>
    </section>
  );
}

Cover.propTypes = {
  id: PropTypes.string.isRequired,
  nextLink: PropTypes.string.isRequired,
  recipientName: PropTypes.string,
};

export default Cover;
