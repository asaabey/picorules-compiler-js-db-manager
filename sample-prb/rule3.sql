-- Drop existing table if it exists
DROP TABLE IF EXISTS SROUT_cd_pulm_copd;
GO

--------------------------------------------------
-- ruleblock:   cd_pulm_copd
--------------------------------------------------

DROP TABLE IF EXISTS SROUT_cd_pulm_copd;

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

DROP TABLE IF EXISTS #SQ_code_copd_dt;

SELECT
    eadv.eid,
    MAX(dt) AS code_copd_dt
INTO
    #SQ_code_copd_dt
FROM
    eadv
WHERE (1=1)
    AND (ATT LIKE 'icpc\_r95%' ESCAPE '\' OR ATT LIKE 'icd\_j44%' ESCAPE '\')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_code_copd_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rx_r03_dt;

SELECT
    eadv.eid,
    MAX(dt) AS rx_r03_dt
INTO
    #SQ_rx_r03_dt
FROM
    eadv
WHERE (1=1)
    AND (ATT LIKE 'rxnc\_r03%' ESCAPE '\')
    AND (val=1)
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_rx_r03_dt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_copd;

SELECT
    #UEADV.eid,
    CASE
        WHEN code_copd_dt IS NOT NULL or rx_r03_dt IS NOT NULL
            THEN 1
        ELSE 0
    END AS copd
INTO
    #SQ_copd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_code_copd_dt ON #SQ_code_copd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_r03_dt ON #SQ_rx_r03_dt.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_copd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_cd_pulm_copd;

SELECT
    #UEADV.eid,
    CASE
        WHEN (CASE WHEN ((copd) is null) THEN NULL ELSE (SELECT MAX(x) FROM (VALUES (copd)) AS T(x)) END)>0
            THEN 1
        ELSE 0
    END AS cd_pulm_copd
INTO
    #SQ_cd_pulm_copd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_code_copd_dt ON #SQ_code_copd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_r03_dt ON #SQ_rx_r03_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_copd ON #SQ_copd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_cd_pulm_copd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS SROUT_cd_pulm_copd;

SELECT
    #UEADV.eid,
    #SQ_code_copd_dt.code_copd_dt,
    #SQ_rx_r03_dt.rx_r03_dt,
    #SQ_copd.copd,
    #SQ_cd_pulm_copd.cd_pulm_copd
INTO
    SROUT_cd_pulm_copd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_code_copd_dt ON #SQ_code_copd_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rx_r03_dt ON #SQ_rx_r03_dt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_copd ON #SQ_copd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_cd_pulm_copd ON #SQ_cd_pulm_copd.eid = #UEADV.eid
;

ALTER TABLE SROUT_cd_pulm_copd ADD PRIMARY KEY (eid);