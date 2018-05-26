require "./../spec_helper"

describe IOTA::API::Api do
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

  describe "#get_balances" do
    it "should return balance" do
      success, data = CLIENT.api.get_balances(
        ["XHCDYOWGDVARNHUBHWCGJCWSAASUITPAKASZPPAKOGUS9OPBKTHYHTWAYWITMZLWSFGBJKLJLJZBQMSAAGYULZGBAD",
         "HOACWXMLM9SEUFBOJ9EERSWEPPWJFIUHFFICYAMNQFIEOXJLUGQPHGEULDJLG9KJLWTSAF9UVBOSYEPEDFONKIQLAB"], 15
      )
      success.should be_true
      data["balances"].size.should eq(2)
    end
  end

  describe "#get_trytes" do
    it "should return trytes" do
      success, data = CLIENT.api.get_trytes(
        ["PUTVHDD9QPORUQTNUMIJOHDCBGRGTDSUWQPXRGFRTDOTUQBZCTCLTNUTKHIYWDISXKOZKWACRWPOEH999"]
      )
      success.should be_true
      data["trytes"].size.should eq(1)
    end
  end

  describe "#get_inclusion_states" do
    it "should return inclusion states" do
      success, data = CLIENT.api.get_inclusion_states(
        ["Y9CRLCBMNVBRMBZBGTUASIFQQDSCG9IISTJLRGISGMRWSFSPTQGHZM9ICLYXJJTXEWVR9XZGLCKCLW999"],
        ["9VSCYRLRYCGUOSLKUWAJ9QENGYQHSZAZLJMYTVVTBEKGF9UVQNEUZMNEMCQRTIOK9DFFBSRACWKHPX999"]
      )
      success.should be_true
      data["states"][0].should be_true
    end
  end

  describe "#get_node_info" do
    it "should return node info" do
      success, data = CLIENT.api.get_node_info
      success.should be_true
      data["appName"].to_s.should eq("IRI Testnet")
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
    it "should fail to add neighbors" do
      success, data = CLIENT.api.add_neighbors(["udp://8.8.8.8:14265"])
      success.should be_false
      data.to_s.should match /not available/
    end
  end

  describe "#remove_neighbors" do
    it "should fail to remove neighbors" do
      success, data = CLIENT.api.remove_neighbors(["udp://8.8.8.8:14265"])
      success.should be_false
      data.to_s.should match /not available/
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

  describe "#get_transactions_to_approve" do
    it "should return transactions to approve" do
      success, data = CLIENT.api.get_transactions_to_approve(5)
      success.should be_true
      puts data["trunkTransaction"]?.should be_truthy
    end
  end
end
