import { sortMetrics, normalizeMetrics } from './utils';

export const getMetricsCount = state =>
  state.groups.reduce((count, group) => count + group.metrics.length, 0);

// combine groups and queryResults from state
// queryResults is a bunch of large arrays, grouped be metricId
// we want to combine them into a single big object for dashboard to use
export const groups = state => {
  if (!state.useDashboardEndpoint) {
    return state.groups;
  }

  return state.groups.reduce((acc, group) => {
    group.panels.forEach(panel => {
      panel.queries = panel.metrics;
      panel.queries.forEach(metric => {
        const metricId = metric.metric_id;
        const result = state.queryResults[metricId];
        metric.result = result || [];
      });
    });

    const metrics = normalizeMetrics(sortMetrics(group.panels));

    return acc.concat({
      ...group,
      metrics,
    });
  }, []);
};

// Reducer function to only include panels with metrics
function hasQueryResult(acc, panel) {
  const metrics = panel.metrics.filter(query => query.result.length > 0);

  if (metrics.length > 0) {
    acc.push({
      ...panel,
      metrics,
    });
  }

  return acc;
}

// Eliminate groups that don't have any panels with results
// if group.panel.metrics.results.length > 0
export function groupsWithData(state) {
  if (!state.useDashboardEndpoint) {
    return state.groups;
  }

  return groups(state).reduce((acc, group) => {
    const panels = group.panels.reduce(hasQueryResult, []);

    if (panels.length > 0) {
      acc.push({
        ...group,
        panels,
      });
    }
    return acc;
  }, []);
}

// prevent babel-plugin-rewire from generating an invalid default during karma tests
export default () => {};
