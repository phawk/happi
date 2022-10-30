class SiteOption < ApplicationRecord
  def self.get(key)
    find_by(key: key.to_s)&.value
  end

  def self.set(key, value)
    record = find_by(key: key.to_s) || new(key: key.to_s)
    record.value = value
    record.save
  end
end
