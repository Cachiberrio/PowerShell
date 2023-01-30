function Invoke-SQL {
    param(
        [string] $dataSource = ".\SQLEXPRESS",
        [string] $Database = "MasterData",
        [string] $sqlCommand = $(throw "Please specify a query.")
      )
 
    $connectionString = "Data Source=$dataSource; " +
            "Integrated Security=SSPI; " +
            "Initial Catalog=$Database"
 
    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $command.CommandTimeout = 0;
    $connection.Open()
 
    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
       
    if ($dataset) {
        $adapter.Fill($dataSet) | Out-Null
    }
    
    $connection.Close()
    $dataSet.Tables
 

}