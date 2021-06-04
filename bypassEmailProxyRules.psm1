set-strictMode -version latest
function format-saveEmailProxyExtension {

   param (
      [parameter (mandatory=$true)]
      [string[]]   $fileNames
   )
   return ($fileNames -replace '(?!.*\.)(.)', '$1-')
}

function format-unsaveEmailProxyExtension {
   param (
      [parameter (mandatory=$true)]
      [string[]]    $fileNames
   )

   return ($fileNames -replace '(?!.*\.)(.-)', '$1')
}
