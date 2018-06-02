class Agent
  attr_accessor :name
  def initialize(name = '傻逼')
    @name = name
  end

  def move(state, available_actions)
    raise
  end

  def receive_reward(reward)
  end
end