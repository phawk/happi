class KnowledgeBase::FileUpload < ApplicationRecord
  belongs_to :user
  belongs_to :team

  has_many :embeddings, as: :object, dependent: :destroy

  has_one_attached :file
  validates :file, content_type: %w[application/pdf application/vnd.apple.pages application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document image/jpeg image/png image/jpg image/tiff text/markdown], size: {less_than: 5.megabytes, message: "is too large – must be less than 5mb"}
  validates :file, presence: true

  scope :with_summary, -> { where.not(summary: nil) }

  def status
    if processed?
      "processed"
    elsif vectorizing?
      "vectorizing"
    else
      "processing"
    end
  end

  def processed?
    processed_at? && vectorized_at?
  end

  def vectorizing?
    processed_at? && !vectorized_at?
  end

  def processing?
    !processed? && !vectorizing?
  end
end
