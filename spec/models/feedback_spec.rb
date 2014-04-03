require 'spec_helper'

describe Feedback do

  let(:text) { 'feedback' }
  let(:feedback) { Feedback.new text: text, email: email}
  let(:subject) { feedback }

  context 'with email' do
    let(:email) { 'test@example.com' }

    it { should be_valid }

    its(:email_or_anonymous_placeholder) { should == email }
    its(:name_for_feedback) { should == 'Unknown' }
    its(:test?) { should be_false }
  end

  context 'without email' do
    let(:email) { '' }

    it { should be_valid }

    its(:email_or_anonymous_placeholder) { should == ENV['ANONYMOUS_PLACEHOLDER_EMAIL'] }
    its(:name_for_feedback) { should == 'anonymous feedback' }
    its(:test?) { should be_false }
  end

  context 'with invalid email' do
    let(:email) { '@example.com' }

    it { should_not be_valid }
  end

  context 'with test text' do
    let(:email) { 'test@example.com' }
    let(:text) { 'test text' }

    it { should be_valid }

    its(:test?) { should be_true }
  end

end
