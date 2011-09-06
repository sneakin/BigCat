BigCat
===

ROAR!! I CATZ BIG IN YER TERM!!


Installation
---

    $ gem install bigcat


Usage
---

BigCat works a lot like good ole `cat`. Without arguments it reads from STDIN and writes to STDOUT:

    $ bigcat
    Hello^D

You can also pipe text to BigCat:

    $ echo hello | bigcat

Files can also be passed as arguments:

    $ bigcat README.md


Development
---

BigCat is hosted on GitHub. You can clone the repository by running:

    $ git clone git://github.com/sneakin/BigCat.git

To run BigCat from your clone, you will need Ruby and Bundler. Then within your clone you can:

    $ bundle install
    $ bundle exec bin/bigcat
    $ bundle exec rake -T


License
---

Copyright © 2011 Nolan Eakins <sneakin@semanticgap.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.