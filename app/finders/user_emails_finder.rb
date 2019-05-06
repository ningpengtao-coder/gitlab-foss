# frozen_string_literal: true

# Finds the user emails.
#
# Arguments:
#   user - which user use
#   types: Array - email types (primary/secondary) the primary is user.email,
#   the secondary are user.emails.
#
# Returns an Email(id, email attributes only) ActiveRecord::Relation with the id set to nil
# for the primary email.
#
# Using pluck in this finder is not supported because we are using select NULL as id and pluck
# overrides the select statement.
class UserEmailsFinder < UnionFinder
  attr_reader :user, :params

  def initialize(user, params = {})
    @user = user
    @params = params
  end

  def execute
    return Email.none unless params[:types].present?

    find_union(all_emails_by_types, Email).order_id_asc_nulls_first
  end

  private

  # rubocop: disable CodeReuse/ActiveRecord
  def all_emails_by_types
    emails = []

    emails << user.class.where(id: user).select('NULL as id, email') if params[:types].include?('primary')
    emails << user.emails.select('id, email') if params[:types].include?('secondary')

    emails
  end
  # rubocop: enable CodeReuse/ActiveRecord
end
