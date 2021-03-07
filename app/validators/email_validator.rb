class EmailValidator < ActiveModel::EachValidator
  VALID_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  def validate_each(record, attribute, value)
    unless value =~ VALID_REGEX
      record.errors.add(attribute, (options[:message] || "is not a valid email address"))
    end
  end
end
