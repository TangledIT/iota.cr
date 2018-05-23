require "./spec_helper"

describe IOTA do
  # TODO: Write tests

  it "loads client" do
    client = IOTA::Client.new({
      host: "https://nodes.testnet.iota.org", port: 443, timeout: 120,
    })
  end
end
