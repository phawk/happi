require "rails_helper"

RSpec.describe HappiMail::FromParser, type: :model do
  it "works for normal from field" do
    record = create_inbound_email_from_mail do |mail|
      mail.to "Payhere <support@payhere.co>"
      mail.from "Bilbo Baggins <bilbo@bagend.com>"
      mail.subject "Come down to the Shire!"
      mail.text_part do |part|
        part.body "Please join us for a party at Bag End"
      end
    end

    parser = HappiMail::FromParser.new(record.mail)

    expect(parser.email_address).to eq("bilbo@bagend.com")
    expect(parser.name).to eq("Bilbo Baggins")
  end

  it "works when only email is provided" do
    record = create_inbound_email_from_mail do |mail|
      mail.to "Payhere <support@payhere.co>"
      mail.from "bilbo@bagend.com"
      mail.subject "Come down to the Shire!"
      mail.text_part do |part|
        part.body "Please join us for a party at Bag End"
      end
    end

    parser = HappiMail::FromParser.new(record.mail)

    expect(parser.email_address).to eq("bilbo@bagend.com")
    expect(parser.name).to eq("Unknown")
  end

  it "supports X-Original-From" do
    record = create_inbound_email_from_mail do |mail|
      mail.to "Payhere <support@payhere.co>"
      mail.from "groups@google.com"
      mail.subject "Come down to the Shire!"
      mail.header["X-Original-From"] = "Staff <staff@payhere.co>"
      mail.text_part do |part|
        part.body "Please join us for a party at Bag End"
      end
    end

    parser = HappiMail::FromParser.new(record.mail)

    expect(parser.email_address).to eq("staff@payhere.co")
    expect(parser.name).to eq("Staff")
  end

  it "gives preference to Reply-To" do
    record = create_inbound_email_from_mail do |mail|
      mail.to "Payhere <support@payhere.co>"
      mail.from "Staff <staff@payhere.co>"
      mail.subject "Come down to the Shire!"
      mail.header["Reply-To"] = "John <john.smith@payhere.co>"
      mail.text_part do |part|
        part.body "Please join us for a party at Bag End"
      end
    end

    parser = HappiMail::FromParser.new(record.mail)

    expect(parser.email_address).to eq("john.smith@payhere.co")
    expect(parser.name).to eq("John")
  end
end
