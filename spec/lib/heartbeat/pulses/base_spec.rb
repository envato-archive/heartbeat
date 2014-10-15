describe Heartbeat::Pulses::Base do
  class Heartbeat::Pulses::DataSetting < described_class
    def tick
      check "data setting" do
        data :monkey, :banana
      end
    end
  end

  class Heartbeat::Pulses::WithException < described_class
    def tick
      check "data setting" do
        data :monkey, :banana
      end

      check "something that raises exception" do
        raise "A fake exception from doing a check"
      end
    end
  end

  subject(:pulse) { Heartbeat::Pulses::DataSetting.new }

  before do
    Retryable.disable
  end

  after do
    Retryable.enable
  end

  describe "#name" do
    it 'returns the short name derived from the class name' do
      expect(pulse.name).to eq 'data_setting'
    end
  end

  describe '#as_json' do
    context 'called before tick' do
      it 'raises InvalidState' do
        expect { pulse.as_json }.to raise_error Heartbeat::Pulses::Base::InvalidState
      end
    end

    context 'called after tick' do
      before do
        pulse.tick
      end

      it 'returns hash of up status, errors, and data' do
        expect(pulse.as_json).to match(
          up: true,
          errors: [],
          data: {
            monkey: :banana,
          }
        )
      end

      context 'with an exception' do
        let(:pulse) { Heartbeat::Pulses::WithException.new }

        it 'returns hash of up status, errors, and data with the correct things' do
          expect(pulse.as_json).to match(
            up: false,
            errors: [
              {
                subject: "something that raises exception",
                message: "A fake exception from doing a check",
                backtrace: anything,
                details: anything,
              }
            ],
            data: {
              monkey: :banana,
            }
          )
        end
      end
    end
  end

  describe "#up?" do
    context 'when called before tick' do
      it 'raises Heartbeat::Pulses::Base::InvalidState' do
        expect { pulse.up? }.to raise_error(Heartbeat::Pulses::Base::InvalidState)
      end
    end

    context 'when called after tick' do
      before do
        pulse.tick
      end

      context 'and theres no exceptions' do
        specify { expect(pulse).to be_up }
      end

      context 'with exceptions' do
        let(:pulse) { Heartbeat::Pulses::WithException.new }

        specify { expect(pulse).to_not be_up }
      end
    end

  end
end
