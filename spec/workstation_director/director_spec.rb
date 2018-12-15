RSpec.describe WorkstationDirector::Director do
  let(:actor_class) do
    actor_class = class_double('ActorClass')
    allow(actor_class).to receive(:new) {actor}
    actor_class
  end
  let(:actor) do
    actor = double('Actor')
    allow(actor).to receive(:install) {true}
    allow(actor).to receive(:present?) {false}
    allow(actor).to receive(:setup) {true}
    actor
  end
  let(:present_actor_class) do
    actor_class = class_double('ActorClass')
    allow(actor_class).to receive(:new) {present_actor}
    actor_class
  end
  let(:present_actor) do
    actor = double('Another Actor')
    allow(actor).to receive(:install) {true}
    allow(actor).to receive(:present?) {true}
    allow(actor).to receive(:setup) {true}
    actor
  end

  context '#action!' do
    context 'with an actor' do
      let(:director) {WorkstationDirector::Director.new(actor_class)}

      context 'that returns false from #present?' do

        it 'creates the actor' do
          director.action!

          expect(actor_class).to have_received(:new)
        end

        it 'tells the actor to install' do
          director.action!

          expect(actor).to have_received(:install)
        end

        it 'tells the actor to setup' do
          director.action!

          expect(actor).to have_received(:setup)
        end
      end

      context 'that returns true from #present?' do
        let(:director) {WorkstationDirector::Director.new(present_actor_class)}
        it 'does not tell an actor to install' do
          director.action!

          expect(present_actor).to have_received(:present?)
          expect(present_actor).to_not have_received(:install)
        end

        it 'tells the actor to setup' do
          director.action!

          expect(present_actor).to have_received(:setup)
        end
      end
    end

    context 'with multiple actors' do
      let(:director) do
        WorkstationDirector::Director.new(actor_class, present_actor_class)
      end

      it 'supports multiple actors' do
        director.action!

        expect(actor).to have_received(:present?)
        expect(actor).to have_received(:install)
        expect(actor).to have_received(:setup)
        expect(present_actor).to have_received(:present?)
        expect(present_actor).to_not have_received(:install)
        expect(present_actor).to have_received(:setup)
      end
    end

    context 'handles errors' do
      it 'stops execution'
      it 'dumps errors'
    end

  end
end
