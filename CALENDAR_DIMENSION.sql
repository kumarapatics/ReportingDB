
CREATE TABLE [dbo].[CALENDAR_DIM](
	[DAY_IDN] [datetime] NULL,
	[DAY_TME_SPAN] [float] NULL,
	[DAY_END_DTE] [datetime] NULL,
	[WK_DAY_FULL_NAM] [varchar](9) NULL,
	[WK_DAY_SHORT_NAM] [varchar](3) NULL,
	--[DAY_TYP] [varchar](15) NULL,
	[DAY_NUM_OF_WK] [float] NULL,
	[DAY_NUM_OF_MM] [float] NULL,
	[DAY_NUM_OF_YR] [float] NULL,
	[WK_START_DTE] [datetime] NULL,
	[WK_END_DTE] [datetime] NULL,
	[MM_IDN_CDE] [varchar](8) NULL,
	[MM_TME_SPAN] [float] NULL,
	[MM_END_DTE] [datetime] NULL,
	[MM_SHORT_DSC] [varchar](8) NULL,
	[MM_LONG_DSC] [varchar](14) NULL,
	[MM_SHORT_NAM] [varchar](3) NULL,
	[MM_LONG_NAM] [varchar](9) NULL,
	[MM_NUM_OF_YR] [float] NULL,
	[QTR_IDN_CDE] [varchar](7) NULL,
	[QTR_TME_SPAN] [float] NULL,
	[QTR_END_DTE] [datetime] NULL,
	[QTR_NUM_OF_YR] [float] NULL,
	[YR_IDN_CDE] [varchar](4) NULL,
	[YR_TME_SPAN] [float] NULL,
	[YR_END_DTE] [datetime] NULL
	--[INSERT_DTE] [datetime] NULL,
	--[HOL_FLG] [varchar](1) NULL,
	--[BusinessDay] [int] NULL
) ON [PRIMARY]

GO

USE [ReportingDB]
GO


alter  TABLE [dbo].[CALENDAR_DIM] alter column 	[DAY_IDN] [date] NULL
alter  TABLE [dbo].[CALENDAR_DIM] alter column 		[DAY_END_DTE] [date] NULL
alter  TABLE [dbo].[CALENDAR_DIM] alter column 	[WK_START_DTE] [date] NULL
alter  TABLE [dbo].[CALENDAR_DIM] alter column 		[WK_END_DTE] [date] NULL
alter  TABLE [dbo].[CALENDAR_DIM] alter column 		[MM_END_DTE] [date] NULL
alter  TABLE [dbo].[CALENDAR_DIM] alter column 		[QTR_END_DTE] [date] NULL
alter  TABLE [dbo].[CALENDAR_DIM] alter column 		[YR_END_DTE] [date] NULL



--drop table #temp
--create table #temp(d date)
--declare @sdate datetime='2001-01-01 00:00'
--declare @edate datetime='2001-12-31 00:00'
--insert into #temp
--select DATEADD(d,number,@sdate) from master..spt_values where type='P' and number<=datediff(d,@sdate,@edate)
--select * from #temp
-------------------------
--drop table #temp
--create table #temp(CurrDate date)
--declare @sdate datetime='2001-01-01 00:00'
--declare @edate datetime='2001-12-31 00:00'
--insert into #temp
--select DATEADD(d,number,@sdate) from master..spt_values where type='P' and number<=datediff(d,@sdate,@edate)

drop table #temp
DECLARE @StartDate datetime = '1950-01-01'
       ,@EndDate   datetime = '2050-12-31'
;

WITH theDates AS
     (SELECT @StartDate as CurrDate
      UNION ALL
      SELECT DATEADD(day, 1, CurrDate)
        FROM theDates
       WHERE DATEADD(day, 1, CurrDate) <= @EndDate
     )


	SELECT CurrDate, 1 as theValue into #temp
	FROM theDates
	OPTION (MAXRECURSION 0)



;

