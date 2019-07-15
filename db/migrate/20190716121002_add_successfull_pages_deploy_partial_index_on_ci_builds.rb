# frozen_string_literal: true

class AddSuccessfullPagesDeployPartialIndexOnCiBuilds < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    add_concurrent_index(
      :ci_builds, :project_id,
      name: 'index_ci_builds_on_project_id_for_successfull_pages_deploy',
      where: "type='GenericCommitStatus' AND stage='deploy' AND name='pages:deploy' AND status = 'success'"
    )
  end

  def down
    remove_concurrent_index_by_name :ci_builds, 'index_ci_builds_on_project_id_for_successfull_pages_deploy'
  end
end
