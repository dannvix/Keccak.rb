Keccak.rb
=========

This is a pure Ruby implementation of the Keccak algorithm, aka the SHA-3 now.


Example
-------
```ruby
keccak = Keccak.new
digest = keccak.hexdigest "hello world"
puts digest #sha-512
```


Test
----
```shell
cd test
ruby test.rb
```

The test cases come from [offcial known answers](http://keccak.noekeon.org/files.html).


Credit
------
Thanks to **Renaud Bauvin** for his [Python implementation](http://keccak.noekeon.org/files.html) of the Kaccak.


Reference
---------
Keccak official site: [The Keccak sponge function family](http://keccak.noekeon.org/)


License
-------
Licensed under the [MIT license](http://opensource.org/licenses/mit-license.php).

Copyright (c) 2012 Shao-Chung Chen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
