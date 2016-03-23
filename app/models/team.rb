class Team < ActiveRecord::Base

  include HasOrderByName

  has_many :users

  validates_presence_of :name
  validates :name, uniqueness: true
end
