-- Step Down

WITH A AS
(
    SELECT DISTINCT [Reference]
            ,(SELECT CONCAT('[', STUFF((
                                        SELECT CONCAT(',[Name=', Name, ',', 'YieldCurveName=', YieldCurveName, ',',
                                                        'Type=', Type, ',', 'Model=', Model,
                                                        ']')
                                        FROM [MarketRisk].[dbo].[AID_FastValProduct_Assets] AS G
                                        WHERE G.[Reference] = H.[Reference]

                                        FOR XML PATH('')
                                        ),1 , 1, '')
                                        ,']'))
                AS Assets
    FROM [MarketRisk].[dbo].[AID_FastValProduct_Assets] AS H
)

, F AS
(
    SELECT DISTINCT [Reference]
        ,(SELECT CONCAT('[', STUFF((
                                    SELECT CONCAT(',[Name=', Name, ',', 'Value=', Value,
                                                    ']')
                                    FROM [MarektRisk].[dbo].[AID_FastValProduct_Macros] AS D
                                    WHERE D.[Reference] = E.[Reference]
                                    
                                    FOR XML PATH('')
                                    ), 1, 1, '')
                        , ',',
                        (
                            SELECT STUFF((
                                            SELECT CONCAT(',[Name=', Name, ',', 'Value=', Value,
                                                            ']')
                                            FROM [MarketRisk].[dbo].[AID_FastValProduct_Macros]
                                            WHERE [Object] = 'Step Down'
                                            AND [Reference] = 'NA'
                                            
                                            FOR XML PATH('')
                                            ), 1, 1, '')
                        ), ']'))
        AS Macros
    FROM [MarketRisk].[dbo].[AID_FastValProduct_Macros] AS E
)

,I AS
(
    SELECT DISTINCT [Reference]
        ,(SELECT CONCAT('[[Name=', Name, ',Schedules=[', STUFF((
                                                                SELECT CONCAT(',[FixingDate=', (convert(varchar(10), convert(datetime, [Schedules_FixingDate]), 101) + ' 00:00:00'), ',',
                                                                                'StartDate=', (convert(varchar(10), convert(datetime, [Schedules_StartDate]), 101) + ' 00:00:00'), ',',
                                                                                'EndDate=', (convert(varchar(10), convert(datetime, [Schedules_EndDate]), 101) + ' 00:00:00'), ',',
                                                                                'PayDate=', (convert(varchar(10), convert(datetime, [Schedules_PayDate]), 101) + ' 00:00:00'), ',',
                                                                                'Basis=', Schedules_Basis,
                                                                                ']')
                                                                FROM [MarketRisk].[dbo].[AID_FastValProduct_CustomSchedules] AS J
                                                                WHERE J.[Reference] = K.[Reference]
                                                                
                                                                FOR XML PATH('')
                                                                ), 1, 1, '')
                                                                ,']]]'))
        AS CustomSchedules
        FROM [MarketRisk].[dbo].[AID_FastValProduct_CustomSchedules] AS K
)

,L AS
(
        SELECT DISTINCT
                A.[Reference]
                ,A[Name]
                ,(CASE WHEN [Reference] != 'NA'
                  THEN (SELECT [MarketRisk].[dbo].[convertDateString3]([X], O, 'D', 'N'))
                  ELSE [X] END) AS X
                ,A.[Y]
                ,B.[Interpolation]
                ,B.[XType]
                ,B.[YType]

        FROM [MarketRisk].[dbo].[AID_FastValProduct_AuxTableData] AS A
        JOIN [MarketRisk].[dbo].[AID_FastValProduct_AuxTables] AS B
        ON A.[Name] = B.[Name]
        WHERE A.[Object] = 'Step Down'
)

,Z AS
(
    SELECT DISTINCT [Reference], [Name], [Interpolation], [XType], [YType],
                    CONCAT('[', STUFF((
                                        SELECT CONCAT(',[X=', X, ',', 'Y=', Y, ']')
                                        FROM L AS A
                                        WHERE A.[Reference] = B.[Reference]
                                        
                                        FOR XML PATH('')
                                        ), 1, 1, '')
                                        , ']')
                                        AS AuxTableData
    FROM L AS B
)

,ZZ AS
(
    SELECT DISTINCT [Reference]
            ,(SELECT CONCAT('[', STUFF((
                                        SELECT CONCAT(',[Name=', Name, ',', 'Interpolation=', Interpolation, ',', 'XType=', XType, ',', 'YType=', YType, ',',
                                                        'AuxTableData=', AuxTableData,
                                                        ']')
                                        FROM Z AS D
                                        WHERE D.[Reference] = E.[Reference]
                                        
                                        FOR XML PATH('')
                                        ), 1, 1, '')
                                        , ',',
                                        (SELECT STUFF((
                                                        SELECT CONCAT(',[Name=', Name, ',', 'Interpolation=', Interpolation, ',',
                                                                        'XType=', XType, ',', 'YType=', YType, ',',
                                                                        'AuxTableData=', AuxTableData,
                                                                        ']')
                                                        FROM Z
                                                        WHERE [Reference] = 'NA'
                                                        
                                                        FOR XML PATH('')
                                                        ), 1, 1, '')
                                        ), ']'))
            AS AuxTables
            FROM Z AS E
)


