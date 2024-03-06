RSpec.describe FractionalIndexer::Midpointer do
  after do
    FractionalIndexer.configure do |config|
      config.base = :base_62
    end
  end

  describe ".execute" do
    subject { described_class.execute(prev_pos, next_pos) }

    describe "use base 10" do
      before do
        FractionalIndexer.configure do |config|
          config.base = :base_10
        end
      end

      context "when prev_pos and next_pos are nil" do
        let(:prev_pos) { nil }
        let(:next_pos) { nil }

        it { is_expected.to eq("5") }
      end

      context "when prev_pos and next_pos are empty" do
        let(:prev_pos) { "" }
        let(:next_pos) { "" }

        it { is_expected.to eq("5") }
      end

      context "when prev_pos is nil and next_pos is empty" do
        let(:prev_pos) { nil }
        let(:next_pos) { "" }

        it { is_expected.to eq("5") }
      end

      context "when prev_pos is empty and next_pos is nil" do
        let(:prev_pos) { "" }
        let(:next_pos) { nil }

        it { is_expected.to eq("5") }
      end

      context "when next_pos is less than prev_pos" do
        let(:prev_pos) { "1" }
        let(:next_pos) { "0" }

        it {
          expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, "prev_pos must be less than next_pos")
        }
      end

      context "when prev_pos ends with 0" do
        let(:prev_pos) { "1" }
        let(:next_pos) { "20" }

        it {
          expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, "prev_pos and next_pos cannot end with 0")
        }
      end

      context "when next_pos ends with 0" do
        let(:prev_pos) { "10" }
        let(:next_pos) { "2" }

        it {
          expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, "prev_pos and next_pos cannot end with 0")
        }
      end

      context "when prev_pos is 5 and next_pos is nil" do
        let(:prev_pos) { "5" }
        let(:next_pos) { nil }

        it { is_expected.to eq("8") }
      end

      context "when prev_pos is 8 and next_pos is nil" do
        let(:prev_pos) { "8" }
        let(:next_pos) { nil }

        it { is_expected.to eq("9") }
      end

      context "when prev_pos is 9 and next_pos is nil" do
        let(:prev_pos) { "9" }
        let(:next_pos) { nil }

        it { is_expected.to eq("95") }
      end

      context "when prev_pos is 95 and next_pos is nil" do
        let(:prev_pos) { "95" }
        let(:next_pos) { nil }

        it { is_expected.to eq("98") }
      end

      context "when prev_pos is 98 and next_pos is nil" do
        let(:prev_pos) { "98" }
        let(:next_pos) { nil }

        it { is_expected.to eq("99") }
      end

      context "when prev_pos is 99 and next_pos is nil" do
        let(:prev_pos) { "99" }
        let(:next_pos) { nil }

        it { is_expected.to eq("995") }
      end



      context "when prev_pos is nil and next_pos is 5" do
        let(:prev_pos) { nil }
        let(:next_pos) { "5" }

        it { is_expected.to eq("3") }
      end

      context "when prev_pos is nil and next_pos is 3" do
        let(:prev_pos) { nil }
        let(:next_pos) { "3" }

        it { is_expected.to eq("2") }
      end

      context "when prev_pos is nil and next_pos is 2" do
        let(:prev_pos) { nil }
        let(:next_pos) { "2" }

        it { is_expected.to eq("1") }
      end

      context "when prev_pos is nil and next_pos is 1" do
        let(:prev_pos) { nil }
        let(:next_pos) { "1" }

        it { is_expected.to eq("05") }
      end

      context "when prev_pos is nil and next_pos is 05" do
        let(:prev_pos) { nil }
        let(:next_pos) { "05" }

        it { is_expected.to eq("03") }
      end

      context "when prev_pos is 1 and next_pos is 2" do
        let(:prev_pos) { "1" }
        let(:next_pos) { "2" }

        it { is_expected.to eq("15") }
      end

      context "when prev_pos is 05 and next_pos is 1" do
        let(:prev_pos) { "05" }
        let(:next_pos) { "1" }

        it { is_expected.to eq("08") }
      end

      context "when prev_pos is 499 and next_pos is 5" do
        let(:prev_pos) { "499" }
        let(:next_pos) { "5" }

        it { is_expected.to eq("4995") }
      end

      context "when prev_pos is 001 and next_pos is 001002" do
        let(:prev_pos) { "001" }
        let(:next_pos) { "001002" }

        it { is_expected.to eq("001001") }
      end

      context "when prev_pos is 001 and next_pos is 001001" do
        let(:prev_pos) { "001" }
        let(:next_pos) { "001001" }

        it { is_expected.to eq("0010005") }
      end
    end

    describe "use base 62" do
      before do
        FractionalIndexer.configure do |config|
          config.base = :base_62
        end
      end

      context "when prev_pos is nil and next_pos is nil" do
        let(:prev_pos) { nil }
        let(:next_pos) { nil }

        it { is_expected.to eq("V") }
      end

      context "when prev_pos is V and next_pos is nil" do
        let(:prev_pos) { "V" }
        let(:next_pos) { nil }

        it { is_expected.to eq("l") }
      end

      context "when prev_pos is l and next_pos is nil" do
        let(:prev_pos) { "l" }
        let(:next_pos) { nil }

        it { is_expected.to eq("t") }
      end

      context "when prev_pos is z and next_pos is nil" do
        let(:prev_pos) { "z" }
        let(:next_pos) { nil }

        it { is_expected.to eq("zV") }
      end

      context "when prev_pos is zV and next_pos is nil" do
        let(:prev_pos) { "zV" }
        let(:next_pos) { nil }

        it { is_expected.to eq("zl") }
      end

      context "when prev_pos is zz and next_pos is nil" do
        let(:prev_pos) { "zz" }
        let(:next_pos) { nil }

        it { is_expected.to eq("zzV") }
      end

      context "when prev_pos is nil and next_pos is V" do
        let(:prev_pos) { nil }
        let(:next_pos) { "V" }

        it { is_expected.to eq("G") }
      end

      context "when prev_pos is nil and next_pos is G" do
        let(:prev_pos) { nil }
        let(:next_pos) { "G" }

        it { is_expected.to eq("8") }
      end

      context "when prev_pos is nil and next_pos is 1" do
        let(:prev_pos) { nil }
        let(:next_pos) { "1" }

        it { is_expected.to eq("0V") }
      end

      context "when prev_pos is 1 and next_pos is 2" do
        let(:prev_pos) { "1" }
        let(:next_pos) { "2" }

        it { is_expected.to eq("1V") }
      end

      context "when prev_pos is 001 and next_pos is 001001" do
        let(:prev_pos) { "001" }
        let(:next_pos) { "001001" }

        it { is_expected.to eq("001000V") }
      end

      context "when prev_pos is 4zz and next_pos is 5" do
        let(:prev_pos) { "4zz" }
        let(:next_pos) { "5" }

        it { is_expected.to eq("4zzV") }
      end
    end
  end
end
