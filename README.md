# Happi.team

Happi is a fresh take on customer support. Our application code is open source, available under the ... license. Follow the steps below to set up Happi on your own machine.

## Development

### Stripe webhooks locally

Install the stripe cli and run `stripe login` first.

```sh
$ stripe listen --forward-to localhost:3000/events/stripe --events customer.subscription.updated,customer.subscription.deleted
```

After listening for webhooks, add the signing secret to the array in `config/initializers/stripe.rb`.

## Testing

```sh
# Run rubocop for style violations
bin/rubocop
# Run specs
bin/rspec
# Run specs and generate code coverage report
COVERAGE=1 bundle exec rspec
```

## Deployments

Happi is hosted on Heroku and uses Heroku Postgres as the primary data store. Deploys happen automatically when you push to the `main` branch.

## Copyright

Copyright (C) 2021 Darkforce Ltd (UK Company number NI682036)

## License

Happi is open-source under the GNU Affero General Public License Version 3 (AGPLv3) or any later version. You can [find it here](./LICENSE).

An exception to this, is our [support widget](https://github.com/phawk/happi-widget) which you can embed on your website. To avoid issues with AGPL, the widget is released under the MIT license.
