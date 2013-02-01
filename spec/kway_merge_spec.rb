require 'kway_merge'

describe "KWayMerge" do
  describe "Stream" do
    describe "#initialize" do
      it "should require one argument" do
        expect{ KWayMerge::Stream.new }.to raise_exception(ArgumentError)
        expect{ KWayMerge::Stream.new([]) }.not_to raise_exception
      end

      it "should require the argument to respond to map" do
        expect{ KWayMerge::Stream.new(stub(:size => 0, :[] => stub)) }.to raise_exception(ArgumentError)
      end

      it "should require the argument to respond to size" do
        expect{ KWayMerge::Stream.new(stub(:map => [], :[] => stub)) }.to raise_exception(ArgumentError)
      end

      it "should require the argument to respond to []" do
        expect{ KWayMerge::Stream.new(stub(:map => [], :size => 0)) }.to raise_exception(ArgumentError)
      end
    end

    shared_examples "empty" do
      it "should claim to be empty" do
        @stream.should be_empty
      end

      it "should return nil from shift" do
        @stream.shift.should be_nil
      end

      it "should not yield at all on iterate" do
        spy = mock # will error if invoke gets called
        @stream.iterate{ spy.invoke }
      end

      it "should return an empty list from collect" do
        @stream.collect.should == []
      end
    end

    context "when initialized empty (no collections)" do
      before do
        @stream = KWayMerge::Stream.new([])
      end

      it_behaves_like "empty"
    end

    context "when initialized empty (empty collections)" do
      before do
        @stream = KWayMerge::Stream.new([[], []])
      end

      it_behaves_like "empty"
    end

    context "when exhausted" do
      before do
        @stream = KWayMerge::Stream.new([[1, 3], [2, 4]])
        @stream.collect
      end

      it_behaves_like "empty"
    end

    context "when non-empty" do
      before do
        @item = 1
        @stream = KWayMerge::Stream.new([[@item]])
      end

      it "should not claim to be empty" do
        @stream.should_not be_empty
      end

      it "should return the next item from shift" do
        @stream.shift.should == @item
      end

      it "should yield items to iterate" do
        yielded = []
        @stream.iterate(1) do |item|
          yielded << @item
        end
        yielded.should == [@item]
      end

      it "should return items from collect" do
        @stream.collect(1).should == [@item]
      end

      it "should skip items on skip" do
        @stream.skip(1)
        @stream.should be_empty
      end
    end
  end
end
