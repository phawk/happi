require "rails_helper"

RSpec.describe Team, type: :model do
  let(:team) { teams(:payhere) }

  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to have_many(:customers) }
  it { is_expected.to have_many(:message_threads) }
  it { is_expected.to have_many(:custom_email_addresses) }
  it { is_expected.to have_many(:canned_responses) }

  it { is_expected.to validate_presence_of(:name) }
  it do
    is_expected.to validate_inclusion_of(:plan).in_array(
      BillingPlan::PLANS
    )
  end
  it { is_expected.to validate_inclusion_of(:subscription_status).in_array(Team::SUBSCRIPTION_STATES) }

  describe "#emails_to_send_from" do
    context "if no custom emails exist" do
      before { team.custom_email_addresses.destroy_all }

      it "returns yo@happi.team" do
        expect(team.emails_to_send_from).to eq(["Payhere <yo@happi.team>"])
      end
    end

    context "if custom emails are added and verified" do
      it "includes them" do
        expect(team.emails_to_send_from).to eq(
          [
            "Payhere Support <support@payhere.co>",
            "Payhere <yo@happi.team>"
          ]
        )
      end
    end
  end

  describe "#has_available_seat?" do
    it "returns true when available_seats is greater than team members" do
      expect(team.has_available_seat?).to be(true)
    end

    it "returns false when there are no available seats" do
      team.update!(available_seats: 1)
      expect(team.has_available_seat?).to be(false)
    end
  end

  describe "#messages_limit_reached?" do
    it "returns true when you have used all messages" do
      team.update(messages_limit: 0)
      expect(team.messages_limit_reached?).to be(true)
    end
  end

  describe "#change_plan(plan)" do
    it "sets plan name and limits" do
      individual_plan = BillingPlan.new(name: "individual")
      team.change_plan(individual_plan)
      expect(team.plan).to eq("individual")
      expect(team.available_seats).to eq(1)
      expect(team.messages_limit).to eq(1_000)
      expect(team.subscription_status).to eq("pending")
    end
  end

  describe "#subscription_active?" do
    it "returns true when subscription is trialing, active or past_due" do
      expect(Team.new(subscription_status: "trialing").subscription_active?).to be(true)
      expect(Team.new(subscription_status: "active").subscription_active?).to be(true)
      expect(Team.new(subscription_status: "past_due").subscription_active?).to be(true)
    end

    it "returns false otherwise" do
      expect(Team.new(subscription_status: "pending").subscription_active?).to be(false)
      expect(Team.new(subscription_status: "canceled").subscription_active?).to be(false)
    end
  end

  describe "#can_send_messages?" do
    it "can send messages when verified, has quota and subscription is active" do
      team = Team.new(verified_at: 1.hour.ago, subscription_status: "active", messages_limit: 1_000)
      expect(team.can_send_messages?).to be(true)
    end

    it "cannot send messages when limit reached" do
      team = Team.new(verified_at: 1.hour.ago, subscription_status: "active", messages_limit: 0)
      expect(team.can_send_messages?).to be(false)
    end

    it "cannot send messages when subscription inactive" do
      team = Team.new(verified_at: 1.hour.ago, subscription_status: "canceled")
      expect(team.can_send_messages?).to be(false)
    end

    it "cannot send messages when unverified" do
      team = Team.new
      expect(team.can_send_messages?).to be(false)
    end
  end
end
