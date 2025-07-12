import PropTypes from "prop-types";

import "./Control.css";

/**
 * @param {Object} props
 * @param {string} [props.animation]
 * @param {string} [props.middleIcon]
 * @param {string} [props.middleLink]
 * @param {string} [props.middleName]
 * @param {string} [props.middleTarget]
 * @param {string} [props.nextLink]
 * @param {string} [props.nextName]
 * @param {string} [props.previousLink]
 * @param {string} [props.previousName]
 */
function Control(props) {
  return (
    <div className={`control ${props.className || ""}`} data-aos-delay="1000" data-aos={props.animation || "fade-in"}>
      {!!props.previousLink && (
        <a href={props.previousLink} title={props.previousName} className="chevron">
          <i className="bi bi-caret-up-fill" />
        </a>
      )}
      {!!props.middleLink && (
        <a href={props.middleLink} title={props.middleName} target={props.middleTarget || "_blank"}>
          <i className={`bi ${props.middleIcon || "bi-circle-fill"}`} />
        </a>
      )}
      {!!props.nextLink && (
        <a href={props.nextLink} title={props.nextName} className="chevron">
          <i className="bi bi-caret-down-fill" />
        </a>
      )}
    </div>
  );
}

Control.propTypes = {
  animation: PropTypes.string,
  middleIcon: PropTypes.string,
  middleLink: PropTypes.string,
  middleName: PropTypes.string,
  middleTarget: PropTypes.string,
  nextLink: PropTypes.string,
  nextName: PropTypes.string,
  previousLink: PropTypes.string,
  previousName: PropTypes.string,
};

export default Control;
