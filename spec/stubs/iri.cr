module IRI
  def self.stub_get_node_info!
    WebMock.stub(:post, "https://nodes.tangled.it/").
      with(body: "{\"command\":\"getNodeInfo\"}").
      to_return(body: {
        "appName" => "IRI",
        "appVersion" => "1.0.8.nu",
        "duration" => 1,
        "jreAvailableProcessors" => 4,
        "jreVersion" => "1.8.0",
        "jreFreeMemory" => 91707424,
        "jreMaxMemory" => 1908932608,
        "jreTotalMemory" => 122683392,
        "latestMilestone" => "VBVEUQYE99LFWHDZRFKTGFHYGDFEAMAEBGUBTTJRFKHCFBRTXFAJQ9XIUEZQCJOQTZNOOHKUQIKOY9999",
        "latestMilestoneIndex" => 107,
        "latestSolidSubtangleMilestone" => "VBVEUQYE99LFWHDZRFKTGFHYGDFEAMAEBGUBTTJRFKHCFBRTXFAJQ9XIUEZQCJOQTZNOOHKUQIKOY9999",
        "latestSolidSubtangleMilestoneIndex" => 107,
        "milestoneStartIndex" => 5,
        "neighbors" => 2,
        "packetsQueueSize" => 0,
        "time" => 1477037811737,
        "tips" => 3,
        "transactionsToRequest" => 0,
        "features" => ["dnsRefresher","zeroMessageQueue","tipSolidification","RemotePOW"],
        "coordinatorAddress" => "KPWCHICGJZXKE9GSUDXZYUAPLHAKAHYHDXNPHENTERYMMBQOPSQIDENXKLKCEYCPVTZQLEEJVYJZV9BWU"
    }.to_json)
  end
end
