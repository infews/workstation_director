require 'rainbow'
require 'workstation_director/actors/sudo_up_front'

using Rainbow

module WorkstationDirector
  class Director
    def initialize(*actor_classes)
      @actor_classes = actor_classes
      @actor_classes.unshift SudoUpFront
    end

    def action!
      puts Rainbow("Directing these actors: ").mediumpurple + actor_names
      @actor_classes.each do |actor_class|
        actor = actor_class.new
        actor.install unless actor.present?
        actor.setup
      end
    rescue => e
      puts Rainbow('Director stopped with this error message:').red
      raise e
    end

    private

    def actor_names
      @actor_classes.collect{|klass| klass.to_s}.join(', ')
    end
  end
end
