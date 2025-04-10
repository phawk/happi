class Ai::Tools::BaseTool
  extend Langchain::ToolDefinition

  attr_reader :agent, :team

  def initialize(agent:, team:)
    @agent = agent
    @team = team
  end

  def start_timer!
    @start_time = Time.now
  end

  def task_duration
    @end_time = Time.now
    @end_time - @start_time
  end

  def json_response(content)
    JSON.pretty_generate(content.merge(response_time: task_duration))
  end
end
