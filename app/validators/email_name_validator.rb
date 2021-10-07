class EmailNameValidator < ActiveModel::EachValidator
  VALID_REGEX = /\A([a-z0-9-_\.]+)\z/i
  def validate_each(record, attribute, value)
    unless value =~ VALID_REGEX
      record.errors.add(attribute, (options[:message] || "is not a valid email address"))
    end
  end
end
