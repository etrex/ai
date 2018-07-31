class Environment
  CHARS = '123456789ABCDEF'
  POSITIONS = CHARS.chars.map.with_index{ |char, index| [char.to_sym, 1 << index] }.to_h

  #'123'  to 0b111
  def self.positions_to_state(text)
    text.chars.reduce(0){|sum, char| sum + (POSITIONS[char.upcase.to_sym] || 0) }
  end

  #0b111  to '123'
  def self.state_to_positions(state)
    binarys = state_to_binarys(state)
    binarys.chars.map.with_index {|char, index| POSITIONS.keys[index] if char == '1' }.join('')
  end

  def self.state_to_binarys(state)
    ("0" * 15 + state.to_s(2))[-15..-1].reverse
  end

  def self.positions_to_binarys(positions)
    state_to_binarys(positions_to_state(positions))
  end
  #        1
  #       2 3
  #      4 5 6
  #     7 8 9 A
  #    B C D E F

  def self.total_actions
    action_1 = ['1','2','3','4','5','6','7','8','9','A','B','C','D','E','F']
    action_12 = ['12','24','47','7B','35','58','8C','69','9D','AE']
    action_13 = ['13','36','6A','AF','25','59','9E','48','8D','7C']
    action_23 = ['23','45','56','78','89','9A','BC','CD','DE','EF']
    action_124 = ['124','247','47B','358','58C','69D']
    action_136 = ['136','36A','6AF','259','59E','48D']
    action_456 = ['456','789','89A','BCD','CDE','DEF']
    actions = action_1 + action_12 + action_13 + action_23 + action_124 + action_136 + action_456
    actions.map{ |text| positions_to_state(text) }
  end

  TOTAL_ACTIONS = total_actions

  def self.available_actions(state)
    TOTAL_ACTIONS.select{|action| action & state == 0 }
  end

  def self.next_state(state, action)
    state | action
  end

  attr_accessor :players
  attr_accessor :current_player_number
  attr_accessor :state
  attr_accessor :skip_message
  attr_accessor :win_count

  def initialize
    @state = 0
    @players = []
    @win_count = []
  end

  def add_player(player)
    @players << player
    @current_player_number = (0...players.count).to_a.sample
    @win_count = Array.new(players.count, 0)
  end

  def available_actions
    self.class.available_actions(state)
  end

  def action_is_valid?(action)
    return false if action == 0
    return false unless available_actions.include? action
    action & state == 0
  end

  def print_board
    return if skip_message
    binarys = Environment::state_to_binarys(state).chars
    char_map = binarys.map.with_index do |bit, index|
      next Environment::CHARS[index] if bit == '0'
      '-'
    end

    count = -1
    (1..5).each do |line|
      space = ' ' * (5 - line)
      chars = (1..line).map do |i|
        count += 1
        char_map[count]
      end
      puts "#{space}#{chars.join(' ')}"
    end
  end

  def change_player
    @current_player_number = (current_player_number + 1) % players.count
  end

  def current_player
    players[current_player_number]
  end

  def game_end?
    state == 0b111111111111111
  end

  def game_reset
    @state = 0
  end

  def start
    game_reset
    print_board
    loop do
      # player select action
      loop do
        puts "#{current_player.name} 的選擇：" unless skip_message
        player_selected_action = current_player.move(state, available_actions)
        puts Environment::state_to_positions(player_selected_action) unless skip_message
        # update game state
        if action_is_valid?(player_selected_action)
          @state = self.class.next_state(state, player_selected_action)
          break
        end
        puts "這是不合法的行為，請重新選擇。" unless skip_message
      end

      print_board

      if game_end?
        current_player.receive_reward(-1)
        change_player
        current_player.receive_reward(1)
        win_count[current_player_number] += 1
        puts "遊戲結束，#{current_player.name} 獲得勝利" unless skip_message
        break
      else
        current_player.receive_reward(0)
      end

      change_player
      sleep 0.5 unless skip_message
    end
  end
end
