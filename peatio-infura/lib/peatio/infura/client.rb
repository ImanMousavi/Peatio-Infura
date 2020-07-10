require 'memoist'
require 'faraday'
require 'better-faraday'

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

      def initialize(endpoint, sign_uri, idle_timeout: 5)
        @json_rpc_endpoint = URI.parse(endpoint)
        @sign_rpc_endpoint = URI.parse(sign_uri)
        @json_rpc_call_id = 0
        @idle_timeout = idle_timeout
      end

      def json_rpc(method, params = [], conn_type=nil)
        current_conn = connection
        unless conn_type.nil?
          current_conn = sign_connection
        end
        response = current_conn.post \
          '/',
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

      def sign_connection
        @connection ||= Faraday.new(@sign_rpc_endpoint) do |f|
          f.adapter :net_http_persistent, pool_size: 5, idle_timeout: @idle_timeout
        end.tap do |connection|
          unless @json_rpc_endpoint.user.blank?
            connection.basic_auth(@json_rpc_endpoint.user, @json_rpc_endpoint.password)
          end
        end
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

