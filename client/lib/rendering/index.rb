module Rendering
  class Index < Base
    def profiles
      Profile.limit(10)
    end

    def my_profile
      Profile.where(first_name: "Ilya")
    end

    def render
      Handlebars.compile_and_render(:main, Context.data, "#container")
      puts "rendered"
    end

    def on_app_ready
      Document.find("input[data-action=save-age]").on(:click) do |e|
        puts "Clicked"
        button = e.target
        element = button.previous
        puts element
        profile_id = element.data("profile-id")
        new_age = element.value
        deferred = Profile.find(profile_id).update_attributes(age: new_age)
        Handlers::Query.fetch(deferred)
      end
      puts "callback added"
    end
  end
end