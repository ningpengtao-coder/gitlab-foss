# frozen_string_literal: true

# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class UpdateStateForEnvironmentsWithoutDeployments < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def up
    sql = <<~SQL
      WITH no_deployments AS (
          SELECT
              environment_id,
              MAX(status)
          FROM
              deployments
          GROUP BY
              environment_id
          HAVING
              max(status) = 0)
      UPDATE
          environments
      SET
          state = 'created'
      WHERE
          EXISTS (
              SELECT
                  1
              FROM
                  no_deployments
              WHERE
                  environment_id = environments.id)
          AND state = 'available'
    SQL

    execute(sql)
  end

  def down
    execute "UPDATE environments SET state='available' WHERE state='created'"
  end
end
