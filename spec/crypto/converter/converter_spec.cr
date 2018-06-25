require "./../../spec_helper"

describe IOTA::Crypto::Converter do
  it "should create trits from trytes and reversed" do
    trytes = "GYOMKVTSNHVJNCNFBBAH9AAMXLPLLLROQY99QN9DLSJUHDPBLCFFAIQXZA9BKMBJCYSFHFPXAHDWZFEIZ"

    trits = IOTA::Crypto::Converter.trits(trytes)
    trits.should be_a(Array(Int32))
    trits.size.should eq 243

    trytes_output = IOTA::Crypto::Converter.trytes(trits)
    trytes_output.should eq trytes
  end
end
