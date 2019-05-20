# frozen_string_literal: true

module DiffForPath
  extend ActiveSupport::Concern

  def render_diff_for_path(diffs)
    diff_file = diffs.diff_files.find do |diff|
      diff.file_identifier == params[:file_identifier]
    end

    return render_404 unless diff_file

    render json: { html: view_to_html_string('projects/diffs/_content', diff_file: diff_file) }
  end

  def render_diff_for_paths(commit, project, environment, batch_number)
    options = diff_options.merge(batch_number: batch_number)

    file_collection = Gitlab::Diff::FileCollection::Batch.new(commit,
                                                              diff_options: options)

    render json: {
      html: view_to_html_string('projects/diffs/_collection',
                                diff_files: file_collection.diff_files,
                                project: project,
                                environment: environment,
                                next_batch: batch_number + 1,
                                diff_page_context: 'is-commit')
   }
  end
end
