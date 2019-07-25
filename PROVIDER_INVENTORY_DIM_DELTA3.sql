Use ReportingDB
go


BEGIN TRAN

	--Insert new records
	Insert into ReportingDB.[DBO].PROVIDER_INVENTORY_HISTORY
	( [INVENTORY_ID]      ,[PROVIDER_ID]      ,[LOCATION_ID]      ,[TREATMENTSERVICEPRODUCTMAP_ID]      ,[AMOUNT]      ,[ACTIVE_FLAG]
		  ,[CREATEDDATE]      ,[MODIFIEDDATE],[IS_DELETED]  )
	SELECT [InventoryId]
		  ,[ProviderId]
		  ,[LocationId]
		  ,[TreatmentServiceProductMapId]
		  ,pspPI.[Amount]
		  , 1 [IsActive]
		  ,pspPI.[CreatedDate]
		  ,ISNULL(pspPI.[ModifiedDate],getdate())
		  ,0
	  FROM [THM].[psp].[ProviderInventory] pspPI 
	left join ReportingDB.[DBO].PROVIDER_INVENTORY_HISTORY rptPI
	  on pspPI.[InventoryId] = rptPI.[INVENTORY_ID] AND 
		 pspPI.[ProviderId] = rptPI.[PROVIDER_ID] AND 
		 pspPI.[LocationId] = rptPI.[LOCATION_ID] AND 
		 pspPI.[TreatmentServiceProductMapId] = rptPI.[TREATMENTSERVICEPRODUCTMAP_ID]  
		 AND  CONVERT(char(10),pspPI.[CreatedDate],121) = CONVERT(char(10),rptPI.CREATEDDATE,121)
	  where
		  rptPI.[INVENTORY_ID]  IS NULL 
	  and rptPI.[PROVIDER_ID]  IS NULL 
	  and rptPI.[LOCATION_ID]  IS NULL 
	  and rptPI.[TREATMENTSERVICEPRODUCTMAP_ID]  IS NULL 
	  and [TreatmentServiceProductMapId] is not null
	  AND  CONVERT(char(10),rptPI.CREATEDDATE,121) is null



	  ---Update flag for old records
	UPDATE rptPI
	SET rptPI.ACTIVE_FLAG = 0
	 FROM [THM].[psp].[ProviderInventory] pspPI 
	 join ReportingDB.[DBO].PROVIDER_INVENTORY_HISTORY rptPI
	  on pspPI.[InventoryId] = rptPI.[INVENTORY_ID] AND 
		 pspPI.[ProviderId] = rptPI.[PROVIDER_ID] AND 
		 pspPI.[LocationId] = rptPI.[LOCATION_ID] AND 
		 pspPI.[TreatmentServiceProductMapId] = rptPI.[TREATMENTSERVICEPRODUCTMAP_ID]  
		 and CONVERT(char(10),pspPI.[CreatedDate],121) = CONVERT(char(10),rptPI.CREATEDDATE,121) 
	  where
		  ISNULL(pspPI.[Amount],0.0) <> ISNULL(rptPI.[AMOUNT],0.0)
		   and rptPI.ACTIVE_FLAG = 1

	--INSERT LATEST records with active flag
	Insert into ReportingDB.[DBO].PROVIDER_INVENTORY_HISTORY
	( [INVENTORY_ID]      ,[PROVIDER_ID]      ,[LOCATION_ID]      ,[TREATMENTSERVICEPRODUCTMAP_ID]      ,[AMOUNT]      ,[ACTIVE_FLAG]
		  ,[CREATEDDATE]      ,[MODIFIEDDATE],[IS_DELETED]	  )
	   
	SELECT [InventoryId]
		  ,[ProviderId]
		  ,[LocationId]
		  ,[TreatmentServiceProductMapId]
		  ,pspPI.[Amount]
		  , 1 [IsActive]
		  ,pspPI.[CreatedDate]
		  ,ISNULL(pspPI.[ModifiedDate],getdate())
		  ,0
			FROM [THM].[psp].[ProviderInventory] pspPI 
	 left join ReportingDB.[DBO].PROVIDER_INVENTORY_HISTORY rptPI 
	  on pspPI.[InventoryId] = rptPI.[INVENTORY_ID] AND 
		 pspPI.[ProviderId] = rptPI.[PROVIDER_ID] AND 
		 pspPI.[LocationId] = rptPI.[LOCATION_ID] AND 
		 pspPI.[TreatmentServiceProductMapId] = rptPI.[TREATMENTSERVICEPRODUCTMAP_ID]  
		 and CONVERT(char(10),pspPI.[CreatedDate],121) = CONVERT(char(10),rptPI.CREATEDDATE,121) 	 
		  and rptPI.[ACTIVE_FLAG] <> 0
	  where
		  rptPI.[INVENTORY_ID]  IS NULL 
	  and rptPI.[PROVIDER_ID]  IS NULL 
	  and rptPI.[LOCATION_ID]  IS NULL 
	  and rptPI.[TREATMENTSERVICEPRODUCTMAP_ID]  IS NULL 
	  and [TreatmentServiceProductMapId] is not null
	  AND  CONVERT(char(10),rptPI.CREATEDDATE,121) is null
	 
	
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
		
	  where
			rptPI.IS_DELETED	= 0	and 
			--rptPI.[ACTIVE_FLAG]	= 1 and
			pspPI.[InventoryId] IS NULL 
		and pspPI.[ProviderId]  IS NULL 
		and pspPI.[LocationId]  IS NULL 
		and pspPI.[TreatmentServiceProductMapId]  IS NULL 
		and  CONVERT(char(10),pspPI.[CreatedDate],121)  is null

COMMIT
