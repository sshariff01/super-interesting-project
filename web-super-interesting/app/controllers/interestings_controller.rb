require 'super-interesting'

class InterestingsController < ApplicationController

  def index
    standup_job = StandupJob.new
    messages = standup_job.run(before: '2017/08/19', after: '2017/08/18')
    @all_interestings = messages.map { |msg| "#{msg['body']}" }.join("<br />")
  end

end
