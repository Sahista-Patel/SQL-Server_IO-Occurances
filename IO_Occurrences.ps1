<#
.SYNOPSIS
    This script will give I/O Ocuurances beyond threshold details for SQL Server.
    Gives the email alert as well as HTML file with the important detail for passed servers in server list.
    
.DESCRIPTION
    Process Name, IO Data (Bytes/s), Data (Operations/Sec), 
    Other (Bytes/Sec), Other (Operations/Sec), 
    Read (Bytes/Sec), Read (Operations/Sec),
    Write (Bytes/Sec), Write (Operations/Sec).
    It will send an email, if scheduled then it is monitoring technique for I/O Occurances check on bunch of servers during patching.
    
.INPUTS
    Server List - txt file with the name of the machines/servers which to examine.
    Please set varibles like server list path, output file path, threshold, E-Mail id and password as and when guided by comment through code.

.EXAMPLE
    .\IO_Occurances.ps1
    This will execute the script and gives HTML file and email with the details in body.

.NOTES
    PUBLIC
    SqlServer Module need to be installed if not than type below command in powershell prompt.
    Install-Module -Name SqlServer
    This scipt must be executed after patching and if Precheck script used before patching then only.

.AUTHOR
    Harsh Parecha
    Sahista Patel
#>


Import-Module SqlServer

#Set Email From
$EmailFrom = “example@outlook.com”

#Set Email To
$EmailTo = “example@outlook.com"

#Set Email Subject
$Subject = “IO-Occurrence(s) Report”

#Set SMTP Server Details
$SMTPServer = “smtp.outlook.com”

$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)

$SMTPClient.Credentials = New-Object System.Net.NetworkCredential(“example@outlook.com”, “Password”);

$ServerList = "Path\server_list.txt"
$HTML = "Path\IO_Report.html"
$count = 0
$Row = @()

$date = Get-Date

$obj=Get-Content -Path $ServerList

#Set Threshold
$threshold = 30
$id = 0

$Row = '<html>
            <head>
                <style type="text/css">
                    .tftable {font-size:12px;color:#333333;width:100%;border-width: 1px;border-color: #729ea5;border-collapse: collapse;}
                    .tftable th {font-size:12px;background-color:#acc8cc;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;text-align:left;}
                    .caption1 {font-size:28px;background-color:#e6983b;border-width: 1px; height: 35px;border-style: solid;border-color: #729ea5;text-align:left; vertical-align:middle; font-weight: bold;}
                    .tftable tr {background-color:#ffffff;}
                    .tftable td {font-size:12px;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;}
                    .tftable tr:hover {background-color:#ffff99;}
                    .Success {background-color:#ff3300;}
                    .Failed {background-color:#33cc33;}
                </style>
                <title>IO occurrence(s) Status</title>
            </head>
            <h2>IO occurrence(s) Status on '+ $date +'</h2>
            <body>'

[System.IO.File]::ReadLines($ServerList) | ForEach-Object {
    
    try{
        
        $count += 1
      
        $ol = Get-WmiObject -Class Win32_Service -ComputerName "$_"
    if ($ol -ne $null){
        
                $properties=@(
                    @{Name="Process Name"; Expression = {$_.Name}},
                    @{Name="IO Data (Bytes/s)"; Expression = {$_.IODataBytesPersec}},
                    @{Name="Data (Operations/Sec)"; Expression = {$_.IODataOperationsPersec}},
                    @{Name="Other (Bytes/Sec)"; Expression = {$_.IOOtherBytesPersec}},
                    @{Name="Other (Operations/Sec)"; Expression = {$_.IOOtherOperationsPersec}},
                    @{Name="Read (Bytes/Sec)"; Expression = {$_.IOReadBytesPersec}},
                    @{Name="Read (Operations/Sec)"; Expression = {$_.IOReadOperationsPersec}},
                    @{Name="Write (Bytes/Sec)"; Expression = {$_.IOWriteBytesPersec}},
                    @{Name="Write (Operations/Sec)"; Expression = {$_.IOWriteOperationsPersec}}
                )

                $IO = Get-WmiObject Win32_PerfFormattedData_PerfProc_Process | Where-Object { $_.Name -like '*sql*' } | Sort-Object -Property IODataBytesPersec -Descending | Select-Object $properties

        $Row += "<div class='caption1'>"+ $_ +"</div><table class='tftable' border='1'> 
                     <tr>
                        <th>Process Name</th>
                        <th>IO Data (Bytes/s)</th>
                        <th>Data (Operations/Sec)</th>
                        <th>Other (Bytes/Sec)</th>
                        <th>Other (Operations/Sec)</th>
                        <th>Read (Bytes/Sec)</th>
                        <th>Read (Operations/Sec)</th>
                        <th>Write (Bytes/Sec)</th>
                        <th>Write (Operations/Sec)</th>
                     </tr>"

           
        Foreach ($IO_list_item in $IO){
                ForEach($line in $IO_list_item){
                if ($line.'IO Data (Bytes/s)'-gt $threshold)
                    {$st = "Failed"}
                     #else 
                    #{$st = "Success"}
                    $Row += "<tr>
                                <td class= '"+$st+"'>"+ $line.'Process Name' +"</td>
                                <td>"+ $line.'Data (Operations/Sec)'+"</td>
                                <td>"+ $line.'Data (Operations/Sec)' +"</td>
                                <td>"+ $line.'Other (Bytes/Sec)' +"</td>
                                <td>"+ $line.'Other (Operations/Sec)' +"</td>
                                <td>"+ $line.'Read (Bytes/Sec)' +"</td>
                                <td>"+ $line.'Read (Operations/Sec)' +"</td>
                                <td>"+ $line.'Write (Bytes/Sec)' +"</td>
                                <td>"+ $line.'Write (Operations/Sec)' +"</td>
                             </tr>"
                }
            }          
            $Row += "</table></br/br>"

    }
    }
    catch{

    }
   }

$Row += "</body></html>"

Set-Content $HTML $Row

$Body = $Row

$SMTPClient.EnableSsl = $true

# Create the message
$mail = New-Object System.Net.Mail.Mailmessage $EmailFrom, $EmailTo, $Subject, $Body

$mail.IsBodyHTML=$true

$SMTPClient.Send($mail) 
