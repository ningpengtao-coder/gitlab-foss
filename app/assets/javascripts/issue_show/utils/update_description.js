/**
 * Function that replaces the open attribute for the <details> element.
 *
 * @param {String} descriptionHtml - The html string passed back from the server as a result of polling
 * @param {Array} details - All detail nodes inside of the issue description.
 */

const updateDescription = (descriptionHtml = '', details = []) => {
  const placeholder = document.createElement('div');
  placeholder.innerHTML = descriptionHtml;

  const newDescription = placeholder.getElementsByTagName('details');

  if(newDescription.length !== details.length) {
    return descriptionHtml;
  };

  [...newDescription].forEach((el, i) => {
    /*
      * <details> has an open attribute that can have a value, "", "true", "false"
      * and will show the dropdown, which is why we are setting the attribute
      * explicitly to true.
    */
    if(details[i].open) el.setAttribute('open', true)
  });

  return placeholder.innerHTML;
};

export default updateDescription;