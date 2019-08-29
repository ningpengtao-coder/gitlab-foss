/**
 *
 * @param {Array} lines
 * @returns {Array}
 */
export const linesParser = (lines = []) => {
  return lines.reduce((acc, line, index) => {
    if (line.section_header) {
      acc.push({
        isClosed: true,
        isHeader: true,
        lines: [{
          ...line,
          lineNumber: index,
        }],
        lineNumber: index,
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
};

// todo
export const isLastLineRepeated = () => {};
