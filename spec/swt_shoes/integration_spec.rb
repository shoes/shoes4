require 'swt_shoes/spec_helper'

describe Shoes::App do
  before :each do
    # The stubs that are unstubbed here occur in the spec_helper
    # error not triggered with a stubbed flush (removing the stub overall
    # seemed to difficult after initial try)
    allow_any_instance_of(Shoes::Swt::App).to receive(:flush).and_call_original
    allow(Shoes::Swt::RedrawingAspect).to receive(:new).and_call_original
  end

  it 'does not fail with just a simple para #574' do
    expect do
      app = Shoes.app do para 'me no fail' end
      app.quit
    end.not_to raise_error
  end
end
