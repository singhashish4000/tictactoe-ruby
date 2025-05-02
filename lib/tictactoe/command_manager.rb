module TicTacToe
  class CommandManager
    def initialize
      @history = []
    end

    def execute(command)
      @history << command
      command.execute
    end

    def undo
      command = @history.pop
      command.undo if command
    end
  end
end