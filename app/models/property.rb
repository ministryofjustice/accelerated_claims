class Property < ActiveRecord::Base
  has_no_table

  belongs_to :claim

  column :street, :string
  validates :street, presence: true, length: { maximum: 70 }

  column :town, :string
  validates :town, length: { maximum: 40 }

  column :postcode, :string
  validates :postcode, presence: true, length: { maximum: 8 }

  column :house, :boolean
  validates :house, presence: true
end
