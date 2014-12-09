[![Gem Version](https://badge.fury.io/rb/hound-tools.svg)](http://badge.fury.io/rb/hound-tools)
[![Build Status](https://travis-ci.org/e2/hound-tools.png?branch=master)](https://travis-ci.org/e2/hound-tools)


# Hound::Tools

Tools and configuration to locally simulate HoundCi checks

## Initial Setup

Add this to your Gemfile:

```ruby
group :development do
  gem 'hound-tools', '~> 0.1', require: false
end
```

Run this for a customizable RuboCop and Hound compatible setup:

```bash
$ hound-tools init
```

NOTE: this runs 'rubocop --auto-gen', so it will disable all the offenses.

## Add new files to repository

Add the files to the repository:

```bash
git add .hound       # default Hound style guide and your overrides
git add .rubocop.yml # Rubocop-only config
git add .hound.yml   # Hound general style-checking config
git add .rubocop_merged_for_hound.yml # auto-generated Hound-only config (without Hound defaults)
```


## Customizing your Rubocop/Hound setup

You should only be interested in these files:
- `.rubocop_todo.yml`, which can be updated with `bundle exec rubocop --auto-gen` and then edited
- `.hound/overrides.yml`, where you can override Hound's default rules or excludes
- `.rubocop_merged_for_hound.yml` - you want to regenerate this and commit

## Usage

Every time you modify `.rubocop_todo.yml` or `.hound/overrides.yml`, you'll
want to regenerate `.rubocop_merged_for_hound.yml` with:

```bash
$ hound-tools
```

(And then you'll want to add all 3 to the repository before doing anything else).

Once you have your style working, you can simulate Hound with almost 100% accuracy with:

```bash
bundle exec rubocop
```

(If this shows no offenses, check the .rubocop_todo.yml file for disabled rules.)

## Tips

1) For quickly fixing most offenses, uncomment the 'auto-correct' ones in
`.rubocop_todo.yml` simply run `bundle exec rubocop -a`

2) The RuboCop README has tips on setting up Rake, Guard, etc.

## Why is this so complex?

Well, simply because Hound doesn't support the RuboCop `inherited_from` keys.
And that's because Hound is avoiding touching the filesystem, because it
downloads files to memory from GitHub.

Also, since Hound internally loads it's defaults and does a "mini-merge" of the
configurations, it needs a different setup than Rubocop.

## Alternatives

1) Use only the default Hound settings (without being able to Hound-check them locally)

2) Copy the default Hound settings (`.hound/defaults.yml`) to `.rubocop.yml` and tweak them (but you loose the flexibility and control of using multiple files and the coolness of .rubocop_todo.yml with 'inherited_from')


## Contributing

1. Fork it ( https://github.com/[my-github-username]/hound-tools/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
