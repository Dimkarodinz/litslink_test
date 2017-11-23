class Payment < ApplicationRecord
  belongs_to :service

  # activerecord level of validation
  validates :service, uniqueness: { scope: :line_item }

  def self.with
  end
end
