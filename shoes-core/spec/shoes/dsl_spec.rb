# frozen_string_literal: true

require 'spec_helper'

describe 'Unimplemented DSL methods' do
  include_context "dsl app"

  it 'video throws a Shoes::NotImplementedError' do
    expect { dsl.video }.to raise_error Shoes::NotImplementedError
  end

  it 'mask throws a Shoes::NotImplementedError' do
    expect { dsl.mask }.to raise_error Shoes::NotImplementedError
  end
end
