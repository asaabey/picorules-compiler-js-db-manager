-- Oracle test data setup script
-- Creates EADV tables and sample data for validation testing

-- Drop existing tables if they exist
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE EADV';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

-- Create EADV table
CREATE TABLE EADV (
    eid NUMBER NOT NULL,
    att VARCHAR2(100) NOT NULL,
    dt DATE NOT NULL,
    val VARCHAR2(1000),
    PRIMARY KEY (eid, att, dt)
);

-- Insert test data for patient 1
-- Lab results with various values for testing aggregation
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', DATE '2024-01-01', '50');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', DATE '2024-01-02', '75');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', DATE '2024-01-03', '100');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', DATE '2024-01-04', '125');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'lab_result', DATE '2024-01-05', '150');

-- Vital signs for exists testing
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'vital_sign', DATE '2024-01-01', '120');
INSERT INTO EADV (eid, att, dt, val) VALUES (1, 'vital_sign', DATE '2024-01-02', '118');

-- Insert test data for patient 2
INSERT INTO EADV (eid, att, dt, val) VALUES (2, 'lab_result', DATE '2024-01-01', '30');
INSERT INTO EADV (eid, att, dt, val) VALUES (2, 'lab_result', DATE '2024-01-02', '40');
INSERT INTO EADV (eid, att, dt, val) VALUES (2, 'lab_result', DATE '2024-01-03', '60');

-- Insert test data for patient 3 (no data)
-- This patient has no records to test exists() = 0

-- Insert test data for patient 4
INSERT INTO EADV (eid, att, dt, val) VALUES (4, 'lab_result', DATE '2024-01-01', '200');
INSERT INTO EADV (eid, att, dt, val) VALUES (4, 'lab_result', DATE '2024-01-02', '200');
INSERT INTO EADV (eid, att, dt, val) VALUES (4, 'lab_result', DATE '2024-01-03', '200');

COMMIT;

-- Verify data
SELECT COUNT(*) as total_records FROM EADV;
SELECT eid, COUNT(*) as record_count FROM EADV GROUP BY eid ORDER BY eid;
