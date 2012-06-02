
shoes4
======

Shoes 4 : the next version of Shoes



Hacking
-------

1. Fork the repository and clone your fork, or

        $ git clone git://github.com/shoes/shoes4.git

2. Install a [JDK](http://www.oracle.com/technetwork/java/javase/downloads/) and [JRuby](http://jruby.org)

        $ rvm install jruby

3. Set up your local environment

        $ cd shoes4
        $ gem install bundler && bundle install

4. You're ready to go!


Hacking (on Windows)
---------------------

1. Fork the repository and clone your fork, or

        C:\tmp> git clone git://github.com/shoes/shoes4.git

2. Install a [JDK](http://www.oracle.com/technetwork/java/javase/downloads/) and [JRuby](http://jruby.org)

- download and install JRuby 1.6.7 Windows Executable

3. Set up your local environment

        C:\tmp>cd shoes4
        C:\tmp\shoes4>jruby --1.9 -S gem install json -v '1.6.1'
        C:\tmp\shoes4>jruby --1.9 -S gem install bundler
        C:\tmp\shoes4>jruby --1.9 -S bundle install
        
        Refer to https://github.com/oneclick/rubyinstaller/wiki/Development-Kit if you have issues building native gems.

4. You're ready to go!

   
Running Specs
-------------

Shoes 4 is developed in a TDD style. You should be running the specs :)

There are rake tasks for running specs. Some examples:

    $ rake spec                # Run all the specs
    $ rake spec:shoes          # Run the specs for the Shoes DSL
    $ rake spec:swt            # Run the specs for the Swt implementation
    $ rake spec[Shape]         # Run all the specs for Shape
    $ rake spec:shoes[Shape]   # Run just the DSL specs for Shape

**Note:** For Windows, `C:\tmp\shoes4>jruby --1.9 -S rake spec`
    
Running a Shoes App
-------------------

Shoes 4 comes with a command-line app runner. Just pass it the filename of your Shoes app.

    $ bin/swt-shoooes samples/simple-sound.rb

**Note:** For Windows, `C:\tmp\shoes4>bin\swt-shoooes samples\simple-sound.rb`

Build Status
------------

[![Build Status](https://secure.travis-ci.org/shoes/shoes4.png?branch=master)](http://travis-ci.org/shoes/shoes4)




