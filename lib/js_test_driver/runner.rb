module JsTestDriver

  class Runner

    def run(command)
      system(command.to_s)
    end

    def runbg(command)
      spawn(command.to_s)
    end

  end

end
