import FilteredSearchTokenKeys from './filtered_search_token_keys';

const tokenKeys = [
  // Currently, no filtering is implemented. This will be fixed in future iterations.
  // See https://gitlab.com/gitlab-org/gitlab-ce/issues/48862 for more information.
];

const ProjectArtifactsFilteredSearchTokenKeys = new FilteredSearchTokenKeys(tokenKeys);

export default ProjectArtifactsFilteredSearchTokenKeys;
