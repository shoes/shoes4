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
end
