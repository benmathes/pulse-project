require 'pp' # pretty-printing
require 'json' # data parsing

# include the classes for this
$LOAD_PATH << './'
require 'Source.rb'
require 'Sources.rb'

# pull from the raw source
simExampleText = File.open('problem-statement/raw-source.json', 'r').read
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
correctAnswer = Sources.new(simExample['correctOutput'])
correct = serverSources.sameAs(correctAnswer)
if (correct)
  puts "Success"
else
  puts "Failure!"
end

