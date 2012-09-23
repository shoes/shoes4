shoes4 [![Build Status](https://secure.travis-ci.org/shoes/shoes4.png?branch=master)](http://travis-ci.org/shoes/shoes4)[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/shoes/shoes4)
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

2. Install a [JDK](http://www.oracle.com/technetwork/java/javase/downloads/) and [JRuby](http://jruby.org) (Windows Executable)

3. Set up your local environment

        C:\tmp>cd shoes4
        C:\tmp\shoes4>jruby --1.9 -S gem install json -v '1.6.1'
        C:\tmp\shoes4>jruby --1.9 -S gem install bundler
        C:\tmp\shoes4>jruby --1.9 -S bundle install

4. You're ready to go!

Refer to the [RubyInstaller DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) if you are having issues building native gems. You might be forced to download and install [MinGW](http://www.mingw.org/) if your system is missing GCC or make.

Running Specs
-------------

Shoes 4 is developed in a TDD style. You should be writing and running the specs :)

There are two kinds of Shoes 4 specs:

1. **Integration specs:** These specify the functionality of the Shoes
   DSL. They can be run with any compatible Shoes backend. Shoes 4 comes
   with a mock backend and an Swt backend that can run the integration
   specs.

2. **Isolation specs:** These specify the internal behavior of a Shoes
   backend, in isolation from the DSL. Shoes 4 comes with an isolation spec
   suite for the Swt backend.

There are rake tasks for running specs. Some examples:

    $ rake spec                      # Run the whole spec suite
    $ rake spec:shoes                # Run integration specs using the mock backend
    $ rake spec:swt                  # Run integration specs using the Swt backend, plus Swt backend unit tests
    $ rake spec:swt:isolation        # Run isolation specs for the Swt backend
    $ rake spec:swt:integration      # Run integration specs using the Swt backend
    $ rake spec[Shape]               # Run the whole Shape spec suite
    $ rake spec:shoes[Shape]         # Run integration specs for Shape using the mock backend
    $ rake spec:swt[Shape]           # Run integration and isolation specs for Shape, using the Swt backend
    $ rake spec:swt:isolation[Shape] # Run isolation specs for Shape using the Swt backend
    
    When passed a class/module name as an argument, each of these commands
    (like the other spec commands) will run only those specs that mention
**Note:** For Windows, `C:\tmp\shoes4>jruby --1.9 -S rake spec`
    
Running a Shoes App
-------------------

Shoes 4 comes with a command-line app runner. Just pass it the filename of your Shoes app.

    $ bin/swt-shoooes samples/simple-sound.rb

**Note:** For Windows, `C:\tmp\shoes4>bin\swt-shoooes samples\simple-sound.rb`

Want to contribute?
-------------------
That's awesome, thank you! 

You can go ahead an try to fix one of our [issues](https://github.com/shoes/shoes4/issues).

Also there is a list of samples that already work at samples/README, along with all the other samples. You can try to get a new sample to run. 

With all you do, please make sure to write specs as Shoes 4 is developped TDD-style (see the [Running Specs](https://github.com/shoes/shoes4#running-specs) section above). So make sure that you don't break any tests  :-)

If you feel unsure about testing or your implementation just open an issue or a pull request. We're happy to help you get your contribution ready to be merged in order to help build Shoes 4!



