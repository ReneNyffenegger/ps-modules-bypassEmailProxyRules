@{
   RootModule        = 'bypassEmailProxyRules.psm1'
   ModuleVersion     = '0.3'
   FunctionsToExport = @(
     'format-saveEmailProxyExtension'         ,
     'format-unsaveEmailProxyExtension'       ,
     'new-bypassEmailProxyRulesZipArchive'    ,
     'expand-bypassEmailProxyRulesZipArchive' ,
     'format-bypassEmailProxyRulesFile'
   )
}
