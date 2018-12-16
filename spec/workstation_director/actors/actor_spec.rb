module WorkstationDirector
  RSpec.describe Actor do

    let(:actor) {Actor.new}

    context 'defaults interface:' do
      it '#present? returns false' do
        expect(actor.present?).to eq(false)
      end

      it '#install returns true' do
        expect(actor.install).to eq(true)
      end

      it '#setup returns true' do
        expect(actor.setup).to eq(true)
      end
    end

    context '#run_command' do
      before do
        allow(Open3).to receive(:capture3).and_return([stdout, stderr, status])
        allow(STDOUT).to receive(:puts).and_return(true)
      end

      context 'when the command exits cleanly' do
        let(:stdout) {'some files'}
        let(:stderr) {''}
        let(:status) do
          status = double('exit status 0')
          allow(status).to receive(:exit_status).and_return(0)
          status
        end

        it 'delegates to Open3#capture3' do
          actor.run_command('ls')

          expect(Open3).to have_received(:capture3).with('ls')
        end

        it 'returns true' do
          expect(actor.run_command('ls')).to eq(true)
        end

        it 'logs stdout' do
          actor.run_command('ls')

          expect(STDOUT).to have_received(:puts).with(stdout)
        end
      end

      context 'when the command fails' do
        let(:stdout) {''}
        let(:stderr) {'that did NOT work'}
        let(:status) do
          status = double('exit status non-zero')
          allow(status).to receive(:exit_status).and_return(99)
          status
        end

        it 'should raise an error' do
          expect {
            actor.run_command('bad idea')
          }.to raise_exception(CommandError)
        end


      end
    end
  end
end
