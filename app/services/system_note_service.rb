# frozen_string_literal: true

# SystemNoteService
#
# Used for creating system notes (e.g., when a user references a merge request
# from an issue, an issue's assignee changes, an issue is closed, etc.)
module SystemNoteService
  extend self

  def add_commits(noteable, project, author, new_commits, existing_commits = [], oldrev = nil)
    service = CommitSystemNoteService.new(noteable, project, author)
    service.add_commits(new_commits, existing_commits, oldrev)
  end

  def tag_commit(noteable, project, author, tag_name)
    service = CommitSystemNoteService.new(noteable, project, author)
    service.tag_commit(tag_name)
  end

  def change_assignee(noteable, project, author, assignee)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.change_assignee(assignee)
  end

  def change_issuable_assignees(issuable, project, author, old_assignees)
    service = IssuablesSystemNoteService.new(issuable, project, author)
    service.change_issuable_assignees(old_assignees)
  end

  def change_milestone(noteable, project, author, milestone)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.change_milestone(milestone)
  end

  def change_due_date(noteable, project, author, due_date)
    service = TimeTrackingSystemNoteService.new(noteable, project, author)
    service.change_due_date(due_date)
  end

  def change_time_estimate(noteable, project, author)
    service = TimeTrackingSystemNoteService.new(noteable, project, author)
    service.change_time_estimate
  end

  def change_time_spent(noteable, project, author)
    service = TimeTrackingSystemNoteService.new(noteable, project, author)
    service.change_time_spent
  end

  def change_status(noteable, project, author, status, source = nil)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.change_status(status, source)
  end

  def merge_when_pipeline_succeeds(noteable, project, author, sha)
    service = MergeRequestsSystemNoteService.new(noteable, project, author)
    service.merge_when_pipeline_succeeds(sha)
  end

  def cancel_merge_when_pipeline_succeeds(noteable, project, author)
    service = MergeRequestsSystemNoteService.new(noteable, project, author)
    service.cancel_merge_when_pipeline_succeeds
  end

  def abort_merge_when_pipeline_succeeds(noteable, project, author, reason)
    service = MergeRequestsSystemNoteService.new(noteable, project, author)
    service.abort_merge_when_pipeline_succeeds(reason)
  end

  def handle_merge_request_wip(noteable, project, author)
    service = MergeRequestsSystemNoteService.new(noteable, project, author)
    service.handle_merge_request_wip
  end

  def add_merge_request_wip_from_commit(noteable, project, author, commit)
    service = MergeRequestsSystemNoteService.new(noteable, project, author)
    service.add_merge_request_wip_from_commit(commit)
  end

  def resolve_all_discussions(merge_request, project, author)
    service = MergeRequestsSystemNoteService.new(merge_request, project, author)
    service.resolve_all_discussions
  end

  def discussion_continued_in_issue(discussion, project, author, issue)
    service = MergeRequestsSystemNoteService.new(nil, project, author)
    service.discussion_continued_in_issue(discussion, issue)
  end

  def diff_discussion_outdated(discussion, project, author, change_position)
    service = MergeRequestsSystemNoteService.new(nil, project, author)
    service.diff_discussion_outdated(discussion, change_position)
  end

  def change_title(noteable, project, author, old_title)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.change_title(old_title)
  end

  def change_description(noteable, project, author)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.change_description
  end

  def change_issue_confidentiality(issue, project, author)
    service = IssuablesSystemNoteService.new(issue, project, author)
    service.change_issue_confidentiality
  end

  def change_branch(noteable, project, author, branch_type, old_branch, new_branch)
    service = MergeRequestsSystemNoteService.new(noteable, project, author)
    service.change_branch(branch_type, old_branch, new_branch)
  end

  def change_branch_presence(noteable, project, author, branch_type, branch, presence)
    service = MergeRequestsSystemNoteService.new(noteable, project, author)
    service.change_branch_presence(branch_type, branch, presence)
  end

  def new_issue_branch(issue, project, author, branch, branch_project: nil)
    service = MergeRequestsSystemNoteService.new(issue, project, author)
    service.new_issue_branch(branch, branch_project: branch_project)
  end

  def new_merge_request(issue, project, author, merge_request)
    service = MergeRequestsSystemNoteService.new(issue, project, author)
    service.new_merge_request(merge_request)
  end

  def cross_reference(noteable, mentioner, author)
    service = IssuablesSystemNoteService.new(noteable, nil, author)
    service.cross_reference(mentioner)
  end

  def cross_reference_exists?(noteable, mentioner)
    service = IssuablesSystemNoteService.new(noteable, nil, nil)
    service.cross_reference_exists?(mentioner)
  end

  def change_task_status(noteable, project, author, new_task)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.change_task_status(new_task)
  end

  def noteable_moved(noteable, project, noteable_ref, author, direction:)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.noteable_moved(noteable_ref, direction)
  end

  def mark_duplicate_issue(noteable, project, author, canonical_issue)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.mark_duplicate_issue(canonical_issue)
  end

  def mark_canonical_issue_of_duplicate(noteable, project, author, duplicate_issue)
    service = IssuablesSystemNoteService.new(noteable, project, author)
    service.mark_canonical_issue_of_duplicate(duplicate_issue)
  end

  def discussion_lock(issuable, author)
    service = IssuablesSystemNoteService.new(issuable, issuable.project, author)
    service.discussion_lock
  end

  def cross_reference_disallowed?(noteable, mentioner)
    service = IssuablesSystemNoteService.new(noteable, nil, nil)
    service.cross_reference_disallowed?(mentioner)
  end

  def zoom_link_added(issue, project, author)
    service = ZoomSystemNoteService.new(issue, project, author)
    service.zoom_link_added
  end

  def zoom_link_removed(issue, project, author)
    service = ZoomSystemNoteService.new(issue, project, author)
    service.zoom_link_removed
  end

  # TODO: Just added for testing
  def new_commit_summary(new_commits)
    CommitSystemNoteService.new(nil, nil, nil).new_commit_summary(new_commits)
  end
end
