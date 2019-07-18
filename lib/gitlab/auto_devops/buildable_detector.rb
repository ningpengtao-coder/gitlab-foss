# frozen_string_literal: true

module Gitlab
  module AutoDevops
    class BuildableDetector
      VARIABLES = [
        'BUILDPACK_URL'
      ].freeze

      FILE_PATTERNS = [
        'Dockerfile',

        # https://github.com/heroku/heroku-buildpack-clojure
        'project.clj',

        # https://github.com/heroku/heroku-buildpack-go
        'go.mod',
        'Gopkg.mod',
        'Godeps/Godeps.json',
        'vendor/vendor.json',
        'glide.yaml',
        'src/**.go',

        # https://github.com/heroku/heroku-buildpack-gradle
        'gradlew',
        'build.gradle',
        'settings.gradle',

        # https://github.com/heroku/heroku-buildpack-java
        'pom.xml',
        'pom.atom',
        'pom.clj',
        'pom.groovy',
        'pom.rb',
        'pom.scala',
        'pom.yaml',
        'pom.yml',

        # https://github.com/heroku/heroku-buildpack-multi
        '.buildpacks',

        # https://github.com/heroku/heroku-buildpack-nodejs
        'package.json',

        # https://github.com/heroku/heroku-buildpack-php
        'composer.json',
        'index.php',

        # https://github.com/heroku/heroku-buildpack-play
        # TODO: detect script excludes some scala files
        '*/conf/application.conf',
        '*modules*',

        # https://github.com/heroku/heroku-buildpack-python
        # TODO: detect script checks that all of these exist, not any
        'requirements.txt',
        'setup.py',
        'Pipfile',

        # https://github.com/heroku/heroku-buildpack-ruby
        'Gemfile',

        # https://github.com/heroku/heroku-buildpack-scala
        '*.sbt',
        'project/*.scala',
        '.sbt/*.scala',
        'project/build.properties',

        # https://github.com/dokku/buildpack-nginx
        '.static'
      ].freeze

      def initialize(project, ref)
        @project = project
        @ref = ref
      end

      def buildable?
        detected_variables? || detected_files?
      end

      private

      attr_accessor :project, :ref

      def detected_variables?
        project.ci_variables_for(ref: ref).exists?(key: VARIABLES) # rubocop:disable CodeReuse/ActiveRecord
      end

      def detected_files?
        return if !ref && !project.repository.root_ref

        project.repository.ls_files(ref).find do |filename|
          FILE_PATTERNS.any? do |pattern|
            File.fnmatch?(pattern, filename, File::FNM_CASEFOLD)
          end
        end
      rescue GRPC::NotFound
        false
      end
    end
  end
end
