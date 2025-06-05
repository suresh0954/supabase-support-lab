-- Login simulation (local)
SET LOCAL ROLE postgres;
SET SESSION "request.jwt.claim.sub" = '1b4a2beb-ff08-4037-a684-0238472b6a45';
SET SESSION "request.jwt.claim.sub" = '9b178e36-3345-44be-8af6-94ce21606043';
SELECT id, title FROM documents;

-- Logging function
CREATE OR REPLACE FUNCTION log_document_view(doc_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO document_views (document_id, viewed_by, viewed_at)
  VALUES (doc_id, auth.uid(), now());
END;
$$;

-- Simulate as Tom
RESET ALL;
SET LOCAL ROLE postgres;
SET SESSION "request.jwt.claim.sub" = '1b4a2beb-ff08-4037-a684-0238472b6a45';

-- Log a view for 'How to Triage Tickets' (replace with real document ID if needed)
SELECT log_document_view('16a174a5-452a-4ffd-a20b-4802a2406e28');
