# SQL-Server_IO-Occurances
This script will give I/O Ocuurances beyond threshold details for SQL Server. Gives the email alert as well as HTML file with the important detail for passed servers in server list.

## Prerequisites

Windows OS - Powershell<br>
SqlServer Module need to be installed if not than type below command in powershell prompt.<br>
Install-Module -Name SqlServer

## Note
  
Process Name<br>
IO Data (Bytes/s)<br>
Data (Operations/Sec)<br>
Other (Bytes/Sec)<br>
Other (Operations/Sec)<br>
Read (Bytes/Sec)<br>
Read (Operations/Sec)<br>
Write (Bytes/Sec)<br> 
Write (Operations/Sec)

## Use

Open Powershell
"C:\IO_Occurences.ps1"


# Input
Server list file path to (example) {$path = "C:\server_list.txt"}<br>
The output file path to (example) {$HTML = "Path\IO_Report.html"}<br>
Set Email From (example) {$EmailFrom = “example@outlook.com”}<br>
Set Email To (example) {$EmailTo = “example@outlook.com"}<br>
Set Email Subject (example) {$Subject = “IO Occurrences”}<br>
Set Threshold (example) {$threshold = 30}<br>
Set SMTP Server Details (example) {<br> 
$SMTPServer = “smtp.outlook.com” <br>
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)<br>
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential(“example@outlook.com”, “Password”);}

## Example O/P

![alt text](https://github.com/Sahista-Patel/SQL-Server_IO-Occurances/blob/Powershell/IO_Output.PNG)

## License

Copyright 2020 Harsh & Sahista

## Contribution

* [Harsh Parecha] (https://github.com/TheLastJediCoder)
* [Sahista Patel] (https://github.com/Sahista-Patel)<br>
We love contributions, please comment to contribute!

## Code of Conduct

Contributors have adopted the Covenant as its Code of Conduct. Please understand copyright and what actions will not be abided.
