#Requires -Version 2

<#
    .SYNOPSIS
    This function tests whether the specified configuration file (PSD1) contains
    all of the required fields.

    .PARAMETERS

    .EXAMPLE

    .NOTES
    This code adheres to the style guidelines published at
    https://poshcode.gitbooks.io/powershell-practice-and-style/

    Copyright (c) 2018 David Passarelli

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>

function ConvertTo-PSON {
    [CmdletBinding()]
    param(
        # The name of the script calling this function. Usually just the value
        # of `$MyInvocation.MyCommand.Name`, truncated and upper-cased.
        [Parameter(Position=0)]
        [Hashtable]$Source
    )

    # https://blogs.technet.microsoft.com/heyscriptingguy/2014/12/03/enforce-better-script-practices-by-using-set-strictmode/
    #
    Set-StrictMode -Version Latest


    ###################################
    #####    INPUT VALIDATION     #####
    ###################################

    if ($null -eq $Source) {
        throw "The input value is required."
    }


    ###################################
    #####     MAIN ALGORITHM      #####
    ###################################

    [System.Text.StringBuilder]$output = New-Object -Type System.Text.StringBuilder # interesting read @ http://www.yoda.arachsys.com/csharp/stringbuilder.html

    $output.Append("@{") | Out-Null # `Out-Null` is required here to keep extraneous output from being returned...see https://stackoverflow.com/a/22682725

    foreach ($key in $Source.Keys) {
        $output.Append($key) | Out-Null
        $output.Append("=""") | Out-Null
        $output.Append($Source.$key.ToString()) | Out-Null
        $output.Append(""";") | Out-Null
    }

    $output.Append("}") | Out-Null

    $output.ToString()
}
