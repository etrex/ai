require './environment.rb'
require './agent.rb'
require './agent_human.rb'
require './agent_random.rb'

def play_n_times(n = 1000)
  tc = Environment.new
  tc.add_player(AgentRandom.new)
  tc.add_player(AgentRandom.new)

  # 玩 1000 場
  tc.skip_message = true
  t1 = Time.now
  (1..n).each do |i|
    tc.start
  end
  p tc.win_count
  p (Time.now - t1)
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

# play_n_times(1000)
# human_play
env_demo