# supabase-support-lab
Simulated support debugger using Supabase RLS and PostgreSQL

# 🧪 Supabase Multi-Tenant Support Debugger

This project simulates a real-world customer support escalation in a multi-tenant SaaS environment using **PostgreSQL**, **Row Level Security (RLS)**, and **Supabase Auth**.

---

## 🔧 Use Case

> A support agent receives a report from a customer:  
> “I can’t see my own support ticket after submitting it.”

This lab walks through:
- Schema setup for tenants, users, and tickets
- Row-level access control based on tenant association
- Debugging a ticket visibility issue caused by a broken data reference
- Step-by-step SQL testing with session simulation

---

## 🗂️ Tables & Relationships

- `tenants`: Represents customer organizations
- `users`: Mirrors `auth.users` and links each user to a tenant
- `tickets`: Support tickets created by users, tied to tenants

```mermaid
erDiagram
    tenants ||--o{ users : has
    tenants ||--o{ tickets : has
    users ||--o{ tickets : creates
