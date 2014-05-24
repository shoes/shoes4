shared_examples_for "image DSL method" do
  let(:path)  { Shoes::DIR + '/static/shoes-icon.png' }
  let(:opts)  { {} }
  let(:image) { dsl.image path, opts }

  it 'should set the path' do
    image.file_path.should == path
  end

  context 'with :top and :left style attributes' do
    let(:opts) { {left: 55, top: 66} }

    it 'should set the left' do
      image.left.should == 55
    end

    it 'should set the top' do
      image.top.should == 66
    end
  end
end
