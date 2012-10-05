describe "Shoes constants" do
  specify "PI equals Math::PI" do
    Shoes::PI.should eq(Math::PI)
  end

  specify "TWO_PI equals 2 * Math::PI" do
    Shoes::TWO_PI.should eq(2 * Math::PI)
  end

  specify "HALF_PI equals 0.5 * Math::PI" do
    Shoes::HALF_PI.should eq(0.5 * Math::PI)
  end

  let(:shoes_rb_dir) { File.absolute_path File.join(File.dirname(__FILE__), "..", "..", "lib") }

  it "is the directory where shoes.rb lives" do
    Shoes::DIR.should eq(shoes_rb_dir)
  end

  it "remains constant when current directory changes" do
    Dir.chdir ".." do
      Shoes::DIR.should eq(shoes_rb_dir)
    end
  end
end
