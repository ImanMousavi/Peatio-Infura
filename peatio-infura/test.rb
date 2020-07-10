require "lib/peatio/infura"

print("00000")
client = Peatio::Infura::Client.new(client = Peatio::Infura::Client.new("https://mainnet.infura.io/v3/186a22c7f0fe4dff998d57a823085ce4","https://mainnet.infura.io/v3/186a22c7f0fe4dff998d57a823085ce4"))
client.json_rpc(:eth_blockNumber)
