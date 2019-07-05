import { MR_ID, MR_ID_SUBMIT } from './constants';
import singleForm from './single_line_form';

const mrLabel = `Enter your merge request ID`;
const mrRememberText = `Remember this number`;

const texts = {
  labelText: mrLabel,
  rememberText: mrRememberText
}

const mrForm = singleForm(MR_ID, MR_ID_SUBMIT, texts);

const authorizeMr = () => { console.log('MR YEAH') };

export { authorizeMr, mrForm };
