class Production < ApplicationRecord
  belongs_to :product
  belongs_to :line

  validates :date, presence: true
  validates :product_id, presence: true
end
