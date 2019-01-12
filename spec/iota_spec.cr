require "./spec_helper"

describe Iota do
  # TODO: Write tests

  it "works" do
    iota = Iota::Core.new({:provider => "https://nodes.tangled.it"})

    IRI.stub_get_node_info!
    p iota.get_node_info
  end
end
