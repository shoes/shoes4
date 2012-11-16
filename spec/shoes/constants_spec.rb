require "pathname"

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

  describe "DIR" do
    let(:shoes_home_dir) { Pathname.new(__FILE__).join("../../..").expand_path }
    subject { Pathname.new Shoes::DIR }

    it "is the shoes home directory" do
      subject.should eq(shoes_home_dir)
    end

    it "contains lib/shoes.rb" do
      subject.join("lib/shoes.rb").should exist
    end

    it "contains static/shoes_icon.png" do
      subject.join("static/shoes-icon.png").should exist
    end

    it "remains constant when current directory changes" do
      Dir.chdir ".." do
        subject.should eq(shoes_home_dir)
      end
    end
  end
end
