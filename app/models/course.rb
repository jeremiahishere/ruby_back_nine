class Course < ActiveRecord::Base
  has_many :holes, :dependent => :destroy

  validates_presence_of :name
  
  scope :active, lambda { where("start_at < ? and end_at > ?", Time.zone.now, Time.zone.now) }
  
  def par
    par = 0
    holes.each {|hole|
      par = (hole.par.nil? ? 0 : hole.par) + par
    }
    return par
  end
end 
