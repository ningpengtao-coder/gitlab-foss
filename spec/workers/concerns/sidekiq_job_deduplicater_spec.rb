# frozen_string_literal: true

require 'spec_helper'

describe SidekiqJobDeduplicater, :clean_gitlab_redis_shared_state do
  let(:worker_class) { PipelineProcessWorker }
  let(:worker) { worker_class.new }
  let(:arg) { 1 }

  subject { worker.perform(arg) }

  it 'goes through Gitlab::BatchPopQueueing' do
    queue = double(Gitlab::BatchPopQueueing)

    allow(Gitlab::BatchPopQueueing)
      .to receive(:new).with('pipeline_process_worker', arg.to_s) { queue }

    expect(queue)
      .to receive(:safe_execute).with([arg], lock_timeout: 10.minutes) { { status: :finished } }

    subject
  end

  context 'when the result of BatchPopQueueing has new items' do
    before do
      allow_any_instance_of(Gitlab::BatchPopQueueing)
        .to receive(:safe_execute) { { status: :finished, new_items: [1] } }
    end

    it 'performs the additional item asynchronously' do
      expect(worker_class).to receive(:perform_async).with(1)

      subject
    end
  end

  context 'when deduplicater_lock_timeout is 1 hour' do
    before do
      worker.deduplicater_lock_timeout = 1.hour
    end

    it 'sets 1 hour to lock timeout' do
      expect_next_instance_of(Gitlab::BatchPopQueueing) do |queue|
        expect(queue).to receive(:safe_execute).with([arg], lock_timeout: 1.hour)
                                               .and_call_original
      end

      subject
    end
  end

  context 'when deduplicater_default_enabled is false' do
    before do
      worker.deduplicater_default_enabled = false
    end

    it 'sets default_enabled false to the feature flag' do
      expect(Feature)
        .to receive(:enabled?).with('enable_deduplicater_for_pipeline_process_worker',
                                    default_enabled: false) { false }

      subject
    end
  end
end
