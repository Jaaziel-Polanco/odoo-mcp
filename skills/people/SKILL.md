---
name: people
description: Manage employees, leave/time off, expenses, and recruitment. Use for HR, employees, medewerkers, verlof, expenses, onkosten, applicants, or onboarding.
triggers: [people, hr, employee, medewerker, leave, verlof, timeoff, expense, onkosten, recruit, werving, applicant, sollicitant, onboarding]
odoo_modules_any: [hr, hr_holidays, hr_expense, hr_recruitment]
---

# People

Employees, their time off, their expenses, and hiring new ones.

## Key models

- `hr.employee` — employee (can exist without a `res.users` login)
- `hr.department` — dept tree (via `parent_id`)
- `hr.job` — job position
- `hr.contract` — employment contract (wage, dates, state)
- `hr.leave` — single leave request
- `hr.leave.allocation` — yearly allowance per leave type
- `hr.leave.type` — leave category (vacation, sick, parental, ...)
- `hr.expense` — single expense line
- `hr.expense.sheet` — expense report (grouping)
- `hr.applicant` — recruitment candidate in a pipeline

## Typical workflows

1. **Onboard** — create `hr.employee`, optional `res.users`, assign `hr.contract`
2. **Leave request** — `hr.leave` draft → confirm → approve → validate
3. **Expense submit** — `hr.expense` → attach to `hr.expense.sheet` → manager approves → accounting posts
4. **Recruit** — `hr.applicant` moves through pipeline stages → hired creates `hr.employee`
5. **Org chart** — walk `hr.employee.parent_id` (manager) tree

## Gotchas

- `hr.employee` without `user_id` exists (e.g. blue-collar workers) — don't assume login.
- Leave allocations must exist *before* leave requests — otherwise balance goes negative silently.
- Expense posting requires analytic + tax setup — check company config before bulk-creating.
- GDPR: employee data includes PII; never expose `private_*` fields in reports.
