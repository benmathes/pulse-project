require 'pp' # pretty-printing
require 'json' # data parsing

# pull from the raw source
sourceText = File.open('problem-statement/raw-source.json', 'r').read
source = JSON.parse(sourceText)

# what we think is the canonical version (server-side). Based on the
# problem description, it looks like feed title is the unique ID 
# (updating the URL to "A" doesn't make a new feed item)
# example format: serverSide = { "A" => { "feed_url" => "www...", "updated" => 123 } }
# keyed on the unique attr for faster existence lookups, but this requires
# maintaining an ordering
serverSide = {} 

source['updateActions'].each do |updateList|
  updateList.each do |userSource|

    # if we don't have it, add it
    if !serverSide[userSource['title']]
      serverSide[userSource['title']] = userSource
    else 
      # if we're resolving differences, compare timestamps and take the latest
      if serverSide[userSource['title']]['updated'] < userSource['updated']
        serverSide[userSource['title']] = userSource
      end
    end

  end
end


pp(serverSide)
