require "rails_helper"

RSpec.describe Team, type: :model do
  let(:team) { teams(:acme) }

  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to have_many(:customers) }
  it { is_expected.to have_many(:message_threads) }
  it { is_expected.to have_many(:custom_email_addresses) }
  it { is_expected.to have_many(:canned_responses) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:mail_hash) }
  it { is_expected.to validate_uniqueness_of(:mail_hash) }
  it { is_expected.to allow_value("acme-llc").for(:mail_hash) }
  it { is_expected.to allow_value("acme.llc").for(:mail_hash) }
  it { is_expected.to allow_value("acme_llc").for(:mail_hash) }
  it { is_expected.not_to allow_value("acme llc").for(:mail_hash) }

  it do
    expect(subject).to validate_inclusion_of(:plan).in_array(
      BillingPlan::PLANS
    )
  end

  it { is_expected.to validate_inclusion_of(:subscription_status).in_array(Team::SUBSCRIPTION_STATES) }

  describe "#default_from_address" do
    it "includes company name" do
      expect(team.default_from_address).to eq("ACME Corp <acme@prioritysupport.net>")
    end
  end

  describe "#emails_to_send_from" do
    context "when no custom emails exist" do
      before { team.custom_email_addresses.destroy_all }

      it "returns acme@prioritysupport.net" do
        expect(team.emails_to_send_from).to eq(["ACME Corp <acme@prioritysupport.net>"])
      end
    end

    context "when custom emails are added and verified" do
      it "includes them" do
        expect(team.emails_to_send_from).to eq(
          [
            "ACME Support <support@acme.com>",
            "ACME Corp <acme@prioritysupport.net>",
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

    it "sets subscription trialing if plan is free" do
      free_plan = BillingPlan.new(name: "free")
      team.change_plan(free_plan)
      expect(team.subscription_status).to eq("trialing")
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

  describe "#messages" do
    it "returns the teams messages" do
      expect(team.messages).to match_array([
        messages(:acme_alex_password_reset_msg_1),
        messages(:acme_alex_stripe_msg_1),
        messages(:acme_alex_stripe_msg_2),
      ])
    end
  end

  describe "#messages_sent" do
    it "counts the sent messages" do
      expect(team.messages_sent).to eq(2)
    end
  end
end
