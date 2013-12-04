shoes4 [![Build Status](https://secure.travis-ci.org/shoes/shoes4.png?branch=master)](http://travis-ci.org/shoes/shoes4)[![Code Climate](https://codeclimate.com/github/shoes/shoes4.png)](https://codeclimate.com/github/shoes/shoes4)[![Coverage Status](https://coveralls.io/repos/shoes/shoes4/badge.png?branch=master)](https://coveralls.io/r/shoes/shoes4)[![Dependency Status](https://gemnasium.com/shoes/shoes4.png)](https://gemnasium.com/shoes/shoes4)
======

Shoes 4 : the next version of Shoes

Still in development
--------------------
Hi there, thanks for checking by! Shoes4 is still in development. It doesn't support all of the shoes DSL just yet.
But if you want to check it out, that's awesome! If you're not too adventurous just yet you can still use the [old shoes](https://github.com/shoes/shoes)!

But hey, make sure to check back later, because shoes4 is the future!

Installing Shoes4 from github
-----------------------------

There isn't a shoes4 gem release (yet) - in the meantime check out these instructions to get shoes4 running on your computer.

### *nix

1. Fork the repository and clone your fork, or

        $ git clone git://github.com/shoes/shoes4.git

2. Install a [JDK](http://www.oracle.com/technetwork/java/javase/downloads/) and [JRuby](http://jruby.org). Installing JRuby can be done easily for instance by using [rvm](http://rvm.io/):

        $ rvm install jruby

**Note:** Please make sure that you either install jruby-1.7.0 or higher or you set jruby to [always run in 1.9 mode](http://stackoverflow.com/questions/4755900/how-to-make-jruby-1-6-default-to-ruby-1-9). This is required in order for shoes4 to work.
If you got rvm, rbenv or something like that installed it might complain that you should use jruby version xx. That's because we keep our .ruby-version files up to date mostly. You should be able to run it with the before mentioned versions either way. We recommend up to date versions though.

3. Set up your local environment

        $ cd shoes4
        $ gem install bundler && bundle install

4. You're ready to go!

### Windows

1. Fork the repository and clone your fork, or

        C:\tmp> git clone git://github.com/shoes/shoes4.git

2. Install a [JDK](http://www.oracle.com/technetwork/java/javase/downloads/) and [JRuby](http://jruby.org) (Windows Executable)

3. Set up your local environment

**JRuby 1.7** (recommended)

        C:\tmp>cd shoes4
        C:\tmp\shoes4>jruby -S gem install bundler
        C:\tmp\shoes4>jruby -S bundle install

**JRuby 1.6**

        C:\tmp>cd shoes4
        C:\tmp\shoes4>jruby --1.9 -S gem install json -v '1.6.1'
        C:\tmp\shoes4>jruby --1.9 -S gem install bundler
        C:\tmp\shoes4>jruby --1.9 -S bundle install

4. You're ready to go!

Refer to the [RubyInstaller DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) if you are having issues building native gems. You might be forced to download and install [MinGW](http://www.mingw.org/) if your system is missing GCC or make.
    
Running a Shoes App
-------------------

Shoes 4 comes with a command-line app runner. Just pass it the filename of your Shoes app.

    $ bin/shoes samples/simple-sound.rb

**Note:** For Windows, `C:\tmp\shoes4>bin\shoes samples\simple-sound.rb`

There is also a simple ruby starter script which you may use as follows:

```
bin/ruby-shoes samples/simple-sound.rb
```

This does not work yet on Mac as jruby (the JVM) needs some additional parameters. Here you can just do the following (which basically is what bin/shoes does):

```
jruby -J-XstartOnFirstThread bin/ruby-shoes samples/simple-sound.rb
```

Another alternative yet is to put `require 'shoes'` at the top of your applications, then you can simply do 

```
jruby path/to/file.rb
```

Want to see what shoes can do?
------------------------------

You can run `rake samples` and random samples we believe are working will be run until you quit with Ctr + C. Some of them are really simple, while others are more complex or even games!
If you notice any issue with those samples please [let us know](https://github.com/shoes/shoes4/issues/new)!

Packaging a Shoes App
---------------------

Packaging is just a baby, so be gentle.

If this is your first time running the packager, you'll want to `bundle install` to pull in a couple of additional gems.

In order to package an app, you need to have the Shoes gem installed in your environment.

    $ rake gem
    $ gem install pkg/shoes-4.0.0.pre1.gem

Now, you can package an app. But first, looky here:

- The packager will include ***everything*** in the directory of your shoes script and below, unless you tell it not to.
- The packager will probably not work properly if it detects a `.gemspec` or a `Gemfile`. It uses Warbler, which always looks for those files. If you run the specs, you may notice some warnings like this:

> warning: Bundler `path' components are not currently supported.
> The `shoes-4.0.0.pre1' component was not bundled.
> Your application may fail to boot!

That's Warbler talking. Actually, we sneak the Shoes gem in anyway, but don't tell.

Okay, now for real. The simplest thing is to put your script in a directory by itself and then

    $ bin/shoes -p swt:app path/to/directory-of/your-shoes-app.rb

You'll find your app at `path/to/directory-of/pkg/Shoes App.app`.

If you want more control (like you want to name your app something besides "Shoes App", or you don't want to include all of those files we talked about before), make an `app.yaml` file. See [the example](https://github.com/shoes/shoes4/blob/master/app.yaml) for more details.

***Note:*** *If you use an `app.yaml`, you will have to customize or comment out each option. The example is just an example ;)*

When you have an `app.yaml` file right next to your script, you have three options:

    $ bin/shoes -p swt:app path/to/directory-of/your-shoes-app.rb
    $ bin/shoes -p swt:app path/to/directory-of/app.yaml
    $ bin/shoes -p swt:app path/to/directory-of

The packager will find your instructions using any of those commands. Again, you'll find your app in the `pkg` directory inside your project's directory. Find out more at `bin/shoes --help`.

Oh, and you can also just run your Shoes apps with `bin/shoes`.

Want to contribute?
-------------------

That's awesome, thank you! 

You can go ahead an try to fix one of our [issues](https://github.com/shoes/shoes4/issues).
We have introduced a new tag 'Newcomer Friendly' for issues we believe are suitable to get started with shoes contributing. These issues either are relatively easy to accomplish or don't depend on a lot of other shoes code (e.g. completely new features) so that it's easier to get started.
Please feel free to tackle any issue - we will help you if needed. The tag is just a suggestion! =)

Also there is a list of samples that already work at samples/README, along with all the other samples. You can try to get a new sample to run. In order to do so you can run `rake non_samples` to run a random sample we think does not work. If you just want to list the non working samples you can also run `rake list_non_samples`.

With all you do, please make sure to write specs as Shoes 4 is developed TDD-style (see the [Running Specs](https://github.com/shoes/shoes4#running-specs) section above). So make sure that you don't break any tests  :-)

We write our specs in rspec and are currently in the process of migrating from the old `should` syntax to the [new `expect` syntax](http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax). We basically say that whenever you touch a spec it'd be good if you converted it to the new syntax. Also new specs should be written in the new expect syntax.

If you feel unsure about testing or your implementation just open an issue or a pull request. We're happy to help you get your contribution ready to be merged in order to help build Shoes 4!

In fact we greatly appreciate early pull requests to review code and help you find your way around Shoes4! =)

If you have questions, also feel free to drop by on the #shoes channel on FreeNode irc. People might not respond instantly, but after some time someone will respond :-)

It sometimes is also a good way to refactor some code or write some specs in order to get familiar with a project. If you want to try this approach you can have a look at our [Code Climate](https://codeclimate.com/github/shoes/shoes4) to find candidates for refactoring or after running the specs locally take a peak into the coverage directory and open index.html - it shows you our current coverage data. See something that isn't covered and maybe you can write a spec for it?

Refer to the following section for information on how to run the specs, that were mentioned before :-)

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
    $ rake spec:swt                  # Run integration specs using the Swt backend, plus isolation specs for the Swt backend
    $ rake spec:swt:isolation        # Run isolation specs for the Swt backend
    $ rake spec:swt:integration      # Run integration specs using the Swt backend
    $ rake spec[Shape]               # Run the whole spec suite, but only for Shape
    $ rake spec:shoes[Shape]         # Run integration specs for Shape using the mock backend
    $ rake spec:swt[Shape]           # Run integration and isolation specs for Shape, using the Swt backend
    $ rake spec:swt:isolation[Shape] # Run isolation specs for Shape using the Swt backend

**Note:** For Windows, `C:\tmp\shoes4>jruby --1.9 -S rake spec`

Contact
-------

Want to get in touch with the shoes community? That's great! You can get in touch here:

* You can join the mailing list, simply send an email to shoes@librelist.com - you can also check out [the archives](http://librelist.com/browser/shoes/)
* We also have an irc channel #shoes on freenode - a lot of people are idling there so it might take some time to react

However we try to keep most discussions about the development in this repository/its issues list so everyone can see them and look them up.
