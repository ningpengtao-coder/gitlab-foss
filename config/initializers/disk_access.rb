# frozen_string_literal: true

module FileWithLog
  extend ActiveSupport::Concern

  OpenFileEvent = Struct.new(:path, :args, :where) do
    def severity
      return Logger::Severity::INFO unless write?
      return Logger::Severity::INFO if log_file?

      Logger::Severity::ERROR
    end

    def log_message
      {
        class: 'File',
        operation: 'new',
        caller: where,
        cwd: Dir.pwd,
        path: path,
        args: args,
        mode: mode,
        message: 'direct file system access detected'
      }
    end

    private

    def mode
      return 'r' if args.empty?

      case mode_info
      when Integer
        return mode_flags
      when String
        return mode_info
      when Hash
        return mode_info[:mode] || 'r'
      end
    end

    def mode_info
      args[0]
    end

    def mode_flags
      return unless mode_info.is_a?(Integer)

      return 'rw' if mode_has_flag?(File::RDWR)
      return 'w' if mode_has_flag?(File::WRONLY)
      return 'a' if mode_has_flag?(File::APPEND)

      'r'
    end

    def mode_has_flag?(flag)
      mode_info & flag == flag
    end

    def safe_mode_no_encodings
      safe_mode = mode || ':'

      safe_mode.split(':', 2)[0]
    end

    def write?
      %w[w a].any? { |m| safe_mode_no_encodings.include?(m) }
    end

    def log_file?
      File.dirname(path) == File.join(Rails.root, 'logs')
    end
  end

  LOGGER = Gitlab::DiskAccessJsonLogger.build

  included do
    alias_method :initialize_without_logging, :initialize
    def initialize(*vars)
      file, *args = vars
      access = OpenFileEvent.new(file, args, caller[0])
      LOGGER.log(access.severity, access.log_message)

      initialize_without_logging(*vars)
    end
  end
end

if !Rails.env.production? || ENV.key?('GITLAB_TRACE_DISK_ACCESS')
  ::File.include(FileWithLog)
end
