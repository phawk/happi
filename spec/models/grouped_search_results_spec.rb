require "rails_helper"

RSpec.describe GroupedSearchResults, type: :model do
  it "groups by message thread" do
    messages = Message.with_rich_text_content.includes(:message_thread).all
    threads = described_class.new(messages).grouped
    expect(threads.size).to eq(2)
  end
end
