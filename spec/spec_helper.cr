require "spec"
require "../src/iota"

CLIENT = IOTA::Client.new({
  host: "https://nodes.testnet.iota.org", port: 443, timeout: 120,
})
