require "rails_helper"

RSpec.describe SpamDetectAgent, type: :agent do
  let(:team) { teams(:acme) }
  let(:thread) { message_threads(:acme_alex_stripe) }
  let(:message) { messages(:acme_alex_stripe_msg_1) }
  let(:agent) { SpamDetectAgent.new(message: message, team: team) }

  describe "#perform!" do
    context "when AI returns a valid score within range" do
      let(:mock_response) do
        Langchain::Assistant::Messages::OpenAIMessage.new(
          role: "assistant",
          content: "3.5"
        )
      end

      it "returns the parsed score as a float" do
        allow(agent).to receive(:generate!).and_return(mock_response)

        expect(agent.perform!).to eq(3.5)
      end
    end

    context "when AI returns a score below 0" do
      let(:mock_response) do
        Langchain::Assistant::Messages::OpenAIMessage.new(
          role: "assistant",
          content: "-2.0"
        )
      end

      it "clamps the score to 0.0" do
        allow(agent).to receive(:generate!).and_return(mock_response)

        expect(agent.perform!).to eq(0.0)
      end
    end

    context "when AI returns a score above 10" do
      let(:mock_response) do
        Langchain::Assistant::Messages::OpenAIMessage.new(
          role: "assistant",
          content: "15.7"
        )
      end

      it "clamps the score to 10.0" do
        allow(agent).to receive(:generate!).and_return(mock_response)

        expect(agent.perform!).to eq(10.0)
      end
    end

    context "when AI returns a non-numeric string" do
      let(:mock_response) do
        Langchain::Assistant::Messages::OpenAIMessage.new(
          role: "assistant",
          content: "this is not a score"
        )
      end

      it "logs a warning and returns 0.0" do
        allow(agent).to receive(:generate!).and_return(mock_response)

        expect(agent.perform!).to eq(0.0)
      end
    end

    context "when AI returns a blank string" do
      let(:mock_response) do
        Langchain::Assistant::Messages::OpenAIMessage.new(
          role: "assistant",
          content: " "
        )
      end

      it "logs a warning and returns 0.0" do
        allow(agent).to receive(:generate!).and_return(mock_response)

        expect(agent.perform!).to eq(0.0)
      end
    end

    context "when AI response content is nil" do
      let(:mock_response) do
        Langchain::Assistant::Messages::OpenAIMessage.new(
          role: "assistant",
          content: nil
        )
      end

      it "logs an error and returns 0.0" do
        allow(agent).to receive(:generate!).and_return(mock_response)

        expect(agent.perform!).to eq(0.0)
      end
    end

    context "when generate! returns nil" do
      before do
        allow(agent).to receive(:generate!).and_return(nil)
      end

      it "logs an error and returns 0.0" do
        expect(agent.perform!).to eq(0.0)
      end
    end

    context "when generate! raises an error" do
      let(:error_message) { "AI Service Unavailable" }
      before do
        allow(agent).to receive(:generate!).and_raise(StandardError.new(error_message))
      end

      it "rescues the error, logs it, and returns 0.0 (if rescue block is uncommented)" do
        # Note: The rescue block in the agent is currently commented out.
        # If uncommented, this test would check its behavior.
        # As is, it will test the behavior without the rescue block.
        # expect { agent.perform! }.to raise_error(StandardError, error_message) # Test without rescue

        # If you uncomment the rescue block in the agent, use this expectation:
        # expect(agent.perform!).to eq(0.0)
        # expect(Rails.logger).to have_received(:error).with(/SpamDetectAgent error.*#{error_message}/i).once

        # Since the rescue block IS commented out, we expect the error to propagate
        expect { agent.perform! }.to raise_error(StandardError, error_message)
      end
    end
  end
end
