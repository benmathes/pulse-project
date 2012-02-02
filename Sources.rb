class Sources
  @sourceHash

  def initialize(sources = [])
    @sourceHash = {}
    sources.each do |source|
      @sourceHash[source.title] = source
    end
  end


  # returns the version of the passed-in source in the current source list
  def get(source)
    return @sourceHash[source.title]
  end

  
  # adds a source to the list, or overwrites it if it's already there
  def update(source)
    @sourceHash[source.title] = source
  end


  # abstracts out the logic of whether a source should be updated in this list
  def shouldUpdate(source)
    if (!self.get(source) || source.newerThan(@sourceHash[source.title]))
      self.update(source)
    end
  end


  # takes a user source list and merges with the internal source hash.
  # returns the new, merged list
  def merge(userSourceList)
    userSourceList.each do |userSource|
      userSource = Source.new(userSource['title'], userSource['feed_url'], userSource['updated']);

      if self.shouldUpdate(userSource)
        self.update(userSource)
      end
    end

    return @sourceHash
  end

end
