class Claim < ActiveRecord::Base
  has_no_table

  has_one :property
end
