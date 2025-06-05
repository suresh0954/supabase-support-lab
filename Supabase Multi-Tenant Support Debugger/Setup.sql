-- 1. Tenants table
CREATE TABLE tenants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL
);

-- 2. Users table (link to auth)
CREATE TABLE users (
  id uuid PRIMARY KEY,  -- matches auth.users.id
  email TEXT,
  tenant_id uuid REFERENCES tenants(id)
);

-- 3. Tickets table
CREATE TABLE tickets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  created_by uuid REFERENCES users(id),
  tenant_id uuid REFERENCES tenants(id)
);

-- Data insert -> Tenants table
INSERT INTO tenants (id, name) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Tom Cruise'),
  ('00000000-0000-0000-0000-000000000002', 'Simon Pegg');


-- Insert auth.id to Users table
INSERT INTO users (id, email, tenant_id) VALUES
  ('9a9d3ad0-2826-4d46-bc28-f26ecf271f97', 'tom.cruise@test.org', '00000000-0000-0000-0000-000000000001'),
  ('9a28bd98-04d0-4bb7-95c5-28d62376fd75', 'simon.pegg@test.org', '00000000-0000-0000-0000-000000000002');


-- Tom's ticket data
INSERT INTO tickets (title, description, created_by, tenant_id)
VALUES (
  'Login Issue',
  'User cannot access dashboard after login.',
  '9a28bd98-04d0-4bb7-95c5-28d62376fd75',
  '00000000-0000-0000-0000-000000000001'
);

-- Simon's ticket data
INSERT INTO tickets (title, description, created_by, tenant_id)
VALUES (
  'Report Bug',
  'Monthly usage report fails to load for tenant admin.',
  '9a9d3ad0-2826-4d46-bc28-f26ecf271f97',
  '00000000-0000-0000-0000-000000000002'
);

-- RLS for tickets table
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;

-- RLS policy for tickets
CREATE POLICY "Users can read tickets from their own tenant"
  ON tickets
  FOR SELECT
  USING (
    auth.uid() IN (
      SELECT id FROM users
      WHERE users.tenant_id = tickets.tenant_id
    )
  );

-- Login simulation (local)
SET LOCAL ROLE postgres;
SET SESSION "request.jwt.claim.sub" = '9a28bd98-04d0-4bb7-95c5-28d62376fd75';

SET LOCAL ROLE postgres;
SET SESSION "request.jwt.claim.sub" = '9a9d3ad0-2826-4d46-bc28-f26ecf271f97';

SELECT * FROM tickets;