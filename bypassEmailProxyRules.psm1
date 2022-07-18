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

function format-bypassEmailProxyRulesFile {
   param (
      [parameter(valueFromPipeline = $true, mandatory = $true)]
      [string]               $filename,
      [parameter()]
      [System.Text.Encoding] $encoding = (new-object System.Text.UTF8Encoding $false)
   )

   process {

      $text       = [System.IO.File]::ReadAllText($ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($filename), $encoding)
      [string] $r = ''

      foreach ($c in $text.ToCharArray()) {

          [int] $n = $c

          if ($encoding.IsSingleByte) {

             $start = 0xb0 # 176

             if     ( $n -ge      48 -and  $n -le      57   ) { $r += [char] ($n + $start - 48) }
             elseif ( $n -ge  $start -and  $n -le  $start+9 ) { $r += [char] ($n - $start + 48) }
             else                                             { $r += $c                        }

          }
          else {

            if     ( $n -ge   48 -and  $n -le   57 ) { $r += [char] ($n + 8256) }
            elseif ( $n -ge 8304 -and  $n -le 8313 ) { $r += [char] ($n - 8256) }
            else                                     { $r += $c                 }
          }

      }

      [System.IO.File]::WriteAllText($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$filename.out"), $r, $encoding)
   }
}
