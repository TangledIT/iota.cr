require "./../../spec_helper"

describe IOTA::Crypto::Converter::Words do
  it "#swap32" do
    tests = [
      [15491, 15489]
    ]

    tests.each do |value|
      # IOTA::Crypto::Converter::Words.swap32(value[0]).should eq value[1]
    end
  end
end
