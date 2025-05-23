langchain_log_level = case Rails.env
when "development"
  :debug
when "test"
  :error
else
  :info
end
Langchain.logger.level = langchain_log_level
