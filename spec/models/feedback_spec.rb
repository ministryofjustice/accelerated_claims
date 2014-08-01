describe Feedback, :type => :model do

  let(:difficulty_feedback) { 'It was difficult' }
  let(:improvement_feedback) { 'But no improvement needed' }
  let(:satisfaction_feedback) { 'Dissatisfied' }
  let(:help_feedback) { 'No, I filled in this form myself' }
  let(:other_help) { 'Searched for court address' }

  let(:feedback) do
    Feedback.new difficulty_feedback: difficulty_feedback,
        improvement_feedback: improvement_feedback,
        satisfaction_feedback: satisfaction_feedback,
        help_feedback: help_feedback,
        other_help: other_help,
        email: email
  end

  let(:subject) { feedback }

  context 'with email' do
    let(:email) { 'test@example.com' }

    it { is_expected.to be_valid }

    its(:email_or_anonymous_placeholder) { should == email }
    its(:name_for_feedback) { should == 'Unknown' }
    its(:test?) { should be false }

    its(:text) { should == "difficulty_feedback: It was difficult

improvement_feedback: But no improvement needed

satisfaction_feedback: Dissatisfied

help_feedback: No, I filled in this form myself

other_help: Searched for court address"}
  end

  context 'without email' do
    let(:email) { '' }

    it { is_expected.to be_valid }

    its(:email_or_anonymous_placeholder) { should == ENV['ANONYMOUS_PLACEHOLDER_EMAIL'] }
    its(:name_for_feedback) { should == 'anonymous feedback' }
    its(:test?) { should be false }
  end

  context 'with invalid email' do
    let(:email) { '@example.com' }

    it { is_expected.not_to be_valid }
  end

  context 'with test text' do
    let(:email) { 'test@example.com' }
    let(:difficulty_feedback) { Feedback::TEST_TEXT }

    it { is_expected.to be_valid }

    its(:test?) { should be true }
  end

end
