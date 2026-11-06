# Servas Travel & Peace API

A Rails API for [Servas](https://servas.org): joining as a member, interviews, and (later) hosts, travellers and stay requests. It is the one backend behind every screen: the volunteers' web app and, later, a members' mobile app.

## Why this project

Akif is an engineer who wants to understand the basics, and every bit and piece, of how a well-built Rails API works. He uses Raspberry Pi's [editor-api](https://github.com/RaspberryPiFoundation/editor-api) as a guide while building his dream travel application API, learning along the way and improving his skills.

The goal is a reliable, well-tested, open-source travel application API.

## The first problem it solves

Today, arranging a membership interview takes many emails and WhatsApp messages. The pilot flow replaces them:

1. An amiko (a person who has joined but is not yet a member) **applies** for a region
2. They see the free interview times of that region's interviewers and **book** one
3. Everyone gets **automatic emails** (time, video link, calendar file, reminders)
4. The interviewer records the **result**, and the membership secretary is told
## Status

| Step | Status |
|---|---|
| Countries, regions, roles and permissions | done |
| Members, `GET /api/me`, real login (Kratos + Hydra) | done |
| Apply for membership (`POST /api/me/membership_application`) | done |
| Cancel an application (`PUT /api/me/membership_application/cancel`) | done |
| Delete my data (`DELETE /api/me`, GDPR) | done |
| Interviewer free slots, booking, automatic emails, results | planned |
| Hosts, stay requests, messaging, mobile app | later |

## How it works

- **Login:** Ory Kratos (who you are) and Ory Hydra (OAuth2 tokens). Apps are public OAuth clients using authorization code + PKCE. The API checks each token with Hydra and identifies a person by the token's `sub`, never by email.
- **Permissions:** one `Ability` class with CanCanCan. Nobody sends a status: people press actions (apply, cancel, book) and the API moves the status itself.
- **Business logic:** operation classes in `lib/concepts`, for example `MembershipApplication::Create` and `MembershipApplication::Cancel`.
- **Errors:** not found is handled in the controller (404), user mistakes come back from the operation (422), and anything unexpected is reported through `Rails.error` to Sentry.
## Stack

Ruby 3.4, Rails 8.1, SQLite, CanCanCan, RSpec, FactoryBot, rspec-openapi (API docs), RuboCop, Sentry, dotenv-rails.

## Run it locally

You need Ruby 3.4 and Docker.

```bash
bundle install
cp .env.example .env        # fill in the values
bin/rails db:setup
bin/rails server -p 3001
```

Start the login services (Kratos and Hydra) with Docker. Start Kratos with **both** compose files, or login fails:

```bash
docker compose -f quickstart.yml -f quickstart-passkey.yml up -d
```

| Port | Service |
|---|---|
| 3001 | this API |
| 4433 / 4434 | Kratos (public / admin) |
| 4444 / 4445 | Hydra (public / admin) |
| 4455 | login pages |
| 4436 | test inbox (login codes) |
| 5173 | web app (separate project) |

## Tests

```bash
bundle exec rspec
bin/rubocop
```

Tests never call real Hydra: they stub it with `stub_authenticated_user(sub: "...")`, so no Docker is needed.

## API docs

The docs are generated from the request specs. Run the **whole** suite to update them, never a single file, or other endpoints drop out:

```bash
OPENAPI=1 bundle exec rspec
```

Open the docs at `localhost`, not `127.0.0.1` (CORS).

## Guides and thanks

- [editor-api](https://github.com/RaspberryPiFoundation/editor-api) (Raspberry Pi Foundation): the main guide for structure, tests and permissions
- [Fizzy](https://github.com/basecamp/fizzy) (37signals): clean, readable Rails style
- [Ory Hydra](https://github.com/ory/hydra) and Kratos: login
## License

To be decided before the first public release.
 