import _ from 'underscore';
import { sortMetrics, normalizeMetrics } from './utils';

export const getMetricsCount = state =>
  state.groups.reduce((count, group) => count + group.metrics.length, 0);

export const groups = state => {
  if (!gon.features.environmentMetricsUsePrometheusEndpoint) {
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

export function groupsWithData(state) {
  if (!gon.features.environmentMetricsUsePrometheusEndpoint) {
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
