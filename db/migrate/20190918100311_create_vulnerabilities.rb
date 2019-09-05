# frozen_string_literal: true

# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class CreateVulnerabilities < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    create_table :vulnerabilities do |t|
      # epic-like/issue-like attributes
      t.bigint "milestone_id"
      t.bigint "epic_id"
      t.bigint "project_id", null: false
      t.bigint "author_id", null: false
      t.bigint "iid", null: false
      t.bigint "updated_by_id"
      t.bigint "last_edited_by_id"
      t.date "start_date"
      t.date "due_date"
      t.datetime "last_edited_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "title", limit: 255, null: false
      t.text "title_html", null: false
      t.text "description"
      t.text "description_html"
      t.bigint "start_date_sourcing_milestone_id"
      t.bigint "due_date_sourcing_milestone_id"
      t.bigint "closed_by_id"
      t.datetime "closed_at"

      # vulnerability-like attributes
      t.integer "state", limit: 2, default: 1, null: false # initially: open, closed
      t.integer "severity", limit: 2, null: false # auto-calculated as highest-severity finding, but overrideable
      t.boolean "severity_overridden", default: false
      t.integer "confidence", limit: 2, null: false # auto-calculated as lowest-confidence finding, but overrideable
      t.boolean "confidence_overridden", default: false
    end
  end
end