SELECT [Object]
      ,B.[Reference]
      ,[MtM]
      ,[Tag_Counterparty]
      ,[Tag_Netting_Set]
      ,[Tag_Product_Class]
      ,[Tag_Book_Node]
      ,[Tag_IMA_Eligible]
      ,[Tag_Is_Option]
      ,[Tag_Include_in_DRC]
      ,[Tag_Securitisation]
      ,[Tag_Include_in_RRAO]
      ,[Tag_Residual_Risk_Type]
      ,[Tag_Notional]
      ,[Tag_Qualifier_ISIN]
      ,[Tag_Index_Series]
      ,[Tag_Index_Family]
      ,[Tag_ISDA_Product_Name]
      ,[Tag_SADRC_Maturity]
      ,[Tag_Asset_Pool]
      ,[Tag_Securitisation_RW]
      ,[Tag_SA_DRC_Index]
      ,[Name]
      ,[Currency]
      ,[RequiredResult]

      ,(SELECT CONCAT('[',
                STUFF((
                        SELECT CONCAT(',[Schedule=', Schedule, ',', 'CustomScheduleName=', Custom_Schedule_Name, ',',
                                        'Start=', Start, ',', 'End=', End_, ',', 'Frequency=', Frequency, ',', 'Basis=', Basis, ',',
                                        'Lockout=', Lockout, ',', 'LookBack=', Look_Back, ',', 'SpotLag=', Spot_Lag, ',', 'Arrears=', Arrears, ',',
                                        'PayLag=', Pay_Lag, ',', 'Script=', Script, ',', 'Holidays=', Holidays,
                                        ']')
                        FROM [MarketRisk].[dbo].[AID_FastValProduct_AdepScripts]
                        WHERE [Object] = 'Step Down'
                        
                        FOR XML PATH('')
                        ),1,1,'')
                ,']'))
        AS AdepScripts

      ,[A].[Assets]

      ,(SELECT CONCAT('[',
                STUFF((
                        SELECT CONCAT(',[Name=', Name, ',', 'Model=', Model,
                                        ']')
                        FROM [MarketRisk].[dbo].[AID_FastValProduct_AssetYieldCurves]
                        WHERE [Object] = 'Step Down'
                        
                        FOR XML PATH('')
                        ), 1, 1, '')
                    ,']'))
        AS AssetYieldCurves
                
      ,[ZZ].[AuxTables]
      ,[F].[Macros]

      ,(SELECT CONCAT('[',
                STUFF((
                        SELECT CONCAT(',[Name=', Name, ',', 'Automatic=', Automatic, ',', 'AutomaticStrike=', AutomaticStrike, ',',
                                        'FixingDate=', FixingDate, ',', 'RollingConvention=', RollingConvention, ',', 'StartDate=', StartDate, ',',
                                        'SwapBasis=', SwapBasis, ',', 'Accuracy=', Accuracy, ',', 'BgmCalibrationType=', BgmCalibrationType, ',',
                                        'BgmFactors=', BgmFactors, ',', 'Correlation=', Correlation, ',', 'Correlation1_2=', Correlation1_2, ',',
                                        'Correlation1_3=', Correlation1_3, ',', 'CurveIndexType=', CurveIndexType, ',', 'DataColumns=', DataColumns, ',',
                                        'MeanReversion1-', MeanReversion1, ',', 'MeanReversion2=', MeanReversion2, ',', 'Model=', Model, ',',
                                        'Skew=', Skew, ',', 'Steps=', Steps, ',', 'Type=', Type, ',', 'VegaWeighting=', VegaWeighting, ',',
                                        ']')
                        FROM [MarketRisk].[dbo].[AID_FastValProduct_Calibrations]
                        WHERE [Object] = 'Step Down'
                        
                        FOR XML PATH('')
                        ), 1, 1, '')
                ,']'))
        AS Calibrations

        ,[I].[CustomSchedules]

        ,[Greek]

        ,'[Accuracy=' + [PricingMethod_Accuracy] + ','
          + 'AdjustLVHybridCalib=' + [PricingMethod_AdjustLVHybridCalib] + ','
          + 'CalibrationName=' + [PricingMethod_CalibrationName] + ','
          + 'Correlation=' + [PricingMethod_Correlation] + ','
          + 'IncludePaymentsToday=' + [PricingMethod_IncludePaymentsToday] + ','
          + 'Nodes=' + [PricingMethod_Nodes] + ','
          + 'NodesX=' + [PricingMethod_NodesX] + ','
          + 'NodesY=' + [PricingMethod_NodesY] + ','
          + 'Paths=' + [PricingMethod_Paths] + ','
          + 'PlotData=' + [PricingMethod_PlotData] + ','
          + 'Points=' + [PricingMethod_Points] + ','
          + 'PricingMethod=' + [PricingMethod_PricingMethod] + ','
          + 'RegressionBatchSize=' + [PricingMethod_RegressionBatchSize] + ','
          + 'StandardDeviation=' + [PricingMethod_StandaradDeviation] + ','
          + 'Steps=' + [PricingMethod_Steps] + ','
          + 'ThetaX=' + [PricingMethod_ThetaX] + ','
          + 'ThetaY=' + [PricingMethod_ThetaY] + ','
          + 'Type=' + [PricingMethod_Type] + ','
          + 'VisualisationProperties=' + [PricingMethod_VisualisationProperties]
          + ']'
          AS PricingMethod

        ,[RiskyDiscounting]
        ,[SabrParameters]

    FROM [MarketRisk].[dbo].[AID_FastValProducts] AS B
    JOIN [A] on B.[Reference] = [A].[Reference]
    JOIN [F] on B.[Reference] = [F].[Reference]
    JOIN [I] ON B.[Reference] = [I].[Reference]
    JOIN [ZZ] ON B.[Reference] = [ZZ].[Reference]
   WHERE [Name] = 'Step Down'
     AND [Base_Date] = '@BaseDate'
     AND [RWA_YN] = '@RWA_YN'
     AND [Tag_Book_Node] != 'HK';