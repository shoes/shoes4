shared_examples_for "edit_line DSL method" do
  context "edit_line" do
    include_examples "editable element"

    let(:dsl_method) { :edit_line }
    let(:klazz) { Shoes::EditLine }
  end
end
