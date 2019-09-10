import { __ } from '~/locale';
import dateFormat from 'dateformat';
import { secondsIn, timeWindowsKeyNames, dateFormats } from './constants';

export const getTimeDiff = timeWindow => {
  const end = Math.floor(Date.now() / 1000); // convert milliseconds to seconds
  const difference = secondsIn[timeWindow] || secondsIn.eightHours;
  const start = end - difference;

  return {
    start: new Date(start * 1000).toISOString(),
    end: new Date(end * 1000).toISOString(),
  };
};

export const getTimeWindow = ({ start, end }) =>
  Object.entries(secondsIn).reduce((acc, [timeRange, value]) => {
    if (end - start === value) {
      return timeRange;
    }
    return acc;
  }, timeWindowsKeyNames.eightHours);

/**
 * This method is used to validate if the graph data format for a chart component
 * that needs a time series as a response from a prometheus query (query_range) is
 * of a valid format or not.
 * @param {Object} graphData  the graph data response from a prometheus request
 * @returns {boolean} whether the graphData format is correct
 */
export const graphDataValidatorForValues = (isValues, graphData) => {
  const responseValueKeyName = isValues ? 'value' : 'values';

  return (
    Array.isArray(graphData.queries) &&
    graphData.queries.filter(query => {
      if (Array.isArray(query.result)) {
        return (
          query.result.filter(res => Array.isArray(res[responseValueKeyName])).length ===
          query.result.length
        );
      }
      return false;
    }).length === graphData.queries.length
  );
};

/**
 * This function validates the graph data contains exactly 3 queries plus
 * value validations from graphDataValidatorForValues.
 * @param {Object} isValues
 * @param {Object} graphData  the graph data response from a prometheus request
 * @returns {boolean} true if the data is valid
 */
export const graphDataValidatorForAnomalyValues = graphData => {
  const anomalySeriesCount = 3; // metric, upper, lower
  return (
    graphData.queries &&
    graphData.queries.length === anomalySeriesCount &&
    graphDataValidatorForValues(false, graphData)
  );
};

/**
 * This function returns the earliest time value in all series of a chart.
 * @param {Object} chartData  chart data with data to populate a timeseries.
 * data should be an array of data points [t, y] where t is a ISO formatted date,
 * and is sorted by t (time).
 * @returns {(String|null)} earliest x value from all series, or null when the
 * chart series data is empty.
 */
export const getEarliestDatapoint = chartData =>
  chartData.reduce((acc, series) => {
    const { data } = series;
    const { length } = data;
    if (!length) {
      return acc;
    }

    const [first] = data[0];
    const [last] = data[length - 1];
    const seriesEarliest = first < last ? first : last;

    return seriesEarliest < acc || acc === null ? seriesEarliest : acc;
  }, null);

export const makeTimeAxis = config => ({
  name: __('Time'),
  type: 'time',
  axisLabel: {
    formatter: date => dateFormat(date, dateFormats.timeOfDay),
  },
  axisPointer: {
    snap: true,
  },
  ...config,
});

export default {};
