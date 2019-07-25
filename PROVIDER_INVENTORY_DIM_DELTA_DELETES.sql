USE [ReportingDB]
GO

/****** Object:  Table [dbo].[PROVIDER_INVENTORY_HISTORY]    Script Date: 6/26/2019 6:23:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PROVIDER_INVENTORY_HISTORY](
	[INVENTORY_ID] [uniqueidentifier] NOT NULL,
	[PROVIDER_ID] [uniqueidentifier] NOT NULL,
	[LOCATION_ID] [uniqueidentifier] NOT NULL,
	[TREATMENTSERVICEPRODUCTMAP_ID] [uniqueidentifier] NOT NULL,
	[AMOUNT] [decimal](18, 0) NULL,
	[ACTIVE_FLAG] [bit] NOT NULL,
	[CREATEDDATE] [date] NOT NULL,
	[MODIFIEDDATE] [date] NOT NULL
) ON [PRIMARY]
GO


alter table dbo.[PROVIDER_INVENTORY_HISTORY] add [IS_DELETED] [bit]  NULL
update dbo.[PROVIDER_INVENTORY_HISTORY] SET IS_DELETED = 0


Update rptPI
SET rptPI.IS_DELETED = 1,
	rptPI.[ACTIVE_FLAG] = 0
from  ReportingDB.[DBO].PROVIDER_INVENTORY_HISTORY rptPI 
left join [THM].[psp].[ProviderInventory] pspPI 
	  on  
		rptPI.[INVENTORY_ID]	= pspPI.[InventoryId] and   
		rptPI.[PROVIDER_ID]		= pspPI.[ProviderId]  and 
		rptPI.[LOCATION_ID]		= pspPI.[LocationId]  AND
		rptPI.[TREATMENTSERVICEPRODUCTMAP_ID] = pspPI.[TreatmentServiceProductMapId] and
		CONVERT(char(10),rptPI.CREATEDDATE,121) = CONVERT(char(10),pspPI.[CreatedDate],121)  
		and rptPI.[ACTIVE_FLAG]	= 1
	  where
			pspPI.[InventoryId] IS NULL 
		and pspPI.[ProviderId]  IS NULL 
		and pspPI.[LocationId]  IS NULL 
		and pspPI.[TreatmentServiceProductMapId]  IS NULL 
		AND  CONVERT(char(10),pspPI.[CreatedDate],121)  is null
	  