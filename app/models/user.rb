class User < ApplicationRecord
  ROLES = %w[user admin superadmin].freeze

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
  validates :role, presence: true, inclusion: { in: ROLES }

  def familiar_name
    name.familiar
  end

  def avatar?
    avatar.attached?
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def assignable_roles
    ROLES[0..ROLES.index(role)]
  end
end
