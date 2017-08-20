require 'super-interesting'

class InterestingsController < ApplicationController

  def index
    standup_job = StandupJob.new
    messages = standup_job.run
    @all_interestings = messages.map { |msg| "#{msg['body']}" }.join("<br />")
  end

end
