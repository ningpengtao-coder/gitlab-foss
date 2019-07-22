# frozen_string_literal: true

require 'jwt'

module Zoom
  # Example
  #
  #   api_key = "API KEY"
  #   api_secret = "API SECRET"
  #   user_id = "email@example.com"
  #
  #   client = Zoom::Client.new(api_key: api_key, api_secret: api_secret)
  #
  #   meeting = client.create_meeting(user_id: user_id)
  #   # OR ..
  #   meeting = client.create_meeting(user_id: user_id, topic: "Incident")
  #
  #   puts meetting["join_url"]
  #
  #   client.list_meetings(user_id: user_id)
  #
  #   client.get_meeting(meetting_id: meetting["id"])
  #
  #   client.delete_meeting(meeting_id: meeting["id"])
  #
  class Client
    Error = Class.new(StandardError)

    def initialize(api_url: 'https://api.zoom.us/v2', api_key:, api_secret:, token_expire: 90)
      @api_url = api_url
      @api_key = api_key
      @api_secret = api_secret
      @token_expire = token_expire
    end

    def list_users
      request(:get, '/users')
    end

    def list_meetings(user_id:)
      request(:get, "/users/#{user_id}/meetings")
    end

    def get_meeting(meeting_id:)
      request(:get, "/meetings/#{meeting_id}")
    end

    def create_meeting(user_id:, topic: nil, agenda: nil, password: nil, schedule_for: nil)
      payload = {
        topic: topic,
        schedule_for: schedule_for,
        agenda: agenda,
        password: password
      }

      request(:post, "/users/#{user_id}/meetings", payload)
    end

    def delete_meeting(meeting_id:)
      request(:delete, "/meetings/#{meeting_id}")
    end

    private

    def request(method, path, json=nil)
      url = @api_url + path

      Gitlab::HTTP.public_send(method, url, **request_params(json))
    rescue => e
      # TODO log?
      raise Error, e.message
    end

    def request_params(json)
      {
        headers: {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{access_token}"
        },
        follow_redirects: false
      }.tap do |hash|
        hash[:body] = json.to_json if json
      end
    end

    def access_token
      payload = { iss: @api_key, exp: Time.now.to_i + @token_expire }

      JWT.encode(payload, @api_secret, 'HS256', { typ: 'JWT' })
    end
  end
end
