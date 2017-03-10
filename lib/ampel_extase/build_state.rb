class AmpelExtase::BuildState
  def self.for(a = nil)
    a ||= [ "N/A", nil ]
    new(*a)
  end

  def initialize(last_result, is_building)
    @last_result, @is_building = last_result, is_building
  end

  attr_reader :last_result

  def building?
    !!@is_building
  end

  def success?
    %w[passed SUCCESS N/A].include? @last_result
  end

  def to_a
    return @last_result, @is_building
  end

  def ==(other)
    to_a == other.to_a
  end

  def to_s
    if building?
      "#{@last_result} (building)"
    else
      @last_result.to_s
    end
  end
end
