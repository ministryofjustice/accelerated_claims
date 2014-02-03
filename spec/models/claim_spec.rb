require 'spec_helper'

describe Claim do

  subject { Claim.new }

  it "should hold a property" do
    should respond_to :property
  end

end
