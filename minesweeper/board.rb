require_relative 'tile.rb'

class Board
  attr_reader :grid_size, :num_bombs

  def initialize(grid_size, num_bombs)
    @grid_size, @num_bombs = grid_size, num_bombs

    generate_board
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def lost? # lose if any tile is bombed and selected
    @grid.flatten.any? { |tile| tile.bombed? && tile.explored? }
  end

  def render(reveal = false)
    # used to fully reveal board @ end of game
    @grid.map do |row|
      row.map do |tile|
        reveal ? tile.reveal : tile.render
      end.join("") # way to reconnect the tiles of each row no spaces
    end.join("\n") # way to reconnect the rows of the grid with newline spaces
  end

  def reveal
    render(true)
  end

  def won?
    # make sure each tile is either bombed & not explored or not bombed & explored
    @grid.flatten.all? { |tile| tile.bombed? != tile.explored? }
  end

  private

  def generate_board
    @grid = Array.new(@grid_size) do |row|
      Array.new(@grid_size) { |col| Tile.new(self, [row, col]) }
    end

    plant_bombs
  end


  def plant_bombs
    total_bombs = 0

    while total_bombs < @num_bombs
      rand_pos = Array.new(2) { rand(@grid_size) } # get random position i.e. (0, 4)

      tile = self[rand_pos] # random tile
      next if tile.bombed?

      tile.plant_bomb   # sets random tile's @bombed status to true
      total_bombs += 1
    end

    nil # returns nil because it is just planting bombs across the grid
  end 
end