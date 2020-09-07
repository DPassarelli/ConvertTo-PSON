# Helper function to do a deep equality check on Hashtables. I created this b/c
# this does not seem to be built into Pester.
#
function Compare-HashTables {
    param(
        [System.Collections.Hashtable]$a,
        [System.Collections.Hashtable]$b
    )

    if ($a.Keys.Count -eq $b.Keys.Count) {
        if ($a.Keys.Count -gt 0) {
            foreach ($key in $a.Keys) {
                try {
                    $valueA = $a.$key
                    $valueB = $b.$key # if `$b` does not contain the same keys `$a`, this should throw an exception

                    # Write-Host "Key: $key"
                    # Write-Host "A: $valueA"
                    # Write-Host "B: $valueB"

                    # null?
                    if ($valueA -eq $null) {
                        return ($valueB -eq $null)
                    }

                    # same type?
                    if (-not $valueA.GetType().Equals($valueB.GetType())) {
                        return $false
                    }

                    # same value?
                    if ($valueA.GetType().Name -eq "hashtable") {
                        if (-not (Compare-HashTables $valueA $valueB)) {
                            Write-Host "not equal"
                            return $false
                        }
                    }
                    elseif (-not $valueA.Equals($valueB)) {
                        return $false
                    }
                }
                catch {
                    # Write-Host "exception:"
                    # Write-Host $_.Exception.Message
                    return $false
                }
            }
        }
        # else...if both instances are empty, then they are equal
    }
    else {
        return $false
    }

    return $true
}
