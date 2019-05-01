export default () => ({
  hasMetrics: false,
  showPanels: true,
  documentationPath: null, // From the vuex docs, strings should be null by default
  settingsPath: null, // From dashboard.vue, props
  clustersPath: null,
  tagsPath: null,
  projectPath: null,
  dashboardEndpoint: '',
  metricsEndpoint: null,
  deploymentEndpoint: null,
  emptyGettingStartedSvgPath: null,
  emptyLoadingSvgPath: null,
  emptyNoDataSvgPath: null,
  emptyUnableToConnectSvgPath: null,
  environmentsEndpoint: null,
  currentEnvironmentName: null, // Finish props
  showEmptyState: true, // From the data
  emptyState: 'loading',
  selectedTimeWindow: null, // finish data section
  groups: [], // NEW
  queryResults: {},
});
