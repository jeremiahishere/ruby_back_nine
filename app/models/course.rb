class Course < ActiveRecord::Base
  has_many :holes, :dependent => :destroy

  validates_presence_of :name
    
end 
