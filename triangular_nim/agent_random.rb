class AgentRandom < Agent
  def move(state, available_actions)
    # puts "state:#{state}"
    # puts "available_actions:#{available_actions.map{|state| TriangleChess::state_to_positions(state)}}"
    available_actions.sample
  end

  def receive_reward(reward)
  end
end