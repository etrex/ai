require './environment.rb'
require './agent.rb'
require './agent_human.rb'
require './agent_random.rb'
require './agent_must_win.rb'

def play_n_times(n = 1000)
  tc = Environment.new
  player1 = AgentRandom.new('傻逼1')
  player2 = AgentRandom.new('傻逼2')
  tc.add_player(player1)
  tc.add_player(player2)

  # 玩 1000 場
  tc.skip_message = true
  t1 = Time.now
  (1..n).each do |i|
    tc.start
  end
  puts "#{player1.name} 贏了 #{tc.win_count[0]} 場"
  puts "#{player2.name} 贏了 #{tc.win_count[1]} 場"
  puts "耗時：#{Time.now - t1} 秒"
end

def human_play
  tc = Environment.new
  tc.add_player(AgentRandom.new)
  tc.add_player(AgentHuman.new('卡米'))
  tc.start
end

def env_demo
  puts Environment::positions_to_state('123')
  # 7
  puts Environment::positions_to_binarys('123')
  # 111000000000000
  puts Environment::state_to_positions(7)
  # 123
end

def must_win_play
  tc = Environment.new
  tc.add_player(AgentRandom.new)
  tc.add_player(AgentMustWin.new)
  tc.start
end

def must_win_play_n_times(n = 1000)
  tc = Environment.new
  player1 = AgentRandom.new
  player2 = AgentMustWin.new
  #player1 = AgentMustWin.new('一定贏A')
  #player2 = AgentMustWin.new('一定贏B')
  tc.add_player(player1)
  tc.add_player(player2)

  # 玩 n 場
  tc.skip_message = true
  t1 = Time.now
  (1..n).each do |i|
    tc.start
  end
  puts "#{player1.name} 贏了 #{tc.win_count[0]} 場"
  puts "#{player2.name} 贏了 #{tc.win_count[1]} 場"
  puts "耗時：#{Time.now - t1} 秒"
end

def human_play_with_must_win
  tc = Environment.new
  tc.add_player(AgentMustWin.new)
  tc.add_player(AgentHuman.new('卡米'))
  tc.start
end

play_n_times(1000)
# human_play
# env_demo
# must_win_play
# must_win_play_n_times
# human_play_with_must_win

