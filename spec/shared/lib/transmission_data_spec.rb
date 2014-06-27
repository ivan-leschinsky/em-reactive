require 'spec_helper'
require 'shared/lib/uid'
require 'shared/lib/transmission_data'

describe TransmissionData do

  describe "#initialize" do
    let(:message) { double(:message) }
    let(:data) { double(:data) }
    let(:uid) { double(:uid) }

    context "when all arguments were passed" do
      subject(:transmission_data) { TransmissionData.new(message, data, uid) }

      it "stores passed message, data and uid" do
        transmission_data.message.should eq(message)
        transmission_data.data.should eq(data)
        transmission_data.uid.should eq(uid)
      end
    end

    context "when message argument is blank" do
      it "raises error" do
        expect { TransmissionData.new(nil, data, uid) }.to raise_error(RuntimeError, "TransmissionData: message can't be blank")
      end
    end

    context "when data argument is blank" do
      it "raises error" do
        expect { TransmissionData.new(message, nil, uid) }.to raise_error(RuntimeError, "TransmissionData: data can't be blank")
      end
    end

    context "when uid argument is blank" do
      it "raises error" do
        expect { TransmissionData.new(message, data, nil) }.to raise_error(RuntimeError, "TransmissionData: uid can't be blank")
      end
    end
  end

  context "from/to json conversion" do
    let(:json) { %Q{{"message":"message","data":"data","uid":"uid"}} }

    describe "#to_json" do
      subject(:transmission_data) { TransmissionData.new("message", "data", "uid") }

      it "converts it to json" do
        transmission_data.to_json.should eq(json)
      end
    end

    describe ".from_json" do
      subject(:transmission_data) { TransmissionData.from_json(json) }
      it "builds object from given json" do
        transmission_data.message.should eq("message")
        transmission_data.data.should eq("data")
        transmission_data.uid.should eq("uid")
      end
    end
  end
end