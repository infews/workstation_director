module WorkstationDirector
  class Director
    def initialize(*actor_classes)
      @actor_classes = Array(actor_classes)
    end

    def action!
      puts "Directing these actors: " + actor_names
      @actor_classes.each do |actor_class|
        actor = actor_class.new
        actor.install unless actor.present?
        actor.setup
      end
    end

    private

    def actor_names
      @actor_classes.collect{|klass| klass.to_s}.join(', ')
    end
  end
end
