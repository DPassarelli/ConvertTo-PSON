#Requires -Version 5

# https://blogs.technet.microsoft.com/heyscriptingguy/2014/12/03/enforce-better-script-practices-by-using-set-strictmode/
#
Set-StrictMode -Version Latest

# Import the code being tested. `Join-Path` is used here (instead of the ususal
# Pester boilerplate) to make this script portable across all environments that
# are supported by .NET Core.
#
[String]$SCRIPT_UNDER_TEST = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$(Join-Path $PSScriptRoot $SCRIPT_UNDER_TEST)"

# Helper function to do a deep equality check on Hashtables.
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

# And now, the tests...
#
Describe "ConvertTo-PSON" {
    Describe "the input validation" {
        It "must throw an exception if the -Source parameter is missing" {
            { ConvertTo-PSON } | Should -Throw
        }

        It "must throw an exception if the -Source parameter is not of type Hashtable" {
            { ConvertTo-PSON -Source "@{}" } | Should -Throw
        }

        It "must not throw an exception if the -Source parameter is an empty Hashtable" {
            { ConvertTo-PSON -Source @{} } | Should -Not -Throw
        }

        It "must not throw an exception if the -Source parameter is not named" {
            { ConvertTo-PSON @{} } | Should -Not -Throw
        }
    }

    Describe "the expected behavior" {
        It "must return a string value" {
            $actual = ConvertTo-PSON @{}
            $actual | Should -BeOfType System.String
        }

        It "must return a string value that can be converted back into a Hashtable" {
            $returnValue = ConvertTo-PSON @{}
            $actual = Invoke-Expression $returnValue

            $actual | Should -BeOfType System.Collections.Hashtable
        }

        Context "non-nested Hashtable" {
            Context "with only string values" {
                It "must return a string value that accurately represents the input parameter" {
                    $expected = @{
                        key1 = "value1"
                        key2 = "value2"
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }
            }

            Context "with mixed values" {
                It "must return a string value that accurately represents the input parameter with a string and integer" {
                    $expected = @{
                        key1 = "value1"
                        key2 = 123
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It "must return a string value that accurately represents the input parameter with a string and decimal" {
                    $expected = @{
                        key1 = "value1"
                        key2 = 123
                        key3 = 123.5
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It "must return a string value that accurately represents the input parameter with a string and nested hashtable" {
                    $expected = @{
                        key1 = "value1"
                        key2 = 123
                        key3 = 123.5
                        key4 = @{
                            subkey1 = "subval1"
                            subkey2 = 123
                        }
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }
            }
        }
    }
}
