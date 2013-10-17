class User

  attr_accessor :email, :id # thd :id accessor is very bad

  def initialize(input)
    @email = input["email"]
    @id = assign_pk
  end

  def assign_pk
    if UserStore.max_id
      return UserStore.max_id + 1
    else
      return 1
    end
  end

  def to_h
    {"id" => id,
      "email" => email
    }
  end

end
