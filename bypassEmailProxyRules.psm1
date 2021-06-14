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

   return ($fileNames -replace '(?!.*\.)(?:(.)-)', '$1')
}

function new-bypassEmailProxyRulesZipArchive {

   param (
      [parameter (mandatory=$true)]
      [string]    $dirName,
      [parameter (mandatory=$true)]
      [string]    $zipName
   )

   $zip = new-zipArchive $zipName

   get-childItem  -path $dirName -recurse -name -attributes !directory | foreach-object {

      $entry_name = format-saveEmailProxyExtension $_

      add-zipEntry "$dirName/$_"   $entry_name   $zip
   }

   close-zipArchive $zip
}

function expand-bypassEmailProxyRulesZipArchive {

   param (
      [parameter (mandatory=$true)]
      [string]    $zipName,
      [parameter (mandatory=$true)]
      [string]    $destDirName
   )

   $zip = open-zipArchive $zipName

   foreach ($entry in $zip.entries) {

      $orig_name = "$destDirName/" + (format-unsaveEmailProxyExtension ($entry.FullName))

      $abs_file = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($orig_name)
      $abs_path = $ExecutionContext.SessionState.Path.ParseParent($abs_file, $null);

      if (-not (test-path $abs_path)) {
         $null = new-item $abs_path -type directory
      }

     [System.IO.Compression.ZipFileExtensions]::ExtractToFile(
        $entry,
        $abs_file,
        $true  # overwrite
      )
   }

   close-zipArchive $zip
}
