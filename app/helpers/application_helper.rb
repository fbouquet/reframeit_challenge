module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", class: "close")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")".html_safe, class: "btn btn-small btn-info btn_add_field col-md-offset-1")
  end

  # Generate a random number and return boolean with the given chance (0..100)
  def random_number_is_under(influence)
    rand_nb = 1 + Random.rand(100)
    rand_nb <= influence
  end


  def convinced_users_hash_to_s(hash)
    return_string = "<h1 class=\"text-center\">Convinced users on each question</h1>"
    hash.each do |question_id, current_array|
      question_content = Question.find(question_id).content
      return_string += "<h2>" + question_content + "</h2>"

      if current_array.length == 0
        return_string += "<p>No other users convinced on this question.</p>"
      else
        return_string += "<ul>"

        current_array.each do |user_name|
          return_string += "<li>" + user_name + "</li>"
        end

        return_string += "</ul>"
      end
    end

    return_string.html_safe
  end
end
