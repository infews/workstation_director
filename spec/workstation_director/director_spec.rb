RSpec.describe WorkstationDirector::Director do
  let(:actor_class) do
    actor_class = class_double('ActorClass')
    allow(actor_class).to receive(:new) {actor}
    allow(actor_class).to receive(:to_s) {'ActorClass'}
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
    actor_class = class_double('PresentActorClass')
    allow(actor_class).to receive(:new) {present_actor}
    allow(actor_class).to receive(:to_s) {'PresentActorClass'}
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
    before do
      allow(STDOUT).to receive(:puts)
      director.action!
    end

    context 'with an actor' do
      let(:director) {WorkstationDirector::Director.new(actor_class)}

      context 'that returns false from #present?' do

        it 'reports the actor(s) its running' do
          expect(STDOUT).to have_received(:puts).with(/Directing these actor(s): ActorClass/)
        end

        it 'creates the actor' do
          expect(actor_class).to have_received(:new)
        end

        it 'tells the actor to install' do
          expect(actor).to have_received(:install)
        end

        it 'tells the actor to setup' do
          expect(actor).to have_received(:setup)
        end
      end

      context 'that returns true from #present?' do
        let(:director) {WorkstationDirector::Director.new(present_actor_class)}

        it 'reports the actor(s) its running' do
          expect(STDOUT).to have_received(:puts).with(/Directing these actor(s): PresentActorClass/)
        end

        it 'creates the actor' do
          expect(present_actor_class).to have_received(:new)
        end

        it 'does not tell an actor to install' do
          expect(present_actor).to have_received(:present?)
          expect(present_actor).to_not have_received(:install)
        end

        it 'tells the actor to setup' do
          expect(present_actor).to have_received(:setup)
        end
      end
    end

    context 'with multiple actors' do
      let(:director) do
        WorkstationDirector::Director.new(actor_class, present_actor_class)
      end

      it 'reports the actor(s) its running' do
        expect(STDOUT).to have_received(:puts).with(/Directing these actor(s): ActorClass, PresentActorClass/)
      end

      it 'creates and directs them all' do
        expect(actor_class).to have_received(:new)
        expect(actor).to have_received(:present?)
        expect(actor).to have_received(:install)
        expect(actor).to have_received(:setup)

        expect(present_actor_class).to have_received(:new)
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
