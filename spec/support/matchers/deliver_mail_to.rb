# frozen_string_literal: true

RSpec::Matchers.define :deliver_mail_to do |*targets|
  match do |email|
    expected_recipients = targets.map {|t| t.try(:email) || t }
    header = email.header[:to] || email.header[:bcc]
    recipients = header.try(:addrs).try(:map, &:to_s)

    expect(email.perform_deliveries).to be_truthy
    expect(recipients).to include(*expected_recipients)
  end
end
