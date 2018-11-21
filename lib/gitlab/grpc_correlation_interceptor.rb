# frozen_string_literal: true

module Gitlab
  class GRPCCorrelationInterceptor < GRPC::ClientInterceptor
    include Singleton

    def request_response(request:, call:, method:, metadata:)
      inject_correlator(metadata) do
        yield
      end
    end

    def client_streamer(requests:, call:, method:, metadata:)
      inject_correlator(metadata) do
        yield
      end
    end

    def server_streamer(request:, call:, method:, metadata:)
      inject_correlator(metadata) do
        yield
      end
    end

    def bidi_streamer(requests:, call:, method:, metadata:)
      inject_correlator(metadata) do
        yield
      end
    end

    private

    def inject_correlator(metadata)
      metadata["x-gitlab-correlation-id"] = Gitlab::CorrelationId.current_id
      yield
    end
  end
end
