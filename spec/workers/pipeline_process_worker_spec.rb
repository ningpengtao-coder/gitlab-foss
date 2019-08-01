# frozen_string_literal: true

require 'spec_helper'

describe PipelineProcessWorker, :clean_gitlab_redis_shared_state do
  include ExclusiveLeaseHelpers

  describe '#perform' do
    subject { worker.perform(pipeline.id) }

    let(:pipeline) { create(:ci_pipeline) }
    let(:worker) { described_class.new }

    context 'when pipeline exists' do
      it 'processes pipeline' do
        expect_any_instance_of(Ci::Pipeline).to receive(:process!)

        described_class.new.perform(pipeline.id)
      end

      context 'when build_ids are passed' do
        let(:build) { create(:ci_build, pipeline: pipeline, name: 'my-build') }

        it 'processes pipeline with a list of builds' do
          expect_any_instance_of(Ci::Pipeline).to receive(:process!)
            .with([build.id])

          described_class.new.perform(pipeline.id, [build.id])
      end

      context 'when the other sidekiq job has already been processing on the pipeline' do
        before do
          stub_exclusive_lease_taken("batch_pop_queueing:lock:pipeline_process_worker:#{pipeline.id}")
        end

        it 'enqueues the pipeline id to the queue and does not process' do
          expect_next_instance_of(Gitlab::BatchPopQueueing) do |queue|
            expect(queue).to receive(:enqueue).with([pipeline.id], anything)
          end

          expect_any_instance_of(Ci::Pipeline).not_to receive(:process!)

          subject
        end
      end

      context 'when there are some items are enqueued during the current process' do
        before do
          allow_any_instance_of(Gitlab::BatchPopQueueing).to receive(:safe_execute) do
            { status: :finished, new_items: [pipeline.id] }
          end
        end

        it 're-executes PipelineProcessWorker asynchronously' do
          expect(PipelineProcessWorker).to receive(:perform_async).with(pipeline.id)

          subject
        end
      end
    end

    context 'when pipeline does not exist' do
      it 'does not raise exception' do
        expect { described_class.new.perform(123) }
          .not_to raise_error
      end
    end

    context 'when pipeline_process_worker_efficient_perform feature flag is disabled' do
      before do
        stub_feature_flags(enable_deduplicater_for_pipeline_process_worker: false)
      end

      it 'processes without SidekiqJobDeduplicater' do
        expect(Gitlab::BatchPopQueueing).not_to receive(:new)

        subject
      end
    end
  end
end
