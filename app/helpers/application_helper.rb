require Rails.root.to_s + "/lib/date_format"

module ApplicationHelper
  def display_yesno(value)
    value ? "yes" : "no" 
  end

  def display_line_breaks(s)
    return s.gsub(/\r\n/, '<br />').html_safe
  end
  
  # @param [Date] date The date
  # @return [String] The date in 1/12/2012 format
  def display_date(date)
    DateFormat.date(date)
    
  end 

  # @param [Date] date The date
  # @return [String] The date in January 12th, 2012 format
  def display_full_date(date)
    DateFormat.full_date(date)
  end 

  # 1/12/2012 at 9:50 pm
  def display_datetime(datetime)
    datetime.strftime("%b. %e, %Y at %I:%M %p")
  end 

  # returns a link with an onclick call to remove_fields using link_to_function
  def link_to_remove_fields(name, f)  
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", {:class => "remove button" })  
  end 

  # returns a link with an onclick call to add_fields
  # the field information is rendered from a partial and stored as a string until it is needed
  def link_to_add_fields(name, f, association, method = "add_fields")  
    # I am a little concerned about this change (JH 8-31-2012)
    # this seems like a better solution but I am unsure of how it will affect other forms
    # new_object = f.object.class.reflect_on_association(association).klass.new  
    new_object = f.object.send(association).build

    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(association.to_s.singularize + "_fields", {:f => builder, :obj => new_object})  
    end  
    link_to_function(name, "#{method}(this, '#{association}', '#{escape_javascript(fields)}')", {:class => name.underscore.gsub(' ', '_') + ' new button'})
  end 
end
