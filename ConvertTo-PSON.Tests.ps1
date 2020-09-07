#Requires -Version 5

# https://blogs.technet.microsoft.com/heyscriptingguy/2014/12/03/enforce-better-script-practices-by-using-set-strictmode/
#
Set-StrictMode -Version Latest

Describe 'ConvertTo-PSON' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'test\Compare-HashTables.ps1')
        . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    }

    Describe 'the input validation' {
        It 'must throw an exception if the -Source parameter is missing' {
            { ConvertTo-PSON } | Should -Throw
        }

        It 'must throw an exception if the -Source parameter is not of type Hashtable' {
            { ConvertTo-PSON -Source "@{}" } | Should -Throw
        }

        It 'must not throw an exception if the -Source parameter is an empty Hashtable' {
            { ConvertTo-PSON -Source @{} } | Should -Not -Throw
        }

        It 'must not throw an exception if the -Source parameter is not named' {
            { ConvertTo-PSON @{} } | Should -Not -Throw
        }
    }

    Describe 'the expected behavior' {
        It 'must return a string value' {
            $actual = ConvertTo-PSON @{}
            $actual | Should -BeOfType System.String
        }

        It 'must return a string value that can be converted back into a Hashtable' {
            $returnValue = ConvertTo-PSON @{}
            $actual = Invoke-Expression $returnValue

            $actual | Should -BeOfType System.Collections.Hashtable
        }

        Context 'non-nested Hashtable' {
            Context 'with only a single value type' {
                It 'must return a string value that accurately represents the input parameter containing a string' {
                    $expected = @{
                        key1 = "value1"
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter containing an integer' {
                    $expected = @{
                        key1 = 123
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter containing a decimal' {
                    $expected = @{
                        key1 = 3.14159
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter containing a null value' {
                    $expected = @{
                        key1 = $null
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter containing a boolean value (true)' {
                    $expected = @{
                        key1 = $true
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter containing a boolean value (false)' {
                    $expected = @{
                        key1 = $false
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter containing a datetime value' {
                    $expected = @{
                        key1 = (Get-Date)
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter containing a hashtable value' {
                    $expected = @{
                        key1 = @{
                            subkey1 = "subval1"
                            subkey2 = 123
                        }
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }
            }

            Context 'with mixed value types' {
                It 'must return a string value that accurately represents the input parameter with a string and integer' {
                    $expected = @{
                        key1 = "value1"
                        key2 = 123
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter with a string, integer, and decimal' {
                    $expected = @{
                        key1 = "value1"
                        key2 = 123
                        key3 = 3.14159
                    }

                    $returnValue = ConvertTo-PSON $expected
                    $actual = Compare-HashTables $expected (Invoke-Expression $returnValue)

                    $actual | Should -BeExactly $true
                }

                It 'must return a string value that accurately represents the input parameter with a string, integer, decimal and nested hashtable' {
                    $expected = @{
                        key1 = "value1"
                        key2 = 123
                        key3 = 3.14159
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
