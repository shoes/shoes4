shared_examples_for "edit_box DSL method" do
  context "edit_box" do
    include_examples "editable element" do
      let(:dsl_method) { :edit_box }
      let(:klazz) { Shoes::EditBox }
    end
  end
end
