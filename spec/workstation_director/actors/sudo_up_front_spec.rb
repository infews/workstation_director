module WorkstationDirector
  RSpec.describe SudoUpFront do

    let(:actor) {SudoUpFront.new}

    context '#setup' do
      before do
        allow(STDOUT).to receive(:puts)
        allow(Kernel).to receive(:system).and_return(true)
        actor.setup
      end

      it 'logs its action' do
        expect(STDOUT).to have_received(:puts).with(/Running/)
        expect(STDOUT).to have_received(:puts).with(/sudo/)
        expect(STDOUT).to have_received(:puts).with(/early/)
      end

      it 'calls sudo' do
        expect(Kernel).to have_received(:system).with('sudo -v')
      end

    end

  end
end
