require 'nokogiri'
require 'awesome_print'
require 'active_support/core_ext/hash/conversions'

Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require file }

class LonelyPlanetParser
  attr_accessor :destinations, :taxonomy, :output_folder, :template, :number_of_files

  def initialize(destinations, taxonomy, output)

    @number_of_files = 0
    taxonomy_f = File.open("#{taxonomy}")
    taxonomy_doc = Nokogiri::XML(taxonomy_f)
    @taxonomy = Taxonomy.new(Hash.from_xml(taxonomy_doc.to_s))
    taxonomy_f.close

    destination_f = File.open("#{destinations}")
    dest_doc = Nokogiri::XML(destination_f)
    @destinations = Destination.new(Hash.from_xml(dest_doc.to_s))
    destination_f.close

    @output_folder = output
    @template = File.read('output-template/example copy.html')

  end

	def run
    taxonomy.content.each do |item|
      @number_of_files += 1
      generate_document(item.merge(destinations.find(item[:id])), taxonomy.children(item[:id]))
    end
	end

  private

  def generate_document(item, children)
    title = item[:name]
    links = ''
    if item[:parent]
      links << "<li><a href=\"#{item[:parent]}.html\">#{taxonomy.parent_name(item[:parent])}</a></li>"
    end
    links << "<li><a href=\"#\"><strong>#{title}</strong></a></li>"
    if children.any?
      children.each do |child|
        links << "<li><a href=\"#{child[:id]}.html\">#{child[:name]}</a></li>"
      end
    end
    new_contents = @template
    new_contents = new_contents.gsub('{DESTINATION NAME}', title)
    new_contents = new_contents.gsub('HIERARCHY NAVIGATION GOES HERE', links)

    x = Nokogiri::HTML(new_contents)
    inner = x.at_css '#main .block .content .inner'
    inner.content = item[:history]
    File.open("#{output_folder}/#{item[:id]}.html", "w") { |file| file.puts x }
  end
end


puts 'Run with default files? (y/n)'
default = gets.chomp

if default.downcase == 'y'
  destinations_file = 'sources/destinations.xml'
  taxonomy_file = 'sources/taxonomy.xml'
  output_folder = 'output-template'
else
  puts 'Please use files relative to the current folder.'
  puts 'Destination file:'
  destinations_file = gets.chomp
  puts 'Taxonomy file:'
  taxonomy_file = gets.chomp
  puts 'Output folder:'
  output_folder = gets.chomp
end


parser = LonelyPlanetParser.new(destinations_file, taxonomy_file, output_folder)
parser.run
puts "Parsing complete. #{parser.number_of_files} files were generated."