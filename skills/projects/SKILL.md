---
name: projects
description: Work with projects, tasks, milestones, and timesheets. Use when the user mentions projects, tasks, taken, timesheets, uren, milestones, or deliverables.
triggers: [project, projecten, task, taak, timesheet, uren, milestone, deliverable, kanban]
odoo_modules_any: [project, hr_timesheet]
---

# Projects

Organize work, assign tasks, log time, bill (if time-and-materials).

## Key models

- `project.project` — project container (customer, analytic account, team)
- `project.task` — task with stage (kanban), assignee, deadline, dependencies
- `project.task.type` — stage on a project's kanban
- `project.milestone` — deliverable with deadline
- `account.analytic.line` — timesheet entry (one row per hour logged)
- `account.analytic.account` — links project to billing

## Typical workflows

1. **Create project** → set `partner_id` (customer), `analytic_account_id`, stages
2. **Add tasks** → assign `user_ids`, set `date_deadline`, link `depend_on_ids`
3. **Log time** → `account.analytic.line` with `task_id`, `unit_amount` (hours)
4. **Billable T&M** — timesheet line with `so_line` link auto-generates invoice qty
5. **Status digest** — tasks by stage, overdue count, blocked tasks, recent activity

## Gotchas

- `account.analytic.line` is shared between HR timesheets and finance analytic — same model.
- `kanban_state = blocked` ≠ stage; it's a separate flag for "stuck" signal.
- Task → SO link goes via `sale_line_id` on the task (requires `sale_timesheet` module).
- Closing a task doesn't auto-archive; stages with `fold = True` just collapse in kanban.
