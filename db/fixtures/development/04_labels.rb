# frozen_string_literal: true

require 'digest/md5'

class Gitlab::Seeder::GroupLabels
  MASS_LABELS_COUNT = 200 # per group

  def seed!
  end
end

class Gitlab::Seeder::ProjectLabels
  include ActionView::Helpers::NumberHelper

  PROJECT_LIMIT = 500_000
  MASS_LABELS_COUNT = 50 # per project

  def seed!
    relation = Project.select(:id).limit(PROJECT_LIMIT)
    total_labels = relation.count * MASS_LABELS_COUNT

    Gitlab::Seeder.with_mass_insert(total_labels, Label) do
      relation.find_in_batches(batch_size: 500) do |projects|
        rows = projects.flat_map do |project|
          MASS_LABELS_COUNT.times.map do
            label_title = FFaker::Product.brand

            {
              title: label_title,
              color: "##{Digest::MD5.hexdigest(label_title)[0..5]}",
              project_id: project.id,
              type: 'ProjectLabel'
            }
          end
        end

        Gitlab::Database.bulk_insert('labels', rows)
        print '.'
      end
    end
  end
end

Gitlab::Seeder.quiet do
  project_labels = Gitlab::Seeder::ProjectLabels.new
  project_labels.seed!
end
