const DETAILS_OPEN = '<details open>';
const DETAILS_EL_REGEXP = new RegExp(/<details>/, 'g');
const DETAILS_TAG = '<details>';

/**
 * Function that replaces the open attribute for the <details> element.
 *
 * @param {String} description - The html string passed back from the server as a result of polling
 * @param {Array} details - All detail nodes inside of the issue description.
 */

const updateDetailsState = (description = '', details = []) => {
  let index = 0;

  return description.replace(DETAILS_EL_REGEXP, () => {
    const shouldReplace = details[index] && details[index].open;
    let str = DETAILS_TAG;
    // increment count every time we find a match.
    index += 1;

    if(shouldReplace) {
      str =  DETAILS_OPEN;
    }
    

    return str;
  });
}

export { updateDetailsState };