module WorkstationDirector
  class Director
    def initialize(*actor_classes)
      @actor_classes = Array(actor_classes)
    end

    def action!
      @actor_classes.each do |actor_class|
        actor = actor_class.new
        actor.install unless actor.present?
        actor.setup
      end
    end
  end
end
