New-ADOrganizationalUnit -name corp

$depts = 'sales','hr','executive','accounting','infotech'
$corpoupath = Get-ADOrganizationalUnit -filter 'name -eq "corp"' | select-object -expandproperty distinguishedname

$depts | foreach-object { New-ADOrganizationalUnit -name $_ -path $corpoupath 
                          New-ADGroup -name ($_ + '_group') -groupscope global -path ('ou=' + $_ + ',' +$corpoupath)
                        }

$users = 'john clay sales','stanley jones sales','martin short sales','joanne borg hr','eric torkelson hr','kyle reese hr','michael ly executive','gene simmons executive','jan brady executive','john connor accounting','noah count accounting','donald crease accounting','jay pritchet infotech','carlos gomez infotech','nick burns infotech'

$pass = convertto-securestring 'P@ssword' -AsPlainText -Force

$users | foreach-object { $fname, $lname, $userdept = $_.split(' ')
                         invoke-command -computername njk-dfs1 -scriptblock { mkdir "c:\dfsroots\share\home_directories\$fname.$lname"
                                                                              new-smbshare -path "c:\dfsroots\share\home_directories\$fname.$lname" -fullaccess 'everyone' -name "$fname.$lname"
                                                                            } 
                         $username = $fname + "." + $lname 
                         $params = @{name              = $username                           
                                     accountpassword   = $pass                               
                                     enabled           = $true                               
                                     givenname         = $fname                              
                                     surname           = $lname                              
                                     DisplayName       = "$fname $lname"           
                                     path              = ("ou=" + $userdept + "," + $corpoupath) 
                                     homedirectory     = ("\\njk-dfs1\" + $username)         
                                     homedrive         = "H:"                                
                                     emailaddress      = ($username + "@dontemail.com")      
                                     userprincipalname = ($username + "@njk.local")
                                    }
                         new-aduser @params
                         Add-ADGroupMember -identity ($userdept + "_group") -members $username

                       }