Integration is part of SciRuby, a collaborative effort to bring scientific computation to Ruby. If you want to help, please
do so!

This guide covers ways in which you can contribute to the development of SciRuby and, more specifically, Integration.

## How to help

There are various ways to help Integration: bug reports, coding and documentation. All of them are important.

First, you can help implement new features or bug fixes. To do that, visit our [issue tracker][2]. If you find something that you want to work on, post it in the issue or on our [mailing list][1].

You need to send tests together with your code. No exceptions. You can ask for our opinion, but we won't accept patches without good spec coverage.

We use RSpec for testing. If you aren't familiar with it, there's a good [guide to better specs with RSpec](http://betterspecs.org/) that shows a bit of the syntax and how to use it properly.
However, the best resource is probably the specs that already exist -- so just read them.

And don't forget to write documentation (we use YARD). It's necessary to allow others to know what's available in the library. There's a section on it later in this guide.

We only accept bug reports and pull requests in GitHub. You'll need to create a new (free) account if you don't have one already. To learn how to create a pull request, please see [this guide on collaborating](https://help.github.com/categories/63/articles).

If you have a question about how to use Integration or SciRuby in general or a feature/change in mind, please ask the [sciruby-dev mailing list][1].

Thanks!

## Coding

To start working on Integration, clone the repository and use bundler to install the dependencies:

```bash
$ git clone git://github.com/SciRuby/integration.git
$ cd integration
$ bundle install
```

If everything's fine until now, you can create a new branch to work on your feature:

```bash
$ git branch new-feature
$ git checkout new-feature
```

Before commiting any code, please read our
[Contributor Agreement](http://github.com/SciRuby/sciruby/wiki/Contributor-Agreement).

## Style guide

Follow the [GitHub styleguide](https://github.com/styleguide/ruby). If you have any doubt, contact us.

## Documentation

We are using [YARD](http://yardoc.org/) for documenting the source. There is still a lot to do: more references, more examples, better names for parameters, etc. We accept patches for each and every one of these problems -- if you want to send a patch improving documentation, we will be pleased to review it!

See the [YARD guides](http://www.yardoc.org/guides/index.html) for more information.

## Conclusion

This guide was heavily based on the
[Contributing to Ruby on Rails guide](http://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html).

[1]: https://groups.google.com/forum/?fromgroups#!forum/sciruby-dev
[2]: https://github.com/sciruby/integration/issues
