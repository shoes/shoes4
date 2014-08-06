shared_examples_for "style DSL method" do
  describe "setting new defaults for text block" do
    let(:stroke) { Shoes::COLORS[:chartreuse] }
    let(:size)   { 42 }
    let(:fill)   { Shoes::COLORS[:peru] }
    let(:font )  { "SOME FONT" }
    let(:style)  { {:stroke => stroke, :size => size, :fill => fill, :font => font} }

    %w(Banner Title Subtitle Tagline Caption Para Inscription).each do |text_block|
      describe text_block do
        let(:element) { dsl.public_send text_block.downcase, "Hello!" }
        let(:klass) { Shoes.const_get(text_block) }

        before :each do
          dsl.style klass, style
        end

        it "creates element with appropriate class" do
          expect(element.class).to eq(klass)
        end

        it "sets size" do
          expect(element.size).to eq(size)
        end

        it "sets font" do
          expect(element.font).to eq(font)
        end
      end
    end
  end
end
