function Invoke-RequestSpnTickets {
    $Out = "`n"

    $search = New-Object DirectoryServices.DirectorySearcher([ADSI]"")
    $search.filter = "(servicePrincipalName=*)"
    $results = $search.Findall()
    $Count = 0

    foreach( $result in $results) {
        if ($Count -ge 100) {
            break
        }
        $userEntry = $result.GetDirectoryEntry()
        $Out += "Object Name =  $($userEntry.name)"
        $Out += "`n"
        $Out += "DN = $($userEntry.distinguishedName)"
        $Out += "`n"
        $Out += "Object Category = $($userEntry.objectCategory)"
        $Out += "`n"

        foreach( $SPN in $userEntry.servicePrincipalName ) {
            try {
                $Out += "Requesting ticket for SPN $($SPN)"
                $Ticket = Invoke-Expression "klist get $($SPN)"
                if ($Ticket) {
                    $Out += "`n"
                    $Out += "Ticket request succeeded."
                    $Count += 1
                }
                else {
                    $Out += "Ticket request failed."
                }
                $Out += "`n`n"
                if ($Count -ge 100) {
                    break
                }
            }
            catch {
                $Out += "[Invoke-Expression] Error requesting ticket for SPN : $_"
                $Out += "`n"
            }
        }
    }
    $Out += "SPN tickets request completed"
    Write-Output $Out
}
