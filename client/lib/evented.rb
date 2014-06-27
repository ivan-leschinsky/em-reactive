module Evented
  def self.run(subject, event)
    puts "Evented: #{subject} #{event}"
    events[subject][event].each(&:call)
  end

  def self.on(subject, event, &block)
    events[subject][event] << block
  end

  private

  def self.events
    @events ||= Hash.new { |h1, k1| h1[k1] = Hash.new { |h2, k2| h2[k2] = Array.new } }
  end
end