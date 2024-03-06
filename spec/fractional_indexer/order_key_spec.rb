RSpec.describe FractionalIndexer::OrderKey do
  describe '.negative?' do
    subject { described_class.negative?(key) }

    context "when key is nil" do
      let(:key) { nil }

      it { expect { subject }.to raise_error(NoMethodError) }
    end

    context "when key is empty" do
      let(:key) { '' }

      it { is_expected.to be_falsey }
    end

    context 'when key is negative' do
      let(:key) { 'Z0' }

      it { is_expected.to be_truthy }
    end

    context 'when key is positive' do
      let(:key) { 'a0' }

      it { is_expected.to be_falsey }
    end
  end

  describe '.positive?' do
    subject { described_class.positive?(key) }

    context "when key is nil" do
      let(:key) { nil }

      it { expect { subject }.to raise_error(NoMethodError) }
    end

    context "when key is empty" do
      let(:key) { '' }

      it { is_expected.to be_falsey }
    end

    context 'when key is negative' do
      let(:key) { 'Z0' }

      it { is_expected.to be_falsey }
    end

    context 'when key is positive' do
      let(:key) { 'a0' }

      it { is_expected.to be_truthy }
    end
  end

  describe '.zero' do
    subject { described_class.zero }

    context "when base is 10" do
      it { is_expected.to eq('a0') }
    end

    context "when base is 62" do
      before do
        FractionalIndexer.configure do |config|
          config.base = :base_62
        end
      end

      it { is_expected.to eq('a0') }
    end

    context "when base is 94" do
      before do
        FractionalIndexer.configure do |config|
          config.base = :base_94
        end
      end

      it { is_expected.to eq('a!') }
    end
  end

  describe '#decrement' do
    subject { described_class.new(key).decrement }

    context "when key is 'A#{'0' * 26}'" do
      let(:key) { 'A' + '0' * 26 }
      let(:error_message) { "invalid order key: 'A00000000000000000000000000' description: it cannot decrement for min integer" }

      it { expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, error_message) }
    end

    context "when key is 'a1'" do
      let(:key) { 'a1' }

      it { is_expected.to eq('a0') }
    end

    context "when key is 'a0'" do
      let(:key) { 'a0' }

      it { is_expected.to eq('Zz') }
    end
  end

  describe '#fractional' do
    subject { described_class.new(key).fractional }

    context "when key is invalid fractional" do
      let(:key) { 'a0010' }
      let(:error_message) { "invalid order key: '#{key}' description: fractional '010' is invalid." }

      it { expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, error_message) }
    end

    context "when key is valid fractional" do
      let(:key) { "b120zZ" }

      it { is_expected.to eq('0zZ')}
    end
  end

  describe '#increment' do
    subject { described_class.new(key).increment }

    context "when key is 'z#{'z' * 26}'" do
      let(:key) { 'z' + 'z' * 26 }
      let(:error_message) { "invalid order key: 'zzzzzzzzzzzzzzzzzzzzzzzzzzz' description: it cannot increment for max integer" }

      it { expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, error_message) }
    end

    context "when key is 'Zz'" do
      let(:key) { 'Zz' }

      it { is_expected.to eq('a0') }
    end

    context "when key is 'a1'" do
      let(:key) { 'a1' }

      it { is_expected.to eq('a2') }
    end
  end

  describe '#integer' do
    subject { described_class.new(key).integer }

    context "when key is invalid integer digits" do
      let(:key) { 'b1' }
      let(:error_message) {"invalid order key: '#{key}' description: integer 'b1' is invalid."}

      it { expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, error_message) }
    end

    context "when key is invalid prefix" do
      let(:key) { '!9' }
      let(:error_message) { "invalid order key: '#{key}' description: prefix '!' is invalid. It should be a-z or A-Z." }

      it { expect { subject }.to raise_error(FractionalIndexer::FractionalIndexerError, error_message) }
    end

    context "when key only has digits" do
      let(:key) { 'd012A'}

      it { is_expected.to eq('d012A') }
    end

    context "when key has digits and fractional" do
      let(:key) { 'b12z' }

      it { is_expected.to eq('b12') }
    end
  end

  describe '#maximum_integer?' do
    subject { described_class.new(key).maximum_integer? }

    context "when key is maximum integer" do
      let(:key) { 'z' + 'z' * 26 + 'a' }

      it { is_expected.to be_truthy }
    end

    context "when key is not maximum integer" do
      let(:key) { 'z' + 'z' * 25 + 'a'  }

      it { is_expected.to be_falsey}
    end
  end

  describe '#minimum_integer?' do
    subject { described_class.new(key).minimum_integer? }

    context "when key is minimum integer" do
      let(:key) { 'A' + '0' * 26 + 'z'}

      it { is_expected.to be_truthy }
    end

    context "when key is not minimum integer" do
      let(:key) { 'A' + '0' * 25 + '1' }

      it { is_expected.to be_falsey }
    end
  end


  describe '#present?' do
    subject { described_class.new(key).present? }

    context "when key is nil" do
      let(:key) { nil }

      it { is_expected.to be_falsey }
    end

    context "when key is empty" do
      let(:key) { '' }

      it { is_expected.to be_falsey }
    end

    context "when key is not nil or empty" do
      let(:key) { 'a0' }

      it { is_expected.to be_truthy }
    end
  end
end
