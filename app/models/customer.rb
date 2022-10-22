class Customer < ApplicationRecord
  PUBLIC_FIELDS = %w[first_name last_name email company phone country_code location].freeze
  include PgSearch::Model
  include Colourable

  pg_search_scope :search,
    against: %i[first_name last_name email company],
    using: { tsearch: { prefix: true, dictionary: "english" } }

  has_person_name

  has_one_attached :avatar

  belongs_to :team
  has_many :message_threads, dependent: :destroy
  validates :first_name, presence: true
  validates :email, presence: true, email: true, uniqueness: { scope: :team_id }

  scope :blocked, -> { where(blocked: true) }

  def self.upsert_by_jwt(token, team)
    payload =
      JWT.decode(
        token,
        team.shared_secret,
        true,
        algorithm: "HS512"
      )[
        0
      ]

    existing = team.customers.find_by(email: payload["email"])

    if existing
      existing.update(payload.slice(*PUBLIC_FIELDS))
      existing
    else
      team.customers.create!(payload.slice(*PUBLIC_FIELDS))
    end
  rescue JWT::DecodeError
    nil
  end

  def avatar?
    avatar.attached?
  end

  def as_jwt
    payload = attributes.slice(*PUBLIC_FIELDS)

    JWT.encode(payload, team.shared_secret, "HS512")
  end
end
