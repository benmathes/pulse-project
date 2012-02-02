class Source
  @title
  @feed_url
  @updated

  attr_accessor :title, :feed_url, :updated

  def initialize(title, feed_url, updated)
    @title = title
    @feed_url = feed_url
    @updated = updated
  end


  def newerThan(otherSource)
    return @updated > otherSource.updated
  end

end

