# Shoes Samples

Welcome to the Shoes Samples! The Ruby files immediately in this directory are meant to show off what Shoes can do for newcomers and experienced folks alike.

You can run the samples via:

```
bundle exec rake samples
```

Got a new sample for everyone? Put it in this directory!

## Naming

There are three basic naming forms for the samples:

* `simple_*` shouldn't be more than a handful of lines, typically demonstrating one concept/method.
* `expert_*` are more fully formed apps. Go wild!
* `nks_*` are samples from _why's ["Nobody Knows Shoes"](http://cloud.github.com/downloads/shoes/shoes/nks.pdf)

The line between simple and expert is a little arbitrary, but new samples should pick one or the other.

## Other Directories

Code in subdirectories isn't picked up by default, but you can force all the samples to run via:

```
bundle exec rake samples:all
```

We have a couple directories:

* `development` contains samples of interest to the Shoes team, but not much for everyone else
* `packaging` contains subfolders so we can easily test packaging without picking up all the samples in the bundle.
* `sounds` contains some samples with large audio files we also don't want bundled up in the `shoes` gem
* `unsupported` contains a small set of samples that older versions of Shoes allowed but aren't anymore. These are kept for historical reference and with hope to someday move them out!
