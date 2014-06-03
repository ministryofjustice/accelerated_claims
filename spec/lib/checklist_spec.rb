# -*- coding: utf-8 -*-
describe Checklist do
  let(:json) { claim_formatted_data }

  subject { Checklist.new(json) }

  it { should respond_to(:add) }
end
