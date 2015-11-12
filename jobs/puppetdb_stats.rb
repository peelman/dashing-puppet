require 'net/http'
require 'json'
require 'time'
require 'uri'

host = 'HOSTNAME'
port = 'PORT'
unreported_delay = 3600 # one hour
use_ssl = false
host_cert = "/path/to/puppet/ssl/certs/fqdn.pem"
host_key = '/path/to/puppet/ssl/private_keys/fqdn.pem'

http = Net::HTTP.new(host, port)

if use_ssl
  http.use_ssl = true
  http.cert = OpenSSL::X509::Certificate.new(File.read(host_cert))
  http.key = OpenSSL::PKey::RSA.new(File.read(host_key))
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
end

one_hour_ago = (Time.now - unreported_delay).utc.iso8601

nodes_uri = '/metrics/v1/mbeans/puppetlabs.puppetdb.query.population:type=default,name=num-nodes'
agg_eventcounts_uri = '/pdb/query/v4/aggregate-event-counts?query=%5B%22%3D%22%2C%22latest_report%3F%22%2Ctrue%5D&summarize_by=certname'
unreported_uri = "/pdb/query/v4/nodes?query=%5B%22extract%22%2C%5B%5B%22function%22%2C%22count%22%5D%5D%2C%5B%22%3C%22%2C%22report_timestamp%22%2C%22#{one_hour_ago}%22%5D%5D"

SCHEDULER.every '5m', :first_in => 0 do |job|
  num_nodes = JSON.parse(http.get(nodes_uri).body)
  agg_eventcounts = JSON.parse(http.get(agg_eventcounts_uri).body)
  unreported = JSON.parse(http.get(unreported_uri).body)

  send_event('puppetdb_stats', { num_nodes: num_nodes['Value'],
                                 unreported: unreported.first['count'].to_i,
                                 successes: agg_eventcounts.first['successes'],
                                 failures: agg_eventcounts.first['failures']
                                 })
end