# frozen_string_literal: true

require 'prometheus/client/support/unicorn'

module Gitlab
  module Metrics
    module Samplers
      class RubySampler < BaseSampler
        def initialize(interval)
          metrics[:process_start_time_seconds].set(labels, Time.now.to_i)

          @last_gc_count = GC.stat[:count]

          super
        end

        def metrics
          @metrics ||= init_metrics
        end

        def with_prefix(prefix, name)
          "ruby_#{prefix}_#{name}".to_sym
        end

        def to_doc_string(name)
          name.to_s.humanize
        end

        def labels
          {}
        end

        def init_metrics
          metrics = {
            file_descriptors:               ::Gitlab::Metrics.gauge(with_prefix(:file, :descriptors), 'File descriptors used', labels),
            memory_bytes:                   ::Gitlab::Metrics.gauge(with_prefix(:memory, :bytes), 'Memory used', labels),
            process_cpu_seconds_total:      ::Gitlab::Metrics.gauge(with_prefix(:process, :cpu_seconds_total), 'Process CPU seconds total'),
            process_max_fds:                ::Gitlab::Metrics.gauge(with_prefix(:process, :max_fds), 'Process max fds'),
            process_resident_memory_bytes:  ::Gitlab::Metrics.gauge(with_prefix(:process, :resident_memory_bytes), 'Memory used', labels),
            process_start_time_seconds:     ::Gitlab::Metrics.gauge(with_prefix(:process, :start_time_seconds), 'Process start time seconds'),
            sampler_duration:               ::Gitlab::Metrics.counter(with_prefix(:sampler, :duration_seconds_total), 'Sampler time', labels),
            total_time:                     ::Gitlab::Metrics.counter(with_prefix(:gc, :duration_seconds_total), 'Total GC time', labels),

            ruby_gc_lost_profile_events:    ::Gitlab::Metrics.counter(with_prefix(:gc, :lost_profile_events), 'Lost GC::Profiler events', labels)
          }

          GC.stat.keys.each do |key|
            metrics[key] = ::Gitlab::Metrics.gauge(with_prefix(:gc_stat, key), to_doc_string(key), labels)
          end

          metrics
        end

        def sample
          p "---> 0. SAMPLE: #{$0}"
          start_time = System.monotonic_time

          metrics[:file_descriptors].set(labels, System.file_descriptor_count)
          metrics[:process_cpu_seconds_total].set(labels, ::Gitlab::Metrics::System.cpu_time)
          metrics[:process_max_fds].set(labels, ::Gitlab::Metrics::System.max_open_file_descriptors)
          set_memory_usage_metrics
          sample_gc

          metrics[:sampler_duration].increment(labels, System.monotonic_time - start_time)
        end

        private

        # TODO: move most of the logic to a separate class
        def sample_gc
          current_gc_count = GC.stat[:count]
          p "---> 1.CURRENT_GC_COUNT: #{current_gc_count}"
          new_events_since_last_sample = current_gc_count - @last_gc_count
          p "---> 2.NEW_EVENTS_SINCE_LAST_SAMPLE: #{new_events_since_last_sample}"

          p "#{GC::Profiler}"
          p "#{GC::Profiler.enabled?}"
          p "#{GC::Profiler.raw_data}"
          p "#{GC::Profiler.raw_data.class}"
          profiled_events = GC::Profiler.raw_data.count
          p "---> 3.PROFILED_EVENTS: #{profiled_events}"

          lost_profiled_events = new_events_since_last_sample - profiled_events
          p "---> 4.LOST_PROFILED_EVENTS: #{lost_profiled_events}"

          unless lost_profiled_events.zero?
            ruby_gc_lost_profile_events.increment(lost_profiled_events)
          end

          # Collect the GC time since last sample in float seconds.
          metrics[:total_time].increment(labels, GC::Profiler.total_time)

          @last_gc_count = current_gc_count
          # TODO: ensure it's not called somewhere else (wrap into separate class + cop)
          GC::Profiler.clear

          # Collect generic GC stats.
          GC.stat.each do |key, value|
            metrics[key].set(labels, value)
          end

        end

        def set_memory_usage_metrics
          memory_usage = System.memory_usage

          metrics[:memory_bytes].set(labels, memory_usage)
          metrics[:process_resident_memory_bytes].set(labels, memory_usage)
        end
      end
    end
  end
end
