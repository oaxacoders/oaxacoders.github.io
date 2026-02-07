# Oaxacoders

Community website and event management ecosystem for [Oaxacoders](https://oaxacoders.org) — a programmer community in Oaxaca, Mexico.

## Architecture

```
Jekyll (GitHub Pages)  ←  Eventbrite API (daily sync)
        ↓
   Live website        →  Twitter/X, BlueSky, Telegram, WhatsApp, Email
```

- **Site**: Jekyll static site on GitHub Pages with Tailwind CSS
- **Events**: Auto-synced from Eventbrite via GitHub Actions (daily at 8am UTC)
- **Notifications**: New events are automatically posted to social media and messaging channels
- **Email**: Newsletter drafts created via Buttondown API

## Local Development

```bash
bundle install
bundle exec jekyll serve
# Visit http://localhost:4000
```

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/fetch_eventbrite.rb` | Fetch events from Eventbrite API, generate Jekyll event files |
| `scripts/post_twitter.rb` | Post event announcement to Twitter/X |
| `scripts/post_bluesky.rb` | Post event announcement to BlueSky |
| `scripts/notify_telegram.rb` | Send event announcement to Telegram |
| `scripts/generate_whatsapp_message.rb` | Generate WhatsApp share message |
| `scripts/send_email.rb` | Create email draft in Buttondown |
| `scripts/health_check.rb` | Verify connectivity to all external APIs |

## GitHub Actions Workflows

- **`sync-events.yml`** — Runs daily, fetches events from Eventbrite, comkkkkmits changes, triggers notifications
- **`notify-failures.yml`** — Sends Telegram alert to admin if sync workflow fails

## GitHub Secrets Required

| Secret | Service |
|--------|---------|
| `EVENTBRITE_TOKEN` | Eventbrite API token |
| `EVENTBRITE_ORG_ID` | Eventbrite organization ID |
| `TWITTER_API_KEY` | Twitter/X |
| `TWITTER_API_SECRET` | Twitter/X |
| `TWITTER_ACCESS_TOKEN` | Twitter/X |
| `TWITTER_ACCESS_TOKEN_SECRET` | Twitter/X |
| `BLUESKY_HANDLE` | BlueSky |
| `BLUESKY_PASSWORD` | BlueSky app password |
| `TELEGRAM_BOT_TOKEN` | Telegram bot |
| `TELEGRAM_CHAT_ID` | Telegram channel/group |
| `BUTTONDOWN_API_KEY` | Buttondown email |
| `TELEGRAM_ADMIN_CHAT_ID` | Telegram admin alerts |

## Directory Structure

```
_layouts/          Jekyll layouts (default, event, post)
_includes/         Reusable components (header, footer, event-card, newsletter-form)
_events/           Auto-generated event pages (from Eventbrite)
_posts/            Blog posts
_data/             Data files (eventos.yml auto-populated)
pages/             Static pages (eventos, blog, about)
assets/            Images and CSS
scripts/           Automation scripts (Ruby)
.github/workflows/ GitHub Actions workflows
```
