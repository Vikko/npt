class MainController < ApplicationController

  def index
    @buffer ||= Listener.new
  end
  
  def action
  end
  
end