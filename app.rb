require 'mechanize'
require 'nokogiri'
require 'mini_magick'
require 'yaml'

agent = Mechanize.new
agent.keep_alive = false
agent.max_history = 1
agent.open_timeout = 60
agent.read_timeout = 180

yaml = YAML.load_file("config/setting.yml")

targetURI = yaml["url"]
puts targetURI

page = agent.get(targetURI)

elements = page.search('div.entry-content a img')

elements.each do |element|
  puts element.get_attribute(:src)
  src = element.get_attribute(:src)
  file_name = src[-8, 8]
  open("img/#{file_name}", 'wb') do |file|
    file.puts(Net::HTTP.get_response(URI.parse(src)).body)
  end
  image = MiniMagick::Image.open("img/#{file_name}")
  image.resize "128x128"
  image.write "new_img/v#{file_name}"
end
