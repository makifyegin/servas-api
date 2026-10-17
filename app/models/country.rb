class Country < ApplicationRecord
  belongs_to :group
  has_many :regions, dependent: :restrict_with_error
  validates :name, presence: true, uniqueness: true
end
