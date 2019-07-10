# frozen_string_literal: true

module Gitlab
  include Comparable

  class WikiPath
    attr_reader :basename

    def initialize(path)
      @path = path.clone
      @basename = @path.pop.to_s
    end

    def self.parse(string)
      new(string ? string.split("/") : [])
    end

    def dirname
      @path.join('/')
    end

    def to_s
      ::File.join(dirname, basename)
    end

    def parent
      self.class.new(@path)
    end

    def root_level?
      @path.empty?
    end

    def depth
      @path.size
    end

    def <=>(other)
      return unless other.is_a?(::Gitlab::WikiPath)

      to_s <=> other.to_s
    end
  end
end
