require "rails_helper"

RSpec.describe MailBodyParser, type: :model do
  it "works for multipart emails" do
    mail = create_inbound_email_from_mail do |mail|
      mail.to "David Heinemeier Hansson <david@loudthinking.com>"
      mail.from "Bilbo Baggins <bilbo@bagend.com>"
      mail.subject "Come down to the Shire!"

      mail.text_part do |part|
        part.body "Please join us for a party at Bag End"
      end

      mail.html_part do |part|
        part.body "<h1>Please join us for a party at Bag End</h1>"
      end
    end

    expect(MailBodyParser.new(mail.mail).content).to include("Please join us for a party at Bag End")
  end

  it "works for plain text emails" do
    mail = create_inbound_email_from_mail do |mail|
      mail.to "David Heinemeier Hansson <david@loudthinking.com>"
      mail.from "Bilbo Baggins <bilbo@bagend.com>"
      mail.subject "Come down to the Shire!"

      mail.body = <<~BODY
        What's the story?
      BODY
    end

    expect(MailBodyParser.new(mail.mail).content).to include("What's the story?")
  end

  it "parses out plain text replies" do
    mail = create_inbound_email_from_mail do |mail|
      mail.to "David Heinemeier Hansson <david@loudthinking.com>"
      mail.from "Bilbo Baggins <bilbo@bagend.com>"
      mail.subject "Come down to the Shire!"

      mail.body = <<~BODY
        What's the story?

        On 15th March Happi wrote:

        > Good to see you
      BODY
    end

    expect(MailBodyParser.new(mail.mail).content).to eq("What's the story?")
  end

  it "works for HTML only emails" do
    mail = create_inbound_email_from_mail do |mail|
      mail.to "David Heinemeier Hansson <david@loudthinking.com>"
      mail.from "Bilbo Baggins <bilbo@bagend.com>"
      mail.subject "Come down to the Shire!"

      mail.html_part do |part|
        part.body "<h1>Please join us for a party at Bag End</h1>"
      end
    end

    expect(MailBodyParser.new(mail.mail).content).to include("Please join us for a party at Bag End")
  end
end
