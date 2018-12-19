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
        allow(Open3).to receive(:popen3).and_yield(double('STDIN'), stdout, stderr, thread)
        allow(STDOUT).to receive(:puts).and_return(true)
      end

      context 'when the command exits cleanly' do
        let(:stdout) do
          stdout = double('STDOUT')
          allow(stdout).to receive(:gets).and_return('some files', nil)
          allow(stdout).to receive(:puts).and_return(true)
          stdout
        end
        let(:stderr) do
          double('STDERR', :gets => nil, :puts => true)
        end
        let(:thread) do
          double('thread', :join => true)
        end

        it 'delegates to Open3#popen3' do
          actor.run_command('ls')

          expect(Open3).to have_received(:popen3).with('ls')
        end

        it 'returns true' do
          expect(actor.run_command('ls')).to eq(true)
        end

        it 'logs stdout' do
          actor.run_command('ls')

          expect(stdout).to have_received(:puts).with('some files')
        end
      end

      context 'when the command fails' do
        let(:stdout) do
          double('STDOUT', :gets => nil, :puts => true)
        end
        let(:stderr) do
          stderr = double('STDERR')
          allow(stderr).to receive(:gets).and_return('that did not work', nil)
          allow(stderr).to receive(:puts)
          stderr
        end
        let(:thread) do
          double('thread', :join => true)
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
