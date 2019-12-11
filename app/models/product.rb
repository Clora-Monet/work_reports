class Product < ApplicationRecord
  has_many :productions

  validates :code, presence: true, uniqueness: true
end
