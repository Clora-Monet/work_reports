class Line < ApplicationRecord
  has_many :productions

  validates :name, presence: true
end
