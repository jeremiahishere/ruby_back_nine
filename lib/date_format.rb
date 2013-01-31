module DateFormat

  # returns the datetime
  def self.datetime(datetime)
    return datetime.strftime '%-m/%-d/%Y at %-l:%M %P' unless datetime.blank?
  end 

  # Due to a client request, this was changed from Jan. 12, 2012 format to 1/12/2012 format (JH 9-28-2012)
  #
  # here is the old format:
  # return date.strftime "%b. #{date.day.ordinalize}, %Y" unless date.blank?
  #
  # @param [Date] date The date
  # @return [String] The date in 1/12/2012 format
  def self.date(date)
    date_mdy(date)
  end 

  # this method was added to be used on a csv field. (AU 11-16-12)
  # @param [Date] date
  #   
  # @retrun [String] the time in 0:00 am/pm format
  def self.time(date)
    return date.strftime "%-l:%M %P" unless date.blank?
  end 

  # @param [Date] date The date
  # @return [String] The date in January 12th, 2012 format
  def self.full_date(date)
    return date.strftime "%B #{date.day.ordinalize}, %Y" unless date.blank?
  end 

  # @param [Date] date The date
  # @return [String] The date in 1/12/2012 format
  def self.date_mdy(date)
    return date.strftime '%-m/%-d/%Y' unless date.blank?
  end 

  # @param [Date] date The date
  # @return [String] The date in 2012/1/12 format
  def self.date_ymd(date)
    return date.strftime '%Y/%-m/%-d' unless date.blank?
  end
end
