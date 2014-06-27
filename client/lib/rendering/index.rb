module Rendering
  class Index < Base
    def posts
      Post.limit(10)
    end

    def my_post
      Post.where(first_name: "Ilya")
    end
  end
end