# frozen_string_literal: true

RSpec.describe FractionalIndexer do
  describe ".generate_key" do
    subject { described_class.generate_key(prev_key: prev_key, next_key: next_key) }

    context "when prev_key is nil and next_key is nil" do
      let(:prev_key) { nil }
      let(:next_key) { nil }

      it { is_expected.to eq("a0") }
    end

    context "when prev_key is less than next_key" do
      let(:prev_key) { "a0" }
      let(:next_key) { "Z9" }

      it { expect { subject }.to raise_error(FractionalIndexer::Error, "a0 is not less than Z9") }
    end

    context "when prev_key is empty and next_key is 'a0'" do
      let(:prev_key) { "" }
      let(:next_key) { "a0" }

      it {
        expect do
          subject
        end.to raise_error(FractionalIndexer::Error, "prev_key and next_key cannot be empty")
      }
    end

    context "when prev_key is 'a0' and next_key is empty" do
      let(:prev_key) { "a0" }
      let(:next_key) { "" }

      it {
        expect do
          subject
        end.to raise_error(FractionalIndexer::Error, "prev_key and next_key cannot be empty")
      }
    end

    context "when prev_key is nil and next_key is 'a0'" do
      let(:prev_key) { nil }
      let(:next_key) { "a0" }

      it { is_expected.to eq("Zz") }
    end

    context "when prev_key is 'a0' and next_key is nil" do
      let(:prev_key) { "a0" }
      let(:next_key) { nil }

      it { is_expected.to eq("a1") }
    end

    context "when prev_key is 'a0' and next_key is 'a1'" do
      let(:prev_key) { "a0" }
      let(:next_key) { "a1" }

      it { is_expected.to eq("a0V") }
    end

    context "when prev_key is 'a0V' and next_key is 'a1'" do
      let(:prev_key) { "a0V" }
      let(:next_key) { "a1" }

      it { is_expected.to eq("a0l") }
    end

    context "when prev_key is 'Zz' and next_key is 'a0'" do
      let(:prev_key) { "Zz" }
      let(:next_key) { "a0" }

      it { is_expected.to eq("ZzV") }
    end

    context "when prev_key is 'Zz' and next_key is 'a1'" do
      let(:prev_key) { "Zz" }
      let(:next_key) { "a1" }

      it { is_expected.to eq("a0") }
    end

    context "when prev_key is nil and next_key is 'Y00'" do
      let(:prev_key) { nil }
      let(:next_key) { "Y00" }

      it { is_expected.to eq("Xzzz") }
    end

    context "when prev_key is 'bzz' and next_key is nil" do
      let(:prev_key) { "bzz" }
      let(:next_key) { nil }

      it { is_expected.to eq("c000") }
    end

    context "when prev_key is 'a0' and next_key is 'a0V" do
      let(:prev_key) { "a0" }
      let(:next_key) { "a0V" }

      it { is_expected.to eq("a0G") }
    end

    context "when prev_key is 'a0' and next_key is 'a0G" do
      let(:prev_key) { "a0" }
      let(:next_key) { "a0G" }

      it { is_expected.to eq("a08") }
    end

    context "when prev_key is 'b125' and next_key is 'b129'" do
      let(:prev_key) { "b125" }
      let(:next_key) { "b129" }

      it { is_expected.to eq("b127") }
    end

    context "when prev_key is 'a0' and next_key is 'a1V'" do
      let(:prev_key) { "a0" }
      let(:next_key) { "a1V" }

      it { is_expected.to eq("a1") }
    end

    context "when prev_key is 'Zz' and next_key is 'a01'" do
      let(:prev_key) { "Zz" }
      let(:next_key) { "a01" }

      it { is_expected.to eq("a0") }
    end

    context "when prev_key is nil and next_key is 'a0V'" do
      let(:prev_key) { nil }
      let(:next_key) { "a0V" }

      it { is_expected.to eq("a0") }
    end

    context "when prev_key is nil and next_key is 'b999'" do
      let(:prev_key) { nil }
      let(:next_key) { "b999" }

      it { is_expected.to eq("b99") }
    end

    context "when prev_key is nil and next_key is 'A0000000000000000000000000'" do
      let(:prev_key) { nil }
      let(:next_key) { "A0000000000000000000000000" }

      it { expect { subject }.to raise_error(FractionalIndexer::Error) }
    end

    context "when prev_key is nil and next_key is minimum integer" do
      let(:prev_key) { nil }
      let(:next_key) { "A" + "0" * 26 }

      it { expect { subject }.to raise_error(FractionalIndexer::Error) }
    end

    context "when prev_key is nil and next_key is 'A00000000000000000000000001'" do
      let(:prev_key) { nil }
      let(:next_key) { "A00000000000000000000000001" }

      it { is_expected.to eq("A00000000000000000000000000V") }
    end

    context "when prev_key is nil and next_key is 'A000000000000000000000000001'" do
      let(:prev_key) { nil }
      let(:next_key) { "A000000000000000000000000001" }

      it { is_expected.to eq("A000000000000000000000000000V") }
    end

    context "when prev_key is '#{"z" * 26}y' and next_key is nil" do
      let(:prev_key) { "z" * 26 + "y" }
      let(:next_key) { nil }

      it { is_expected.to eq("z" * 27) }
    end

    context "when prev_key is 'z' * 27 and next_key is nil" do
      let(:prev_key) { "z" * 27 }
      let(:next_key) { nil }

      it { is_expected.to eq("z" * 27 + "V") }
    end

    context "when prev_key is 'a00' and next_key is nil" do
      let(:prev_key) { "a00" }
      let(:next_key) { nil }

      it { expect { subject }.to raise_error(FractionalIndexer::Error) }
    end

    context "when prev_key is 'a00' and next_key is 'a1'" do
      let(:prev_key) { "a00" }
      let(:next_key) { "a1" }

      it { expect { subject }.to raise_error(FractionalIndexer::Error) }
    end

    context "when prev_key is '0' and next_key is '1'" do
      let(:prev_key) { "0" }
      let(:next_key) { "1" }

      it { expect { subject }.to raise_error(FractionalIndexer::Error) }
    end
  end

  describe ".generate_keys" do
    subject { described_class.generate_keys(prev_key: prev_key, next_key: next_key, count: count) }

    before do
      described_class.configure do |config|
        config.base = :base_10
      end
    end

    context "when count is 0" do
      let(:prev_key) { "a0" }
      let(:next_key) { nil }
      let(:count) { 0 }

      it { is_expected.to eq([]) }
    end

    context "when count is -1" do
      let(:prev_key) { "a0" }
      let(:next_key) { nil }
      let(:count) { 0 }

      it { is_expected.to be_empty }
    end

    context "when prev_key is nil and next_key is nil and count is 5" do
      let(:prev_key) { nil }
      let(:next_key) { nil }
      let(:count) { 5 }

      it { is_expected.to eq(["a0", "a1", "a2", "a3", "a4"]) }
    end

    context "when prev_key is 'a41' and next_key is nil and count is 5" do
      let(:prev_key) { "a41" }
      let(:next_key) { nil }
      let(:count) { 5 }

      it { is_expected.to eq(["a5", "a6", "a7", "a8", "a9"]) }
    end

    context "when prev_key is nil and next_key is 'a1' and count is 2" do
      let(:prev_key) { nil }
      let(:next_key) { "a1" }
      let(:count) { 2 }

      it { is_expected.to eq(["Z9", "a0"]) }
    end

    context "when prev_key is 'a0' and next_key is 'a2' and count is 20" do
      let(:prev_key) { "a0" }
      let(:next_key) { "a2" }
      let(:count) { 20 }

      let(:result) do
        [
          "a01",
          "a02",
          "a03",
          "a035",
          "a04",
          "a05",
          "a06",
          "a07",
          "a08",
          "a09",
          "a1",
          "a11",
          "a12",
          "a13",
          "a14",
          "a15",
          "a16",
          "a17",
          "a18",
          "a19",
        ]
      end

      it { is_expected.to eq(result) }
    end

    context "when prev_key is nil and next_key is 'A00000000000000000000000001' and count is 5" do
      let(:prev_key) { nil }
      let(:next_key) { "A00000000000000000000000001" }
      let(:count) { 5 }

      let(:result) do
        [
          "A0000000000000000000000000005",
          "A000000000000000000000000001",
          "A000000000000000000000000002",
          "A000000000000000000000000003",
          "A000000000000000000000000005",
        ]
      end

      it { is_expected.to eq(result) }
    end
  end
end
