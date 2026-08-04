---
name: configuring
description: Add custom fields, adjust views/forms, and customize models without writing a module (Studio-style changes). Use when the user wants to add a field, change a form layout, or customize a view.
triggers: [configure, configuration, studio, customize, aanpassen, field, veld, view, form, layout]
---

# Configuring

Adapt Odoo to the tenant's shape without a code deploy.

## Key models

- `ir.model` — all models (including custom ones prefixed `x_`)
- `ir.model.fields` — all fields; custom ones prefixed `x_`
- `ir.ui.view` — XML view definitions (form, tree, kanban, search)
- `ir.ui.menu` — menu entries
- `ir.actions.act_window` — window actions
- `ir.model.data` — external IDs (the `__import__.*` and `module.record` pointers)

## Typical workflows

1. **Add custom field** — create `ir.model.fields` record (`name = 'x_your_field'`, `ttype`, `state = 'manual'`)
2. **Show it in a form** — either inherit view XML (`ir.ui.view` with `inherit_id`) or use Studio's GUI
3. **Computed custom field** — set `compute` code on the field; test carefully, no module hot-reload needed
4. **Custom model** — create `ir.model` with `state = 'manual'`, then add fields

## Gotchas

- Field name MUST start with `x_` for manual/Studio-created fields.
- Don't modify core `ir.ui.view` records directly — always inherit. Otherwise next upgrade overwrites.
- Custom fields created at runtime don't survive a module reinstall that drops their table.
- Studio changes are stored as XML in `ir.ui.view` — diff them like regular code before deploy.
- `noupdate = True` on `ir.model.data` means it won't be overwritten by module updates.
