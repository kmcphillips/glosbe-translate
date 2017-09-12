# Glosbe translate

[![Build Status](https://travis-ci.org/kmcphillips/glosbe-translate.svg?branch=master)](https://travis-ci.org/kmcphillips/glosbe-translate)

Wrapper around the [Glosbe](https://glosbe.com) online multilingual dictionary. Translate and get definitions of words between languages.

See a [full list of supported languages](https://glosbe.com/all-languages).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'glosbe-translate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install glosbe-translate


## Usage

### Language codes

All translations and definitions take the [ISO-639]((http://en.wikipedia.org/wiki/List_of_ISO_639-3_codes)) languages codes as `to` and `from` in either the two or three character versions. Glosbe supports a [long list of languages](https://glosbe.com/all-languages).


### Single lookups

Class methods on the language object that allow you to do a single lookup:

```ruby
Glosbe::Language.translate("please", from: :en, to: :nl)
=> "alstublieft"
```

Fetch an array of definitions in the `from` language:
```ruby
Glosbe::Language.define("pineapple", from: :en, to: :fr)
=> ["fruit",
 "Large sweet fleshy tropical fruit with a terminal tuft of stiff leaves.",
 "plant"]
```

Fetch an array of definitions in the `to` language:
```ruby
Glosbe::Language.translated_define("pie", from: :en, to: :fr)
=> ["Plat constitué de viandes, fruits ou autres nourriture cuits dans ou sur une pâte.",
 "Plat, préparation à base de pâte aplatie au rouleau, et d’une garniture salée ou sucrée"]
```

Any of the three above methods can also use the simpler key value pair of `from: :to` languages:

```ruby
Glosbe::Language.translate("fromage", fr: :en)
=> "cheese"
```

## Language object

Translations and definitions are done from a `Language` object:

```ruby
language = Glosbe::Language.new(from: "eng", to: "nld")
```

Symbols and strings are accepted, and the language code will be converted to match what is expected by the API.

The same three methods are available to translate and define a phrase using this object:

```ruby
language.translate("please", from: :en, to: :nl)
=> "alstublieft"
```

```ruby
language.define("pineapple", from: :en, to: :fr)
=> ["fruit",
 "Large sweet fleshy tropical fruit with a terminal tuft of stiff leaves.",
 "plant"]
```

```ruby
language.translated_define("pie", from: :en, to: :fr)
=> ["Plat constitué de viandes, fruits ou autres nourriture cuits dans ou sur une pâte.",
 "Plat, préparation à base de pâte aplatie au rouleau, et d’une garniture salée ou sucrée"]
```


### Response object

Doing a lookup will return a `Response` object:

```ruby
response = language.lookup("coffee")
```

The response represents all the fields returned from the API in a very similar structure.

Was the HTTP a 200 OK?
```
response.success?
=> true
```

Were any results returned?
```
response.found?
=> true
```

Fields in the response are directly mapped for convenience:
```ruby
response.from
=> "en"
response.to
=> "nl"
response.phrase
=> "coffee"
```

There can sometimes be messages returned from the server. This is particularly interesting for rate limiting warnings:
```ruby
response.messages
=> []
```

Convenience methods extract the same three functions and return values repeated above:

```ruby
response.translation
response.define
response.translated_define
```

The raw results matching the structure of the API are available here.


### Results

The list of all results is available from a response:

```ruby
response.results
=> [...]
```

Each result object has the translated phrase if present;

```ruby
result.phrase
=> "koffie"
```

The result then lists its authors:

```ruby
result.authors
=> [...]
```

And its meanings:

```ruby
result.meanings
=> [...]
```

Each meaning has language and text:

```ruby
meaning.text
=> "Een drank bekomen door infusie van de bonen van de koffieplant in heet water."
meaning.language
=> "nl"
```

None of these fields are guaranteed to exist. Though they will return a string or `nil` for value fields, and will always return an empty array for collection fields.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kmcphillips/glosbe-translate.

Come talk to me about what you're working on. I'd love to review PRs if you find bugs or think of improvements.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
