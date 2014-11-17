require "pathname"

describe "Shoes constants" do
  specify "PI equals Math::PI" do
    expect(Shoes::PI).to eq(Math::PI)
  end

  specify "TWO_PI equals 2 * Math::PI" do
    expect(Shoes::TWO_PI).to eq(2 * Math::PI)
  end

  specify "HALF_PI equals 0.5 * Math::PI" do
    expect(Shoes::HALF_PI).to eq(0.5 * Math::PI)
  end

  describe "DIR" do
    let(:shoes_home_dir) { Pathname.new(__FILE__).join("../../..").expand_path }
    subject { Pathname.new Shoes::DIR }

    it "is the shoes home directory" do
      expect(subject).to eq(shoes_home_dir)
    end

    it "contains lib/shoes.rb" do
      expect(subject.join("lib/shoes.rb")).to exist
    end

    it "contains static/shoes_icon.png" do
      expect(subject.join("static/shoes-icon.png")).to exist
    end

    it "remains constant when current directory changes" do
      Dir.chdir ".." do
        expect(subject).to eq(shoes_home_dir)
      end
    end
  end
end
