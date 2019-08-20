# frozen_string_literal: true

RSpec::Matchers.define :have_mail_body do |target|
  match do |email|
    matcher = target.is_a?(String) ? include(target) : match(target)

    expect(email.default_part_body.to_s.gsub(/\s+/, ' ')).to matcher
  end
end
