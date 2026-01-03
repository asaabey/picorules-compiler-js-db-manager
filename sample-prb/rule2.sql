-- Drop existing table if it exists
DROP TABLE IF EXISTS SROUT_rule2;
GO

--------------------------------------------------
-- ruleblock:   rule2
--------------------------------------------------

DROP TABLE IF EXISTS SROUT_rule2;

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

DROP TABLE IF EXISTS #SQ_icd_fd;

SELECT
    eid,
    dt AS icd_fd
INTO
    #SQ_icd_fd
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
            dt ASC, att ASC, val ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT LIKE 'icd\_c18%' ESCAPE '\' OR ATT LIKE 'icd\_c19%' ESCAPE '\' OR ATT LIKE 'icd\_c20%' ESCAPE '\')
        
    ) SQ_icd_fd_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_icd_fd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_icpc_fd;

SELECT
    eid,
    dt AS icpc_fd
INTO
    #SQ_icpc_fd
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
            dt ASC, att ASC, val ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT LIKE 'icpc\_d75%' ESCAPE '\')
        
    ) SQ_icpc_fd_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_icpc_fd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_code_fd;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN (SELECT MIN(x) FROM (VALUES (icd_fd), (icpc_fd)) AS T(x) WHERE X IS NOT NULL)
    END AS code_fd
INTO
    #SQ_code_fd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_icd_fd ON #SQ_icd_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_icpc_fd ON #SQ_icpc_fd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_code_fd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rule2;

SELECT
    #UEADV.eid,
    CASE
        WHEN code_fd IS NOT NULL
            THEN 1
        ELSE 0
    END AS rule2
INTO
    #SQ_rule2
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_icd_fd ON #SQ_icd_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_icpc_fd ON #SQ_icpc_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_code_fd ON #SQ_code_fd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rule2 ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS SROUT_rule2;

SELECT
    #UEADV.eid,
    #SQ_icd_fd.icd_fd,
    #SQ_icpc_fd.icpc_fd,
    #SQ_code_fd.code_fd,
    #SQ_rule2.rule2
INTO
    SROUT_rule2
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_icd_fd ON #SQ_icd_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_icpc_fd ON #SQ_icpc_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_code_fd ON #SQ_code_fd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rule2 ON #SQ_rule2.eid = #UEADV.eid
;

ALTER TABLE SROUT_rule2 ADD PRIMARY KEY (eid);