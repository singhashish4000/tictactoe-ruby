module TicTacToe
  class CommandManager
    def initialize
      @history = []
    end

    def execute(command)
      success = command.execute
      if success
        @history << command
      end
      success
    end

    def undo
      return false if @history.empty?

      command = @history.pop
      command.undo
    end

    def history
      @history
    end
  end
end