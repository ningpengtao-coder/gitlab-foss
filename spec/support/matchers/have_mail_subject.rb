# frozen_string_literal: true

RSpec::Matchers.define :have_mail_subject do |target|
  match do |email|
    expect(email).to have_attributes(subject: target)
  end
end
