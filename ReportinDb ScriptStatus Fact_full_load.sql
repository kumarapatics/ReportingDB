

use ReportingDB
Go

DROP TABLE DBO.[SCRIPT_STATUS_FACT]
USE [ReportingDB]
GO

/****** Object:  Table [dbo].[SCRIPT_STATUS_FACT]    Script Date: 5/5/2019 1:02:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SCRIPT_STATUS_FACT](
	[SCRIPT_ID] [bigint] NULL,
	[CLIENT_DIM_KEY] [int] NULL,
	[TREATMENT_TYPE_DIM_KEY] [int] NULL,
	[SERVICE_TYPE_DIM_KEY] [int] NULL,
	[PRODUCT_TYPE_DIM_KEY] [int] NULL,
	[REFERRALSTATUS_TYPE_DIM_KEY] [int] NULL,
	[REFERRALSTATUS_TYPE_NAME] [varchar](100) NULL,
	[REFERRAL_SUBSTATUS_TYPE_DIM_KEY] [int] NULL,
	[DATE_OF_INJURY] [date] NULL,
	[CLAIM_NUMBER] [varchar](255) NULL,
	[IS_BID_ACCEPTED] [bit] NULL,
	[BID_SUBMITTED_DATE] [date] NULL,
	[ZIP_CODES_STATES_STATECODE] [varchar](50) NULL,
	[REFERRAL_SUBMITTED_DATE] [date] NULL,
	[BID_EXPIREDATE] [date] NULL,
	[IS_BID_EXPIRED] [bit] NULL
) ON [PRIMARY]
GO



truncate table DBO.[SCRIPT_STATUS_FACT]

INSERT INTO DBO.[SCRIPT_STATUS_FACT]
([SCRIPT_ID], [DATE_OF_INJURY], [CLAIM_NUMBER], [IS_BID_ACCEPTED], [BID_SUBMITTED_DATE], 
[ZIP_CODES_STATES_STATECODE], [REFERRAL_SUBMITTED_DATE], [BID_EXPIREDATE], [IS_BID_EXPIRED],
[CLIENT_DIM_KEY], [TREATMENT_TYPE_DIM_KEY], [SERVICE_TYPE_DIM_KEY], [PRODUCT_TYPE_DIM_KEY],
 [REFERRALSTATUS_TYPE_DIM_KEY], [REFERRALSTATUS_TYPE_NAME], [REFERRAL_SUBSTATUS_TYPE_DIM_KEY]
)
select r.scriptid
,r.DateOfInjury
,r.ClaimNumber
,prbd.IsBidAccepted
--,prbd.BidPrice
--,prbd.StandingPrice
--,prbd.distance
,prbd.SubmittedDate as bid_submitted_date
,zd.ZIP_CODES_STATES_CODE
,rtsm.SubmittedDate referral_submitted_date
,rtsm.BidExpireDate
,rtsm.IsBidExpired
,cd.CLIENT_DIM_KEY
,[TREATMENT_TYPE_DIM_KEY]
,[SERVICE_TYPE_DIM_KEY]
,[PRODUCT_TYPE_DIM_KEY]
,rstd.[REFERRALSTATUS_TYPE_DIM_KEY]
,rstd.REFERRALSTATUS_TYPE_NAME
,rsstd.[REFERRAL_SUBSTATUS_TYPE_DIM_KEY]
from thm.dbo.referral r
join thm.dbo.ReferralTreatmentServiceMap rtsm on rtsm.ReferralId = r.id
join thm.dbo.ReferralTreatmentServiceProviderMap rtsp on rtsp.ReferralTreatmentServiceMapId = rtsm.id
join thm.dbo.[ProviderReferralBidDescision] prbd on prbd.[ReferralTreatmentServiceProviderMapId ] = rtsp.id
join reportingdb.[dbo].[CLIENT_DIM] cd on cd.[SUB_CLIENT_GUID] = r.ClientId
join  [THM].[ref].[ReferralStatusType] rst on rst.Id = rtsm.ReferralStatusTypeId
left outer join thm.[ref].[ReferralSubStatusType] rsst on rsst.ReferralStatusTypeId = rst.id
join reportingdb.[dbo].[REFERRALSTATUS_TYPE_DIM] rstd on rstd.[REFERRALSTATUS_TYPE_NAME] = rst.Name
left outer join reportingdb.[dbo].[REFERRAL_SUBSTATUS_TYPE_DIM] rsstd on rsstd.[REFERRAL_SUBSTATUS_TYPE_NAME] = rsst.SubStatusName
join [ReportingDB].[dbo].[TREATMENT_TYPE_DIM] ttd on ttd.[TREATMENT_TYPE_GUID] = rtsm.TreatmentTypeId
join [ReportingDB].[dbo].[SERVICE_TYPE_DIM] std on std.[SERVICE_TYPE_GUID] = rtsm.servicetypeid
join [ReportingDB].[dbo].[PRODUCT_TYPE_DIM] ptd on ptd.[PRODUCT_TYPE_GUID] = rtsm.producttypeid
left outer join ReportingDB.[dbo].[ZIP_CODES_STATES_DIM] zd on zd.ZIP_CODES_STATES_GUID = r.[StateOfJurisdiction]




select * from DBO.[SCRIPT_STATUS_FACT]