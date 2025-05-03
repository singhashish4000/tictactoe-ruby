module TicTacToe
  class Board
    attr_reader :grid, :size

    def initialize(size = 3)
      @size = size
      @grid = Array.new(size) { Array.new(size)}
    end

    def place_mark(x, y, mark)
      return false unless valid_move?(x, y)

      @grid[x][y] = mark
      true
    end

    def valid_move?(x, y)
      x.between?(0, size - 1) && y.between?(0, size - 1) && grid[x][y].nil?
    end

    def full?
      @grid.flatten.none?(&:nil?)
    end

    def winner?
      lines = rows + columns + diagonals
      lines.map {|line| return line[0] if line.uniq.size == 1 && line[0] }
      nil
    end

    def display
      puts " " * (size * 4 + 1)
      puts "-" * (size * 4 + 1) # Horizontal separator
      @grid.each do |row|
        print "|"
        row.each do |cell|
          print " #{cell.nil? ? ' ' : cell} |"
        end
        puts
        puts "-" * (size * 4 + 1) # Horizontal separator
      end
    end

    def clear_cell(x, y)
      if x.between?(0, size - 1) && y.between?(0, size - 1)
        @grid[x][y] = nil
        true
      else
        false
      end
    end

    private

    def rows
      @grid
    end

    def columns
      @grid.transpose
    end

    def diagonals
      [
        (0...size).map {|i| @grid[i][i] },
        (0...size).map{|i| @grid[i][size - i - 1]}
      ]
    end


  end
end