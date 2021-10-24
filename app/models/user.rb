class User < ApplicationRecord
  ROLES = %w[user admin superadmin].freeze
  ADMIN_ROLES = %w[admin superadmin].freeze

  include Colourable

  attr_accessor :terms_and_conditions

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :confirmable,
    :recoverable, :rememberable, :validatable, :masqueradable

  has_person_name

  has_one_attached :avatar

  has_many :visits, class_name: "Ahoy::Visit", dependent: :nullify
  has_and_belongs_to_many :teams
  belongs_to :team, optional: true

  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :terms_and_conditions, acceptance: true, on: :create

  scope :admins, -> { where(role: ADMIN_ROLES) }

  def familiar_name
    name.familiar
  end

  def avatar?
    avatar.attached?
  end

  def can_send_messages?
    confirmed? && team&.can_send_messages?
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def assignable_roles
    ROLES[0..ROLES.index(role)]
  end

  def as_customer_jwt
    payload = attributes.slice("first_name", "last_name", "email")

    JWT.encode(payload, ENV.fetch("HAPPI_SHARED_SECRET"), "HS512")
  end
end
