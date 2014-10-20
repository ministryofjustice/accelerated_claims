describe ReferenceNumber, :type => :model do

  subject do
    params = claim_post_data['claim']['reference_number']
    ReferenceNumber.new(params)
  end

  it { is_expected.to be_valid }

  it { expect(subject.as_json).to eq('reference_number' => 'my-ref-123')  }

end
