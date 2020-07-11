# frozen_string_literal: true

require 'memoist'
require 'faraday'
require 'better-faraday'
require 'openssl'
require 'base16'
require 'digest/sha3'


module Peatio
  module Infura
    class Client
      Error = Class.new(StandardError)

    class ConnectionError < Error; end

      class ResponseError < Error
        def initialize(code, msg)
        super "#{msg} (#{code})"
        end
      end

      extend Memoist

    def initialize(endpoint, idle_timeout: 5)
        @json_rpc_endpoint = URI.parse(endpoint)
        @json_rpc_call_id = 0
        @idle_timeout = idle_timeout
      end

      def eth_address(public_key)
        s = public_key[2, 128]
        s.downcase!
        s = Base16.decode16(s)
        h = Digest::SHA3.hexdigest(s, 256)
        '0x' + h[-40..-1]
      end

      def get_address

        ec = OpenSSL::PKey::EC.new('secp256k1')
        ec.generate_key
        public_key = ec.public_key.to_bn.to_s(16)
        private_key = ec.private_key.to_s(16)
        eth_address = eth_address(public_key)
        puts "address: #{eth_address}"
        puts "private_key: #{private_key}"
      rescue StandardError => e
        raise Error, e
      end

      def json_rpc(method, params = [])
        response = connection.post \
          connection.url_prefix,
          {jsonrpc: '2.0', id: rpc_call_id, method: method, params: params}.to_json,
          {'Accept' => 'application/json',
           'Content-Type' => 'application/json'}
        response.assert_success!
        response = JSON.parse(response.body)
        response['error'].tap { |error| raise ResponseError.new(error['code'], error['message']) if error }
        response.fetch('result')
      rescue Faraday::Error => e
        raise ConnectionError, e
      rescue StandardError => e
        raise Error, e
      end

      private

      def rpc_call_id
        @json_rpc_call_id += 1
      end


      def connection
        @connection ||= Faraday.new(@json_rpc_endpoint) do |f|
          f.adapter :net_http_persistent, pool_size: 5, idle_timeout: @idle_timeout
        end.tap do |connection|
          unless @json_rpc_endpoint.user.blank?
            connection.basic_auth(@json_rpc_endpoint.user, @json_rpc_endpoint.password)
          end
        end
      end

    end
  end

end

