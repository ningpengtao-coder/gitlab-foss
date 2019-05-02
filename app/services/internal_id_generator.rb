# frozen_string_literal: true

class InternalIdGenerator
  # Generate next internal id for a given scope and usage.
  #
  # For currently supported usages, see #usage enum.
  #
  # The method implements a locking scheme that has the following properties:
  # 1) Generated sequence of internal ids is unique per (scope and usage)
  # 2) The method is thread-safe and may be used in concurrent threads/processes.
  # 3) The generated sequence is gapless.
  # 4) In the absence of a record in the internal_ids table, one will be created
  #    and last_value will be calculated on the fly.
  #
  # subject: The instance we're generating an internal id for. Gets passed to init if called.
  # scope: Attributes that define the scope for id generation.
  # usage: Symbol to define the usage of the internal id, see InternalId.usages
  attr_reader :subject, :scope, :scope_attrs, :usage

  def initialize(subject, scope, usage)
    @subject = subject
    @scope = scope
    @usage = usage

    raise ArgumentError, 'Scope is not well-defined, need at least one column for scope (given: 0)' if scope.empty?

    unless InternalId.usages.has_key?(usage.to_s)
      raise ArgumentError, "Usage '#{usage}' is unknown. Supported values are #{InternalId.usages.keys} from InternalId.usages"
    end
  end

  # Generates next internal id and returns it
  # init: Block that gets called to initialize InternalId record if not present
  #       Make sure to not throw exceptions in the absence of records (if this is expected).
  def generate(init)
    subject.transaction do
      # Create a record in internal_ids if one does not yet exist
      # and increment its last value
      #
      # Note this will acquire a ROW SHARE lock on the InternalId record
      (lookup || create_record(init)).increment_and_save!
    end
  end

  # Reset tries to rewind to `value-1`. This will only succeed,
  # if `value` stored in database is equal to `last_value`.
  # value: The expected last_value to decrement
  # rubocop: disable CodeReuse/ActiveRecord
  def reset(value)
    return false unless value

    updated =
      InternalId
      .where(**scope, usage: usage_value)
      .where(last_value: value)
      .update_all('last_value = last_value - 1')

    updated > 0
  end
  # rubocop: enable CodeReuse/ActiveRecord

  # Create a record in internal_ids if one does not yet exist
  # and set its new_value if it is higher than the current last_value
  #
  # Note this will acquire a ROW SHARE lock on the InternalId record
  def track_greatest(init, new_value)
    subject.transaction do
      (lookup || create_record(init)).track_greatest_and_save!(new_value)
    end
  end

  private

  # Retrieve InternalId record for (project, usage) combination, if it exists
  def lookup
    InternalId.find_by(**scope, usage: usage_value) # rubocop: disable CodeReuse/ActiveRecord
  end

  def usage_value
    @usage_value ||= InternalId.usages[usage.to_s]
  end

  # Create InternalId record for (scope, usage) combination, if it doesn't exist
  #
  # We blindly insert without synchronization. If another process
  # was faster in doing this, we'll realize once we hit the unique key constraint
  # violation. We can safely roll-back the nested transaction and perform
  # a lookup instead to retrieve the record.
  def create_record(init)
    subject.transaction(requires_new: true) do
      InternalId.create!(
        **scope,
        usage: usage_value,
        last_value: init.call(subject) || 0
      )
    end
  rescue ActiveRecord::RecordNotUnique
    lookup
  end
end
