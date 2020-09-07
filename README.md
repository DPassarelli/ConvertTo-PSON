# ConvertTo-PSON

Converts a PowerShell `Hashtable` object to a PSON-formatted string.

[![Build Status](https://img.shields.io/appveyor/build/DPassarelli/convertto-pson/master?logo=appveyor)](https://ci.appveyor.com/project/DPassarelli/convertto-pson)


## Usage

1. Download the source code.
2. Dot-source `ConvertTo-PSON.ps1` in your script.
3. Call `ConvertTo-PSON`, providing a `Hashtable` object as the only parameter, and assign the resulting value to a `String` variable.


## Limitations

This function currently only understands the following general types of data:

* strings
* integers
* decimals
* date/time
* booleans
* `$null`
* `Hashtable`s

It does not yet understand arrays, nor other specific object types (such as `PSCustomObject`, or `Credential`, etc).

I've only confirmed that this code works with PowerShell 5 running on .NET Core 2. Additional versions will be tested as soon as I bring this project into a cloud-based CI system.


## Why?

I needed this for some TDD that I was doing in PowerShell. If you haven't already, check out [Pester](https://github.com/pester/Pester#pester)!

And if you aren't testing, [then](https://softwareengineering.stackexchange.com/q/2042) [get](http://a.co/d/2uLOELi) [onboard](http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd) [already](https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d)! _Just remember that [it's not magic](https://blog.jbrains.ca/permalink/tdd-is-not-magic)._


## Inspiration

https://stackoverflow.com/q/15139552


## License

MIT (please refer to the file named LICENSE).
