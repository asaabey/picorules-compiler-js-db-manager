-- Drop existing table if it exists
DROP TABLE IF EXISTS SROUT_acr_graph_test;
GO

--------------------------------------------------
-- ruleblock:   acr_graph_test
--------------------------------------------------

DROP TABLE IF EXISTS SROUT_acr_graph_test;

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

DROP TABLE IF EXISTS #SQ_rrt;

SELECT
    SROUT_rrt.eid,
    SROUT_rrt.rrt AS rrt
INTO
    #SQ_rrt
FROM
    SROUT_rrt
;

ALTER TABLE #SQ_rrt ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_max;

SELECT
    eid,
    val AS acr_max_val,
    dt AS acr_max_dt
INTO
    #SQ_acr_max
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
            CAST(val AS FLOAT) DESC, dt DESC, att ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT = 'lab_ua_acr')
        
    ) SQ_acr_max_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_acr_max ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_min;

SELECT
    eid,
    val AS acr_min_val,
    dt AS acr_min_dt
INTO
    #SQ_acr_min
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
            CAST(val AS FLOAT) ASC, dt DESC, att ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT = 'lab_ua_acr')
        
    ) SQ_acr_min_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_acr_min ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_f;

SELECT
    eid,
    val AS acr_f_val,
    dt AS acr_f_dt
INTO
    #SQ_acr_f
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
            dt ASC, att ASC, val ASC
        ) AS RANK
    FROM
            eadv
    WHERE (1=1)
        AND (ATT = 'lab_ua_acr')
        
    ) SQ_acr_f_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_acr_f ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_l;

SELECT
    eid,
    val AS acr_l_val,
    dt AS acr_l_dt
INTO
    #SQ_acr_l
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
        AND (ATT = 'lab_ua_acr')
        
    ) SQ_acr_l_WINDOW
WHERE
    RANK = 1
;

ALTER TABLE #SQ_acr_l ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_dspan;

SELECT
    #UEADV.eid,
    CASE
        WHEN acr_l_dt> acr_f_dt
            THEN DATEDIFF(DAY, acr_f_dt, acr_l_dt)
    END AS dspan
INTO
    #SQ_dspan
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_dspan ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_dspan_y;

SELECT
    #UEADV.eid,
    CASE
        WHEN dspan>0
            THEN CEILING(dspan/365)
    END AS dspan_y
INTO
    #SQ_dspan_y
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_dspan_y ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_n;

SELECT
    eadv.eid,
    COUNT(dt) AS acr_n
INTO
    #SQ_acr_n
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'lab_ua_acr')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_acr_n ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_n_30;

SELECT
    eadv.eid,
    COUNT(val) AS acr_n_30
INTO
    #SQ_acr_n_30
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'lab_ua_acr')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_acr_n_30 ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_graph_canvas_x;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN 350
    END AS acr_graph_canvas_x
INTO
    #SQ_acr_graph_canvas_x
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_acr_graph_canvas_x ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_graph_canvas_y;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN 200
    END AS acr_graph_canvas_y
INTO
    #SQ_acr_graph_canvas_y
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_acr_graph_canvas_y ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_graph_data;

SELECT
    eadv.eid,
    STRING_AGG(CAST(round(val,0) AS VARCHAR(100)) + '~' + CONVERT(VARCHAR, dt, 23), ',')
    WITHIN GROUP (ORDER BY dt) AS acr_graph_data
INTO
    #SQ_acr_graph_data
FROM
    eadv
WHERE (1=1)
    AND (ATT = 'lab_ua_acr')
    
GROUP BY
    eadv.eid
;

ALTER TABLE #SQ_acr_graph_data ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_graph_y_max;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN acr_max_val
    END AS acr_graph_y_max
INTO
    #SQ_acr_graph_y_max
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_y ON #SQ_acr_graph_canvas_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_data ON #SQ_acr_graph_data.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_acr_graph_y_max ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_graph_y_min;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN acr_min_val
    END AS acr_graph_y_min
INTO
    #SQ_acr_graph_y_min
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_y ON #SQ_acr_graph_canvas_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_data ON #SQ_acr_graph_data.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_max ON #SQ_acr_graph_y_max.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_acr_graph_y_min ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_graph_x_scale;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN round(acr_graph_canvas_x/dspan,5)
    END AS acr_graph_x_scale
INTO
    #SQ_acr_graph_x_scale
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_y ON #SQ_acr_graph_canvas_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_data ON #SQ_acr_graph_data.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_max ON #SQ_acr_graph_y_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_min ON #SQ_acr_graph_y_min.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_acr_graph_x_scale ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_graph_y_scale;

SELECT
    #UEADV.eid,
    CASE
        WHEN acr_graph_y_max > acr_graph_y_min
            THEN round(acr_graph_canvas_y/(acr_graph_y_max-acr_graph_y_min),5)
        ELSE round(acr_graph_canvas_y/10,5)
    END AS acr_graph_y_scale
