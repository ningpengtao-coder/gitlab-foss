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

export const graphDataValidatorForAnomalyValues = (isValues, graphData) => {
  const anomalySeriesCount = 3; // metric, upper, lower
  return (
    graphData.queries &&
    graphData.queries.length === anomalySeriesCount &&
    graphDataValidatorForValues(isValues, graphData)
  );
};

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

export const makeTimeAxis = config => {
  const defaults = {
    name: __('Time'),
    type: 'time',
    axisLabel: {
      formatter: date => dateFormat(date, dateFormats.timeOfDay),
    },
    axisPointer: {
      snap: true,
    },
  };
  return { ...defaults, ...config };
};

export default {};
