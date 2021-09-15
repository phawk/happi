# Happi.team

This README would normally document whatever steps are necessary to get the
application up and running.

## Development

### Stripe webhooks locally

Install the stripe cli and run `stripe login` first.

```sh
$ stripe listen --forward-to localhost:3000/events/stripe --events customer.subscription.updated,customer.subscription.deleted
```

After listening for webhooks, add the signing secret to the array in `config/initializers/stripe.rb`.

## Deployments

Happi is hosted on Heroku and uses Heroku Postgres as the primary data store. Deploys happen automatically when you push to the `main` branch.
