import PropTypes from "prop-types";
import Control from "../Components/Control";
import "./NewlyWeds.css";

/**
 * @param {Object} props
 * @param {string} props.id
 * @param {string} props.previousLink
 * @param {string} props.nextLink
 * @param {string} props.groomName
 * @param {string} props.groomFatherName
 * @param {string} props.groomMotherName
 * @param {string} props.brideName
 * @param {string} props.brideFatherName
 * @param {string} props.brideMotherName
 */
function NewlyWeds(props) {
  return (
    <section className="newlyweds" id={props.id}>
      <div className="newlyweds__info">
        <h1 className="newlyweds__name decorative" data-aos="fade-up">{props.brideName}</h1>
        <div className="field" data-aos="fade-up">Putri Dari</div>
        <div className="newlyweds__parents paragraph" data-aos="fade-up">{props.brideFatherName} & {props.brideMotherName}</div>
      </div>

      <span className="newlyweds__ampersand" data-aos="fade-up">&</span>

      <div className="newlyweds__info">
        <h1 className="newlyweds__name decorative" data-aos="fade-up">{props.groomName}</h1>
        <div className="field" data-aos="fade-up">Putra Dari</div>
        <div className="newlyweds__parents paragraph" data-aos="fade-up">{props.groomFatherName} & {props.groomMotherName}</div>
      </div>

      <Control previousLink={props.previousLink} nextLink={props.nextLink} />
    </section>
  );
}

NewlyWeds.propTypes = {
  id: PropTypes.string.isRequired,
  previousLink: PropTypes.string.isRequired,
  nextLink: PropTypes.string.isRequired,
  groomName: PropTypes.string.isRequired,
  groomFatherName: PropTypes.string.isRequired,
  groomMotherName: PropTypes.string.isRequired,
  brideName: PropTypes.string.isRequired,
  brideFatherName: PropTypes.string.isRequired,
  brideMotherName: PropTypes.string.isRequired,
};

export default NewlyWeds;
