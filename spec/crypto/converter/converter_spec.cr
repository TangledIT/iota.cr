require "./../../spec_helper"

describe IOTA::Crypto::Converter do
  it "should create trits from trytes and reversed" do
    trytes = "GYOMKVTSNHVJNCNFBBAH9AAMXLPLLLROQY99QN9DLSJUHDPBLCFFAIQXZA9BKMBJCYSFHFPXAHDWZFEIZ"
    trits = IOTA::Crypto::Converter.trits(trytes)
    trits.size.should eq 243
    trits.should be_a(Hash(Int32, Int32))

    trytes_output = IOTA::Crypto::Converter.trytes(trits)
    trytes_output.should eq trytes
  end
end
