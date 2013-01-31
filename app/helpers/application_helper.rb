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
    DateFormat.datetime(datetime)
  end 
end
