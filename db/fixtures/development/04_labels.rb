# frozen_string_literal: true

require 'digest/md5'

class Gitlab::Seeder::GroupLabels
  MASS_LABELS_COUNT = 200 # per group

  def seed!
  end
end

class Gitlab::Seeder::ProjectLabels
  MASS_LABELS_COUNT = 400 # per project

  def initialize(project)
    @project = project
  end

  def seed!
    Project.select(:id).find_in_batches(batch_size: 100) do |projects|
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

      puts "*** ROWS BEING INSERTED ***"
      p rows.size

      print rows.size * '.'
      Gitlab::Database.bulk_insert('labels', rows)

      puts "*** LABELS COUNT ***"
      print Label.count
    end

    puts "#{number_with_delimiter(MASS_LABELS_COUNT)} project labels created for each project!"
  end
end

Gitlab::Seeder.quiet do
  # puts "\nGenerating group labels"
  # group_labels = Gitlab::Seeder::GroupLabels.new
  # group_labels.seed!

  puts "\nGenerating project labels"
  project_labels = Gitlab::Seeder::ProjectLabels.new
  project_labels.seed!
end
