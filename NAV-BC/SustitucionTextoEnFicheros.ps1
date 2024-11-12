Function ReplaceTextInTextFile{
    Param([string]$CodeunitId,
          [String]$TextToReplace,
          [String]$ReplacementText)
    Echo 'Sustituyendo ' $TextToReplace $ReplacementText
    $CodeunitTextFilePath = $RutaBase + '\COD' + $CodeunitId + '.txt'
    $text = get-content -path $CodeunitTextFilePath -Encoding default
    # $newText = $text -replace $TextToReplace,$ReplacementText
    # $newText > $TextFilePath
    $text -replace $TextToReplace,$ReplacementText|out-file -FilePath $CodeunitTextFilePath -Encoding default
    
}   
Function CrearDirectorio{
    Param([string]$RutaReferencia)
    echo ("Creando directorio " + $RutaReferencia)
    if (Test-Path $RutaReferencia) 
        {
        Remove-Item ($RutaReferencia) -Recurse | out-null
        }
    New-Item -Path $RutaReferencia -ItemType "directory" | out-null
}

cls

$RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client CU67\NavModelTools.ps1'
Import-Module $RutaModulo

$Ficheros = (Get-Item ('C:\Users\am\Desktop\Sustitución texto PS\*.txt'))
foreach ($Ficheros in $Ficheros)
    {
    if (-not (Test-Path ('C:\Users\am\Desktop\Sustitución texto PS\' + $Ficheros.BaseName)))
        {
        CrearDirectorio $Ficheros.BaseName
        }
    Split-NAVApplicationObjectFile -Source $Ficheros `
                                    -Destination ('C:\Users\am\Desktop\Sustitución texto PS\' + $Ficheros.BaseName) `
                                    -Force
    }

$RutaBase = 'C:\Users\am\Desktop\Sustitución texto PS\' + $Ficheros.BaseName

ReplaceTextInTextFile '7239202' 'PostIEPNRProductEntryIEPNRJnlLine' 'PostIEPNRProdEntryIEPNRJnlLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupSalesHeader' 'FindIEPNRPostSetSalesHdr'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupSalesInvoiceLine' 'FindIEPNRPostSetSalesInvLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupSalesCrMemoLine' 'FindPNRPostSetSalesCrMemoLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupPurchaseHeader' 'FindIEPNRPostSetPurchHdr'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupPurchaseLine' 'FindIEPNRPostingSetupPurchLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupPurchInvoiceLine' 'FindIEPNRPostSetPurchInvLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupPurchCrMemoLine' 'FindPNRPostSetPurchCrMemoLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferHeaderShipment' 'FindIEPNRPostSetTransfHdrShpmt'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferLineShipment' 'FindPNRPostSetTransfLineShpmt'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferShipmetLine' 'FindPNRPostSetTransfShpmtLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferHeaderReceipt' 'FindIEPNRPostSetTransfHdrRcpt'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferLineReceipt' 'FindIEPNRPostSetTransfLineRcpt'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferReceiptLine' 'FindIEPNRPostSetTransfRcptLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupItemJournalLine' 'FindIEPNRPostSetItemJnlLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupAssemblyHeader' 'FindIEPNRPostSetAssemblyHdr'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupPostedAssemblyHeader' 'FindPNRPostSetPostedAssHdr'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupProdOrderLine' 'FindIEPNRPostSetProdOrderLine'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupItemLedgerEntry' 'FindPNRPostSetItemLedgerEntry'
ReplaceTextInTextFile '7239202' 'IsInternalProductionPlasticItem' 'IsInternalProdionPlasticItem'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferShipmentHeader' 'FindIEPNRPostSetTransfShpmtHdr'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferShipmentLine' 'FindPNRPostSetTransfShpmtLine2'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferReceiptHeader' 'FindIEPNRPostSetTransfRcptHdr'
ReplaceTextInTextFile '7239202' 'FindIEPNRPostingSetupTransferReceiptLineObsoleto' 'FindPNRostSetTransfRcptLineObs'
ReplaceTextInTextFile '7239204' 'NavigateRelatedIEPNRProductEntries' 'NavigateRelatedPNRProdEntries'
ReplaceTextInTextFile '7239205' 'OnBeforeCheckIEPNRProductJournalLine' 'OnBeforeCheckIEPNRProdJnlLine'
ReplaceTextInTextFile '7239205' 'OnAfterCheckIEPNRProductJournalLine' 'OnAfterCheckIEPNRProdJnlLine'
ReplaceTextInTextFile '7239206' 'OnBeforePostJournalIEPNRProductLine' 'OnBeforePostJnlIEPNRProdLine'
ReplaceTextInTextFile '7239206' 'OnAfterPostJournalIEPNRProductLine' 'OnAfterPostJnlIEPNRProdLine'
ReplaceTextInTextFile '7239206' 'OnBeforeCreateIEPNRProductEntry' 'OnBeforeCreateIEPNRProdEntry'
ReplaceTextInTextFile '7239206' 'IsPurchaserAllowedTransferShipment' 'IsPurchaserAllowedTransfShpmt'
ReplaceTextInTextFile '7239206' 'IsPurchaserAllowedTransferReceipt' 'IsPurchaserAllowedTransfRcpt'
ReplaceTextInTextFile '7239206' 'IsManufacturerAllowedTransferShipment' 'IsManufactAllowedTransfShpmt'
ReplaceTextInTextFile '7239206' 'IsManufacturerAllowedTransferReceipt' 'IsManufactAllowedTransferRcpt'
ReplaceTextInTextFile '7239206' 'IsManufacturerAllowedProduction' 'IsManufacturerAllowedPO'
ReplaceTextInTextFile '7239206' 'IsManufacturerAllowedDestruction' 'IsManufacturerAllowedDestruct'
ReplaceTextInTextFile '7239206' 'IsManufacturerAllowedAdjustment' 'IsManufacturerAllowedAdjust'
ReplaceTextInTextFile '7239208' 'OnBeforeCheckIEPNRProductJournalLine' 'OnBeforeCheckIEPNRProdJnlLine'
ReplaceTextInTextFile '7239208' 'OnAfterCheckIEPNRProductJournalLine' 'OnAfterCheckIEPNRProdJnlLine'
ReplaceTextInTextFile '7239210' 'SetSalesLineSourceFilterWithCalculationNormal' 'SetSaleLineSrcFiltWithNormCalc'
ReplaceTextInTextFile '7239210' 'CalculateIEPNRTaxAmountDiscountAmount' 'CalculatePNRTaxAmtDiscAmt'
ReplaceTextInTextFile '7239210' 'LineAmountIEPNRExcludedSalesLine' 'LineAmountPNRExcludedSalesLine'
ReplaceTextInTextFile '7239210' 'FindVATProdPostingGroupForIEPNRTaxEntry' 'FindVATProdPostGrForPNRTaxEnt'
ReplaceTextInTextFile '7239210' 'CreateDescriptionSalesInvoiceLine' 'CreateDescriptionSalesInvLine'
ReplaceTextInTextFile '7239210' 'CheckBreakDownSalesLineOnPosting' 'CheckBrdwnSalesLineOnPosting'
ReplaceTextInTextFile '7239210' 'CheckSalesIEPNRalesLinesCreatedOnPosting' 'ChkSalePNRSaleLinesCreatOnPost'
ReplaceTextInTextFile '7239210' 'CreateIEPNRAccountLinesFromSalesHeader' 'CreatePNRAccLinesFromSalesHdr'
ReplaceTextInTextFile '7239210' 'CreateIEPNRSalesLinesFromSalesLine' 'CreatePNRSalesLinesFrSalesLine'
ReplaceTextInTextFile '7239210' 'GetPostedDocumentCerticateArray' 'GetPostedDocumentCerticateArr'
ReplaceTextInTextFile '7239210' 'ShowNonReuPlasticBreakdownHeader' 'ShowNonReuPlasticBreakdownHdr'
ReplaceTextInTextFile '7239211' 'UpdatePlasticInfoOnValidateQuantity' 'UpdatePNRInfoOnValidateQty'
ReplaceTextInTextFile '7239211' 'DeletePlasticInfoFromSalesLineOnDelete' 'DeletePNRInfoFromSalesLine'
ReplaceTextInTextFile '7239211' 'MoveTempRecordsToSalesLineOnInsert' 'MoveTempRecordsToSalesLine'
ReplaceTextInTextFile '7239211' 'SubstractPlasticTaxAmountFromSalesAmount' 'SubstractIEPNRAmtFromSalesAmt'
ReplaceTextInTextFile '7239211' 'SubstractPlasticTaxAmountFromLineDiscountAmount' 'SubstractIEPNRAmtFrLineDiscAmt'
ReplaceTextInTextFile '7239211' 'TrasnferPricesIncludingExciseTaxFromCustomer' 'TransfPricesIncludingTaxFrCust'
ReplaceTextInTextFile '7239211' 'ProcessSalesInvoiceLineOnAfterInsertInvLineFromShptLine' 'OnAfterInsInvLineFromShptLine'
ReplaceTextInTextFile '7239211' 'CopyIEPNROnAfterCopySalesInvoiceLine' 'CopyPNROnAfterCopySalesInvLine'
ReplaceTextInTextFile '7239211' 'CalcIEPNRLinesStatisticsInvoice' 'CalcIEPNRLinesStatisticsInv'
ReplaceTextInTextFile '7239211' 'CheckLineNumberBufferBeforeInsert' 'CheckLineNoBufferBeforeInsert'
ReplaceTextInTextFile '7239212' 'CopyNonReuPlasticBreakdownToObsoleto' 'CopyPNRBrdwnToObsoleto'
ReplaceTextInTextFile '7239229' 'UpdatePlasticInfoOnValidateQuantity' 'UpdatePNRInfoOnValidateQty'
ReplaceTextInTextFile '7239229' 'UpdatePlasticInfoOnValidateLocationCode' 'UpdatePNRInfoOnValidateLocCode'
ReplaceTextInTextFile '7239229' 'DeletePlasticInfoFromPurchaseHeaderOnDelete' 'DeletePNRInfoFromPurchHdr'
ReplaceTextInTextFile '7239229' 'DeletePlasticInfoFromPurchaseLineOnDelete' 'DeletePNRInfoFromPurchLine'
ReplaceTextInTextFile '7239229' 'MoveTempRecordsToPurchaseLineOnInsert' 'MoveTempRecordsToPurchLine'
ReplaceTextInTextFile '7239229' 'CreatePlasticInfoFromPurchaseLine' 'CreatePlasticInfoFromPurchLine'
ReplaceTextInTextFile '7239229' 'DeletePlasticInfoFromPurchaseLine' 'DeletePlasticInfoFromPurchLine'
ReplaceTextInTextFile '7239229' 'CreateIEPNRProdJnlLineFromNRPlasticBrdwn' 'CreatePNRProdJnlLineFrPNRBrdwn'
ReplaceTextInTextFile '7239229' 'ShowNonReuPlasticBreakdownHeader' 'ShowNonReuPlasticBreakdownHdr'
ReplaceTextInTextFile '7239229' 'ShowNonReuPlasticBreakdownInvHdr' 'ShowNonReuPlasticBrdwnInvHdr'
ReplaceTextInTextFile '7239229' 'ShowNonReuPlasticBreakdownInvLine' 'ShowNonReuPlasticBrdwnInvLine'
ReplaceTextInTextFile '7239229' 'ShowNonReuPlasticBreakdownCrMemoHdr' 'ShowPNRBrdwnCrMemoHdr'
ReplaceTextInTextFile '7239229' 'ShowNonReuPlasticBreakdownCrMemoLine' 'ShowPNRBrdwnCrMemoLine'
ReplaceTextInTextFile '7239229' 'CreatePlasticInfoFromPurchaseInvLine' 'CreatePNRInfoFromPurchInvLine'
ReplaceTextInTextFile '7239229' 'CreatePlasticInfoFromPurchaseCrMemoLine' 'CreatePNRInfoFrPurchCrMemoLine'
ReplaceTextInTextFile '7239230' 'UpdatePlasticInfoOnValidateQuantity' 'UpdatePNRInfoOnValidateQty'
ReplaceTextInTextFile '7239230' 'UpdatePlasticInfoOnValidateLocationCode' 'UpdatePNRInfoOnValidateLocCode'
ReplaceTextInTextFile '7239230' 'DeletePlasticInfoFromSalesHeaderOnDelete' 'DeletePNRInfoFromSalesHdr'
ReplaceTextInTextFile '7239230' 'DeletePlasticInfoFromSalesLineOnDelete' 'DeletePNRInfoFromSalesLine'
ReplaceTextInTextFile '7239230' 'MoveTempRecordsToSalesLineOnInsert' 'MoveTempRecToSalesLineOnInsert'
ReplaceTextInTextFile '7239230' 'DeletePlasticInfoFromSalesHeader' 'DeletePlasticInfoFromSalesHdr'
ReplaceTextInTextFile '7239230' 'CreateIEPNRProdJnlLineFromNRPlasticBrdwn' 'CreatePNRProdJnlLineFrPNRBrdwn'
ReplaceTextInTextFile '7239230' 'ShowNonReuPlasticBreakdownHeader' 'ShowNonReuPlasticBreakdownHdr'
ReplaceTextInTextFile '7239230' 'ShowNonReuPlasticBreakdownInvHdr' 'ShowNonReuPlasticBrdwnInvHdr'
ReplaceTextInTextFile '7239230' 'ShowNonReuPlasticBreakdownInvLine' 'ShowNonReuPlasticBrdwnInvLine'
ReplaceTextInTextFile '7239230' 'ShowNonReuPlasticBreakdownCrMemoHdr' 'ShowPNRBrdwnCrMemoHdr'
ReplaceTextInTextFile '7239230' 'ShowNonReuPlasticBreakdownCrMemoLine' 'ShowPNRBrdwnCrMemoLine'
ReplaceTextInTextFile '7239230' 'CreatePlasticInfoFromSalesInvoiceLine' 'CreatePNRInfoFromSalesInvLine'
ReplaceTextInTextFile '7239230' 'CreatePlasticInfoFromSalesCrMemoLine' 'CreatePNRInfoFrSalesCrMemoLine'
ReplaceTextInTextFile '7239231' 'UpdatePlasticInfoOnValidateQuantity' 'UpdatePNRInfoOnValidateQty'
ReplaceTextInTextFile '7239231' 'UpdatePlasticInfoOnValidateLocationCode' 'UpdatePNRInfoOnValidateLocCode'
ReplaceTextInTextFile '7239231' 'DeletePlasticInfoFromSalesLineOnDelete' 'DeletePNRInfoFromSalesLine'
ReplaceTextInTextFile '7239231' 'MoveTempRecordsToSalesLineOnInsert' 'MoveTempRecordsToSalesLine'
ReplaceTextInTextFile '7239231' 'CreatePlasticInfoFromProdOrderLine' 'CreatePNRInfoFromProdOrderLine'
ReplaceTextInTextFile '7239231' 'DeletePlasticInfoFromProdOrderLine' 'DeletePNRInfoFromProdOrderLine'
ReplaceTextInTextFile '7239231' 'SetPostedProdOrderLineSourceFilter' 'SetPostedProdOrdLineSrcFilter'
ReplaceTextInTextFile '7239231' 'CreateIEPNRProdJnlLineFromNRPlasticBrdwn' 'CreatePNRProdJnlLineFrPNRBrdwn'
ReplaceTextInTextFile '7239231' 'ShowNonReuPlasticBreakdownPOLine' 'ShowNonReuPlasticBrdwnPOLine'
ReplaceTextInTextFile '7239231' 'ShowNonReuPlasticBreakdownItemJnlLine' 'ShowPNRBrdwnItemJnlLine'
ReplaceTextInTextFile '7239231' 'CreateNRPlasticBreakdownFromPOLine' 'CreateNRPlasticBrdwnFromPOLine'
ReplaceTextInTextFile '7239231' 'CreatePlasticInfoFromItemLedgerEntry' 'CreatePNRInfoFrItemLedgerEntry'
ReplaceTextInTextFile '7239232' 'UpdatePlasticInfoOnValidateQuantity' 'UpdatePNRInfoOnValidateQty'
ReplaceTextInTextFile '7239232' 'UpdatePlasticInfoOnValidateLocationCode' 'UpdatePNRInfoOnValidateLocCode'
ReplaceTextInTextFile '7239232' 'DeletePlasticInfoFromAssemblyHdrOnDelete' 'DeletePNRInfoFrAssHdrOnDelete'
ReplaceTextInTextFile '7239232' 'MoveTempRecordsToSalesLineOnInsert' 'MoveTempRecordsToSalesLine'
ReplaceTextInTextFile '7239232' 'CreatePlasticInfoFromAssemblyHeader' 'CreatePNRInfoFromAssemblyHdr'
ReplaceTextInTextFile '7239232' 'DeletePlasticInfoFromAssemblyHeader' 'DeletePNRInfoFromAssemblyHdr'
ReplaceTextInTextFile '7239232' 'MoveTempRecordsToAssemblyHeader' 'MoveTempRecordsToAssemblyHdr'
ReplaceTextInTextFile '7239232' 'SetPostedAssemblyHeaderSourceFilter' 'SetPostedAssHdrSourceFilter'
ReplaceTextInTextFile '7239232' 'CreateIEPNRProdJnlLineFromNRPlasticBrdwn' 'CreatePNRProdJnlLineFrPNRBrdwn'
ReplaceTextInTextFile '7239232' 'ShowNonReuPlasticBreakdownHeader' 'ShowNonReuPlasticBreakdownHdr'
ReplaceTextInTextFile '7239232' 'ShowNonReuPlasticBreakdownPostedHeader' 'ShowPNRBrdwnPostedHdr'
ReplaceTextInTextFile '7239232' 'CreateNRPlasticBreakdownFromAssembyHdr' 'CreateNRPlasticBrdwnFromAssHdr'
ReplaceTextInTextFile '7239232' 'CreatePlasticInfoFromPostedAssemblyHeader' 'CreatePNRInfoFromPostedAssHdr'
ReplaceTextInTextFile '7239233' 'UpdatePlasticInfoOnValidateQuantity' 'UpdatePNRInfoOnValidateQty'
ReplaceTextInTextFile '7239233' 'UpdatePlasticInfoOnValidateFromLocationCode' 'UpdPNRInfoOnValidateFrLocCode'
ReplaceTextInTextFile '7239233' 'UpdatePlasticInfoOnValidateToLocationCode' 'UpdPNRInfoOnValidateToLocCode'
ReplaceTextInTextFile '7239233' 'DeletePlasticInfoFromTransferLineOnDelete' 'DeletePNRInfoFrTransfLineOnDel'
ReplaceTextInTextFile '7239233' 'DeletePlasticInfoFromTransferHeaderOnDelete' 'DeletePNRInfoFromTransfHdr'
ReplaceTextInTextFile '7239233' 'MoveTempRecordsToTransferLineOnInsert' 'MoveTempRecordsToTransfLine'
ReplaceTextInTextFile '7239233' 'OnAfterTransferShipmentHeaderInsert' 'OnAfterTransfShpmtHeaderInsert'
ReplaceTextInTextFile '7239233' 'OnAfterTransferShipmentLineInsert' 'OnAfterTransferShpmtLineInsert'
ReplaceTextInTextFile '7239233' 'CreatePlasticInfoFromTransferLine' 'CreatePNRInfoFromTransfLine'
ReplaceTextInTextFile '7239233' 'DeletePlasticInfoFromTransferLine' 'DeletePNRInfoFromTransfLine'
ReplaceTextInTextFile '7239233' 'DeletePlasticInfoFromTransferHeader' 'DeletePlasticInfoFromTransfHdr'
ReplaceTextInTextFile '7239233' 'CreateIEPNRProdJnlLineFromNRPlasticBrdwn' 'CreatePNRProdJnlLineFrPNRBrdwn'
ReplaceTextInTextFile '7239233' 'ShowNonReuPlasticBreakdownHeader' 'ShowNonReuPlasticBreakdownHdr'
ReplaceTextInTextFile '7239233' 'ShowNonReuPlasticBreakdownShptHdr' 'ShowNonReuPlasticBrdwnShptHdr'
ReplaceTextInTextFile '7239233' 'ShowNonReuPlasticBreakdownShptLine' 'ShowNonReuPlasticBrdwnShptLine'
ReplaceTextInTextFile '7239233' 'SetTransferShipmentHeaderFilter' 'SetTransferShpmtHeaderFilter'
ReplaceTextInTextFile '7239233' 'SetTransferShipmentLineFilter' 'SetTransferShpmtLineFilter'
ReplaceTextInTextFile '7239233' 'CreatePlasticInfoFromTransferShipmentLine' 'CreatePNRInfoFrTransfShpmtLine'
ReplaceTextInTextFile '7239234' 'UpdatePlasticInfoOnValidateQuantity' 'UpdatePNRInfoOnValidateQty'
ReplaceTextInTextFile '7239234' 'UpdatePlasticInfoOnValidateFromLocationCode' 'UpdPNRInfoOnValidateFrLocCode'
ReplaceTextInTextFile '7239234' 'UpdatePlasticInfoOnValidateToLocationCode' 'UpdPNRInfoOnValidateToLocCode'
ReplaceTextInTextFile '7239234' 'DeletePlasticInfoFromTransferHeaderOnDelete' 'DeletePNRInfoFromTransfHdr'
ReplaceTextInTextFile '7239234' 'DeletePlasticInfoFromTransferLineOnDelete' 'DelPNRInfoFromTransfLineOnDel'
ReplaceTextInTextFile '7239234' 'MoveTempRecordsToTransferLineOnInsert' 'MoveTempRecordsToTransfLine'
ReplaceTextInTextFile '7239234' 'CreatePlasticInfoFromTransferLine' 'CreatePNRInfoFromTransfLine'
ReplaceTextInTextFile '7239234' 'DeletePlasticInfoFromTransferHeader' 'DeletePlasticInfoFromTransfHdr'
ReplaceTextInTextFile '7239234' 'DeletePlasticInfoFromTransferLine' 'DeletePNRInfoFromTransfLine'
ReplaceTextInTextFile '7239234' 'CreateIEPNRProdJnlLineFromNRPlasticBrdwn' 'CreatePNRProdJnlLineFrPNRBrdwn'
ReplaceTextInTextFile '7239234' 'ShowNonReuPlasticBreakdownHeader' 'ShowNonReuPlasticBreakdownHdr'
ReplaceTextInTextFile '7239234' 'ShowNonReuPlasticBreakdownShptHdr' 'ShowNonReuPlasticBrdwnShptHdr'
ReplaceTextInTextFile '7239234' 'ShowNonReuPlasticBreakdownShptLine' 'ShowNonReuPlasticBrdwnShptLine'
ReplaceTextInTextFile '7239234' 'CreatePlasticInfoFromTransferReceiptLine' 'CreatePNRInfoFrTransfRcptLine'
ReplaceTextInTextFile '7239235' 'TransferShipmentProcessing' 'TransferShpmtProcessing'


Join-NAVApplicationObjectFile -Source ($RutaBase + "\*.txt") -Destination ('C:\Users\am\Desktop\Sustitución texto PS\Resultado.txt') -Force