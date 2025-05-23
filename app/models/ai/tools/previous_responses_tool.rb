class Ai::Tools::PreviousResponsesTool < Ai::Tools::BaseTool
  define_function :search, description: "Search the previous responses for relevant information to give you more context and see how similar messages have been answered before." do
    property :query, type: "string", description: "The query to search for", required: true
    property :limit, type: "integer", description: "The number of results to return", required: false
  end

  def search(query:, limit: 10)
    start_timer!

    embeddings = Embedding.similarity_search(content: query, object_type: "ReplyStatistic", team: team)
    results = embeddings.map(&:to_search_result)

    json_response(data: results)
  end
end
