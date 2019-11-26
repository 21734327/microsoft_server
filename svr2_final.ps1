#You can deviate from the output if you so choose to improve. This is simply a template if you want to use it. 

#Prompt for Student name and assign to variable 

#The out-file path has to exist on your system somewhere.  You can save it where you wish 

$Student=Read-Host "Enter Name of Student" 

#Header 

write-output "**************************************************************************" | Out-File e:\powershell\$student.txt -Append 

write-output "******** $Student Domain Report *******************************************"| Out-File e:\powershell\$student.txt -append 

write-output "**************************************************************************" | Out-File e:\powershell\$student.txt -Append 

#Line Breaks 

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "" | Out-File e:\powershell\$student.txt -Append 

#Header 

write-output "***********$Student User Report*******************************************" | Out-File e:\powershell\$student.txt -Append 

#should display 75 users based on previous labs 

#required attributes to display: Distinguishedname,homedirectory,company 

get-aduser -filter * -property Distinguishedname,homedirectory,company | select -property Distinguishedname,homedirectory,company | ft -autosize | Out-File e:\powershell\$student.txt -Append 


write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "***********$Student Security Group **************************************" | Out-File e:\powershell\$student.txt -Append 

#should display 8 Security Groups based on previous labs 

#required attributes to display: Name,members 

get-adgroup -filter * -property name,members | select -property name,members | ft -autosize | Out-File e:\powershell\$student.txt -Append

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "***********$Student Domain Structure (Organizational Unit) ***************" | Out-File e:\powershell\$student.txt -Append 

#should display 9 OUs (including Corp) 

#required attributes to display: Name 

get-adorganizationalunit -filter * -property name | select -property name | ft -autosize | Out-File e:\powershell\$student.txt -Append

write-output "" "" "" | Out-File e:\powershell\$student.txt -Append 

write-output "***********$Student File System (Home folders and Departmental Folders) Report****************************************************************" | Out-File e:\powershell\$student.txt -Append 

#should display 8 departmental folders 

#should display 75 home folders 

#example to be modified for your file system 

#get-childitem e:\home -recurse | get-acl | select path,accesstostring | fl | out-file e:\powershell\$student.txt -append 

#get-childitem e:\corp -recurse | get-acl | select path,accesstostring | fl | out-file e:\powershell\$student.txt -append 

#required attributes to display: Path,accesstostring  

 
write-output "" "" "" | Out-File e:\powershell\$student.txt -Append 



write-output "***********$Student Server/System Report **************************************" | Out-File e:\powershell\$student.txt -Append 

#Server/System Report will retrieve/list the following: 

#Report on all servers in your cloud->HINT: create an OU under Corp named Servers and move servers into the OU 

#System name-You're passing the name, so this shouldn't be difficult 

#System IP- 

#Installed Roles (DC only) 

#System RAM (DC Only) 

$servers = get-adcomputer -searchbase (get-adorganizationalunit -filter 'name -eq "servers"').distinguishedname -properties * 

$servers | foreach {
  'Server name: ' + $_.name | Out-File e:\powershell\$student.txt -Append 
  'Server IP address: ' + $_.ipv4address | Out-File e:\powershell\$student.txt -Append
  '' | Out-File e:\powershell\$student.txt -Append
}

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "" | Out-File e:\powershell\$student.txt -Append 

write-output "***********$Student Domain Controllers Report **************************************" | Out-File e:\powershell\$student.txt -Append 


$allDCs = (Get-ADForest).Domains | foreach { Get-ADDomainController -Filter * -Server $_ }

$alldcs | foreach {
  'DC system name: ' + $_.name | Out-File e:\powershell\$student.txt -Append 
  'System RAM: ' + ((get-ciminstance -class 'cim_physicalmemory' -computername $_.name | measure-object -property capacity -sum).sum /1gb) | Out-File e:\powershell\$student.txt -Append 
  get-windowsfeature -computername $_ | where installed | ft -autosize -wrap | Out-File e:\powershell\$student.txt -Append 
}
