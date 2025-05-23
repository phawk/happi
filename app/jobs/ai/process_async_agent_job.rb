class Ai::ProcessAsyncAgentJob < ApplicationJob
  def perform(agent_class:, **agent_args)
    agent_class.classify.constantize.new(**agent_args).perform!
  end
end
