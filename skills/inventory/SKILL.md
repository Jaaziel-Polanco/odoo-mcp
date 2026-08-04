---
name: inventory
description: Work with stock levels, transfers, warehouse operations, lots, and serial numbers. Use when the user mentions inventory, stock, voorraad, warehouse, transfers, pickings, lots, or serials.
triggers: [inventory, stock, voorraad, warehouse, magazijn, transfer, picking, lot, serial, barcode]
odoo_modules_any: [stock]
---

# Inventory

Physical goods: where they are, how they move, what's available.

## Key models

- `stock.warehouse` — physical warehouse
- `stock.location` — location inside/outside warehouse (internal, supplier, customer, inventory)
- `stock.quant` — on-hand quantity per product+location+lot (the "truth")
- `stock.move` — intended movement of product from A → B
- `stock.picking` — grouped moves (receipt, delivery, internal transfer)
- `stock.lot` — lot/serial number
- `stock.warehouse.orderpoint` — min/max reorder rule

## Typical workflows

1. **Receipt** — `stock.picking` type `incoming`, confirm → assign → validate → updates `stock.quant`
2. **Delivery** — `stock.picking` type `outgoing`, auto-created from SO
3. **Internal transfer** — between two internal locations
4. **Inventory adjustment** — compare counted qty to `stock.quant.quantity`, post difference
5. **Lot tracking** — enable `tracking = lot/serial` on product, assign lot on receipt

## Gotchas

- `stock.quant` is the source of truth; `stock.move` is the plan. Reconcile via moves with `state = done`.
- Location types matter: `internal` counts toward on-hand, `supplier`/`customer`/`inventory` don't.
- A picking in `assigned` state has reserved stock; `done` has actually moved it.
- Negative quants happen when deliveries outrun receipts — allowed unless you block it.
