# frozen_string_literal: true

require 'pathname'

module QA
  module Resource
    module Repository
      class Push < Base
        attr_accessor :file_name, :file_content, :commit_message,
                      :branch_name, :new_branch, :output, :repository_http_uri,
                      :repository_ssh_uri, :ssh_key, :user

        attr_writer :remote_branch

        def initialize
          @file_name = 'file.txt'
          @file_content = '# This is test file'
          @commit_message = "This is a test commit"
          @branch_name = 'master'
          @new_branch = true
          @repository_http_uri = ""
          @ssh_key = nil
        end

        def remote_branch
          @remote_branch ||= branch_name
        end

        def directory=(dir)
          raise "Must set directory as a Pathname" unless dir.is_a?(Pathname)

          @directory = dir
        end

        def files=(files)
          if !files.is_a?(Array) || files.empty?
            raise ArgumentError, "Please provide an array of hashes e.g.: [{name: 'file1', content: 'foo'}]"
          end

          @files = files
        end

        def fabricate!
          Git::Repository.perform do |repository|
            if ssh_key
              repository.uri = repository_ssh_uri
              repository.use_ssh_key(ssh_key)
            else
              repository.uri = repository_http_uri
              repository.use_default_credentials unless user
            end

            username = 'GitLab QA'
            email = 'root@gitlab.com'

            if user
              repository.username = user.username
              repository.password = user.password
              username = user.name
              email = user.email
            end

            repository.clone
            repository.configure_identity(username, email)

            if new_branch
              repository.checkout_new_branch(branch_name)
            else
              repository.checkout(branch_name)
            end

            if @directory
              @directory.each_child do |f|
                repository.add_file(f.basename, f.read) if f.file?
              end
            elsif @files
              @files.each do |f|
                repository.add_file(f[:name], f[:content])
              end
            else
              repository.add_file(file_name, file_content)
            end

            repository.commit(commit_message)
            @output = repository.push_changes("#{branch_name}:#{remote_branch}")

            repository.delete_ssh_key
          end
        end
      end
    end
  end
end
