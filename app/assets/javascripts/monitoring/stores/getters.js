export const groups = state => {
  return state.groups.map(group => {
    group.panels.forEach(panel => {
      panel.queries = panel.metrics;
      panel.queries.forEach(metric => {
        const metricId = metric.metric_id;
        const result = state.queryResults[metricId];
        metric.result = result;
      });
    });
    return group;
  })

  // panel.queries[0].result 
  
  // queryResults: {
  //   metricId
  //   result
  // }
} 
