-- Drop existing table if it exists
DROP TABLE IF EXISTS SROUT_rrt;
GO

--------------------------------------------------
-- ruleblock:   rrt
--------------------------------------------------

DROP TABLE IF EXISTS SROUT_rrt;

DROP TABLE IF EXISTS #UEADV;

SELECT
    eadv.eid
INTO
    #UEADV
FROM
    eadv
GROUP BY
    eadv.eid
;

DROP TABLE IF EXISTS #SQ_hd_z49_n;

SELECT
    eadv.eid,
    COUNT(dt) AS hd_z49_n
INTO
    #SQ_hd_z49_n
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'icd_z49_1')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_hd_z49_n ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_131_n;

SELECT
    eadv.eid,
    COUNT(dt) AS hd_131_n
INTO
    #SQ_hd_131_n
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'caresys_1310000')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_hd_131_n ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_z49_1y_n;

SELECT
    eadv.eid,
    COUNT(dt) AS hd_z49_1y_n
INTO
    #SQ_hd_z49_1y_n
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'icd_z49_1')
    AND (dt>DATEADD(DAY, -365, GETDATE()))
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_hd_z49_1y_n ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_131_1y_n;

SELECT
    eadv.eid,
    COUNT(dt) AS hd_131_1y_n
INTO
    #SQ_hd_131_1y_n
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'caresys_1310000')
    AND (dt>DATEADD(DAY, -365, GETDATE()))
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_hd_131_1y_n ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_mbs_13105_dt_max;

SELECT
    eadv.eid,
    MAX(dt) AS mbs_13105_dt_max
INTO
    #SQ_mbs_13105_dt_max
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'mbs_13105')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_mbs_13105_dt_max ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_mbs_13105_dt_min;

SELECT
    eadv.eid,
    MIN(dt) AS mbs_13105_dt_min
INTO
    #SQ_mbs_13105_dt_min
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'mbs_13105')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_mbs_13105_dt_min ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_icpc_dt;

SELECT
    eadv.eid,
    MAX(dt) AS hd_icpc_dt
INTO
    #SQ_hd_icpc_dt
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'icpc_u59001' OR ATT = 'icpc_u59008')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_hd_icpc_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_dt;

SELECT
    eadv.eid,
    MAX(dt) AS hd_dt
INTO
    #SQ_hd_dt
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'caresys_1310000' OR ATT = 'icpc_u59001' OR ATT = 'icpc_u59008' OR ATT = 'icd_z49_1' OR ATT = 'mbs_13105')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_hd_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_dt_min;

SELECT
    eadv.eid,
    MIN(dt) AS hd_dt_min
INTO
    #SQ_hd_dt_min
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'caresys_1310000' OR ATT = 'icpc_u59001' OR ATT = 'icpc_u59008' OR ATT = 'icd_z49_1' OR ATT = 'mbs_13105')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_hd_dt_min ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_pd_dt0;

SELECT
    eadv.eid,
    MAX(dt) AS pd_dt0
INTO
    #SQ_pd_dt0
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'caresys_1310006' OR ATT = 'caresys_1310007' OR ATT = 'caresys_1310008' OR ATT = 'icpc_u59007' OR ATT = 'icpc_u59009' OR ATT = 'icd_z49_2')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_pd_dt0 ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_pd_dt_min;

SELECT
    eadv.eid,
    MIN(dt) AS pd_dt_min
INTO
    #SQ_pd_dt_min
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'caresys_1310006' OR ATT = 'caresys_1310007' OR ATT = 'caresys_1310008' OR ATT = 'icpc_u59007' OR ATT = 'icpc_u59009' OR ATT = 'icd_z49_2')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_pd_dt_min ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_pd_ex_dt;

SELECT
    eadv.eid,
    MIN(dt) AS pd_ex_dt
INTO
    #SQ_pd_ex_dt
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'caresys_1311000')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_pd_ex_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_pd_enc_ld;

SELECT
    eadv.eid,
    MAX(dt) AS pd_enc_ld
