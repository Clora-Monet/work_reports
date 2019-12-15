class Production < ApplicationRecord
  belongs_to :product
  belongs_to :line

  validates :date, presence: true
  validates :product_id, presence: true

  def self.search(date,line_id,product_id)
    Production.find_by("(date = ?) AND (line_id = ?) AND (product_id = ?)",
                 date, line_id,  product_id)
  end
end
