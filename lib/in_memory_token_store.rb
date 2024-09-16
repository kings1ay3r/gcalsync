require "googleauth"

class InMemoryTokenStore
  def initialize
    @tokens = {}
  end

  def store(token, user_id)
    @tokens[user_id] = token
  end

  def load(user_id)
    @tokens[user_id]
  end
end