INTO
    #SQ_pd_enc_ld
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'enc_op_ren_hpd' OR ATT = 'enc_op_rdu_hpd')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_pd_enc_ld ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_pd_dt;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN (SELECT MAX(x) FROM (VALUES (pd_dt0), (pd_enc_ld)) AS T(x) WHERE x IS NOT NULL)
    END AS pd_dt
INTO
    #SQ_pd_dt
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_pd_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_dt_icpc;

SELECT
    eadv.eid,
    MIN(dt) AS tx_dt_icpc
INTO
    #SQ_tx_dt_icpc
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'icpc_u28001')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_tx_dt_icpc ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_dt_icd;

SELECT
    eadv.eid,
    MIN(dt) AS tx_dt_icd
INTO
    #SQ_tx_dt_icd
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'icd_z94_0')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_tx_dt_icd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_dt_icd_last;

SELECT
    eadv.eid,
    MAX(dt) AS tx_dt_icd_last
INTO
    #SQ_tx_dt_icd_last
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'icd_z94_0')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_tx_dt_icd_last ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_dt;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN (SELECT MIN(x) FROM (VALUES (tx_dt_icpc), (tx_dt_icd)) AS T(x) WHERE X IS NOT NULL)
    END AS tx_dt
INTO
    #SQ_tx_dt
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_tx_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_tx_tx2_n;

SELECT
    #UEADV.eid,
    COUNT(dt) AS hd_tx_tx2_n
INTO
    #SQ_hd_tx_tx2_n
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN eadv ON eadv.eid = #UEADV.eid
        AND (ATT = 'icd_z49_1')
        AND (dt between tx_dt_icd and tx_dt )
GROUP BY
    #UEADV.eid
;

ALTER TABLE #SQ_hd_tx_tx2_n ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_tx_tx2_ld;

SELECT
    #UEADV.eid,
    MAX(dt) AS hd_tx_tx2_ld
INTO
    #SQ_hd_tx_tx2_ld
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN eadv ON eadv.eid = #UEADV.eid
        AND (ATT = 'icd_z49_1')
        AND (dt between tx_dt_icd and tx_dt )
GROUP BY
    #UEADV.eid
;

ALTER TABLE #SQ_hd_tx_tx2_ld ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_tx2;

SELECT
    #UEADV.eid,
    COUNT(dt) AS hd_tx2
INTO
    #SQ_hd_tx2
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN eadv ON eadv.eid = #UEADV.eid
        AND (ATT = 'icd_z49_1')
        AND (dt > DATEADD(DAY, 30, tx_dt) )
GROUP BY
    #UEADV.eid
;

ALTER TABLE #SQ_hd_tx2 ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_multi_fd;

SELECT
    #UEADV.eid,
    MIN(dt) AS tx_multi_fd
INTO
    #SQ_tx_multi_fd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN eadv ON eadv.eid = #UEADV.eid
        AND (ATT = 'icd_z94_0')
        AND (dt > hd_tx_tx2_ld )
GROUP BY
    #UEADV.eid
;

ALTER TABLE #SQ_tx_multi_fd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_multi_flag;

SELECT
    #UEADV.eid,
    CASE
        WHEN hd_tx_tx2_n >10
            THEN 1
        ELSE 0
    END AS tx_multi_flag
INTO
    #SQ_tx_multi_flag
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_tx_multi_flag ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_multi_current;

SELECT
    #UEADV.eid,
    CASE
        WHEN tx_multi_flag =1 and coalesce(hd_tx2,0)=0
            THEN 1
        ELSE 0
    END AS tx_multi_current
INTO
    #SQ_tx_multi_current
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_tx_multi_current ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_enc_op_fd;

SELECT
    eadv.eid,
    MIN(dt) AS tx_enc_op_fd
INTO
    #SQ_tx_enc_op_fd
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'enc_op_ren_rnt' OR ATT = 'enc_op_ren_rtc' OR ATT = 'enc_op_ren_rtn' OR ATT = 'enc_op_ren_rcf' OR ATT = 'enc_op_rdu_rnt' OR ATT = 'enc_op_rdu_rtc' OR ATT = 'enc_op_rdu_rtn' OR ATT = 'enc_op_rdu_rcf')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_tx_enc_op_fd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_enc_op_ld;

