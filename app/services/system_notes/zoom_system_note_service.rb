# frozen_string_literal: true

class ZoomSystemNoteService < BaseSystemNoteService
  def zoom_link_added
    create_note(NoteSummary.new(noteable, project, author, _('added a Zoom call to this issue'), action: 'pinned_embed'))
  end

  def zoom_link_removed
    create_note(NoteSummary.new(noteable, project, author, _('removed a Zoom call from this issue'), action: 'pinned_embed'))
  end
end
