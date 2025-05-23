class Embedding < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :object, polymorphic: true

  validates :vectors, presence: true
  validates :content, presence: true

  class << self
    def similarity_search(content:, team:, object_type: nil, limit: 10)
      vectors = Ai::EmbeddingService.embed(content)

      base_scope = if object_type.present?
        where(team:, object_type:)
      else
        where(team:)
      end

      base_scope.order(Arel.sql("embeddings.vectors <-> ARRAY[#{vectors.join(',')}]::vector")).limit(limit)
    end
  end

  def to_search_result
    {
      id:,
      object_type:,
      object_id:,
      content:,
      created_at:,
      updated_at:
    }
  end
end
