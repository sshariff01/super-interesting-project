class CategoryParser

  def parse_out_category(category_to_parse_out:, messages:)
    messages.each do |message|
      message['body'] = message['body'][/\<h2\>#{category_to_parse_out}\<\/h2\>\s*([\S\s]*?)(\<h2\>.*\<\/h2\>|----------)/, 1].strip
    end
    messages
  end

end