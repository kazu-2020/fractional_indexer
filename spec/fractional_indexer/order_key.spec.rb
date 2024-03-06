RSpec.describe FractionalIndexer::OrderKey do
  after do
    FractionalIndexer.configure do |config|
      config.base = :base_62
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

  describe '#smallest_integer?' do
    subject { described_class.new(key).smallest_integer? }

    context "when key is smallest integer" do
      let(:key) { 'A' + '0' * 26 }

      it { is_expected.to be_truthy }
    end

    context "when key is not smallest integer" do
      let(:key) { 'A' + '0' * 25 + '1' }

      it { is_expected.to be_falsey }
    end
  end
end
