# TODO: Write documentation for `Iota`
module Iota
  module Bundle
    def self.get_entry_with_defaults(bundle_entry = {} of Symbol => String)
    end

    def self.create_bundle(entries = [] of String)

    end

    def self.add_entry(transactions = [] of String, entry  = "")

    end

    def self.add_trytes(transactions = [] of String, fragments = [] of String, offset = 0)
    end

    def self.finalize_bundle(transactions = [] of String)
    end
  end
end
