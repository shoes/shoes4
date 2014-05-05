require 'spec_helper'

describe RenamedDelegate do

  class ToDelegate
    def method_key
    end

    def abcd
    end

    def key
    end

    def bla_key
    end

    def method_something
    end

    def key_something
    end
  end

  class TestClass
    extend RenamedDelegate

    attr_reader :delegate

    def initialize(delegate)
      @delegate = delegate
    end
  end

  TestClass.renamed_delegate_to :delegate,
                                ToDelegate.public_instance_methods(false),
                                {'key' => 'shoes', 'something' => 'awesome'}

  let(:delegate) {double('delegate').as_null_object}
  subject {TestClass.new delegate}

  def test_renaming(new_name, old_name)
    subject.public_send new_name
    expect(delegate).to have_received old_name
  end

  it 'delegates method_shoes to method_key' do
    test_renaming :method_shoes, :method_key
  end

  it 'delegates shoes to key' do
    test_renaming :shoes, :key
  end

  it 'delegates bla_shoes to bla_key' do
    test_renaming :bla_shoes, :bla_key
  end

  it 'delegates method_awesome to method_something' do
    test_renaming :method_awesome, :method_something
  end

  it 'also applies multiple renamings' do
    test_renaming :shoes_awesome, :key_something
  end

  it 'does not define a method for methods without renamings' do
    expect(subject).not_to respond_to :abcd
  end
end