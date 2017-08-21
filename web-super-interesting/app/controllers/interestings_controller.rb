require 'super-interesting'

class InterestingsController < ApplicationController

  def index
    standup_job = StandupJob.new(
      message_downloader: message_downloader,
      message_decoder: message_decoder,
      category_parser: category_parser
    )
    messages = standup_job.run(before: '2017/08/19', after: '2017/08/18')
    @all_interestings = messages.map do
      |msg| "<h2>Interestings from #{msg['location']}</h2>#{msg['body']}"
    end.join("<br />")
  end

  def message_downloader
    MessageDownloader.new
  end

  def message_decoder
    MessageDecoder.new
  end

  def category_parser
    CategoryParser.new(category: 'Interestings')
  end

end
