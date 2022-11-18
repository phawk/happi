class BlockedDomainsController < ApplicationController
  def create
    customer = current_team.customers.find_by!(email: params[:email])
    blocked_domain = current_team.blocked_domains.where(
      domain: BlockedDomain.domain_from_email(customer.email)
    ).first_or_initialize

    blocked_domain.save!
    blocked_domain.block_matching_customers!

    redirect_to customer
  end

  def destroy
    blocked_domain = current_team.blocked_domains.find(params[:id])
    blocked_domain.unblock_matching_customers!
    blocked_domain.destroy
    redirect_to blocked_domains_settings_path
  end
end
