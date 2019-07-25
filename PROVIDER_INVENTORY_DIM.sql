USE [ReportingDB]
GO

/****** Object:  Table [psp].[ProviderInventory]    Script Date: 6/4/2019 6:14:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


DROP TABLE [DBO].PROVIDER_INVENTORY_HISTORY

CREATE TABLE [DBO].PROVIDER_INVENTORY_HISTORY(
	[INVENTORY_ID] [UNIQUEIDENTIFIER] NOT NULL,
	[PROVIDER_ID] [UNIQUEIDENTIFIER] NOT NULL,
	[LOCATION_ID] [UNIQUEIDENTIFIER] NOT NULL,
	[TREATMENTSERVICEPRODUCTMAP_ID] [UNIQUEIDENTIFIER] NOT NULL,
	[AMOUNT] [DECIMAL](18, 0) NULL,
	[ACTIVE_FLAG] [BIT] NOT NULL,
	[CREATEDDATE] [DATE] NOT NULL,
	[MODIFIEDDATE] [DATE] NOT NULL,
 
) ON [PRIMARY]
GO

/****** Object:  Index [PK_PROVIDER_INVENTORY_HISTORY]    Script Date: 6/19/2019 8:46:34 AM ******/
CREATE CLUSTERED INDEX [PK_PROVIDER_INVENTORY_HISTORY] ON [dbo].[PROVIDER_INVENTORY_HISTORY]
(
	[INVENTORY_ID] ASC,
	[PROVIDER_ID] ASC,
	[LOCATION_ID] ASC,
	[TREATMENTSERVICEPRODUCTMAP_ID] ASC,
	[CREATEDDATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO



/****** Object:  Index [IDX_PROVIDER_INVENTORY_HISTORY_ACTIVE_FLAG]    Script Date: 6/19/2019 8:46:44 AM ******/
CREATE NONCLUSTERED INDEX [IDX_PROVIDER_INVENTORY_HISTORY_ACTIVE_FLAG] ON [dbo].[PROVIDER_INVENTORY_HISTORY]
(
	[ACTIVE_FLAG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO




Insert into [DBO].PROVIDER_INVENTORY_HISTORY
( [INVENTORY_ID]      ,[PROVIDER_ID]      ,[LOCATION_ID]      ,[TREATMENTSERVICEPRODUCTMAP_ID]      ,[AMOUNT]      ,[ACTIVE_FLAG]
      ,[CREATEDDATE]      ,[MODIFIEDDATE]	  )
SELECT [InventoryId]
      ,[ProviderId]
      ,[LocationId]
      ,[TreatmentServiceProductMapId]
      ,pspPI.[Amount]
      , 1 [IsActive]
      ,pspPI.[CreatedDate]
      ,ISNULL(pspPI.[ModifiedDate],getdate())
  FROM [THM].[psp].[ProviderInventory] pspPI 
left join [DBO].PROVIDER_INVENTORY_HISTORY rptPI
  on pspPI.[InventoryId] = rptPI.[INVENTORY_ID] AND 
	 pspPI.[ProviderId] = rptPI.[PROVIDER_ID] AND 
	 pspPI.[LocationId] = rptPI.[LOCATION_ID] AND 
	 pspPI.[TreatmentServiceProductMapId] = rptPI.[TREATMENTSERVICEPRODUCTMAP_ID]  
  where
	  rptPI.[INVENTORY_ID]  IS NULL 
  and rptPI.[PROVIDER_ID]  IS NULL 
  and rptPI.[LOCATION_ID]  IS NULL 
  and rptPI.[TREATMENTSERVICEPRODUCTMAP_ID]  IS NULL 
  and [TreatmentServiceProductMapId] is not null
  --and pspPI.[Amount] <> rptPI.[AMOUNT]


  select * from [DBO].PROVIDER_INVENTORY_HISTORY order by [MODIFIEDDATE] desc




  
alter table dbo.[PROVIDER_INVENTORY_HISTORY] add [IS_DELETED] [bit]  NULL
update dbo.[PROVIDER_INVENTORY_HISTORY] SET IS_DELETED = 0
