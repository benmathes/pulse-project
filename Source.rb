class Source
  @title = ""
  @feed_url = ""
  @updated = ""

  attr_accessor :title, :feed_url, :updated

  def initialize(title, feed_url, updated)
    @title = title
    @feed_url = feed_url
    @updated = updated
  end


  def newerThan(otherSource)
    return @updated > otherSource.updated
  end


  def equals?(otherSource)
    toCheck = [:title, :feed_url, :updated]
    toCheck.each do |attr|
      if self.send(attr) != otherSource.send(attr)
        return false
      end
    end

    return true
  end

end

