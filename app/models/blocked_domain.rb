class BlockedDomain < ApplicationRecord
  belongs_to :team

  def self.domain_from_email(email)
    address = Mail::Address.new
    address.address = email
    address.domain
  end

  def self.blocked?(email)
    where(domain: domain_from_email(email)).any?
  end

  def block_matching_customers!
    team.customers
      .where("email LIKE :matcher", { matcher: "%#{domain}" })
      .update_all(blocked: true)
  end

  def unblock_matching_customers!
    team.customers
      .where("email LIKE :matcher", { matcher: "%#{domain}" })
      .update_all(blocked: false)
  end
end
