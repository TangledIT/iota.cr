require "./../spec_helper"

describe IOTA::API::Api do
  describe "#get_node_info" do
    it "should return node info" do
      client = IOTA::Client.new({
        host: "https://nodes.testnet.iota.org", port: 443, timeout: 120,
      })

      success, data = client.api.get_node_info
      success.should be_true
      puts data["appName"].to_s.should eq("IRI Testnet")
    end
  end

  describe "#get_tips" do
    it "should return tips" do
      client = IOTA::Client.new({
        host: "https://nodes.testnet.iota.org", port: 443, timeout: 120,
      })

      success, data = client.api.get_tips
      success.should be_true
      # puts data["hashes"]
    end
  end
end
