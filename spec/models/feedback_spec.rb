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

    it { expect(feedback.email_or_anonymous_placeholder).to eq email  }
    it { expect(feedback.name_for_feedback).to eq 'Unknown'  }
    it { expect(feedback.test?).to be false }

    it do expect(feedback.text).to eq "difficulty_feedback: It was difficult

improvement_feedback: But no improvement needed

satisfaction_feedback: Dissatisfied

help_feedback: No, I filled in this form myself

other_help: Searched for court address"
    end
  end

  context 'without email' do
    let(:email) { '' }

    it { is_expected.to be_valid }

    it { expect(feedback.email_or_anonymous_placeholder).to eq ENV['ANONYMOUS_PLACEHOLDER_EMAIL']  }
    it { expect(feedback.name_for_feedback).to eq 'anonymous feedback'  }
    it { expect(feedback.test?).to be false }
  end

  context 'with invalid email' do
    let(:email) { '@example.com' }

    it { is_expected.not_to be_valid }
  end

  context 'with test text' do
    let(:email) { 'test@example.com' }
    let(:difficulty_feedback) { Feedback::TEST_TEXT }

    it { is_expected.to be_valid }

    it { expect(feedback.test?).to be true }
  end

end
