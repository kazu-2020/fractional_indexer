RSpec.describe FractionalIndexer::Decrementer do
  describe ".execute" do
    subject { described_class.execute(order_key) }
    let(:order_key) { FractionalIndexer::OrderKey.new(key) }

    describe "use base 10" do
      before do
        FractionalIndexer.configure do |config|
          config.base = :base_10
        end
      end

      context "when key is 'a1'" do
        let(:key) { "a1" }

        it { is_expected.to eq("a0") }
      end

      context "when key is 'a0'" do
        let(:key) { "a0" }

        it { is_expected.to eq("Z9") }
      end

      context "when key is 'b00'" do
        let(:key) { "b00" }

        it { is_expected.to eq("a9") }
      end

      context "when key is 'Z0'" do
        let(:key) { "Z0" }

        it { is_expected.to eq("Y99") }
      end

      context "when key is 'A#{'0' * 26}'" do
        let(:key) { 'A' + '0' * 26 }

        it { is_expected.to be_nil }
      end
    end

    describe "use base 62" do
      before do
        FractionalIndexer.configure do |config|
          config.base = :base_62
        end
      end

      context "when key is 'b00'" do
        let(:key) { "b00" }

        it { is_expected.to eq("az") }
      end

      context "when key is 'b10'" do
        let(:key) { "b10" }

        it { is_expected.to eq("b0z") }
      end

      context "when key is 'c000'" do
        let(:key) { "c000" }

        it { is_expected.to eq("bzz") }
      end

      context "when key is 'Zz'" do
        let(:key) { "Zz" }

        it { is_expected.to eq("Zy") }
      end

      context "when key is 'a0'" do
        let(:key) { "a0" }

        it { is_expected.to eq("Zz") }
      end

      context "when key is 'Yzz'" do
        let(:key) { "Yzz" }

        it { is_expected.to eq("Yzy") }
      end

      context "when key is 'Y00'" do
        let(:key) { "Y00" }

        it { is_expected.to eq("Xzzz") }
      end

      context "when key is 'dAC00'" do
        let(:key) { "dAC00" }

        it { is_expected.to eq("dABzz") }
      end

      context "when key is 'A#{'0' * 26}'" do
        let(:key) { 'A' + '0' * 26 }

        it { is_expected.to be_nil }
      end
    end
  end
end
