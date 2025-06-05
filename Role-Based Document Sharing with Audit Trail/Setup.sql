-- 1. Users table (linked to auth.users)
CREATE TABLE users (
  id uuid PRIMARY KEY,  -- Must match auth.users.id
  email TEXT NOT NULL
);

-- 2. Documents table
CREATE TABLE documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT,
  created_by uuid REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Document access table (who can access what, and with what role)
CREATE TABLE document_access (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id uuid REFERENCES documents(id),
  user_id uuid REFERENCES users(id),
  access_role TEXT CHECK (access_role IN ('admin', 'editor', 'viewer')),
  granted_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Document views table (for audit trail)
CREATE TABLE document_views (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id uuid REFERENCES documents(id),
  viewed_by uuid REFERENCES users(id),
  viewed_at TIMESTAMPTZ DEFAULT now()
);

-- Instert auth ids
INSERT INTO users (id, email) VALUES
  ('1b4a2beb-ff08-4037-a684-0238472b6a45', 'tom.cruise@test.org'),
  ('9b178e36-3345-44be-8af6-94ce21606043', 'simon.pegg@test.org');

-- Toggle RLS
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- RLS policy
CREATE POLICY "Users with access can read document"
  ON documents
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM document_access
      WHERE document_access.document_id = documents.id
      AND document_access.user_id = auth.uid()
    )
  );


-- Login simulation (local)
SET LOCAL ROLE postgres;
SET SESSION "request.jwt.claim.sub" = '1b4a2beb-ff08-4037-a684-0238472b6a45';
SET SESSION "request.jwt.claim.sub" = '9b178e36-3345-44be-8af6-94ce21606043';
SELECT id, title FROM documents;