class Sources
  @sourceHash = {}

  attr_accessor :sourceHash

  def initialize(sources = [])
    @sourceHash = {}
    sources.each do |source|
      if !source.is_a? Source
        source = Source.new(source['title'], source['feed_url'], source['updated']);
      end

      @sourceHash[source.title] = source
    end
  end


  # returns the version of the passed-in source in the current source list, if any
  def get(source)
    return @sourceHash[source.title]
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
      userSource = Source.new(userSource['title'], userSource['feed_url'], userSource['updated']);

      if self.shouldUpdate(userSource) 
        if $VERBOSE then puts "      updating source #{userSource.title}" end
        self.update(userSource)
      end

    end

    return @sourceHash
  end


  # returns a boolean whether self is the same as another Sources object
  def sameAs(otherSources)

    # titles are our unique key. Need to go over all of them
    allTitles = @sourceHash.keys | otherSources.sourceHash.keys
    allTitles.each do |title|
      mine = self.getByTitle(title)
      theirs = self.getByTitle(title)

      # if missing in one of them
      if !mine
        if $VERBOSE then puts "missing the source for #{title} in my list" end
        return false
      elsif !theirs
        if $VERBOSE then puts "missing the source for #{title} in their list" end
        return false
      elsif !mine.equals?(theirs)
        if $VERBOSE then puts "#{title} is different" end
        return false
      end

    end

    return true
  end

end
