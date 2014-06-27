require 'spec_helper'
require 'shared/lib/uid'

describe UID do
  context ".generate" do
    let(:length) { 30 }
    subject(:uid) { UID.generate(length) }
    let(:another_uid) { UID.generate(length)  }

    it { should be_instance_of(String) }
    its(:length) { should eq(length) }
    it { should_not eq(another_uid) }
  end
end