insert into [dbo].[CALENDAR_DIM]
(
[DAY_IDN], [DAY_TME_SPAN], [DAY_END_DTE], [WK_DAY_FULL_NAM], [WK_DAY_SHORT_NAM], [DAY_NUM_OF_WK], [DAY_NUM_OF_MM], [DAY_NUM_OF_YR],
 [WK_START_DTE], [WK_END_DTE], [MM_IDN_CDE], [MM_TME_SPAN], [MM_END_DTE], [MM_SHORT_DSC], [MM_LONG_DSC], [MM_SHORT_NAM], [MM_LONG_NAM],
  [MM_NUM_OF_YR], [QTR_IDN_CDE], [QTR_TME_SPAN], [QTR_END_DTE], [QTR_NUM_OF_YR], [YR_IDN_CDE], [YR_TME_SPAN], [YR_END_DTE]
)

SELECT  
CurrDate																AS DAY_IDN,
1                                                                       AS DAY_TME_SPAN,
CurrDate                                                                AS DAY_END_DTE,
datename(weekday,CurrDate)                                              AS WK_DAY_FULL_NAM,
UPPER(Substring(datename(weekday,CurrDate),1,3))                        AS WK_DAY_SHORT_NAM,
DATEPART(dw,CurrDate)									                AS DAY_NUM_OF_WK,
datename(dd,CurrDate)										            AS DAY_NUM_OF_MM,
datename(dayofyear,CurrDate)										    AS DAY_NUM_OF_YR,
DATEADD(dd, -(DATEPART(dw, CurrDate)-1), CurrDate)                      AS WK_START_DTE,
DATEADD(dd, 7-(DATEPART(dw, CurrDate)), CurrDate)                       AS WK_END_DTE,
RTRIM(UPPER(CONVERT(CHAR(4), CurrDate, 100))) + '-'+ CONVERT(CHAR(4), CurrDate, 120)      AS MM_IDN_CDE,
DAY(EOMONTH(CurrDate))                                                  AS MM_TME_SPAN,
EOMONTH(CurrDate)														AS MM_END_DTE,
CONVERT(CHAR(4), CurrDate, 100) +  CONVERT(CHAR(4), CurrDate, 120)		AS MM_SHORT_DESC,
datename(MONTH,CurrDate)  + ' ' +  CONVERT(CHAR(4), CurrDate, 120)		AS MM_LONG_DESC,
CONVERT(CHAR(4), CurrDate, 100)                                         AS MM_SHORT_NAM,
datename(MONTH,CurrDate)		                                        AS MM_LONG_NAM,
DATEPART(month, CurrDate)												AS MM_NUM_OF_YR,
'Q' + CAST(DATENAME(QUARTER,CurrDate) as CHAR(1) ) + '-'+ 
CAST(datepart(year,CurrDate) as char(4))								AS QTR_IDN_CDE,
31                                                                      AS QTR_TME_SPAN,
dateadd(qq, DateDiff(qq, 0, CurrDate), -1)                              AS QTR_END_DTE,
DATENAME(QUARTER,CurrDate)												AS QTR_NUM_OF_YR,
datepart(year,CurrDate)                                                 AS YR_IDN_CDE,
DATEDIFF(day,  cast(datepart(year,CurrDate)  as char(4)),  cast(datepart(year,CurrDate) +1 as char(4)))   AS YR_TME_SPAN,
Convert (char(10), DATEADD (dd, -1, DATEADD(yy, DATEDIFF(yy, 0, CurrDate) +1, 0)),121)			AS YR_END_DTE
--current_timestamp                                                       AS INSERT_DATE
FROM
	#temp

--select * from [CALENDAR_DIM]


-- Calculate Beginning Week Day

UPDATE CALENDAR_DIM
SET WK_START_DTE = DAY_IDN
WHERE DAY_NUM_OF_WK = 2;

UPDATE CALENDAR_DIM
SET WK_START_DTE = DAY_IDN - 1
WHERE DAY_NUM_OF_WK = 2;

UPDATE CALENDAR_DIM
SET WK_START_DTE = DAY_IDN - 2
WHERE DAY_NUM_OF_WK = 3;

UPDATE CALENDAR_DIM
SET WK_START_DTE = DAY_IDN - 3
WHERE DAY_NUM_OF_WK = 4;

UPDATE CALENDAR_DIM
SET WK_START_DTE = DAY_IDN - 4
WHERE DAY_NUM_OF_WK = 5;

