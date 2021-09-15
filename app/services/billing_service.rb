module BillingService
  module_function

  def create_checkout(plan_id:, user:, team:, success_url:, cancel_url:)
    stripe_customer = upsert_stripe_customer(user: user, team: team)

    checkout_session = Stripe::Checkout::Session.create({
      success_url: success_url,
      cancel_url: cancel_url,
      payment_method_types: ["card"],
      line_items: [{ price: plan_id, quantity: 1 }],
      mode: "subscription",
      allow_promotion_codes: true,
      customer: stripe_customer.id,
      client_reference_id: team.id,
      subscription_data: {
        metadata: {
          happi_team_id: team.id,
        },
      }
    })

    checkout_session
  end

  def create_portal_link(user:, team:, return_url:)
    stripe_customer = upsert_stripe_customer(user: user, team: team)

    portal = Stripe::BillingPortal::Session.create({
      customer: stripe_customer.id,
      return_url: return_url,
    })

    portal.url
  end

  def upsert_stripe_customer(user:, team:)
    if team.stripe_customer_id.present?
      begin
        return Stripe::Customer.retrieve(team.stripe_customer_id)
      rescue Stripe::StripeError => e
        # try to load, or fall through to create
      end
    end

    cus = Stripe::Customer.create({
      name: user.name,
      email: user.email,
      metadata: {
        happi_team_id: team.id,
        happi_user_id: user.id,
      }
    })

    team.update(stripe_customer_id: cus.id)

    cus
  end
end
