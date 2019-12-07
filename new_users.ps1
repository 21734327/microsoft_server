cls





$users = import-csv 'c:\powershell\users.csv' | where -property samaccountname -notin administrator,guest,krbtgt
$users | select samaccountname,company,distinguishedname,department | ft -autosize


$users | foreach {
    $1,$2,$3 = $_.distinguishedname.split(',',3)
    $path = $2 +','+$3
    $1,$department = $2.split('=')
    $userparams = @{
        path = $path.tolower()
 #       givenname = $_.givenname
 #       surname = $_.surname
        name = $_.name
        samaccountname = $_.samaccountname.tolower()
        company = $_.company
        homedirectory = '\\njk.local\share\users\' + $_.samaccountname.tolower()
        department = $department.tolower()
    }
#    mkdir -path $userparams.homedirectory
    $acl = get-acl $userparams.homedirectory
    $acl.SetAccessRuleprotection($true,$true)
    $homepermission = new-object system.security.accesscontrol.filesystemaccessrule($userparams.samaccountname,'modify','containerinherit,objectinherit','none','allow')
    $acl.setaccessrule($homepermission)
    set-acl $userparams.homedirectory $acl
    $userparams | ft -autosize
#    new-aduser @userparams
#    new-adgroup -name ($userparams.department + '_group') -path (get-adorganizationalunit -filter 'name -eq "corp"').distinguishedname -groupscope global
#    add-adgroupmember -identity ($userparams.department + '_group') -members $userparams.samaccountname
    set-aduser -identity $userparams.samaccountname -company $userparams.company -homedirectory $userparams.homedirectory -homedrive h
    set-adaccountpassword -identity $userparams.samaccountname -newpassword (convertto-securestring -asplaintext 'P@ssword' -force) -reset
}



#>





get-aduser -filter * -properties * | where -property samaccountname -notin administrator,guest,krbtgt | select distinguishedname,samaccountname,company,homedirectory | ft -autosize
#>
