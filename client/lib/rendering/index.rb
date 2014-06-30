module Rendering
  class Index < Base
    def profiles
      Profile.limit(10)
    end

    def my_profile
      Profile.where(first_name: "Ilya")
    end
  end
end