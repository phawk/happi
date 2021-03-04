class Customer < ApplicationRecord
  include Colourable

  has_person_name

  has_one_attached :avatar

  belongs_to :team
  has_many :message_threads, dependent: :destroy
  validates :first_name, :last_name, :email, presence: true

  def avatar?
    avatar.attached?
  end
end
