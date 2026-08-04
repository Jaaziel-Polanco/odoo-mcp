---
name: support
description: Handle customer support tickets, SLAs, and field-service interventions. Use for helpdesk, tickets, support, SLAs, or on-site service jobs.
triggers: [support, helpdesk, ticket, sla, field service, fsm, service, customer issue]
odoo_modules_any: [helpdesk, industry_fsm]
---

# Support

Inbound customer issues and scheduled on-site work.

## Key models

- `helpdesk.ticket` — customer issue (stage, priority, SLA, team)
- `helpdesk.team` — support team with its own stages and SLAs
- `helpdesk.stage` — kanban stage per team
- `helpdesk.sla` — SLA policy (priority + tag → target time)
- `project.task` (with `is_fsm = True`) — field service task/visit
- `mail.template` — canned responses

## Typical workflows

1. **Triage** — assign `team_id`, set `priority`, tag, pick `user_id`
2. **Respond** — send via `message_post` using a `mail.template`
3. **Escalate** — move stage or reassign team; SLA clock may restart
4. **Resolve** — move to "Done" stage (`fold = True`), SLA closes
5. **Field service** — dispatch via `project.task` with worksheet and signature capture

## Gotchas

- SLA targets are measured from ticket creation, not from stage change — unless policy says otherwise.
- Email-to-ticket creates via `mail.alias`; parsing fails silently — check `mail.alias.mc_alias_id` if tickets don't appear.
- Helpdesk stages are per-team; moving a ticket across teams needs a compatible stage on the destination.
- Field service worksheets are Studio-like custom models — structure varies per tenant.
