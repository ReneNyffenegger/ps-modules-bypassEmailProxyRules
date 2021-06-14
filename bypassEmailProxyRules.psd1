@{
   RootModule        = 'bypassEmailProxyRules.psm1'
   ModuleVersion     = '0.2'
   FunctionsToExport = @(
     'format-saveEmailProxyExtension'         ,
     'format-unsaveEmailProxyExtension'       ,
     'new-bypassEmailProxyRulesZipArchive'    ,
     'expand-bypassEmailProxyRulesZipArchive'
   )
}
