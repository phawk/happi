class BetaSignup < ApplicationRecord
  belongs_to :team, optional: true

  validates :email, email: true, presence: true, uniqueness: true
end
