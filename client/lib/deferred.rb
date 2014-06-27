# Class for building anonymous deferred objects
#
# @example
#   deferred = Deferred.new
#   deferred.done do |data|
#     puts "Success: #{data}"
#   end
#
#   deferred.fail do |data|
#     puts "Fail: #{data}"
#   end
#
#   deferred.resolve(response)
#   # => "Success: ..."
#   # or
#   deferred.reject(response)
#   # => "Fail: ..."
#
class Deferred

  STATES = {
    1 => :pending,
    2 => :resolved,
    3 => :rejected
  }

  attr_reader :success_callbacks
  attr_reader :fail_callbacks

  def initialize
    @state = 1
    @success_callbacks = []
    @fail_callbacks = []
  end

  # Subscribes to "success" event
  #
  # @yield data [Hash] reponse data (data from `resolve` arguments)
  #
  def done(&callback)
    if resolved?
      callback.call(@data)
    else
      success_callbacks << callback
    end
  end

  # Subscribes to "fail" event
  #
  # @yield data [Hash] response data (data from `reject` arguments)
  #
  def fail(&callback)
    if rejected?
      callback.call(@data)
    else
      fail_callbacks << callback
    end
  end

  # Fires "success" event, runs 'done' callbacks
  #
  # @param response [TransmissionData]
  #
  def resolve(response)
    @state = 2
    @data = response.data
    success_callbacks.each { |c| c.call(@data) }
  end

  # Fires "fail" event, runs 'fail' callbacks
  #
  # @param response [TransmissionData]
  #
  def reject(response)
    @state = 3
    @data = response.data
    fail_callbacks.each { |c| c.call(@data) }
  end

  # Returns state of deferred object
  #
  # @return [Symbol]
  # @see Deferred::STATES
  #
  def state
    STATES[@state]
  end

  # Returns true if deferred object is pending (in initial state and no events were fired)
  #
  # @return [true, false]
  #
  def pending?
    state == :pending
  end

  # Returns true if deferred object is resolved (success event was fired)
  #
  # @return [true, false]
  #
  def resolved?
    state == :resolved
  end

  # Returns true if deferred object is rejected (faile event was fired)
  #
  # @return [true, false]
  #
  def rejected?
    state == :rejected
  end
end
