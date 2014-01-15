require 'swt_shoes/spec_helper'

describe Shoes::App do
  before :each do
    # The stubs that are unstubbed here occur in the spec_helper
    # error not triggered with a stubbed flush (removing the stub overall
    # seemed to difficult after initial try)
    Shoes::Swt::App.any_instance.unstub(:flush)
    Shoes::Swt::RedrawingAspect.unstub :new
  end

  it 'does not fail with just a simple para #574' do
    expect do
      app = Shoes.app do para 'me no fail' end
      app.quit
    end.not_to raise_error
  end
end