function Replace-Arguments {
    param (
        [string]
        # Specifies the base folder for the replacement.
        $FolferPath = "\\HOTH\Software\Navision\Utilidades\RoleTailored Clients\Links\",
        [Parameter(Mandatory=$true)]
        [string]
        # specifies the argument text to be replaced.
        $ArgumentsFrom,
        [Parameter(Mandatory=$true)]
        [string] 
        # The string to replace all occurrences of $argumentsFrom. 
        $ArgumentsTo
    )

    $fileName ="*.lnk"   
    $fileList = Get-ChildItem -Path $folferPath -Filter $fileName -Recurse  | Where-Object { $_.Attributes -ne "Directory"} | select -ExpandProperty FullName 
    $obj = New-Object -ComObject WScript.Shell 
    
    ForEach($filePath in $fileList) 
    { 
        Write-Output ('Fichero: ' + $filePath)

        $link = $obj.CreateShortcut($filePath) 
        #[string]$path = $link.TargetPath  
        #[string]$path = [string]$path.Replace($from.tostring(),$to.ToString()) 
        #If you need workingdirectory change please uncomment the below line.
        #$link.WorkingDirectory = [string]$WorkingDirectory.Replace($from.tostring(),$to.ToString())  
        #$link.TargetPath = [string]$path  
        # $link.Arguments = $link.Arguments.Replace($from.tostring(),$to.ToString())  
        
        $newArgs =  $link.Arguments -ireplace [regex]::Escape($ArgumentsFrom.tostring()), $ArgumentsTo.ToString()
        $link.Arguments = [string]$newArgs 
        $link.Save() 

        Write-Output ('  Argumentos: ' + $link.Arguments)    
    } 

    <#
        .SYNOPSIS
        Replace the given text of the link argument

        .DESCRIPTION
        Replace the given text of the link argument

        .LINK
        https://docs.microsoft.com/en-us/dynamics-nav/starting-the-windows-client-at-the-command-prompt

        .EXAMPLE
        Replace-Arguments -folferPath "\\HOTH\Software\Navision\Utilidades\RoleTailored Clients\Links\" -argumentsFrom "HOTH\SQL2K16" -argumentsTo "CORUSCANT\SQL2K16"
    #>
}