class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  after_create :default_role

  has_many :assignments
  has_many :roles, :through => :assignments
  
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def name
    email
  end

  private
  def default_role
    golfer = Role.where(:name => 'golfer').first
    self.roles << golfer unless self.has_role?(golfer)
  end
end
