require "rails_helper"

RSpec.describe HappiMail::FromParser, type: :model do
  it "works for normal from field" do
    record = create_inbound_email_from_mail do |mail|
      mail.to "ACME Corp <support@acme.com>"
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
      mail.to "ACME Corp <support@acme.com>"
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
      mail.to "ACME <support@acme.com>"
      mail.from "groups@google.com"
      mail.subject "Come down to the Shire!"
      mail.header["X-Original-From"] = "Staff <staff@acme.com>"
      mail.text_part do |part|
        part.body "Please join us for a party at Bag End"
      end
    end

    parser = HappiMail::FromParser.new(record.mail)

    expect(parser.email_address).to eq("staff@acme.com")
    expect(parser.name).to eq("Staff")
  end

  it "gives preference to Reply-To" do
    record = create_inbound_email_from_fixture("netlify_form_email", status: :processing)

    parser = HappiMail::FromParser.new(record.mail)

    expect(parser.email_address).to eq("robertsonfreddie7@gmail.com")
    expect(parser.name).to eq("Freddie Robertson")
  end

  it "works for happi messages" do
    record = create_inbound_email_from_fixture("email_from_happi", status: :processing)

    parser = HappiMail::FromParser.new(record.mail)

    expect(parser.email_address).to eq("happi@prioritysupport.net")
    expect(parser.name).to eq("Pete Hawkins")
  end
end
