# Happi.team

Happi is a fresh take on customer support.

Our core application is open source, as we believe this gives complete transparency and holds us accountable to our use of your data and ensures we act with privacy and security at front of mind.

## Cloud vs. self-hosted

We have a [cloud hosted version of Happi](https://happi.team), which we run and maintain, also, our code is open source, so you are free to download it yourself and self-host Happi on your own servers.

The main difference between the two versions is with the self-hosted version, you have to install it, set it up and manage it on your own servers.

#### Key differences

Feature | Cloud | Self-hosted
--------|-------|------------
Hosting | Everything is simple, we host Happi on our servers and make sure it’s running performantly and reliably for all our customers | You have to install Happi on your own servers, make sure you have configured key components such as Postgres, Redis, Postmark etc.
Data | We keep your data secure and encrypted within the EU. | You need to manage this yourself, however you can choose where to host and store your data.
Support | We provide priority support for all paid plans. | You can open an issue on GitHub, however we don’t have a specific timeframe for when we will get back to you, and we might not be able to help with your issue.
Costs | We charge you a simple monthly fee to allow you to use our hosted service. | There is no fee for using the software, however you will need to pay for servers, databases and email delivery, which adds up!
Upgrades | Happi is always up to date, we deploy fixes, improvements and features multiple times a day. | You need to upgrade Happi yourself, this can be time consuming.

## Overview

Happi is built using the following technologies:
- Ruby on Rails (using ruby v3.0.2)
- PostgreSQL database
- Hotwire/turbo for frontend tech, bundled using esbuild
- TailwindCSS for styling
- Sidekiq (and redis) for background jobs

## Development

```sh
# Install JS dependencies
yarn install
# Copy and set your environment variables
cp .env.sample .env
# Run dev server
bin/dev
```

#### Listening to Stripe webhooks locally

Install the stripe cli and run `stripe login` first.

```sh
stripe listen --forward-to localhost:3000/events/stripe --events customer.subscription.updated,customer.subscription.deleted
```

After listening for webhooks, add the signing secret as `STRIPE_CLI_WEBHOOKS_SECRET` to `./.env` (you will need to restart the development server to pick up this change).

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

An exception to this, is our [Support widget](https://github.com/phawk/happi-widget) which you can embed on your website. To avoid issues with AGPL, the widget is released under the MIT license.
