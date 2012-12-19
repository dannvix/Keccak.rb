Keccak.rb
=========

This is a pure Ruby implementation of the Keccak algorithm, aka the SHA-3 now.


Example
-------
```ruby
hasher = Keccak.new
digest = hasher.keccak([128, "00112233445566778899AABBCCDDEEFF"], 576, 1024, 512)
puts digest
```


Acknowledgements
----------------
Thanks **Renaud Bauvin** for his Python implementation of the Kaccak.


References
----------
Keccak official site: [The Keccak sponge function family](http://keccak.noekeon.org/)


License
-------
Licensed under the MIT licensed.

Copyright (c) 2012 Shao-Chung Chen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
