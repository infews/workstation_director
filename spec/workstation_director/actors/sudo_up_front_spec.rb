require 'open3'

module WorkstationDirector
  RSpec.describe SudoUpFront do

    let(:actor) {SudoUpFront.new}

    context '#setup' do
      let(:status) do
        double('exit status 0', :exit_status => 0)
      end
      before do
        allow(STDOUT).to receive(:puts)
        allow(Open3).to receive(:capture3).and_return(['', '', status])
        actor.setup
      end

      it 'logs its action' do
        expect(STDOUT).to have_received(:puts).with(/Running/)
        expect(STDOUT).to have_received(:puts).with(/sudo/)
        expect(STDOUT).to have_received(:puts).with(/early/)
      end

      it 'calls sudo' do
        expect(Open3).to have_received(:capture3).with('sudo -v')
      end
    end
  end
end
