RSpec.describe FractionalIndexer::Integer do
  describe "#increment" do
    describe "use base 10" do
      subject { described_class.new.increment(int) }

      context "when int is 'a0'" do
        let(:int) { "a0" }

        it { is_expected.to eq("a1") }
      end

      context "when int is 'a1'" do
        let(:int) { "a1" }

        it { is_expected.to eq("a2") }
      end

      context "when int is 'c999" do
        let(:int) { "c999" }

        it { is_expected.to eq("d0000") }
      end

      context "when the number of digits is different from that indicated by order key" do
        let(:int) { "a10" }

        it { expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, "Invalid integer part of order key: a") }
      end

      context "when order key is invalid" do
        let(:int) { "!0" }

        it { expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, "Invalid order key: !") }
      end
    end

    describe "use base 62" do
      digits = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
      subject { described_class.new(digits).increment(int) }

      context "when int is 'az'" do
        let(:int) { "az" }

        it { is_expected.to eq("b00") }
      end

      context "when int is 'b0z'" do
        let(:int) { "b0z" }

        it { is_expected.to eq("b10") }
      end

      context "when int is 'b1z'" do
        let(:int) { "b1z" }

        it { is_expected.to eq("b20") }
      end

      context "when int is 'bzz'" do
        let(:int) { "bzz" }

        it { is_expected.to eq("c000") }
      end

      context "when int is 'Zy'" do
        let(:int) { "Zy" }

        it { is_expected.to eq("Zz") }
      end

      context "when int is 'Zz'" do
        let(:int) { "Zz" }

        it { is_expected.to eq("a0") }
      end

      context "when int is 'Yzy'" do
        let(:int) { "Yzy" }

        it { is_expected.to eq("Yzz") }
      end

      context "when int is 'Yzz'" do
        let(:int) { "Yzz" }

        it { is_expected.to eq("Z0") }
      end

      context "when int is 'Xyzz'" do
        let(:int) { "Xyzz" }

        it { is_expected.to eq("Xz00") }
      end

      context "when int ix 'Xz00'" do
        let(:int) { "Xz00" }

        it { is_expected.to eq("Xz01") }
      end

      context "when int is 'Xzzz'" do
        let(:int) { "Xzzz" }

        it { is_expected.to eq('Y00')}
      end

      context "when int is 'dABzz'" do
        let(:int) { "dABzz" }

        it { is_expected.to eq('dAC00')}
      end

      context "when int is 'zzzzzzzzzzzzzzzzzzzzzzzzzzz'" do
        let(:int) { "zzzzzzzzzzzzzzzzzzzzzzzzzzz" }

        it { is_expected.to be_nil}
      end
    end
  end

  describe "#decrement" do
    describe "use base 10" do
      subject { described_class.new.decrement(int) }

      context "when int is 'a0'" do
        let(:int) { "a1" }

        it { is_expected.to eq("a0") }
      end

      context "when int is 'a'" do
        let(:int) { "a2" }

        it { is_expected.to eq("a1") }
      end

      context "when int is 'b00'" do
        let(:int) { "b00" }

        it { is_expected.to eq("a9")}
      end
    end

    describe "use base 62" do
      digits = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
      subject { described_class.new(digits).decrement(int) }

      context "when int is 'b00'" do
        let(:int) { "b00" }

        it { is_expected.to eq("az") }
      end

      context "when int is 'b10'" do
        let(:int) { "b10" }

        it { is_expected.to eq("b0z") }
      end

      context "when int is 'c000'" do
        let(:int) { "c000" }

        it { is_expected.to eq("bzz") }
      end

      context "when int is 'Zz'" do
        let(:int) { "Zz" }

        it { is_expected.to eq("Zy") }
      end

      context "when int is 'a0'" do
        let(:int) { "a0" }

        it { is_expected.to eq("Zz") }
      end

      context "when int is 'Yzz'" do
        let(:int) { "Yzz" }

        it { is_expected.to eq("Yzy") }
      end

      context "when int is 'Z0'" do
        let(:int) { "Z0" }

        it { is_expected.to eq("Yzz") }
      end

      context "when int is 'Xz01'" do
        let(:int) { "Xz01" }

        it { is_expected.to eq("Xz00") }
      end

      context "when int is 'Xz00'" do
        let(:int) { "Xz00" }

        it { is_expected.to eq("Xyzz") }
      end

      context "when int is 'Y00'" do
        let(:int) { "Y00" }

        it { is_expected.to eq("Xzzz") }
      end

      context "when int is 'dAC00'" do
        let(:int) { "dAC00" }

        it { is_expected.to eq("dABzz") }
      end

      context "when int is 'A00000000000000000000000000'" do
        let(:int) { "A00000000000000000000000000" }

        it { is_expected.to be_nil }
      end
    end
  end
end
