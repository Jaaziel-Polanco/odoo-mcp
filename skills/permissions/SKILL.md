---
name: permissions
description: Manage access rights, user groups, record rules, and field-level security. Use for permissions, security, access control, roles, groups, or "who can see/edit what".
triggers: [permissions, security, access, rights, roles, groups, rechten, rollen, groep, record rule]
---

# Permissions

Who can do what, on which records, and which fields.

## Key models

- `res.users` — user account
- `res.groups` — group (a role, e.g. "Sales / User")
- `ir.model.access` — CRUD access per group × model (read/write/create/unlink)
- `ir.rule` — record rule: domain filter per group, restricts which rows they see
- `ir.model.fields` — `groups` field for field-level visibility

## Layers (most permissive wins per layer, but all layers must pass)

1. **Model access** (`ir.model.access`) — can this group touch this model at all?
2. **Record rules** (`ir.rule`) — which rows within that model? (applied as AND for non-global rules)
3. **Field access** — is this specific field visible/editable for this group?

## Typical workflows

1. **Add user to group** — write `groups_id = [(4, group_id)]` on `res.users`
2. **Create a role** — new `res.groups`, add `implied_ids` for inheritance (e.g. Manager implies User)
3. **Restrict records** — `ir.rule` with domain `[('user_id', '=', user.id)]` limits to "own records"
4. **Hide a field** — set `groups` on `ir.model.fields` to restrict visibility
5. **Audit** — list which groups a user belongs to (direct + inherited via `implied_ids`)

## Gotchas

- `sudo()` in server actions **bypasses all rules** — use sparingly, never in user-facing code paths.
- `ir.rule` with `global = True` applies to everyone regardless of groups — rare, use with care.
- Groups inherit via `implied_ids` — user in "Sales Manager" automatically also has "Sales User".
- Per-company rules (`company_ids` on user) are a separate layer — multi-company needs extra care.
- Removing access to a model breaks UI for that group — menu items disappear, actions fail silently.
