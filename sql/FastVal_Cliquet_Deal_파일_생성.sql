-- Cliquet

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
                                    ),1,1,'')
                        , ',',
                        (
                            SELECT STUFF((
                                            SELECT CONCAT(',[Name=', Name, ',', 'Value=', Value,
                                                            ']')
                                            FROM [MarketRisk].[dbo].[AID_FastValProduct_Macros]
                                            WHERE [Object] = 'Cliquet'
                                            AND [Reference] = 'NA'
                                            
                                            FOR XML PATH('')
                                            ), 1, 1, '')
                        ), ']'))
        AS Macros
    FROM [MarketRisk].[dbo].[AID_FastValProduct_Macros] AS E
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
                        WHERE [Object] = 'Cliquet'
                        
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
                        WHERE [Object] = 'Cliquet'
                        
                        FOR XML PATH('')
                        ), 1, 1, '')
                    ,']'))
        AS AssetYieldCurves
                
      ,'' AS AuxTables

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
                        WHERE [Object] = 'Cliquet'
                        
                        FOR XML PATH('')
                        ), 1, 1, '')
                ,']'))
        AS Calibrations

        ,'' AS CustomSchedules

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
   WHERE [Name] = 'Cliquet'
     AND [Base_Date] = '@BaseDate'
     AND [RWA_YN] = '@RWA_YN'
     AND [Tag_Book_Node] != 'HK';