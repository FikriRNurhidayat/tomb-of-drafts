import PropTypes from "prop-types";
import Control from "../Components/Control";

import "./Greeting.css";

/**
 * @param {Object} props
 * @param {string} props.id
 * @param {string} props.previousLink
 * @param {string} props.nextLink
 */
function Greeting(props) {
  return (
    <section className="greeting" id={props.id}>
      <div className="greeting__text paragraph" data-aos="fade-up">Dengan hormat, kami berkenan mengundang Bapak/Ibu/Saudara/i pada acara resepsi pernikahan kami.</div>

      <Control previousLink={props.previousLink} nextLink={props.nextLink} />
    </section>
  )
}

Greeting.propTypes = {
  id: PropTypes.string.isRequired,
  previousLink: PropTypes.string.isRequired,
  nextLink: PropTypes.string.isRequired,
  recipientName: PropTypes.string,
};

export default Greeting;
