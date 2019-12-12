class Production < ApplicationRecord
  belongs_to :product
  belongs_to :line

  validates :date, presence: true
  validates :product_id, presence: true

  def self.search(search)
    if search
      Production.where('text LIKE(?)', "%#{search}%")
    else
      redirect_to line_production_path
    end
  end
end
