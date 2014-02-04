require 'spec_helper'

describe License do
  let(:license) do
    License.new(hmo: true,
                authority: "Westminster City",
                hmo_date: "1,1,2013",
                housing_act: true,
                housing_act_authority: "Westminster City",
                housing_act_date: "1,1,2013")
  end


end
