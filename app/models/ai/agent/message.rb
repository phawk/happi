module Ai
  module Agent
    class Message
      attr_reader :role, :content, :tool_calls, :tool_call_id

      def initialize(role:, content:, tool_calls: [], tool_call_id: nil)
        @role = role
        @content = content
        @tool_calls = tool_calls
        @tool_call_id = tool_call_id
      end
    end
  end
end
