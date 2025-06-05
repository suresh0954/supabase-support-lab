# 🔐 Supabase Lab: Role-Based Document Sharing with Audit Trail

This lab simulates a document-sharing platform with **role-based access control (RBAC)** and an **audit trail** of views. It demonstrates how Supabase Auth + PostgreSQL + RLS can enforce fine-grained security and track user activity.

---

## 📌 Use Case

> Users can create, share, and view documents based on their assigned roles:
> - **Admin**: Full control  
> - **Editor**: Modify content  
> - **Viewer**: Read-only access  

All views are logged for auditability.

---

## 🗂️ Schema Overview

### Tables:
- `users`: Mirrors `auth.users`, stores basic metadata
- `documents`: Created by users
- `document_access`: Many-to-many mapping between users and documents with role-based access
- `document_views`: Logs each access to a document

```mermaid
erDiagram
  users ||--o{ documents : creates
  users ||--o{ document_access : granted_to
  documents ||--o{ document_access : shared_with
  documents ||--o{ document_views : viewed_by
