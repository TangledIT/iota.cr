require "./../spec_helper"

describe IOTA::Crypto::Kerl do
  it "should absorb and squeeze" do
    input = "GYOMKVTSNHVJNCNFBBAH9AAMXLPLLLROQY99QN9DLSJUHDPBLCFFAIQXZA9BKMBJCYSFHFPXAHDWZFEIZ"
    expected = "OXJCNFHUNAHWDLKKPELTBFUCVW9KLXKOGWERKTJXQMXTKFKNWNNXYD9DMJJABSEIONOSJTTEVKVDQEWTW"

    trits = IOTA::Crypto::Converter.trits(input)
    kerl = IOTA::Crypto::Kerl.new
    kerl.absorb(trits, 0, trits.size)
    puts kerl.k.result

    hash_trits = Hash(Int32, Int32).new
    kerl.squeeze(hash_trits)

    # puts kerl.k.result
    # output = IOTA::Crypto::Converter.trytes(hash_trits)
    # output.should eq expected
  end
end
