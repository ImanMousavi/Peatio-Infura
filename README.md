# Peatio::Infura

Peatio infura plugin for Openware stack

## Create Gem

Clone this repository
	
	git clone https://github.com/irmaster/Peatio-Infura.git

Enter `peatio-infura` folder and build image

	docker build -t evinsoft/ruby-infura .

Run container

	docker run --name infura_container -d evinsoft/ruby-infura

Enter container
	
	docker exec -it infura_container bash

Build GEM

	gem build peatio-infura.gemspec

Test GEM


	./bin/setup
	./bin/console
	client = Peatio::Infura::Client.new('https://rinkeby.infura.io/v3/b5d560f71a4341428acacd4a5b25a8a0','https://rinkeby.infura.io/v3/b5d560f71a4341428acacd4a5b25a8a0')
	client.json_rpc(:eth_blockNumber)

Push GEM

	gem push peatio-infura-0.1.0.gem


*others*
Delete accidentaly added rubygem *if the gem contains password, you should reset all passwords*
	
	gem yank -v 0.1.0 peatio-infura


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'peatio-infura'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install peatio-infura

## Usage

For Peatio Infura plugin integration you need to do the following steps:

### Image Build.

1. Add peatio-infura gem into your Gemfile.plugin
```ruby
gem 'peatio-infura', '~> 0.2.0'
```

2. Run `bundle install` for updating Gemfile.lock

3. Build custom Peatio [docker image with Infura plugin](https://github.com/rubykube/peatio/blob/master/docs/plugins.md#build)

4. Push your image using `docker push`

5. Update your deployment to use image with peatio-infura gem

### Peatio Configuration.

1. Create Infura Blockchain [config example](../config/blockchains.yml).
    * No additional steps are needed

2. Create Infura Currency [config example](../config/currencies.yml).
    * No additional steps are needed

3. Create Infura Wallets [config example](../config/wallets.yml)(deposit and hot wallets are required).
    * No additional steps are needed


## Development

Plugin development [example](https://github.com/rubykube/peatio/blob/master/docs/coins/development.md).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rubykube/peatio-infura.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Consulting

You can contact Openware for finding certified vendors:
[Openware.com](https://www.openware.com)
