describe Checklist do
  let(:json) { claim_formatted_data }

  subject { Checklist.new(json) }

  it { is_expected.to respond_to(:add) }
end
