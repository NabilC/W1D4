class Tile
    DELTAS = [
        [-1, -1], # up 1 left 1
        [-1, 0], # up 1
        [-1, 1], # up 1 right 1
        [0, -1], # right 1
        [0, 1], # left 1
        [1, -1], # down 1, left 1
        [1, 0], # down 1
        [1, 1] # down 1, right 1
    ].freeze # freezes object; prevents future changes to this array
    
    attr_reader :pos

    def initialize(board, pos)
        # pass Board to Tile on initialize so Tile instance can find its neighbors
        @board, @pos = board, pos
        @bombed, @explored, @flagged = false, false, false # these are used as booleans
    end

    def bombed?
        @bombed # can't use attr_reader to create instance var for this method b/c it ends w/ '?'
    end

    def explored?
        @explored
    end

    def flagged?
        @flagged
    end

    def adjacent_bomb_count
        neighbors.select(&:bombed?).count
    end

    def explore
        # don't explore location user thinks is bombed
        return self if flagged?

        # don't revisit previously explored tiles
        return self if explored?

        @explored = true
        if !bombed? && adjacent_bomb_count == 0
            neighbors.each(&:explore) # explores all the adjacent positions
            # note &:explore technique explores each neighbor
        end
        
        self
    end

    def inspect
        # instead of printing out the whole board (information overload)
        # overrides (defines) the inspect method in Tile class
        # returns string containing just info needed about its state (position and bombed,flagged etc.)
        { pos: pos,
          bombed: bombed?,
          flagged: flagged?,
          explored: explored? }.inspect
    end

    def neighbors # all squares adjacent to the tile
        adjacent_coords = DELTAS.map do |(dx, dy)|
            [pos[0] + dx, pos[1] + dy]
        end.select do |row, col|
            [row, col].all? do |coord|
                coord.between?(0, @board.grid_size - 1)
                # this between ensures you only keep actual positions on the board
            end
        end

        adjacent_coords.map { |pos| @board[pos] }
    end

    def plant_bomb
        @bombed = true # sets bombed status to true for tile
    end
    
    
    def render
        if flagged?
            "F" # places flag bomb
        elsif explored? # if tile already explored
            adjacent_bomb_count == 0 ? "_" : adjacent_bomb_count.to_s 
            # '_' used for interior squares when exploring
            # prints adjacent bomb count if tile already explored
        else # if unexplored square -> neither flagged nor explored (newly encountered tile)
            "*"
        end
        
    end

    def reveal
        # used to fully reveal board at end of game
        if flagged?
            # mark true and false flags
            bombed? ? "F" : "f"
        elsif bombed?
            # diplay a hit bomb as X and unhit bombs as B
            explored? ? "X" : "B"
        else
            # if tile is neither flagged or bombed, display adj bomb count
            adjacent_bomb_count == 0 ? "_" : adjacent_bomb_count.to_s 
            # '_' used for interior square when exploring
        end
    end

    def toggle_flag
        # ignore flagging of explored squares
        @flagged = !@flagged unless @explored
    end
end

