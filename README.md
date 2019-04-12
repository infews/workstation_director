# Workstation Director

Yet another MacOS workstation installation & setup system.

_Why would I use Workstation Director?_

- Because Homebrew can’t do everything (but it does SO much SO well)
- Doing a little bit before, and then after, Homebrew can make your Mac even happier.
- You want to automate MacOS Workstation configuration, but you’re more comfortable in Ruby than in BASH.

## How to Use

- Define some Actors
- Write a script that `requires` them
- Make a Director
- Call `#action!` until the Actors get it right

## Example Script

```ruby
#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'workstation_director'
using Rainbow

actors_path = File.absolute_path(File.join(File.dirname(__FILE__), 'actors'))
Dir.glob(File.join(actors_path, '*.rb')).each {|actor_file| require actor_file }

director = WorkstationDirector::Director.new(
  Homebrew,              # Homebrew the things
  QSInterfaceYosemite,   # Quicksilver plugin
  Rcm,                   # RCM for dotfiles
  MacOsDefaults.         # lotsa default writes
)
director.action!
```

…and run repeatedly this until you get :applause:.

# The Actors

An `Actor` is a class with a specific set of interfaces for installing a single application and then setting up, or configuring, it for use.

`WorkstationDirector::Actor` [src][actor] is available as a parent class for new Actors. The [Homebrew Actor][homebrew-actor] is a great example.

## `#install`

Installs an application. The Director assumes that installation is idempotent. I

Should return `true` if the installation is successful. Should raise an exception if installation is *not* successful.

## `#present?`

An optional method for applications that cannot, or should not be installed idempotently.

The Director will only call `.install` if `.present?` returns `false`.

## `#setup`

An optional method for applications that can, or want to, be configured separately from install time.

Should return `true` if the installation is successful. Should raise an exception if installation is *not* successful.

## `#run_command(cmd)`

This method takes a shell command and runs it, streaming output to stdout. It will also dump stderr and raise an error if the command fails for any reason.

# The Director

`WorkstationDirector::Director` is the engine that tells all the Actors what to do. It takes a list of Actor classes, and then one-by-one instantiates, then tells them to install and setup.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/infews/workstation_director. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WorkstationDirector project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/workstation_director/blob/master/CODE_OF_CONDUCT.md).



[actor]: https://github.com/infews/workstation_director/blob/master/lib/workstation_director/actors/actor.rb
[homebrew-actor]: <fill me in>
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/workstation_director. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WorkstationDirector project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/workstation_director/blob/master/CODE_OF_CONDUCT.md).
