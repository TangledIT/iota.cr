require "./spec_helper"

describe Iota do
  # TODO: Write tests

  it "works" do
    iota = Iota::Core.new({:provider => "https://nodes.tangled.it"})

    # p iota.get_transactions_to_approve(depth: 15)
  end
end
