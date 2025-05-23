class Ai::Tools::KnowledgeBaseTool < Ai::Tools::BaseTool
  define_function :search, description: "Vector Similarity Search the knowledgebase for relevant information to give you more context" do
    property :query, type: "string", description: "The query to search for", required: true
    property :limit, type: "integer", description: "The number of results to return", required: false
  end

  def search(query:, limit: 10)
    start_timer!

    embeddings = Embedding.similarity_search(content: query, object_type: "KnowledgeBase::FileUpload", team: team)
    results = embeddings.map(&:to_search_result)

    json_response(data: results)
  end
end
