module WorkstationDirector
  RSpec.describe Actor do

    let(:actor) {Actor.new}

    context 'defaults' do
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
  end
end
