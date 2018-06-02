class AgentHuman < Agent
  def move(state, available_actions)
    positions = gets.strip
    Environment.positions_to_state(positions)
  end

  def receive_reward(reward)
  end
end