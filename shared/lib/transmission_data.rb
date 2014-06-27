require 'json'

class TransmissionData

  attr_reader :message, :data, :uid

  def initialize(message, data, uid = UID.generate)
    @message = message
    @data = data
    @uid = uid
    check_params!
  end

  def to_json
    { message: message, data: data, uid: uid }.to_json
  end

  def self.from_json(json_data)
    parsed_json = JSON.parse(json_data)
    TransmissionData.new(parsed_json['message'], parsed_json['data'], parsed_json['uid'])
  end

  private

  def check_params!
    [:message, :data, :uid].each do |attribute|
      raise "TransmissionData: #{attribute} can't be blank" if send(attribute).nil?
    end
  end
end