SELECT
    eadv.eid,
    MAX(dt) AS tx_enc_op_ld
INTO
    #SQ_tx_enc_op_ld
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'enc_op_ren_rnt' OR ATT = 'enc_op_ren_rtc' OR ATT = 'enc_op_ren_rtn' OR ATT = 'enc_op_ren_rcf' OR ATT = 'enc_op_rdu_rnt' OR ATT = 'enc_op_rdu_rtc' OR ATT = 'enc_op_rdu_rtn' OR ATT = 'enc_op_rdu_rcf')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_tx_enc_op_ld ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_enc_active;

SELECT
    #UEADV.eid,
    CASE
        WHEN tx_enc_op_ld > DATEADD(DAY, -365, GETDATE())
            THEN 1
        ELSE 0
    END AS tx_enc_active
INTO
    #SQ_tx_enc_active
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_tx_enc_active ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_coding;

SELECT
    #UEADV.eid,
    CASE
        WHEN tx_dt IS NOT NULL
            THEN 1
        ELSE 0
    END AS tx_coding
INTO
    #SQ_tx_coding
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_tx_coding ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tdm_tac;

SELECT
    eid,
    CAST(val AS VARCHAR(1000)) + '~' + CONVERT(VARCHAR, dt, 23) AS tdm_tac,
    val AS tdm_tac_val,
    dt AS tdm_tac_dt
INTO
    #SQ_tdm_tac
FROM
    (
    SELECT
        eadv.eid,
        val,
        dt,
        ROW_NUMBER()
    OVER
        (
        PARTITION BY
            eadv.eid
        ORDER BY
            dt DESC, att ASC, val ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT = 'lab_bld_tdm_tacrolimus')
        AND (dt > DATEADD(DAY, -365, GETDATE()))
    ) SQ_tdm_tac_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_tdm_tac ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tdm_evl;

SELECT
    eid,
    CAST(val AS VARCHAR(1000)) + '~' + CONVERT(VARCHAR, dt, 23) AS tdm_evl,
    val AS tdm_evl_val,
    dt AS tdm_evl_dt
INTO
    #SQ_tdm_evl
FROM
    (
    SELECT
        eadv.eid,
        val,
        dt,
        ROW_NUMBER()
    OVER
        (
        PARTITION BY
            eadv.eid
        ORDER BY
            dt DESC, att ASC, val ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT = 'lab_bld_tdm_everolimus')
        AND (dt > DATEADD(DAY, -365, GETDATE()))
    ) SQ_tdm_evl_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_tdm_evl ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rx_l04ad;

SELECT
    eid,
    dt AS rx_l04ad
INTO
    #SQ_rx_l04ad
FROM
    (
    SELECT
        eadv.eid,
        dt,
        ROW_NUMBER()
    OVER
        (
        PARTITION BY
            eadv.eid
        ORDER BY
            dt DESC, att ASC, val ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT = 'rxnc_l04ad')
        
    ) SQ_rx_l04ad_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_rx_l04ad ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rx_l04aa;

SELECT
    eid,
    dt AS rx_l04aa
INTO
    #SQ_rx_l04aa
FROM
    (
    SELECT
        eadv.eid,
        dt,
        ROW_NUMBER()
    OVER
        (
        PARTITION BY
            eadv.eid
        ORDER BY
            dt DESC, att ASC, val ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT = 'rxnc_l04aa')
        
    ) SQ_rx_l04aa_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_rx_l04aa ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_cni_mtor_rx;

SELECT
    #UEADV.eid,
    CASE
        WHEN coalesce(rx_l04ad,rx_l04aa) IS NOT NULL
            THEN 1
        ELSE 0
    END AS cni_mtor_rx
INTO
    #SQ_cni_mtor_rx
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_cni_mtor_rx ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_cni_mtor_mon;

SELECT
    #UEADV.eid,
    CASE
        WHEN coalesce(tdm_tac_val,tdm_evl_val) IS NOT NULL
            THEN 1
        ELSE 0
    END AS cni_mtor_mon
INTO
    #SQ_cni_mtor_mon
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_cni_mtor_mon ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_active;

