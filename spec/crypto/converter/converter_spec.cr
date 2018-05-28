require "./../../spec_helper"

describe IOTA::Crypto::Converter do
  it "should absorb and squeeze" do
    trits = IOTA::Crypto::Converter.trits("GYOMKVTSNHVJNCNFBBAH9AAMXLPLLLROQY99QN9DLSJUHDPBLCFFAIQXZA9BKMBJCYSFHFPXAHDWZFEIZ")
    puts trits
  end
end
