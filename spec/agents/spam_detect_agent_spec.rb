require "rails_helper"
require "active_agent"

RSpec.describe SpamDetectAgent, type: :agent do
  let(:team) { teams(:acme) }
  let(:thread) { message_threads(:acme_alex_stripe) }
  let(:message) { messages(:acme_alex_stripe_msg_1) }
  let(:agent) { SpamDetectAgent.new }

  # Mock ActionPrompt::Message response structure
  let(:mock_response) { instance_double(ActiveAgent::ActionPrompt::Message) }

  before do
    # Stub generate on the instance, disabling method verification
    # RSpec::Mocks.without_partial_double_verification do
    #   allow(agent).to receive(:generate).with(prompt: { message: message, team: team })
    #                               .and_return(mock_response)
    # end

    # Stub loggers
    allow(Rails.logger).to receive(:error)
    allow(Rails.logger).to receive(:warn)
  end

  describe "#detect" do
    context "when AI returns a valid score within range" do
      it "returns the score as a float" do
        allow(mock_response).to receive(:content).and_return(" 2.5 ")
        expect(agent.detect(message: message, team: team)).to eq(2.5)
      end
    end

    context "when AI returns a score outside the 0-10 range" do
      it "clamps the score to 0 if negative" do
        allow(mock_response).to receive(:content).and_return("-5.0")
        expect(agent.detect(message: message, team: team)).to eq(0.0)
      end

      it "clamps the score to 10 if greater than 10" do
        allow(mock_response).to receive(:content).and_return("15.5")
        expect(agent.detect(message: message, team: team)).to eq(10.0)
      end
    end

    context "when AI returns a non-numeric response" do
      it "returns 0.0 and logs a warning" do
        allow(mock_response).to receive(:content).and_return("This is likely not spam.")
        expect(agent.detect(message: message, team: team)).to eq(0.0)
        expect(Rails.logger).to have_received(:warn).with(/could not parse score/i).once
      end
    end

    context "when AI returns a blank response" do
      it "returns 0.0 and logs an error" do
        allow(mock_response).to receive(:content).and_return("")
        expect(agent.detect(message: message, team: team)).to eq(0.0)
        expect(Rails.logger).to have_received(:error).with(/failed to get score/i).once
      end
    end

    context "when generate call returns nil" do
      it "returns 0.0 and logs an error" do
        # Need to override the stub for this specific case
        RSpec::Mocks.without_partial_double_verification do
          allow(agent).to receive(:generate).with(prompt: { message: message, team: team }).and_return(nil)
        end
        expect(agent.detect(message: message, team: team)).to eq(0.0)
        expect(Rails.logger).to have_received(:error).with(/failed to get score/i).once
      end
    end

    context "when generate call raises an error" do
      it "returns 0.0 and logs the error" do
        # Need to override the stub for this specific case
        RSpec::Mocks.without_partial_double_verification do
          allow(agent).to receive(:generate).with(prompt: { message: message, team: team })
                                  .and_raise(StandardError.new("AI provider down"))
        end
        expect(agent.detect(message: message, team: team)).to eq(0.0)
        expect(Rails.logger).to have_received(:error).with(/SpamDetectAgent error.*AI provider down/i).once
      end
    end
  end
end