SELECT
    #UEADV.eid,
    CASE
        WHEN tx_dt IS NOT NULL and coalesce(hd_tx2,0)<10
            THEN 1
        ELSE 0
    END AS tx_active
INTO
    #SQ_tx_active
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_tx_active ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_homedx_icpc_ld;

SELECT
    eadv.eid,
    MAX(dt) AS homedx_icpc_ld
INTO
    #SQ_homedx_icpc_ld
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'icpc_u59j99')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_homedx_icpc_ld ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_homedx_enc_ld;

SELECT
    eadv.eid,
    MAX(dt) AS homedx_enc_ld
INTO
    #SQ_homedx_enc_ld
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'enc_op_ren_hdp' OR ATT = 'enc_op_ren_rhd' OR ATT = 'enc_op_rdu_hdp' OR ATT = 'enc_op_rdu_rhd')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_homedx_enc_ld ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_homedx_dt;

SELECT
    #UEADV.eid,
    CASE
        WHEN homedx_enc_ld IS NOT NULL
            THEN homedx_enc_ld
        WHEN homedx_icpc_ld IS NOT NULL
            THEN homedx_icpc_ld
    END AS homedx_dt
INTO
    #SQ_homedx_dt
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_homedx_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_ren_enc;

SELECT
    eadv.eid,
    MAX(dt) AS ren_enc
INTO
    #SQ_ren_enc
FROM
    eadv
