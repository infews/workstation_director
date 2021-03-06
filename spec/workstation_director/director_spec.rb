RSpec.describe WorkstationDirector::Director do
  let(:actor_class) do
    actor_class = class_double('ActorClass')
    allow(actor_class).to receive(:new) {actor}
    allow(actor_class).to receive(:to_s) {'ActorClass'}
    actor_class
  end
  let(:actor) do
    actor = double('Actor')
    allow(actor).to receive(:present?) {false}
    allow(actor).to receive(:install) {true}
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
    allow(actor).to receive(:present?) {true}
    allow(actor).to receive(:install) {true}
    allow(actor).to receive(:setup) {true}
    actor
  end
  let!(:early_sudo) {WorkstationDirector::SudoUpFront.new}

  context '#action!' do

    before do
      allow(STDOUT).to receive(:puts)
      allow(WorkstationDirector::SudoUpFront).to receive(:new) {early_sudo}
      allow(early_sudo).to receive(:present?)
      allow(early_sudo).to receive(:setup)
      allow(early_sudo).to receive(:setup).and_return(true)
    end

    context 'SudoUpFront' do
      let(:director) {WorkstationDirector::Director.new()}

      before do
        director.action!
      end

      it 'reports the actor(s) its running' do
        expect(STDOUT).to have_received(:puts).with(/Directing these actor(s):/)
        expect(STDOUT).to have_received(:puts).with(/SudoUpFront/)
      end

      it 'creates the actor' do
        expect(WorkstationDirector::SudoUpFront).to have_received(:new)
      end

      it 'tells the actor to setup' do
        expect(early_sudo).to have_received(:setup)
      end

      it 'tells the actor to setup' do
        expect(early_sudo).to have_received(:setup)
      end
    end

    context 'with an actor' do
      let(:director) {WorkstationDirector::Director.new(actor_class)}

      before do
        director.action!
      end

      context 'that returns false from #present?' do
        it 'reports the actor(s) it is running' do
          expect(STDOUT).to have_received(:puts).with(/Directing these actor(s):/)
          expect(STDOUT).to have_received(:puts).with(/SudoUpFront, ActorClass/)
        end

        it 'creates the actor' do
          expect(actor_class).to have_received(:new)
        end

        it 'tells the actor to setup' do
          expect(actor).to have_received(:setup)
        end

        it 'tells the actor to setup' do
          expect(actor).to have_received(:setup)
        end
      end

      context 'that returns true from #present?' do
        let(:director) {WorkstationDirector::Director.new(present_actor_class)}

        it 'reports the actor(s) its running' do
          expect(STDOUT).to have_received(:puts).with(/Directing these actor(s):/)
          expect(STDOUT).to have_received(:puts).with(/SudoUpFront, PresentActorClass/)
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

      before do
        director.action!
      end

      it 'reports the actor(s) its running' do
        expect(STDOUT).to have_received(:puts).with(/Directing these actor(s):/)
        expect(STDOUT).to have_received(:puts).with(/SudoUpFront, ActorClass, PresentActorClass/)
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

    context 'when there is an error raised' do
      let(:actor_class_with_error) {
        actor_class = class_double('ActorClassWithError')
        allow(actor_class).to receive(:new) {actor_with_error}
        allow(actor_class).to receive(:to_s) {'ActorClassWithError'}
        actor_class
      }
      let(:actor_with_error) {
        actor = double('Actor With Error')
        allow(actor).to receive(:present?) {raise "Test Error message"}
        actor
      }
      let(:director) {WorkstationDirector::Director.new(actor_class_with_error, actor_class)}

      it 'raises an error and does not execute further actors' do
        expect {
          director.action!
        }.to raise_exception(RuntimeError)

        expect(STDOUT).to have_received(:puts).with(/Director stopped/)
        expect(actor_class).to_not have_received(:new)
      end
    end
  end
end

