require 'pp' # pretty-printing
require 'json' # data parsing

# include the classes for this
$LOAD_PATH << './'
require 'Source.rb'
require 'Sources.rb'

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: run_simulation.rb --source [raw-source, raw-source-w-reorder]"
  opts.on('-s [ARG]', '--source [ARG]', "Specify the source json") do |v|
    options[:source] = v
  end
  opts.on('-h', '--help', 'Display this help') do 
    puts opts
    exit
  end
end.parse!


# pull from the raw source
simExampleText = File.open("problem-statement/#{options[:source]}.json", 'r').read
simExample = JSON.parse(simExampleText)

# what we think is the canonical version (server-side). Based on the
# problem description, it looks like feed title is the unique ID 
# (updating the URL to "A" doesn't make a new feed item)
# example format: serverSide = { "A" => { "feed_url" => "www...", "updated" => 123 } }
# keyed on the unique attr for faster existence lookups, but this requires
# maintaining an ordering
serverSources = Sources.new() 

simExample['updateActions'].each do |userSourceList|
  serverSources.merge(userSourceList)
  # send down new list if there was a user on the other side

end


# verify we got it right
if (serverSources.sameAs(Sources.new(simExample['correctOutput'])))
  puts "Success"
else
  puts "Failure!"
end

