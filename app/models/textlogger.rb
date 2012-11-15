class Textlogger < ActiveRecord::Base
  attr_accessible :content
  
  scope :between, lambda {|from,to| where("created_at > ? AND created_at < ?", from, to)}
  
end