UPDATE CALENDAR_DIM
SET WK_START_DTE = DAY_IDN - 5
WHERE DAY_NUM_OF_WK = 6;

UPDATE CALENDAR_DIM
SET WK_START_DTE = DAY_IDN - 6
WHERE DAY_NUM_OF_WK = 7;



--SELECT MIN(DAY_IDN), MAX(DAY_IDN) FROM CALENDAR_DIM;



--- Calculate Ending Week Day

UPDATE CALENDAR_DIM
SET WK_END_DTE = DAY_IDN
WHERE DAY_NUM_OF_WK = 1;

UPDATE CALENDAR_DIM
SET WK_END_DTE = DAY_IDN + 6
WHERE DAY_NUM_OF_WK = 2;

UPDATE CALENDAR_DIM
SET WK_END_DTE = DAY_IDN + 5
WHERE DAY_NUM_OF_WK = 3;

UPDATE CALENDAR_DIM
SET WK_END_DTE = DAY_IDN + 4
WHERE DAY_NUM_OF_WK = 4;

UPDATE CALENDAR_DIM
SET WK_END_DTE = DAY_IDN + 3
WHERE DAY_NUM_OF_WK = 5;

UPDATE CALENDAR_DIM
SET WK_END_DTE = DAY_IDN + 2
WHERE DAY_NUM_OF_WK = 6;

UPDATE CALENDAR_DIM
SET WK_END_DTE = DAY_IDN + 2
WHERE DAY_NUM_OF_WK = 7;
 

 
---- QUARTER END DATE AND TIME SPAN ATTRIBUTES.
----
--UPDATE  A
--SET QTR_TME_SPAN = B.TS
--from CALENDAR_DIM A
--JOIN 
--(
--SELECT DISTINCT QTR_IDN_CDE,
--SUM(DAY_TME_SPAN) AS TS
--FROM CALENDAR_DIM
--GROUP BY QTR_IDN_CDE
--) B
--on  A.QTR_IDN_CDE = B.QTR_IDN_CDE


----
--UPDATE CALENDAR_DIM A
--SET QTR_END_DTE =
--(SELECT ED
--FROM
--(SELECT DISTINCT QTR_IDN_CDE,
--MAX(DAY_IDN) AS ED
--FROM CALENDAR_DIM
--GROUP BY QTR_IDN_CDE
--) B
--WHERE A.QTR_IDN_CDE = B.QTR_IDN_CDE
--);



----
---- Month end date and time span attributes.
----
--UPDATE CALENDAR_DIM A
--SET MM_TME_SPAN =
--(SELECT TS
--FROM
--(SELECT DISTINCT MM_IDN_CDE,
--SUM(DAY_TME_SPAN) AS TS
--FROM CALENDAR_DIM
--GROUP BY MM_IDN_CDE
--) B
--WHERE A.MM_IDN_CDE = B.MM_IDN_CDE
--);
----
--UPDATE CALENDAR_DIM A
--SET MM_END_DTE =
--(SELECT ED
--FROM
--(SELECT DISTINCT MM_IDN_CDE,
--MAX(DAY_IDN) AS ED
--FROM CALENDAR_DIM
--GROUP BY MM_IDN_CDE
--) B
--WHERE A.MM_IDN_CDE = B.MM_IDN_CDE
--);
----
----
---- YEAR END DATE AND TIME SPAN ATTRIBUTES.
----
--UPDATE CALENDAR_DIM A
--SET YR_TME_SPAN =
--(SELECT TS
--FROM
--(SELECT DISTINCT YR_IDN_CDE,
--SUM(DAY_TME_SPAN) AS TS
--FROM CALENDAR_DIM
--GROUP BY YR_IDN_CDE
--) B
--WHERE A.YR_IDN_CDE = B.YR_IDN_CDE
--);
----
--UPDATE CALENDAR_DIM A
--SET YR_END_DTE =
--(SELECT ED
--FROM
--(SELECT DISTINCT YR_IDN_CDE,
--MAX(DAY_IDN) AS ED
--FROM CALENDAR_DIM
--GROUP BY YR_IDN_CDE
--) B
--WHERE A.YR_IDN_CDE = B.YR_IDN_CDE
--);

--COMMIT;
