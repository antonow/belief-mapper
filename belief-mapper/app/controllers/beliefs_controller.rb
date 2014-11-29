class BeliefsController < ApplicationController
  def index
    @beliefs = Belief.all
    @connections = Connection.all
  end
end
