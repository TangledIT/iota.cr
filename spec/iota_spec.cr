require "./spec_helper"

describe IOTA do
  # TODO: Write tests

  it "loads client" do
    client = IOTA::Client.new
    # puts client.api
    client.api.get_node_info do

    end
  end
end
