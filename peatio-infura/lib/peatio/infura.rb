require "active_support/core_ext/object/blank"
require "active_support/core_ext/enumerable"
require "peatio"

module Peatio
  module Infura
    require "bigdecimal"
    require "bigdecimal/util"
    require "peatio/infura/blockchain"
    require "peatio/infura/client"
    require "peatio/infura/wallet"

    require "peatio/infura/hooks"

    require "peatio/infura/version"
  end
end
