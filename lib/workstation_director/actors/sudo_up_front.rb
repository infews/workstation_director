require 'rainbow'
using Rainbow

module WorkstationDirector
  class SudoUpFront < Actor
    def setup
      puts Rainbow("Running ").mediumpurple + "sudo " + Rainbow("early so shell has permissions").mediumpurple
      Kernel.system "sudo -v"
    end
  end
end
