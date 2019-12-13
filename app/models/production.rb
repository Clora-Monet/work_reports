class Production < ApplicationRecord
  belongs_to :product
  belongs_to :line

  validates :date, presence: true
  validates :product_id, presence: true

  def self.search(date,line_id,product_id)
    if search
      Production.where("(date = ?) AND (line_id = ?) AND (product_id = ?)", "%#{date}%", "%#{line_id}%", "%#{product_id}%")
    else
      redirect_to productions_searches_path
    end
  end
end