WHERE (1=1)
    AND (ATT LIKE 'enc\_op\_%' ESCAPE '\')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_ren_enc ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt;

SELECT
    #UEADV.eid,
    CASE
        WHEN tx_dt IS NOT NULL and tx_dt >= ISNULL((SELECT MAX(x) FROM (VALUES (DATEADD(DAY, -30, hd_dt)), (DATEADD(DAY, -30, pd_dt)), (DATEADD(DAY, -30, homedx_dt))) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE))
            THEN 3
        WHEN tx_dt IS NOT NULL and tx_multi_current=1
            THEN 3
        WHEN tx_active=1
            THEN 3
        WHEN homedx_dt > ISNULL((SELECT MAX(x) FROM (VALUES (DATEADD(DAY, -30, hd_dt)), (pd_dt), (tx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE)) and tx_multi_current=0
            THEN 4
        WHEN pd_dt > ISNULL((SELECT MAX(x) FROM (VALUES (DATEADD(DAY, -30, hd_dt)), (tx_dt), (homedx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE)) and pd_dt>coalesce(pd_ex_dt,CAST('0001-01-01' AS DATE)) and tx_multi_current=0
            THEN 2
        WHEN hd_dt > ISNULL((SELECT MAX(x) FROM (VALUES (pd_dt), (tx_dt), (homedx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE)) and (hd_z49_n>10 or hd_131_n>10 or ISNULL(pd_dt, homedx_dt) IS NOT NULL) and tx_multi_current=0 and tx_active=0
            THEN 1
        WHEN hd_icpc_dt > ISNULL((SELECT MAX(x) FROM (VALUES (pd_dt), (tx_dt), (homedx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE)) and coalesce(hd_dt,mbs_13105_dt_max)>DATEADD(DAY, -90, GETDATE())
            THEN 1
        WHEN mbs_13105_dt_max > ISNULL((SELECT MAX(x) FROM (VALUES (pd_dt), (tx_dt), (homedx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE))
            THEN 1
        ELSE 0
    END AS rrt
INTO
    #SQ_rrt
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_wip_hd_dt;

SELECT
    eadv.eid,
    MAX(dt) AS wip_hd_dt
INTO
    #SQ_wip_hd_dt
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'caresys_1310000' OR ATT = 'icpc_u59001' OR ATT = 'icpc_u59008' OR ATT = 'icd_z49_1' OR ATT = 'mbs_13105')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_wip_hd_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_wip_tx_dt_icpc_ld;

SELECT
    eadv.eid,
    MAX(dt) AS wip_tx_dt_icpc_ld
INTO
    #SQ_wip_tx_dt_icpc_ld
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'icpc_u28001')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_wip_tx_dt_icpc_ld ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_wip_tx_dt_ld;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN (SELECT MAX(x) FROM (VALUES (wip_tx_dt_icpc_ld), (tx_dt_icd)) AS T(x) WHERE x IS NOT NULL)
    END AS wip_tx_dt_ld
INTO
    #SQ_wip_tx_dt_ld
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_wip_tx_dt_ld ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_wip_rrt_wip;

SELECT
    #UEADV.eid,
    CASE
        WHEN tx_dt IS NOT NULL and wip_tx_dt_ld >= ISNULL((SELECT MAX(x) FROM (VALUES (DATEADD(DAY, -30, hd_dt)), (DATEADD(DAY, -30, pd_dt)), (DATEADD(DAY, -30, homedx_dt))) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE))
            THEN 3
        WHEN tx_dt IS NOT NULL and tx_multi_current=1
            THEN 3
        WHEN tx_active=1
            THEN 3
        WHEN homedx_dt > ISNULL((SELECT MAX(x) FROM (VALUES (DATEADD(DAY, -30, hd_dt)), (pd_dt), (tx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE)) and tx_multi_current=0
            THEN 4
        WHEN pd_dt > ISNULL((SELECT MAX(x) FROM (VALUES (DATEADD(DAY, -30, hd_dt)), (tx_dt), (homedx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE)) and pd_dt>coalesce(pd_ex_dt,CAST('0001-01-01' AS DATE)) and tx_multi_current=0
            THEN 2
        WHEN hd_dt > ISNULL((SELECT MAX(x) FROM (VALUES (pd_dt), (tx_dt), (homedx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE)) and (hd_z49_n>10 or hd_131_n>10 or ISNULL(pd_dt, homedx_dt) IS NOT NULL) and tx_multi_current=0 and tx_active=0
            THEN 1
        WHEN hd_icpc_dt > ISNULL((SELECT MAX(x) FROM (VALUES (pd_dt), (tx_dt), (homedx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE)) and coalesce(hd_dt,mbs_13105_dt_max)>DATEADD(DAY, -90, GETDATE())
            THEN 1
        WHEN mbs_13105_dt_max > ISNULL((SELECT MAX(x) FROM (VALUES (pd_dt), (tx_dt), (homedx_dt)) AS T(x) WHERE x IS NOT NULL),CAST('0001-01-01' AS DATE))
            THEN 1
        ELSE 0
    END AS wip_rrt_wip
INTO
    #SQ_wip_rrt_wip
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_wip_rrt_wip ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_assert_level;

SELECT
    #UEADV.eid,
    CASE
        WHEN rrt=3
            THEN (tx_coding *1000) + (cni_mtor_mon *100) + (cni_mtor_rx * 10 )+ tx_enc_active
        ELSE 0
    END AS tx_assert_level
INTO
    #SQ_tx_assert_level
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_tx_assert_level ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_mm1;

SELECT
    #UEADV.eid,
    CASE
        WHEN hd_dt<DATEADD(DAY, -90, GETDATE())
            THEN 1
        ELSE 0
    END AS rrt_mm1
INTO
    #SQ_rrt_mm1
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_mm1 ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_hd;

SELECT
    #UEADV.eid,
    CASE
        WHEN rrt=1
            THEN 1
        ELSE 0
    END AS rrt_hd
INTO
    #SQ_rrt_hd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_hd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_pd;

SELECT
    #UEADV.eid,
    CASE
        WHEN rrt=2
            THEN 1
        ELSE 0
    END AS rrt_pd
INTO
    #SQ_rrt_pd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_pd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_tx;

SELECT
    #UEADV.eid,
    CASE
        WHEN rrt=3
            THEN 1
        ELSE 0
    END AS rrt_tx
INTO
    #SQ_rrt_tx
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_tx ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_hhd;

SELECT
    #UEADV.eid,
    CASE
        WHEN rrt=4
            THEN 1
        ELSE 0
    END AS rrt_hhd
INTO
    #SQ_rrt_hhd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_hhd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_hd_rsd;

SELECT
    #UEADV.eid,
    CASE
        WHEN mbs_13105_dt_max IS NOT NULL
            THEN 1
        ELSE 0
    END AS rrt_hd_rsd
INTO
    #SQ_rrt_hd_rsd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_hd_rsd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_hd_rsd_1y;

SELECT
    #UEADV.eid,
    CASE
        WHEN mbs_13105_dt_max > DATEADD(DAY, -365, GETDATE())
            THEN 1
        ELSE 0
    END AS rrt_hd_rsd_1y
INTO
    #SQ_rrt_hd_rsd_1y
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_hd_rsd_1y ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_incd;

SELECT
    #UEADV.eid,
    CASE
        WHEN hd_dt_min > DATEADD(DAY, -365, GETDATE()) and hd_z49_n>=10
            THEN 1
        ELSE 0
    END AS hd_incd
INTO
    #SQ_hd_incd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_hd_incd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_pd_incd;

SELECT
    #UEADV.eid,
    CASE
        WHEN pd_dt_min > DATEADD(DAY, -365, GETDATE())
            THEN 1
        ELSE 0
    END AS pd_incd
INTO
    #SQ_pd_incd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_pd_incd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_incd;

SELECT
    #UEADV.eid,
    CASE
        WHEN hd_incd=1 or pd_incd=1
            THEN 1
        ELSE 0
    END AS rrt_incd
INTO
    #SQ_rrt_incd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_incd ON #SQ_pd_incd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_incd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_past;

SELECT
    #UEADV.eid,
    CASE
        WHEN rrt=1 and coalesce(pd_dt,tx_dt,homedx_dt) IS NOT NULL
            THEN 1
        WHEN rrt=2 and coalesce(hd_dt,tx_dt,homedx_dt) IS NOT NULL
            THEN 1
        WHEN rrt=3 and coalesce(pd_dt,hd_dt,homedx_dt) IS NOT NULL
            THEN 1
        WHEN rrt=4 and coalesce(hd_dt,tx_dt,pd_dt) IS NOT NULL
            THEN 1
        WHEN rrt=0 and hd_icpc_dt IS NOT NULL
            THEN 1
        ELSE 0
    END AS rrt_past
INTO
    #SQ_rrt_past
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_incd ON #SQ_pd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_incd ON #SQ_rrt_incd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_past ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rrt_past_pd;

SELECT
    #UEADV.eid,
    CASE
        WHEN pd_dt IS NOT NULL
            THEN 1
        ELSE 0
    END AS rrt_past_pd
INTO
    #SQ_rrt_past_pd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_incd ON #SQ_pd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_incd ON #SQ_rrt_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past ON #SQ_rrt_past.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rrt_past_pd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_hd_recent_flag;

SELECT
    #UEADV.eid,
    CASE
        WHEN mbs_13105_dt_max> DATEADD(DAY, -30, GETDATE()) or hd_dt> DATEADD(DAY, -30, GETDATE())
            THEN 1
        ELSE 0
    END AS hd_recent_flag
INTO
    #SQ_hd_recent_flag
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_incd ON #SQ_pd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_incd ON #SQ_rrt_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past ON #SQ_rrt_past.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past_pd ON #SQ_rrt_past_pd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_hd_recent_flag ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_ret_hd_post_tx;

SELECT
    #UEADV.eid,
    MIN(dt) AS ret_hd_post_tx
INTO
    #SQ_ret_hd_post_tx
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_incd ON #SQ_pd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_incd ON #SQ_rrt_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past ON #SQ_rrt_past.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past_pd ON #SQ_rrt_past_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_recent_flag ON #SQ_hd_recent_flag.eid = #UEADV.eid
    LEFT OUTER JOIN eadv ON eadv.eid = #UEADV.eid
        AND (ATT = 'icd_z49_1')
        AND (dt > DATEADD(DAY, 90, tx_dt))
GROUP BY
    #UEADV.eid
;

ALTER TABLE #SQ_ret_hd_post_tx ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_ret_hd_post_pd;

SELECT
    #UEADV.eid,
    MIN(dt) AS ret_hd_post_pd
INTO
    #SQ_ret_hd_post_pd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_incd ON #SQ_pd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_incd ON #SQ_rrt_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past ON #SQ_rrt_past.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past_pd ON #SQ_rrt_past_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_recent_flag ON #SQ_hd_recent_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ret_hd_post_tx ON #SQ_ret_hd_post_tx.eid = #UEADV.eid
    LEFT OUTER JOIN eadv ON eadv.eid = #UEADV.eid
        AND (ATT = 'icd_z49_1')
        AND (dt > DATEADD(DAY, 90, pd_dt_min))
GROUP BY
    #UEADV.eid
;

ALTER TABLE #SQ_ret_hd_post_pd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_tx_current;

SELECT
    #UEADV.eid,
    CASE
        WHEN rrt_tx=1 and ren_enc>DATEADD(DAY, -731, GETDATE())
            THEN 1
        ELSE 0
    END AS tx_current
INTO
    #SQ_tx_current
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_incd ON #SQ_pd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_incd ON #SQ_rrt_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past ON #SQ_rrt_past.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past_pd ON #SQ_rrt_past_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_recent_flag ON #SQ_hd_recent_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ret_hd_post_tx ON #SQ_ret_hd_post_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ret_hd_post_pd ON #SQ_ret_hd_post_pd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_tx_current ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS SROUT_rrt;

SELECT
    #UEADV.eid,
    #SQ_hd_z49_n.hd_z49_n,
    #SQ_hd_131_n.hd_131_n,
    #SQ_hd_z49_1y_n.hd_z49_1y_n,
    #SQ_hd_131_1y_n.hd_131_1y_n,
    #SQ_mbs_13105_dt_max.mbs_13105_dt_max,
    #SQ_mbs_13105_dt_min.mbs_13105_dt_min,
    #SQ_hd_icpc_dt.hd_icpc_dt,
    #SQ_hd_dt.hd_dt,
    #SQ_hd_dt_min.hd_dt_min,
    #SQ_pd_dt0.pd_dt0,
    #SQ_pd_dt_min.pd_dt_min,
    #SQ_pd_ex_dt.pd_ex_dt,
    #SQ_pd_enc_ld.pd_enc_ld,
    #SQ_pd_dt.pd_dt,
    #SQ_tx_dt_icpc.tx_dt_icpc,
    #SQ_tx_dt_icd.tx_dt_icd,
    #SQ_tx_dt_icd_last.tx_dt_icd_last,
    #SQ_tx_dt.tx_dt,
    #SQ_hd_tx_tx2_n.hd_tx_tx2_n,
    #SQ_hd_tx_tx2_ld.hd_tx_tx2_ld,
    #SQ_hd_tx2.hd_tx2,
    #SQ_tx_multi_fd.tx_multi_fd,
    #SQ_tx_multi_flag.tx_multi_flag,
    #SQ_tx_multi_current.tx_multi_current,
    #SQ_tx_enc_op_fd.tx_enc_op_fd,
    #SQ_tx_enc_op_ld.tx_enc_op_ld,
    #SQ_tx_enc_active.tx_enc_active,
    #SQ_tx_coding.tx_coding,
    #SQ_tdm_tac.tdm_tac,
    #SQ_tdm_evl.tdm_evl,
    #SQ_rx_l04ad.rx_l04ad,
    #SQ_rx_l04aa.rx_l04aa,
    #SQ_cni_mtor_rx.cni_mtor_rx,
    #SQ_cni_mtor_mon.cni_mtor_mon,
    #SQ_tx_active.tx_active,
    #SQ_homedx_icpc_ld.homedx_icpc_ld,
    #SQ_homedx_enc_ld.homedx_enc_ld,
    #SQ_homedx_dt.homedx_dt,
    #SQ_ren_enc.ren_enc,
    #SQ_rrt.rrt,
    #SQ_wip_hd_dt.wip_hd_dt,
    #SQ_wip_tx_dt_icpc_ld.wip_tx_dt_icpc_ld,
    #SQ_wip_tx_dt_ld.wip_tx_dt_ld,
    #SQ_wip_rrt_wip.wip_rrt_wip,
    #SQ_tx_assert_level.tx_assert_level,
    #SQ_rrt_mm1.rrt_mm1,
    #SQ_rrt_hd.rrt_hd,
    #SQ_rrt_pd.rrt_pd,
    #SQ_rrt_tx.rrt_tx,
    #SQ_rrt_hhd.rrt_hhd,
    #SQ_rrt_hd_rsd.rrt_hd_rsd,
    #SQ_rrt_hd_rsd_1y.rrt_hd_rsd_1y,
    #SQ_hd_incd.hd_incd,
    #SQ_pd_incd.pd_incd,
    #SQ_rrt_incd.rrt_incd,
    #SQ_rrt_past.rrt_past,
    #SQ_rrt_past_pd.rrt_past_pd,
    #SQ_hd_recent_flag.hd_recent_flag,
    #SQ_ret_hd_post_tx.ret_hd_post_tx,
    #SQ_ret_hd_post_pd.ret_hd_post_pd,
    #SQ_tx_current.tx_current
INTO
    SROUT_rrt
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_hd_z49_n ON #SQ_hd_z49_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_n ON #SQ_hd_131_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_z49_1y_n ON #SQ_hd_z49_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_131_1y_n ON #SQ_hd_131_1y_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_max ON #SQ_mbs_13105_dt_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_mbs_13105_dt_min ON #SQ_mbs_13105_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_icpc_dt ON #SQ_hd_icpc_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt ON #SQ_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_dt_min ON #SQ_hd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt0 ON #SQ_pd_dt0.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt_min ON #SQ_pd_dt_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_ex_dt ON #SQ_pd_ex_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_enc_ld ON #SQ_pd_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_dt ON #SQ_pd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icpc ON #SQ_tx_dt_icpc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd ON #SQ_tx_dt_icd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt_icd_last ON #SQ_tx_dt_icd_last.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_dt ON #SQ_tx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_n ON #SQ_hd_tx_tx2_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx_tx2_ld ON #SQ_hd_tx_tx2_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_tx2 ON #SQ_hd_tx2.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_fd ON #SQ_tx_multi_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_flag ON #SQ_tx_multi_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_multi_current ON #SQ_tx_multi_current.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_fd ON #SQ_tx_enc_op_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_op_ld ON #SQ_tx_enc_op_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_enc_active ON #SQ_tx_enc_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_coding ON #SQ_tx_coding.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_tac ON #SQ_tdm_tac.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tdm_evl ON #SQ_tdm_evl.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04ad ON #SQ_rx_l04ad.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_l04aa ON #SQ_rx_l04aa.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_rx ON #SQ_cni_mtor_rx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cni_mtor_mon ON #SQ_cni_mtor_mon.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_active ON #SQ_tx_active.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_icpc_ld ON #SQ_homedx_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_enc_ld ON #SQ_homedx_enc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_homedx_dt ON #SQ_homedx_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ren_enc ON #SQ_ren_enc.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_hd_dt ON #SQ_wip_hd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_icpc_ld ON #SQ_wip_tx_dt_icpc_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_tx_dt_ld ON #SQ_wip_tx_dt_ld.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_wip_rrt_wip ON #SQ_wip_rrt_wip.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_assert_level ON #SQ_tx_assert_level.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_mm1 ON #SQ_rrt_mm1.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd ON #SQ_rrt_hd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_pd ON #SQ_rrt_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_tx ON #SQ_rrt_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hhd ON #SQ_rrt_hhd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd ON #SQ_rrt_hd_rsd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_hd_rsd_1y ON #SQ_rrt_hd_rsd_1y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_incd ON #SQ_hd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_pd_incd ON #SQ_pd_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_incd ON #SQ_rrt_incd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past ON #SQ_rrt_past.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rrt_past_pd ON #SQ_rrt_past_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_hd_recent_flag ON #SQ_hd_recent_flag.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ret_hd_post_tx ON #SQ_ret_hd_post_tx.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ret_hd_post_pd ON #SQ_ret_hd_post_pd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_tx_current ON #SQ_tx_current.eid = #UEADV.eid
;

ALTER TABLE SROUT_rrt ADD PRIMARY KEY (eid);