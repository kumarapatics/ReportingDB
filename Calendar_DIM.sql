

CREATE TABLE DM_CALENDAR_DIMENSION AS
SELECT CurrDate                                                         AS DAY_IDN,
1                                                                       AS DAY_TME_SPAN,
CurrDate                                                                AS DAY_END_DTE,
TO_CHAR(CurrDate,'Day')                                                 AS WK_DAY_FULL_NAM,
TO_CHAR(CurrDate,'DY')                                                  AS WK_DAY_SHORT_NAM,
TO_NUMBER(TRIM(leading '0' FROM TO_CHAR(CurrDate,'D')))                 AS DAY_NUM_OF_WK,
TO_NUMBER(TRIM(leading '0' FROM TO_CHAR(CurrDate,'DD')))                AS DAY_NUM_OF_MM,
TO_NUMBER(TRIM(leading '0' FROM TO_CHAR(CurrDate,'DDD')))               AS DAY_NUM_OF_YR,
CurrDate                                                                AS WK_START_DTE,
CurrDate                                                                AS WK_END_DTE,
UPPER(TO_CHAR(CurrDate,'Mon') || '-' || TO_CHAR(CurrDate,'YYYY'))       AS MM_IDN_CDE,
31                                                                      AS MM_TME_SPAN,
to_date('31-JAN-2010','DD-MON-YYYY')                                    AS MM_END_DTE,
TO_CHAR(CurrDate,'Mon') || ' ' || TO_CHAR(CurrDate,'YYYY')              AS MM_SHORT_DESC,
RTRIM(TO_CHAR(CurrDate,'Month')) || ' ' || TO_CHAR(CurrDate,'YYYY')     AS MM_LONG_DESC,
TO_CHAR(CurrDate,'Mon')                                                 AS MM_SHORT_NAM,
TO_CHAR(CurrDate,'Month')                                               AS MM_LONG_NAM,
TO_NUMBER(TRIM(leading '0'FROM TO_CHAR(CurrDate,'MM')))                 AS MM_NUM_OF_YR,
'Q' || UPPER(TO_CHAR(CurrDate,'Q') || '-' || TO_CHAR(CurrDate,'YYYY'))  AS QTR_IDN_CDE,
31                                                                      AS QTR_TME_SPAN,
to_date('31-JAN-2010','DD-MON-YYYY')                                    AS QTR_END_DTE,
TO_NUMBER(TO_CHAR(CurrDate,'Q'))                                        AS QTR_NUM_OF_YR,
TO_CHAR(CurrDate,'YYYY')                                                AS YR_IDN_CDE,
31                                                                      AS YR_TME_SPAN,
to_date('31-JAN-2010','DD-MON-YYYY')                                    AS YR_END_DTE,
CURRENT_DATE                                                            AS DM_INSERT_DATE
FROM
(SELECT level n,
-- Calendar starts at the day after this date.
TO_DATE('31/12/1919','DD/MM/YYYY') + NUMTODSINTERVAL(level,'day') CurrDate
FROM dual
-- Change for the number of days to be added to the table.
CONNECT BY level <= 37986);

