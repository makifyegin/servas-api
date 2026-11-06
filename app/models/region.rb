class Region < ApplicationRecord
  belongs_to :country
  has_many :roles, dependent: :restrict_with_error
  has_many :membership_applications, dependent: :restrict_with_error
  has_many :members, dependent: :restrict_with_error
  validates :name, presence: true, uniqueness: { scope: :country_id }
end
