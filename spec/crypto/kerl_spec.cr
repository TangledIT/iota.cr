require "./../spec_helper"

describe IOTA::Crypto::Kerl do
  it "should convert with SHA3" do
    digest = "\xe0\xef\x02\xd2FD\xa7\xb2\x8b<\x1b\x01\xc4\xfe\x13zI\x86M[\xdefV\xfa\xf49\xe1\xeb\xa6X\x06M\x9e\xcf\x842U\xba\x90=\x1c\xeb\xdcf\xff/\x16\xce"
    hexdigest = "e0ef02d24644a7b28b3c1b01c4fe137a49864d5bde6656faf439e1eba658064d9ecf843255ba903d1cebdc66ff2f16ce"

    a = Digest::Keccak3.new(384)
    a.update("GYOMKVTSNHVJNCNFBBAH9AAMXLPLLLROQY99QN9DLSJUHDPBLCFFAIQXZA9BKMBJCYSFHFPXAHDWZFEIZ")

    a.result.size.should eq 48
    a.hexdigest.should eq hexdigest
  end

  it "should absorb and squeeze" do
    input = "GYOMKVTSNHVJNCNFBBAH9AAMXLPLLLROQY99QN9DLSJUHDPBLCFFAIQXZA9BKMBJCYSFHFPXAHDWZFEIZ"
    expected = "OXJCNFHUNAHWDLKKPELTBFUCVW9KLXKOGWERKTJXQMXTKFKNWNNXYD9DMJJABSEIONOSJTTEVKVDQEWTW"

    trits = IOTA::Crypto::Converter.trits(input)

    kerl = IOTA::Crypto::Kerl.new
    kerl.absorb(trits)

    hash_trits = Array(Int32).new
    trots = kerl.squeeze(hash_trits)

    hash = IOTA::Crypto::Converter.trytes(trots) if trots.is_a?(Array(Int32))

    hash.should eq expected
  end

  it "should absorb and multi squeeze" do
    input = "9MIDYNHBWMBCXVDEFOFWINXTERALUKYYPPHKP9JJFGJEIUY9MUDVNFZHMMWZUYUSWAIOWEVTHNWMHANBH"
    expected = "G9JYBOMPUXHYHKSNRNMMSSZCSHOFYOYNZRSZMAAYWDYEIMVVOGKPJBVBM9TDPULSFUNMTVXRKFIDOHUXXVYDLFSZYZTWQYTE9SPYYWYTXJYQ9IFGYOLZXWZBKWZN9QOOTBQMWMUBLEWUEEASRHRTNIQWJQNDWRYLCA"

    trits = IOTA::Crypto::Converter.trits(input)
    kerl = IOTA::Crypto::Kerl.new
    kerl.absorb(trits)

    hash_trits = Array(Int32).new
    trots = kerl.squeeze(hash_trits, 0, IOTA::Crypto::Curl::HASH_LENGTH * 2)

    hash = IOTA::Crypto::Converter.trytes(trots) if trots.is_a?(Array(Int32))
    hash.should eq expected
  end

  it "should multi absorb and multi squeeze" do
    input = "G9JYBOMPUXHYHKSNRNMMSSZCSHOFYOYNZRSZMAAYWDYEIMVVOGKPJBVBM9TDPULSFUNMTVXRKFIDOHUXXVYDLFSZYZTWQYTE9SPYYWYTXJYQ9IFGYOLZXWZBKWZN9QOOTBQMWMUBLEWUEEASRHRTNIQWJQNDWRYLCA"
    expected = "LUCKQVACOGBFYSPPVSSOXJEKNSQQRQKPZC9NXFSMQNRQCGGUL9OHVVKBDSKEQEBKXRNUJSRXYVHJTXBPDWQGNSCDCBAIRHAQCOWZEBSNHIJIGPZQITIBJQ9LNTDIBTCQ9EUWKHFLGFUVGGUWJONK9GBCDUIMAYMMQX"

    trits = IOTA::Crypto::Converter.trits(input)
    kerl = IOTA::Crypto::Kerl.new
    kerl.absorb(trits, 0, trits.size)

    hash_trits = Array(Int32).new
    trots = kerl.squeeze(hash_trits, 0, IOTA::Crypto::Curl::HASH_LENGTH * 2)

    hash = IOTA::Crypto::Converter.trytes(trots) if trots.is_a?(Array(Int32))
    hash.should eq expected
  end
end
