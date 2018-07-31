class AgentMustWin < Agent

  def initialize(name = '一定贏')
    super(name)
    @my_turn_cache = {}
    @enemy_turn_cache = {}
  end

  def move(state, available_actions)
    _score, action = my_turn(state)
    action
  end

  def receive_reward(reward)
  end

  WIN = 1
  LOST = -1

  private

  def my_turn(state)
    cached = @my_turn_cache[state]
    return cached unless cached.nil?

    available_actions = Environment.available_actions(state)

    score_act = my_turn_act(state, available_actions)

    @my_turn_cache[state] = score_act
    score_act
  end

  def enemy_turn(state)
    cached = @enemy_turn_cache[state]
    return cached unless cached.nil?

    available_actions = Environment.available_actions(state)

    score_act = enemy_turn_act(state, available_actions)

    @enemy_turn_cache[state] = score_act
    score_act
  end

  # === search all and minimax ===
  # slower, will 'sample' from winning options

  #def my_turn_act(state, actions)
    #return [LOST, actions[0]] if actions.count == 1
    #return [WIN, nil] if actions.count == 0

    #actions.map do |act|
      #[enemy_turn(Environment.next_state(state, act))[0], act]
    #end.group_by do |score, act|
      #score
    #end.to_a.map do |score, actions|
      #[score, actions.sample[1]]
    #end.max_by do |score, _action|
      #score
    #end
  #end

  #def enemy_turn_act(state, actions)
    #return [WIN, nil] if actions.count == 1
    #return [LOST, actions[0]] if actions.count == 0

    #actions.map do |act|
      #[my_turn(Environment.next_state(state, act))[0], act]
    #end.group_by do |score, act|
      #score
    #end.to_a.map do |score, actions|
      #[score, actions.sample[1]]
    #end.min_by do |score, _action|
      #score
    #end
  #end

  # === deep first and minimax ===
  # quicker, will choose the first winning option
  
  def my_turn_act(state, actions)
    return [LOST, actions[0]] if actions.count == 1
    return [WIN, nil] if actions.count == 0

    for act in actions
      score, _act = enemy_turn(Environment.next_state(state, act))
      return [WIN, act] if score == WIN
    end

    [LOST, actions.sample]
  end

  def enemy_turn_act(state, actions)
    return [WIN, nil] if actions.count == 1
    return [LOST, actions[0]] if actions.count == 0

    for act in actions
      score, _act = my_turn(Environment.next_state(state, act))
      return [LOST, act] if score == LOST
    end

    [WIN, actions.sample]
  end

end
