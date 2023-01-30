function Get-NAVServerSession2
{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String]$ServerInstance,
        [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [String]$Id="Default"
    )
    BEGIN
    {
        $ResultObjectArray =  @()   
        $CurrentServerInstance = Get-NAVServerInstance -ServerInstance $ServerInstance
    }
    PROCESS
    {   
        $CurrentTenant = Get-NAVTenant -ServerInstance $ServerInstance -Tenant $Id
        $AllSession = $CurrentTenant | Get-NAVServerSession
        
        foreach ($Session in $AllSession)
        {
            $ResultObject = New-Object System.Object
            $ResultObject | Add-Member -type NoteProperty -name ServerInstance -value $CurrentTenant.ServerInstance
            $ResultObject | Add-Member -type NoteProperty -name SessionId -value $Session.SessionId
            $ResultObject | Add-Member -Type NoteProperty -Name Tenant -Value $CurrentTenant.Id
            $ResultObjectArray += $ResultObject
        }
    }
    END
    {
        $ResultObjectArray
    }
}
