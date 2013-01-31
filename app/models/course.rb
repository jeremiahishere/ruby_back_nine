class Course < ActiveRecord::Base
  has_many :holes

  validates_presence_of :name
    
end 
