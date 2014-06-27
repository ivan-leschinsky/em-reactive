require 'spec_helper'
require 'client/lib/deferred'

describe Deferred do
  subject(:deferred) { Deferred.new }
  let(:response) { double(:response, data: "data") }

  it "allows to subscribe to success event and run callback when success event was fired" do
    called = false
    deferred.done { |data| called = true }
    deferred.resolve(response)
    called.should be_true
  end

  it "allows to subscribe to fail event and run callback when fail event was fired" do
    called = false
    deferred.fail { |data| called = true }
    deferred.reject(response)
    called.should be_true
  end

  it "calls success callback even when event was previously fired" do
    called = false
    deferred.resolve(response)
    deferred.done { |data| called = true }
    called.should be_true
  end

  it "calls success callback even when event was previously fired" do
    called = false
    deferred.reject(response)
    deferred.fail { |data| called = true }
    called.should be_true
  end

  context "passing response data to callbacks" do
    let(:data) { double(:data) }
    let(:response) { double(:response, data: data) }

    it "passes response data to success callback" do
      callback_arg = nil
      deferred.done { |arg| callback_arg = arg }
      deferred.resolve(response)
    end

    it "passes response data to reject callback" do
      callback_arg = nil
      deferred.fail { |arg| callback_arg = arg }
      deferred.reject(response)
    end
  end

  context "state" do
    context "when deferred is pending" do
      its(:state) { should eq(:pending) }
      its(:pending?) { should be_true }
      its(:rejected?) { should be_false }
      its(:resolved?) { should be_false }
    end

    context "when deferred is rejected" do
      before { deferred.reject(response) }
      its(:state) { should eq(:rejected) }
      its(:pending?) { should be_false }
      its(:rejected?) { should be_true }
      its(:resolved?) { should be_false }
    end

    context "when deferred is resolved" do
      before { deferred.resolve(response) }
      its(:state) { should eq(:resolved) }
      its(:pending?) { should be_false }
      its(:rejected?) { should be_false }
      its(:resolved?) { should be_true }
    end
  end
end
