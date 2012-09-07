require 'swt_shoes/spec_helper'

describe "alert" do
  let(:mock_mb) { mock(:mb, setMessage: true, open: true) }
  
  subject { alert 'hello' }
  
  specify "pops up a window containing a short message." do
    ::Swt::Widgets::Shell.stub(:new)
    ::Swt::Widgets::MessageBox.stub(:new) { mock_mb }
    subject
  end
end
