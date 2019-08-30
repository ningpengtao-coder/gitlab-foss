# frozen_string_literal: true

class AddDuplicatedToToIssue < ActiveRecord::Migration[5.2]
  DOWNTIME = false

  def change
    add_reference :issues, :duplicated_to, references: :issues, index: true
  end
end
