-- Drop existing table if it exists
DROP TABLE IF EXISTS SROUT_rule1;
GO

--------------------------------------------------
-- ruleblock:   rule1
--------------------------------------------------

DROP TABLE IF EXISTS SROUT_rule1;

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

DROP TABLE IF EXISTS #SQ_egfr;

SELECT
    eid,
    val AS egfr
INTO
    #SQ_egfr
FROM
    (
    SELECT
        eadv.eid,
        val,
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
        AND (ATT = 'lab_bld_egfr_c')
        
    ) SQ_egfr_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_egfr ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_ckd;

SELECT
    #UEADV.eid,
    CASE
        WHEN egfr < 90
            THEN 1
        ELSE 0
    END AS ckd
INTO
    #SQ_ckd
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_egfr ON #SQ_egfr.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_ckd ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_rule1;

SELECT
    #UEADV.eid,
    CASE
        WHEN ckd=1
            THEN 1
        ELSE 0
    END AS rule1
INTO
    #SQ_rule1
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_egfr ON #SQ_egfr.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ckd ON #SQ_ckd.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_rule1 ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS SROUT_rule1;

SELECT
    #UEADV.eid,
    #SQ_egfr.egfr,
    #SQ_ckd.ckd,
    #SQ_rule1.rule1
INTO
    SROUT_rule1
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_egfr ON #SQ_egfr.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_ckd ON #SQ_ckd.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_rule1 ON #SQ_rule1.eid = #UEADV.eid
;

ALTER TABLE SROUT_rule1 ADD PRIMARY KEY (eid);