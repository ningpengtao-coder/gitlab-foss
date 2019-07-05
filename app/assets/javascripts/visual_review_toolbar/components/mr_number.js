import { MR_ID_BOX, MR_ID_SUBMIT } from './constants';
import singleForm from './single_line_form';

const mrLabel = `Enter your merge request ID`;

const mrForm = singleForm(MR_ID_BOX, MR_ID_SUBMIT, mrLabel);

const authorizeMr = () => { console.log('MR YEAH') };

export { authorizeMr, mrForm };
