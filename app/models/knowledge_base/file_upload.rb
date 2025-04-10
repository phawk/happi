class KnowledgeBase::FileUpload < ApplicationRecord
  belongs_to :user
  belongs_to :team

  has_many :embeddings, as: :object, dependent: :destroy

  has_one_attached :file
  validates :file, content_type: %w[application/pdf application/vnd.apple.pages application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document image/jpeg image/png image/jpg image/tiff text/markdown], size: {less_than: 5.megabytes, message: "is too large – must be less than 5mb"}
  validates :file, presence: true
end