COMMIT; 
--
-- Month end date and time span attributes.
--
UPDATE DM_CALENDAR_DIMENSION A
SET MM_TME_SPAN =
(SELECT TS
FROM
(SELECT DISTINCT MM_IDN_CDE,
SUM(DAY_TME_SPAN) AS TS
FROM DM_CALENDAR_DIMENSION
GROUP BY MM_IDN_CDE
) B
WHERE A.MM_IDN_CDE = B.MM_IDN_CDE
);
--
UPDATE DM_CALENDAR_DIMENSION A
SET MM_END_DTE =
(SELECT ED
FROM
(SELECT DISTINCT MM_IDN_CDE,
MAX(DAY_IDN) AS ED
FROM DM_CALENDAR_DIMENSION
GROUP BY MM_IDN_CDE
) B
WHERE A.MM_IDN_CDE = B.MM_IDN_CDE
);
--
-- QUARTER END DATE AND TIME SPAN ATTRIBUTES.
--
UPDATE DM_CALENDAR_DIMENSION A
SET QTR_TME_SPAN =
(SELECT TS
FROM
(SELECT DISTINCT QTR_IDN_CDE,
SUM(DAY_TME_SPAN) AS TS
FROM DM_CALENDAR_DIMENSION
GROUP BY QTR_IDN_CDE
) B
WHERE A.QTR_IDN_CDE = B.QTR_IDN_CDE
);
--
UPDATE DM_CALENDAR_DIMENSION A
SET QTR_END_DTE =
(SELECT ED
FROM
(SELECT DISTINCT QTR_IDN_CDE,
MAX(DAY_IDN) AS ED
FROM DM_CALENDAR_DIMENSION
GROUP BY QTR_IDN_CDE
) B
WHERE A.QTR_IDN_CDE = B.QTR_IDN_CDE
);
--
-- YEAR END DATE AND TIME SPAN ATTRIBUTES.
--
UPDATE DM_CALENDAR_DIMENSION A
SET YR_TME_SPAN =
(SELECT TS
FROM
(SELECT DISTINCT YR_IDN_CDE,
SUM(DAY_TME_SPAN) AS TS
FROM DM_CALENDAR_DIMENSION
GROUP BY YR_IDN_CDE
) B
WHERE A.YR_IDN_CDE = B.YR_IDN_CDE
);
--
UPDATE DM_CALENDAR_DIMENSION A
SET YR_END_DTE =
(SELECT ED
FROM
(SELECT DISTINCT YR_IDN_CDE,
MAX(DAY_IDN) AS ED
FROM DM_CALENDAR_DIMENSION
GROUP BY YR_IDN_CDE
) B
WHERE A.YR_IDN_CDE = B.YR_IDN_CDE
);

COMMIT;

--- Calculate Ending Week Day

UPDATE DM_CALENDAR_DIMENSION
SET WK_END_DTE = DAY_IDN
WHERE DAY_NUM_OF_WK = 1;

UPDATE DM_CALENDAR_DIMENSION
SET WK_END_DTE = DAY_IDN + 6
WHERE DAY_NUM_OF_WK = 2;

UPDATE DM_CALENDAR_DIMENSION
SET WK_END_DTE = DAY_IDN + 5
WHERE DAY_NUM_OF_WK = 3;

UPDATE DM_CALENDAR_DIMENSION
SET WK_END_DTE = DAY_IDN + 4
WHERE DAY_NUM_OF_WK = 4;

UPDATE DM_CALENDAR_DIMENSION
SET WK_END_DTE = DAY_IDN + 3
WHERE DAY_NUM_OF_WK = 5;

UPDATE DM_CALENDAR_DIMENSION
SET WK_END_DTE = DAY_IDN + 2
WHERE DAY_NUM_OF_WK = 6;

UPDATE DM_CALENDAR_DIMENSION
SET WK_END_DTE = DAY_IDN + 2
WHERE DAY_NUM_OF_WK = 7;
 


-- Calculate Beginning Week Day

UPDATE DM_CALENDAR_DIMENSION
SET WK_START_DTE = DAY_IDN
WHERE DAY_NUM_OF_WK = 2;

UPDATE DM_CALENDAR_DIMENSION
SET WK_START_DTE = DAY_IDN - 1
WHERE DAY_NUM_OF_WK = 2;

UPDATE DM_CALENDAR_DIMENSION
SET WK_START_DTE = DAY_IDN - 2
WHERE DAY_NUM_OF_WK = 3;

UPDATE DM_CALENDAR_DIMENSION
SET WK_START_DTE = DAY_IDN - 3
WHERE DAY_NUM_OF_WK = 4;

UPDATE DM_CALENDAR_DIMENSION
SET WK_START_DTE = DAY_IDN - 4
WHERE DAY_NUM_OF_WK = 5;

UPDATE DM_CALENDAR_DIMENSION
SET WK_START_DTE = DAY_IDN - 5
WHERE DAY_NUM_OF_WK = 6;

UPDATE DM_CALENDAR_DIMENSION
SET WK_START_DTE = DAY_IDN - 6
WHERE DAY_NUM_OF_WK = 7;

COMMIT;

SELECT MIN(DAY_IDN), MAX(DAY_IDN) FROM DM_CALENDAR_DIMENSION;