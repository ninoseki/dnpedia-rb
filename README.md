# dnpedia-rb

[![Build Status](https://travis-ci.com/ninoseki/dnpedia-rb.svg?branch=master)](https://travis-ci.com/ninoseki/dnpedia-rb)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/dnpedia-rb/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/dnpedia-rb?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/dnpedia-rb/badge)](https://www.codefactor.io/repository/github/ninoseki/dnpedia-rb)

[DNPedia](https://dnpedia.com/) domain search API wrapper for Ruby.

## Installation

```bash
gem install dnpedia
```

## Usage

```ruby
require "dnpedia"

api = DNPedia::API.new
api.search("%apple%")

# You can pass following parameters to the search method.
# - days: default = 2
# - mode: default = "added"
# - rows: default = 500
# - page: default = 1
# - sidx: default = "length"
# - sord: default = "asc"
api.search("%apple%", mode: "deleted")
api.search("%apple%", days: 2, rows: 100)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
