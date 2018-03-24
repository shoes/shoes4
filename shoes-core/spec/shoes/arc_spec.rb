# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Arc do
  include_context "dsl app"
  let(:parent) { app }

  let(:left)        { 13 }
  let(:top)         { 44 }
  let(:width)       { 200 }
  let(:height)      { 300 }
  let(:start_angle) { 0 }
  let(:end_angle)   { Shoes::TWO_PI }

  describe "basic" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle) }

    it_behaves_like "an art element" do
      let(:subject_without_style) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle) }
      let(:subject_with_style) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle, arg_styles) }
    end
    it_behaves_like "left, top as center", :start_angle, :end_angle

    it "is a Shoes::Arc" do
      expect(arc.class).to be(Shoes::Arc)
    end

    its(:angle1) { should eq(0) }
    its(:angle2) { should eq(Shoes::TWO_PI) }
    its(:wedge)  { should eq(false) }
  end

  describe "relative dimensions" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, relative_width, relative_height, start_angle, end_angle) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, -width, -height, 0, Shoes::TWO_PI) }
    it_behaves_like "object with negative dimensions"
  end

  describe "with wedge: true" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle, wedge: true) }

    its(:wedge) { should eq(true) }
  end

  describe "dsl" do
    it "takes no arguments" do
      arc = dsl.arc
      expect(arc).to have_attributes(left: 0,
                                     top: 0,
                                     width: 0,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 1 argument" do
      arc = dsl.arc 10
      expect(arc).to have_attributes(left: 10,
                                     top: 0,
                                     width: 0,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 1 argument with hash" do
      arc = dsl.arc 10, top: 20, width: 30, height: 40
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 2 arguments" do
      arc = dsl.arc 10, 20
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 0,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 2 arguments with hash" do
      arc = dsl.arc 10, 20, width: 30, height: 40
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 2 arguments with hash side" do
      arc = dsl.arc 10, 20, width: 30
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 3 arguments" do
      arc = dsl.arc 10, 20, 30
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 3 arguments with hash" do
      arc = dsl.arc 10, 20, 30, height: 40
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 4 arguments" do
      arc = dsl.arc 10, 20, 30, 40
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 4 arguments with hash" do
      arc = dsl.arc 10, 20, 30, 40, left: -1, top: -2, width: -3, height: -4
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 5 arguments" do
      arc = dsl.arc 10, 20, 30, 40, Shoes::PI
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: 0)
    end

    it "takes 5 arguments with hash" do
      arc = dsl.arc 10, 20, 30, 40, Shoes::PI,
                    left: -1, top: -2, width: -3, height: -4, angle1: -5, angle2: 6
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: 6)
    end

    it "takes 6 arguments" do
      arc = dsl.arc 10, 20, 30, 40, Shoes::PI, Shoes::TWO_PI
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: Shoes::TWO_PI)
    end

    it "takes 6 arguments with hash" do
      arc = dsl.arc 10, 20, 30, 40, Shoes::PI, Shoes::TWO_PI,
                    left: -1, top: -2, width: -3, height: -4, angle1: -5, angle2: -6
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: Shoes::TWO_PI)
    end

    it "takes styles hash" do
      arc = dsl.arc left: 10, top: 20, width: 30, height: 40,
                    angle1: Shoes::PI, angle2: Shoes::TWO_PI
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: Shoes::TWO_PI)
    end

    it "doesn't like too many arguments" do
      expect { dsl.arc 10, 20, 30, 40, Shoes::PI, Shoes::TWO_PI, 666 }.to raise_error(ArgumentError)
    end

    it "doesn't like too many arguments and options too!" do
      expect { dsl.arc 10, 20, 30, 40, Shoes::PI, Shoes::TWO_PI, 666, left: -1 }.to raise_error(ArgumentError)
    end
  end

  describe 'in_bounds methods' do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle) }

    describe '#radius_x' do
      it 'must return half the width' do
        expect(arc.radius_x).to eq(width.to_f / 2)
      end
    end

    describe '#radius_y' do
      it 'must return half the height' do
        expect(arc.radius_y).to eq(height.to_f / 2)
      end
    end

    describe '#middle_x' do
      it 'must return the left plus radius_x' do
        expect(arc.middle_x).to eq(113.0)
      end
    end

    describe '#middle_y' do
      it 'must return the top plus radius_y' do
        expect(arc.middle_y).to eq(194.0)
      end
    end

    describe '#inside_oval?' do
      context 'when point is inside' do
        it 'must return true' do
          expect(arc.inside_oval??(arc.middle_x, arc.middle_y)).to eq(true)
        end
      end

      context 'when point is outside' do
        it 'must return false' do
          expect(arc.inside_oval??(arc.top, arc.left)).to eq(false)
        end
      end
    end

    describe '#adjust_angle' do
      it 'must rotate the angle 1.5708 radians (90 degrees)' do
        expect(arc.adjust_angle(1.5708)).to eq(3.1416)
      end
    end

    describe '#y_adjust_negative?' do
      context 'when angle is between 0 and 1.5708' do
        it 'must return true' do
          expect(arc.y_adjust_negative?(1)).to eq(true)
        end
      end

      context 'when angle is between 1.5708 and 4.71239' do
        it 'must return false' do
          expect(arc.y_adjust_negative?(2)).to eq(false)
        end
      end

      context 'when angle is between 4.71239 and 6.28319' do
        it 'must return true' do
          expect(arc.y_adjust_negative?(5)).to eq(true)
        end
      end
    end

    describe '#x_adjust_positive?' do
      context 'when angle is between 0 and 3.14159' do
        it 'must return true' do
          expect(arc.y_adjust_negative?(1)).to eq(true)
        end
      end

      context 'when angle is above 3.14159' do
        it 'must return false' do
          expect(arc.y_adjust_negative?(2)).to eq(false)
        end
      end
    end

    describe '#y_result_adjustment' do
      context 'when #y_adjust_negative? is false' do
        before(:each){allow(arc).to receive(:y_adjust_negative?){false}}

        it 'should add y_result to middle_y' do
          expect(arc.y_result_adjustment(1,1)).to eq(195.0)
        end
      end

      context 'when #y_adjust_negative? is true' do
        before(:each){allow(arc).to receive(:y_adjust_negative?){true}}

        it 'should subtract y_result from middle_y' do
          expect(arc.y_result_adjustment(1,1)).to eq(193.0)
        end
      end

    end

    describe '#x_result_adjustment' do
      context 'when #x_adjust_positive? is false' do
        before(:each){allow(arc).to receive(:x_adjust_positive?){false}}

        it 'should subtract y_result from middle_y' do
          expect(arc.x_result_adjustment(1,1)).to eq(112.0)
        end
      end

      context 'when #x_adjust_positive? is true' do
        before(:each){allow(arc).to receive(:x_adjust_positive?){true}}

        it 'should add y_result from middle_y' do
          expect(arc.x_result_adjustment(1,1)).to eq(114.0)
        end
      end
    end

    describe '#generate_coordinates' do
      it 'must output a hash of the adjusted x and y coordinates' do
        allow(arc).to receive(:x_result_adjustment){5.0035}
        allow(arc).to receive(:y_result_adjustment){7.0034}
        expect(arc.generate_coordinates(0,50,50)).to eq({x_value: 5.004, y_value: 7.003})
      end
    end

    describe '#angle_base_coords' do
      it 'must find the coordinates for a given angle' do
        expect(arc.angle_base_coords(1.5708)).to eq({:x_value=>112.999, :y_value=>344.0})
      end
    end

    describe '#angle1_coordinates' do
      it 'must call angle_base_coords' do
        allow(arc).to receive(:angle_base_coords){|e| e}
        expect(arc.angle1_coordinates).to eq(arc.angle1)
      end
    end

    describe '#angle2_coordinates' do
      it 'must call angle_base_coords' do
        allow(arc).to receive(:angle_base_coords){|e| e}
        expect(arc.angle2_coordinates).to eq(arc.angle2)
      end
    end

    describe '#angle1_x' do
      it 'must grab :x_value from @angle1_coordinates' do
        allow(arc).to receive(:angle1_coordinates){{x_value: 55}}
        expect(arc.angle1_x).to eq(55)
      end
    end

    describe '#angle1_y' do
      it 'must grab :y_value from @angle1_coordinates' do
        allow(arc).to receive(:angle1_coordinates){{y_value: 55}}
        expect(arc.angle1_y).to eq(55)
      end
    end

    describe '#angle2_x' do
      it 'must grab :x_value from @angle2_coordinates' do
        allow(arc).to receive(:angle2_coordinates){{x_value: 55}}
        expect(arc.angle2_x).to eq(55)
      end
    end

    describe '#angle2_y' do
      it 'must grab :y_value from @angle2_coordinates' do
        allow(arc).to receive(:angle2_coordinates){{y_value: 55}}
        expect(arc.angle2_y).to eq(55)
      end
    end

    describe '#slope_of_angles' do
      it 'must calculate the slope value from the angles' do
        expect(arc.slope_of_angles).to eq(-0.0)
      end
    end

    describe '#b_value_for_line' do
      it 'must calculate the b value of the line equation from its angles' do
        expect(arc.b_value_for_line).to eq(194.0  )
      end
    end

    describe '#vertical_check' do
      context 'if angle_x is same as input' do
        it 'must return :on' do
          allow(arc).to receive(:angle1_x){55}
          expect(arc.vertical_check(55)).to eq(:on)
        end
      end

      context 'if angle_x is less than input' do
        it 'must return :above' do
          allow(arc).to receive(:angle1_x){1}
          expect(arc.vertical_check(55)).to eq(:above)
        end
      end

      context 'if angle_x is more than input' do
        it 'must return :below' do
          allow(arc).to receive(:angle1_x){100}
          expect(arc.vertical_check(55)).to eq(:below)
        end
      end
    end

    describe '#normal_above_below_check' do
      before(:each){allow(arc).to receive(:b_value_for_line){0}}

      context 'if right_side_of_equation is same as y_input' do
        it 'must return :on' do
          expect(arc.normal_above_below_check(10, 10)).to eq(:on)
        end
      end

      context 'if right_side_of_equation is less than y_input' do
        it 'must return :below' do
          expect(arc.normal_above_below_check(8, 10)).to eq(:below)
        end
      end

      context 'if right_side_of_equation is more than y_input' do
        it 'must return :above' do
          expect(arc.normal_above_below_check(12, 10)).to eq(:above)
        end
      end
    end

    describe '#above_below_on' do
      before(:each){allow(arc).to receive(:vertical_check){|x| x}}
      before(:each){allow(arc).to receive(:normal_above_below_check){|x,y| [x,y]}}

      context 'when mx_value over a million' do
        context 'when #slope_of_angles is positive' do
          before(:each){allow(arc).to receive(:slope_of_angles){1}}

          it 'must call and return #vertical_check' do
            expect(arc.above_below_on(6_000_000, 100)).to eq(6_000_000)
          end
        end

        context 'when #slope_of_angles is negative' do
          before(:each){allow(arc).to receive(:slope_of_angles){-1}}

          it 'must call and return #vertical_check' do
            expect(arc.above_below_on(-6_000_000, 100)).to eq(-6_000_000)
          end
        end
      end

      context 'when mx_value under a million' do
        it 'must call #normal_above_below_check' do
          allow(arc).to receive(:slope_of_angles){1}
          expect(arc.above_below_on(60, 100)).to eq([60, 100])
        end
      end
    end

    describe '#in_bounds?' do
      context 'when #inside_oval?? is false' do
        it 'must return nil' do
          allow(arc).to receive(:inside_oval??){false}
          expect(arc.in_bounds?(1,1)).to eq(nil)
        end
      end

      context 'when #inside_oval?? is true' do
        it 'must return nil' do
          allow(arc).to receive(:inside_oval??){true}
          expect(arc.in_bounds?(1,1)).to eq(nil)
        end
      end
    end
  end
end
