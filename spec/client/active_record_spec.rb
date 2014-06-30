require 'spec_helper'
require 'pry'

def with_client_active_record
  Object.send(:remove_const, :ActiveRecord) if defined?(ActiveRecord)
  $LOADED_FEATURES.delete_if { |i| i.match("active_record") || i.match("activerecord") }
  $:.unshift File.join(ROOT, 'client')
  require 'active_record'
  yield
  $:.shift
  $LOADED_FEATURES.delete_if { |i| i.match("active_record") || i.match("activerecord") }
  Object.send(:remove_const, :ActiveRecord) if defined?(ActiveRecord)
end

describe "client ActiveRecord::Base" do

  let(:model) do
    stub_const("Test::Post", Class.new(ActiveRecord::Base)).tap do |klass|
      klass.column_names = ["title", "id", "description"]
    end
  end

  around(:each) do |example|
    with_client_active_record do
      example.run
    end
  end


  context "#initialize" do
    let(:attrs) { { title: "Title", description: "Description" } }

    it "stores passed arguments" do
      instance = model.new(attrs)
      instance.attrs.should eq(attrs)
    end

    context "when non-column was passed" do
      it "raises exception" do
        expect { model.new(asd: 123) }.to raise_error(ActiveRecord::UknownAttribute, "Unknown attribute 'asd'")
      end
    end
  end

  context "instance accessors" do
    subject(:instance) { model.new(id: 1, title: "Title", description: "Description") }

    its(:id) { should eq(1) }
    its(:title) { should eq("Title") }
    its(:description) { should eq("Description") }

    it { should respond_to(:id) }
    it { should respond_to(:title) }
    it { should respond_to(:description) }

    it { should_not respond_to(:some_attr) }

    it { expect { instance.some_attr }.to raise_error }
  end

  context "chaining" do
    subject(:chained) { model.where(title: "Title", description: "Description").offset(10).first }
    it { should be_a(ActiveRecord::ChainedObject) }

    let(:expected_data) do
      [
        {
          method: :where,
          args: [{ title: "Title", description: "Description" }]
        },
        {
          method: :offset,
          args: [10]
        },
        {
          method: :first,
          args: []
        }
      ]
    end

    its(:data) { should eq(expected_data) }
  end

end