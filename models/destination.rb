class Destination
  attr_accessor :hash, :content

  def initialize(hash)
    @hash = hash
    @content = []
    generate_content
  end

  def find(id)
    content.select { |object| object[:id] == id }.first
  end

  private

  def generate_content
    destination_level.each do |destination|
      history = destination['overview'] unless destination['overview'].nil?
      history = destination['history']['history']['overview'] unless destination['history'].nil?
      history = destination['introductory']['introduction']['overview'] unless destination['introductory'].nil?
      content << {id: destination['atlas_id'], name: destination['title'], history: history}
    end
  end

  def destination_level
    hash['destinations']['destination']
  end
end
