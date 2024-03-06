RSpec.describe FractionalIndexer::Incrementer do
  describe ".execute" do
    subject { described_class.execute(order_key) }
    let(:order_key) { FractionalIndexer::OrderKey.new(key) }

    describe "use base 10" do
      before do
        FractionalIndexer.configure do |config|
          config.base = :base_10
        end
      end

      context "when key is 'a0'" do
        let(:key) { "a0" }

        it { is_expected.to eq("a1") }
      end

      context "when key is 'a1'" do
        let(:key) { "a1" }

        it { is_expected.to eq("a2") }
      end

      context "when key is 'c999'" do
        let(:key) { "c999" }

        it { is_expected.to eq("d0000") }
      end

      context "when key is 'Z999'" do
        let(:key) { "Z999" }

        it { is_expected.to eq("a0") }
      end

      context "when key is 'Y99'" do
        let(:key) { "Y99" }

        it { is_expected.to eq("Z0") }
      end

      context "when key is 'z#{'9' * 26}'" do
        let(:key) { 'z' + '9' * 26 }

        it { is_expected.to be_nil }
      end
    end

    describe "use base 62" do
      before do
        FractionalIndexer.configure do |config|
          config.base = :base_62
        end
      end

      context "when key is 'az'" do
        let(:key) { "az" }

        it { is_expected.to eq("b00") }
      end

      context "when key is 'a9'" do
        let(:key) { "a9" }

        it { is_expected.to eq("aA") }
      end

      context "when key is 'b0z'" do
        let(:key) { "b0z" }

        it { is_expected.to eq("b10") }
      end

      context "when key si 'bzz'" do
        let(:key) { "bzz" }

        it { is_expected.to eq("c000") }
      end

      context "when key is 'Zy'" do
        let(:key) { "Zy" }

        it { is_expected.to eq("Zz") }
      end

      context "when key is 'Yzy'" do
        let(:key) { "Yzy" }

        it { is_expected.to eq("Yzz") }
      end

      context "when key is 'dABzz'" do
        let(:key) { "dABzz" }

        it { is_expected.to eq("dAC00") }
      end

      context "when key is 'z#{'z' * 26}'" do
        let(:key) { 'z' + 'z' * 26 }

        it { is_expected.to be_nil }
      end
    end
  end
end
