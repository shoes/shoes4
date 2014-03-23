require 'spec_helper'

# also for stuff that is hard/brittle to test in isolation
describe 'Integration specs' do
  describe 'hover & leave' do

    # that #hover and #leave are called with @__app__.current_slot is hard to
    # test since therefore there needs to be a current slot which is only during
    # block execution, stubbing it seems fairly brittle and dependent on
    # internal structure, see #603
    it 'does not raise an error' do
      expect do
        Shoes.app do
          hover {}
          leave {}
        end
      end.not_to raise_error
    end
  end
end