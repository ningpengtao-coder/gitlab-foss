import initPipelineDetails from '~/pipelines/pipeline_details_bundle';
import initPipelines from '../init_pipelines';
import { fetchCommitMergeRequests } from '~/commit_merge_requests';

document.addEventListener('DOMContentLoaded', () => {
  initPipelines();
  initPipelineDetails();
  fetchCommitMergeRequests();
});
