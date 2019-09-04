/**
 * Parses the job log content into a structure usable by the template
 *
 * For collaspible lines (section_header = true):
 *    - creates a new array to hold the lines that are collpasible,
 *    - adds a isClosed property to handle toggle
 *    - adds a isHeader property to handle template logic
 * For each line:
 *    - adds the index as  lineNumber
 *
 * TODO: Check if line has content before adding it to the array
 * @param {Array} lines
 * @returns {Array}
 */
export default (lines = []) =>
  lines.reduce((acc, line, index) => {
    if (line.section_header) {
      acc.push({
        isClosed: true,
        isHeader: true,
        line: {
          ...line,
          lineNumber: index,
        },
        lines: [],
      });
    } else if (acc.length && acc[acc.length - 1].isHeader) {
      acc[acc.length - 1].lines.push({
        ...line,
        lineNumber: index,
      });
    } else {
      acc.push({
        ...line,
        lineNumber: index,
      });
    }

    return acc;
  }, []);
