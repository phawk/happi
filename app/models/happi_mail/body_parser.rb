module HappiMail
  class BodyParser
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::TextHelper

    attr_accessor :found_text_part, :found_html_part
    attr_reader :mail

    def initialize(mail)
      @mail = mail
    end

    def content
      resp = EmailReplyParser.parse_reply(text_content)
      resp = simple_format(resp) if found_text_part
      resp = clean_html(resp) if found_html_part
      resp
    end

    def text_content
      if mail.multipart?
        parts = mail.parts

        # Multipart emails with attachments have multipart as first part
        parts = parts.first.parts if parts.first.multipart?

        if (text_part = parts.find(&:text?))
          self.found_text_part = true
          text_part.decoded
        else
          parts.first.decoded
        end
      else
        if mail.mime_type == "text/html"
          self.found_html_part = true
        else
          self.found_text_part = true
        end
        mail.decoded
      end
    end

    private

    def clean_html(html)
      sanitize(html).strip
    end
  end
end
