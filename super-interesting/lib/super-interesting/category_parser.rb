class CategoryParser
  attr_reader :category

  def initialize(category:)
    @category = category
  end

  def parse_out_category(messages:)
    messages.each do |message|
      message['body'] = message['body'][/\<h2\>#{category}\<\/h2\>\s*([\S\s]*?)(\<h2\>.*\<\/h2\>|----------)/, 1].strip
    end
    messages
  end

end