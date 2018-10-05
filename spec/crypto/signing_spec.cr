require "./../spec_helper"

describe IOTA::Crypto::Signing do
  it "should convert sign seed" do
    seed = "OKPPJZ9INLAFGAQISJXLT9CINJKLPSFOSKJGEXGJGCAJHBPMFGJEHLLN9QFDMLAUHROHHHVQBAWPPICF9"
    p IOTA::Crypto::Converter.trits(seed)
    # key = IOTA::Crypto::Signing.key(IOTA::Crypto::Converter.trits(seed), 1, 1)
  end
end
