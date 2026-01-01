-- SQL Server test data setup script
-- Creates EADV tables and sample data for validation testing

-- Drop existing table if it exists
IF OBJECT_ID('dbo.EADV', 'U') IS NOT NULL
    DROP TABLE dbo.EADV;
GO

-- Create EADV table
CREATE TABLE EADV (
    eid INT NOT NULL,
    att VARCHAR(100) NOT NULL,
    dt DATETIME NOT NULL,
    val VARCHAR(1000),
    PRIMARY KEY (eid, att, dt)
);
GO

-- Insert test data for patient 1
-- Lab results with various values for testing aggregation
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', '2024-01-01', '50');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', '2024-01-02', '75');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', '2024-01-03', '100');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', '2024-01-04', '125');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', '2024-01-05', '150');

-- Vital signs for exists testing
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'vital_sign', '2024-01-01', '120');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'vital_sign', '2024-01-02', '118');

-- Insert test data for patient 2
INSERT INTO EADV (eid, att, dt, val) VALUES (2, 'lab_result', '2024-01-01', '30');
INSERT INTO EADV (eid, att, dt, val) VALUES (2, 'lab_result', '2024-01-02', '40');
INSERT INTO EADV (eid, att, dt, val) VALUES (2, 'lab_result', '2024-01-03', '60');

-- Insert test data for patient 3 (no data)
-- This patient has no records to test exists() = 0

-- Insert test data for patient 4
INSERT INTO EADV (eid, att, dt, val) VALUES (4, 'lab_result', '2024-01-01', '200');
INSERT INTO EADV (eid, att, dt, val) VALUES (4, 'lab_result', '2024-01-02', '200');
INSERT INTO EADV (eid, att, dt, val) VALUES (4, 'lab_result', '2024-01-03', '200');
GO

-- Verify data
SELECT COUNT(*) as total_records FROM EADV;
SELECT eid, COUNT(*) as record_count FROM EADV GROUP BY eid ORDER BY eid;
GO
