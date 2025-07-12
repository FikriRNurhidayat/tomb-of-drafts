import PropTypes from "prop-types";
import Control from "../Components/Control";

import "./Closing.css";

/**
 * @param {Object} props
 * @param {string} props.id
 * @param {string} props.previousLink
 * @param {string} props.nextLink
 * @param {string} props.groomName
 */
function Closing(props) {
  return (
    <section className="closing" id={props.id}>
      <Control previousLink={props.previousLink} animation="zoom-out-up" />

      <div data-aos="fade-up" className="closing__text paragraph">
        Merupakan suatu kehormatan dan kebahagiaan bagi kami apabila,
        Bapak/Ibu/Saudara/i berkenan hadir untuk memberikan do'a restunya kami
        ucapkan terimakasih.
      </div>
    </section>
  );
}

Closing.propTypes = {
  id: PropTypes.string.isRequired,
  previousLink: PropTypes.string.isRequired,
  nextLink: PropTypes.string.isRequired,
};

export default Closing;
