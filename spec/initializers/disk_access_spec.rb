require 'spec_helper'

describe 'disk_access' do
  let(:path) { '/tmp/a_file_to_test' }

  describe 'File.new' do
    let(:mode) { 'w' }
    let(:args) { [mode] }
    let(:severity) { ::Logger::Severity::ERROR }
    let(:log_message) do
      {
        class: 'File',
        cwd: Dir.pwd,
        path: path,
        operation: 'new',
        args: args,
        mode: mode,
        caller: an_instance_of(String),
        message: 'direct file system access detected'
      }
    end

    it 'logs calls' do
      expect(FileWithLog::LOGGER)
        .to receive(:log).with(severity, log_message)
              .and_call_original

      f = File.new(path, 'w')
      File.unlink(f.path)
    end
  end
end
