require 'spec_helper'

describe Feedback do

  let(:feedback) { Feedback.new text: 'feedback', email: email}
  let(:subject) { feedback }

  context 'with email' do
    let(:email) { 'test@example.com' }

    it { should be_valid }

    its(:email_or_anonymous_placeholder) { should == email }
    its(:name_for_feedback) { should == 'Unknown' }
  end

  context 'without email' do
    let(:email) { '' }

    it { should be_valid }

    its(:email_or_anonymous_placeholder) { should == ENV['ANONYMOUS_PLACEHOLDER_EMAIL'] }
    its(:name_for_feedback) { should == 'anonymous feedback' }
  end

  context 'with invalid email' do
    let(:email) { '@example.com' }

    it { should_not be_valid }
  end

end
