class Profile < ActiveRecord::Base
  after_save :notify_clients

  def notify_clients
    puts "Notifying about changes in #{self.inspect}"
    TriggerStorage.each do |trigger|
      trigger.notify_client(self) if trigger.applicable_for?(self)
    end
  end
end