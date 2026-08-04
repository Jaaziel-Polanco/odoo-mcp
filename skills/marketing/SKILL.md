---
name: marketing
description: Run campaigns — mass mailings, marketing automation, events, and lead generation tracking. Use for marketing, campaigns, mailings, email blasts, events, or UTM tracking.
triggers: [marketing, campaign, mailing, email blast, newsletter, event, utm, lead gen, automation flow]
odoo_modules_any: [mass_mailing, marketing_automation, event]
---

# Marketing

Reach audiences, measure response, feed qualified leads into `selling`.

## Key models

- `mailing.mailing` — one email or SMS blast
- `mailing.list` — audience list of contacts
- `mailing.contact` — contact on a list (not the same as `res.partner`)
- `mailing.trace` — per-recipient delivery/open/click record
- `marketing.automation` — multi-step automation campaign
- `event.event` — event with registrations
- `event.registration` — attendee
- `utm.campaign` / `utm.source` / `utm.medium` — attribution triple

## Typical workflows

1. **Build audience** — `mailing.list` + `mailing.contact`, or use domain on `res.partner`
2. **Send blast** — `mailing.mailing` in draft → test → send → track via `mailing.trace`
3. **Multi-step flow** — `marketing.automation` with activities (send, wait, condition, create lead)
4. **Run event** — `event.event` with ticket types, manage `event.registration`, post-event follow-up
5. **Attribute** — `utm.campaign` on inbound lead/form maps to the campaign that generated it

## Gotchas

- `mailing.contact` is a separate model from `res.partner` — cross-sync with `mailing.contact.subscription`.
- Opens/clicks via pixel/link tracking; blocked by privacy tools, so numbers skew low.
- Unsubscribe is tracked on `mailing.contact` per list — a user can opt out of one list, not all.
- `utm.*` values are created on-the-fly when unknown — check for duplicates via `lookup` before creating.
