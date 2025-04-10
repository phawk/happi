require "dry-initializer"
require "dry/monads"

class ApplicationAgent
  DEFAULT_TEMPERATURE = 0.7
  DEFAULT_MODEL = "gpt-4o-mini"

  extend Dry::Initializer
  include Dry::Monads[:result]

  option :team
  option :model, default: -> { DEFAULT_MODEL }

  def generate!(instructions:, messages:)
    assistant = Langchain::Assistant.new(
      llm: llm,
      instructions: instructions,
      tools: custom_tools.values,
      # parallel_tool_calls: parallel_tool_calls,
      # add_message_callback: -> (message) {
      #   # Rails.logger.info("agent:#{name} message callback: #{message.role} - #{message.content}")
      #   task.upsert_message(
      #     role: message.role,
      #     content: message.content,
      #     tool_calls: message.tool_calls,
      #     tool_call_id: message.tool_call_id
      #   )
      # }
    )
    # do |response_chunk|
    #   # ...handle the response stream
    #   if response_chunk.dig("delta", "content").present?
    #     streaming_response << response_chunk.dig("delta", "content")
    #     Rails.logger.info("~" * 60)
    #     Rails.logger.info(streaming_response)
    #     Rails.logger.info("~" * 60)
    #     stream_message.update!(content: streaming_response)
    #   end
    #   # {"index"=>0, "delta"=>{"content"=>" If"}, "logprobs"=>nil, "finish_reason"=>nil}
    #   # finish_reason == "stop" means the assistant has finished running
    #   # print(response_chunk.inspect)
    # end

    messages.each do |message|
      assistant.add_message(
        role: message.role,
        content: message.content,
        tool_calls: message.tool_calls.presence || [],
        tool_call_id: message.tool_call_id
      )
    end

    assistant.run(auto_tool_execution: true)

    assistant.messages.last
  # rescue Faraday::Error => e
    # TODO: Handle errors
  end

  def llm
    @_llm ||= Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      llm_options: { request_timeout: 240 },
      default_options: { temperature: DEFAULT_TEMPERATURE, chat_model: model }
    )
  end

  def custom_tools
    {
      knowledge_base_tool: Ai::Tools::KnowledgeBaseTool.new(agent: self)
    }
  end
end
