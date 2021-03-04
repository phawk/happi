class User < ApplicationRecord
  include Colourable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable

  has_person_name

  has_one_attached :avatar

  has_and_belongs_to_many :teams
  belongs_to :team, optional: true

  validates :first_name, :last_name, presence: true

  def avatar?
    avatar.attached?
  end
end
