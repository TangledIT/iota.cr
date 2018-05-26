require "./../spec_helper"

describe IOTA::API::Api do
  describe "#get_node_info" do
    it "should return node info" do
      success, data = CLIENT.api.get_node_info
      success.should be_true
      data["appName"].to_s.should eq("IRI Testnet")
    end
  end

  describe "#find_transactions" do
    it "should return transactions" do
      success, data = CLIENT.api.find_transactions({
        "bundles"   => ["TCLO9HO9JGLWVULETGGS9SRHL9TPSYPLZTEVYFTCGKEIOL99ZQYCKGJIAHAXZ9CGBE9P9H9TDAIYRCCJB"],
        "tags"      => ["VJ9999999999999999999999999"],
        "addresses" => ["XHCDYOWGDVARNHUBHWCGJCWSAASUITPAKASZPPAKOGUS9OPBKTHYHTWAYWITMZLWSFGBJKLJLJZBQMSAAGYULZGBAD"],
      })
      success.should be_true
    end
  end

  describe "#get_tips" do
    it "should return tips" do
      success, data = CLIENT.api.get_tips
      success.should be_true
      data["hashes"][0].to_s.size.should eq(81)
      data["hashes"].size.should be > 0
    end
  end

  describe "#get_neighbors" do
    it "should return neighbors" do
      success, data = CLIENT.api.get_neighbors
      success.should be_false
      data.to_s.should match /not available/
    end
  end

  describe "#add_neighbors" do
    it "should return neighbors" do
      success, data = CLIENT.api.add_neighbors(["udp://8.8.8.8:14265"])
      success.should be_false
      data.to_s.should match /not available/
    end
  end
end
