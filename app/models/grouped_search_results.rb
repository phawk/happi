class GroupedSearchResults
  attr_reader :messages

  def initialize(messages)
    @messages = messages
  end

  def grouped
    results = []

    messages.each do |message|
      if (existing = results.find { |row| row.thread == message.message_thread })
        existing.messages << message
      else
        results << MessageSearchResult.new(message.message_thread, [message])
      end
    end

    results
  end

  class MessageSearchResult < Struct.new(:thread, :messages)
  end
end
