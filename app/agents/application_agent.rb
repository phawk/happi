class ApplicationAgent < ActiveAgent::Base
  layout 'agent'
  
  generate_with :openai, model: "gpt-4o-mini", instructions: "You are a helpful assistant."
  
  def text_prompt
    prompt { |format| format.text { render plain: params[:message] } }
  end
end
