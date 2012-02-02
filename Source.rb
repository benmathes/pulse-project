class Source
  @title = ""
  @feed_url = ""
  @updated = ""
  @order = nil

  attr_accessor :title, :feed_url, :updated, :order

  def initialize(title, feed_url, updated, order)
    @title = title
    @feed_url = feed_url
    @updated = updated
    @order = order
  end


  def newerThan(otherSource)
    return @updated > otherSource.updated
  end


  def equals?(otherSource)
    toCheck = [:title, :feed_url, :updated, :order]
    toCheck.each do |attr|
#      puts "#{self.title}'s #{attr}: (#{ self.send(attr) }, #{ otherSource.send(attr) })"
      if self.send(attr) != otherSource.send(attr)
        return false
      end
    end

    return true
  end

end

