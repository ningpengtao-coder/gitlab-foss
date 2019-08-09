# frozen_string_literal: true

class ZoomService < Service
  prop_accessor :api_key, :api_secret
  validates :api_key, :api_secret, presence: true, if: :activated?
  def title
    'Zoom'
  end

  def description
    s_('ZoomService|Integrating Zoom allows you to embed zoom content in GitLab issues')
  end

  def help
    'Embed Zoom content in GitLab issues'
  end

  def self.to_param
    'zoom'
  end

  def fields
    [
      {
        type: 'text',
        name: 'api_key',
        placeholder: s_('ZoomService|Api key placeholder...'),
        required: true
      },
      {
        type: 'text',
        name: 'api_secret',
        placeholder: s_('ZoomService|Secret key placeholder...'),
        required: true
      }
   ]
  end

   def self.supported_events
      %w()
   end

end
