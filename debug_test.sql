-- Scenario: A User cannot access or view his/her own tickets

-- BE bug removed tenant_id for Simon's ticket

UPDATE tickets
SET tenant_id = NULL          -- Assuming this caused the issue
WHERE title = 'Report Bug'; 

-- Fix - Manually update or restore tenant_id

UPDATE tickets
SET tenant_id = '00000000-0000-0000-0000-000000000002'
WHERE title = 'Report Bug';
