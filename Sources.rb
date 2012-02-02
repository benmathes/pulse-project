class Sources
  @sourceHash = {}
  # a hash keyed on the source title since that's the unique ID as implied by the prob statement
  # this makes ordering trickier, but the hash lookup for checking if we have a source 
  # is worth it instead of searching the entire list of sources.
  # {
  #     "source title" => {
  #       "order" => 2,
  #       "object" => Source.new(...)
  #     },
  #     ...
  # }

  attr_accessor :sourceHash

  def initialize(sources = [])
    @sourceHash = {}
    sources.each do |source|
      if !source.is_a? Source
        source = Source.new(source['title'], source['feed_url'], source['updated'], source['order']);
      end

      @sourceHash[source.title] = source
    end
  end


  # returns the version of the passed-in source in the current source list, if any
  def get(source)
    return @sourceHash[source.title]
  end


  # returns the sorted list. nlogn expensive.
  def getOrdered
    sorted = @sourceHash.values.sort_by do |source|
      # when updating a source, it's possible that we have identital "order" values.
      # e.g. we think the order is a,b,c, and the user updates that c goes into pos 1.
      # it's not explicitly clear that the "right" answer is c,a,b or a,c,b, so we
      # infer that the "lastest" update to pos 1 wins.
      [ source.order, -source.updated ]
    end

    return sorted
  end


  # returns the version of the passed-in title in the current source list, if any
  def getByTitle(title)
    return @sourceHash[title]
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

    if $VERBOSE then puts "###### merging user source list with internal" end
    userSourceList.each do |userSource|
      userSource = Source.new(userSource['title'], userSource['feed_url'], userSource['updated'], userSource['order']);

      if self.shouldUpdate(userSource) 
        if $VERBOSE then puts "      updating source #{userSource.title}" end
        self.update(userSource)
      end

    end

    return @sourceHash
  end


  # returns a boolean whether self is the same as another Sources object
  def sameAs(otherSources)

    # early exit if possible
    if (self.sourceHash.length != otherSources.sourceHash.length)
      if $VERBOSE then puts "diferent lengths" end
      return false
    end

    # order them first to make sure the ordering logic is identical
    mineOrdered = self.getOrdered
    theirsOrdered = otherSources.getOrdered

    # check each one, in order, for equality
    for i in 0...[mineOrdered.length, theirsOrdered.length].max do
      mine = mineOrdered[i]
      theirs = theirsOrdered[i]

      # if missing in one of them
      if !mine
        if $VERBOSE then puts "missing the source for #{theirs.title} in my list" end
        return false
      elsif !theirs
        if $VERBOSE then puts "missing the source for #{mine.title} in their list" end
        return false
      elsif !mine.equals?(theirs)
        if $VERBOSE then puts "##{i} is different" end
        pp mine
        pp theirs
        return false
      end
    end

    return true
  end

end
