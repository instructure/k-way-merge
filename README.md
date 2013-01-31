# k-way-merge

Ruby implementation of a K-Way Merge algorithm with support for
streaming evaluation.

## Installation

This ~~is~~ *will be* packaged as the `k-way-merge` rubygem, so you can just add the
dependency to your Gemfile or install the gem on your system:

```bash
gem install k-way-merge
```

To require the library in your project:

```ruby
require 'kway_merge'
```

## Usage

The library provides two primary features: the `KWayMerge::Stream` class
and the `KWayMerge.combine` convenience method.

### `KWayMerge::Stream`

The `Stream` class encapsulates the merge algorithm and provides a
lazy-evaluation interface for accessing the output stream.

The constructor takes an array of subcollections to merge (which are
assumed sorted individually) and a block describing how to get the sort
value for a given element. If no block is given, the element is assumed
to respond to `<=>` and will act as its own sort value.

The stream can then be queried with the `empty?` predicate and consumed
one element at a time with the `shift` method. You can `skip(count)`
over multiple elements, or `collect(count)` a handful of elements of the
stream. Getting all the remaining elements is as easy as `collect(:all)`
(you can also `skip(:all)`, but that's kinda silly). If you don't want
to do your own looping, but `collect` and `skip` aren't general enough,
just `iterate(count)` or `iterate(:all)` with a custom block.

### `KwayMerge.combine`

For when you don't need lazy evaluation and want the full result set.
Takes the same arguments as the `KWayMerge::Stream` constructor, but
immediately collects and returns all the results from the stream for
you.