INTO
    #SQ_acr_graph_y_scale
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_y ON #SQ_acr_graph_canvas_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_data ON #SQ_acr_graph_data.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_max ON #SQ_acr_graph_y_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_min ON #SQ_acr_graph_y_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_x_scale ON #SQ_acr_graph_x_scale.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_acr_graph_y_scale ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_line_upper_y;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN 0
    END AS line_upper_y
INTO
    #SQ_line_upper_y
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_y ON #SQ_acr_graph_canvas_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_data ON #SQ_acr_graph_data.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_max ON #SQ_acr_graph_y_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_min ON #SQ_acr_graph_y_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_x_scale ON #SQ_acr_graph_x_scale.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_scale ON #SQ_acr_graph_y_scale.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_line_upper_y ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_line_lower_y;

SELECT
    #UEADV.eid,
    CASE
        WHEN 1=1
            THEN (acr_graph_y_max-acr_graph_y_min) * acr_graph_y_scale
    END AS line_lower_y
INTO
    #SQ_line_lower_y
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_y ON #SQ_acr_graph_canvas_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_data ON #SQ_acr_graph_data.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_max ON #SQ_acr_graph_y_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_min ON #SQ_acr_graph_y_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_x_scale ON #SQ_acr_graph_x_scale.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_scale ON #SQ_acr_graph_y_scale.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_line_upper_y ON #SQ_line_upper_y.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_line_lower_y ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS #SQ_acr_graph_test;

SELECT
    #UEADV.eid,
    CASE
        WHEN acr_n_30>3 and rrt=0
            THEN 1
        ELSE 0
    END AS acr_graph_test
INTO
    #SQ_acr_graph_test
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_y ON #SQ_acr_graph_canvas_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_data ON #SQ_acr_graph_data.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_max ON #SQ_acr_graph_y_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_min ON #SQ_acr_graph_y_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_x_scale ON #SQ_acr_graph_x_scale.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_scale ON #SQ_acr_graph_y_scale.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_line_upper_y ON #SQ_line_upper_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_line_lower_y ON #SQ_line_lower_y.eid = #UEADV.eid
WHERE (1=1)
;

ALTER TABLE #SQ_acr_graph_test ADD PRIMARY KEY (eid);

DROP TABLE IF EXISTS SROUT_acr_graph_test;

SELECT
    #UEADV.eid,
    #SQ_rrt.rrt,
    #SQ_acr_max.acr_max_val,
    #SQ_acr_max.acr_max_dt,
    #SQ_acr_min.acr_min_val,
    #SQ_acr_min.acr_min_dt,
    #SQ_acr_f.acr_f_val,
    #SQ_acr_f.acr_f_dt,
    #SQ_acr_l.acr_l_val,
    #SQ_acr_l.acr_l_dt,
    #SQ_dspan.dspan,
    #SQ_dspan_y.dspan_y,
    #SQ_acr_n.acr_n,
    #SQ_acr_n_30.acr_n_30,
    #SQ_acr_graph_canvas_x.acr_graph_canvas_x,
    #SQ_acr_graph_canvas_y.acr_graph_canvas_y,
    #SQ_acr_graph_data.acr_graph_data,
    #SQ_acr_graph_y_max.acr_graph_y_max,
    #SQ_acr_graph_y_min.acr_graph_y_min,
    #SQ_acr_graph_x_scale.acr_graph_x_scale,
    #SQ_acr_graph_y_scale.acr_graph_y_scale,
    #SQ_line_upper_y.line_upper_y,
    #SQ_line_lower_y.line_lower_y,
    #SQ_acr_graph_test.acr_graph_test
INTO
    SROUT_acr_graph_test
FROM
    #UEADV
    LEFT OUTER JOIN #SQ_rrt ON #SQ_rrt.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_max ON #SQ_acr_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_min ON #SQ_acr_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_f ON #SQ_acr_f.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_l ON #SQ_acr_l.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan ON #SQ_dspan.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_dspan_y ON #SQ_dspan_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n ON #SQ_acr_n.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_n_30 ON #SQ_acr_n_30.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_x ON #SQ_acr_graph_canvas_x.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_canvas_y ON #SQ_acr_graph_canvas_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_data ON #SQ_acr_graph_data.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_max ON #SQ_acr_graph_y_max.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_min ON #SQ_acr_graph_y_min.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_x_scale ON #SQ_acr_graph_x_scale.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_y_scale ON #SQ_acr_graph_y_scale.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_line_upper_y ON #SQ_line_upper_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_line_lower_y ON #SQ_line_lower_y.eid = #UEADV.eid
    LEFT OUTER JOIN #SQ_acr_graph_test ON #SQ_acr_graph_test.eid = #UEADV.eid
;

ALTER TABLE SROUT_acr_graph_test ADD PRIMARY KEY (eid);