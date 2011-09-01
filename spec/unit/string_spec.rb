require 'bigcat'

describe BigCat::String do
  describe '#big_top_half' do
    subject { described_class.new(string) }

    context "when the argument is not an empty line" do
      let!(:string) { "Hello" }

      it "returns the string prefixed with the VT100 escape for the double size font's top" do
        subject.big_top_half.should == "\e#3#{string}"
      end
    end

    context "when the argument is an empty line" do
      let!(:string) { "\n" }

      it "returns the string" do
        subject.big_top_half.should == string
      end
    end

    context "when the argument is empty" do
      let!(:string) { "" }

      it "returns the string" do
        subject.big_top_half.should == string
      end
    end
  end

  describe '#big_bottom_half' do
    subject { described_class.new(string) }

    context "when the argument is not an empty line" do
      let!(:string) { "Hello" }

      it "returns the string prefixed with the VT100 escape for the double size font's bottom" do
        subject.big_bottom_half.should == "\e#4#{string}"
      end
    end

    context "when the argument is an empty line" do
      let!(:string) { "\n" }

      it "returns the string" do
        subject.big_bottom_half.should == string
      end
    end

    context "when the argument is empty" do
      let!(:string) { "" }

      it "returns the string" do
        subject.big_bottom_half.should == string
      end
    end
  end
end
