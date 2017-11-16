require 'nokogiri'
require 'open-uri'
class Monster
  #Basic Attributes
  attr_accessor :id, :name, :level, :size, :race, :image

  #Optional Attributes
  attr_accessor :property, :exp_base, :exp_class

  @@base_url = "http://ragnarok.uol.com.br/database/thor/monstros"

  def initialize(id, name, level, size, race, image, options = {})
    @id = id
    @name = name
    @level = level
    @size = size
    @race = race
    @image = image

    #Optional
    @property = options[:property]
    @exp_base = options[:exp_base]
    @exp_class = options[:exp_class]
  end

  def self.all(page = 1)
    doc = Nokogiri::HTML(open("#{@@base_url}?page=#{page}"))
    last_page = self.total_of_pages(doc.css("p.total-result").text)
    itens = extract_multiple_monsters(doc)

    return { 
      all: itens,
      last_page: last_page
    }
  end

  def self.show(id)
    doc = Nokogiri::HTML(open("#{@@base_url}/detalhes/#{id}"))
    data = extract_single_monster(doc)

    monster = Monster.new(
      id, 
      data[:name], 
      data[:level], 
      data[:size], 
      data[:race], 
      data[:image], 
      { 
        property: data[:property], 
        exp_base: data[:exp_base], 
        exp_class: data[:exp_class]
      }
    )
  end

  def self.search(term, page = 1)
    doc = Nokogiri::HTML(open("#{@@base_url}?page=#{page}&nome=#{term}"))
    last_page = self.total_of_pages(doc.css("p.total-result").text)
    itens = extract_multiple_monsters(doc)

    return { 
      all: itens,
      last_page: last_page
    }
  end

  def to_json(options = {})
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get var
    end
    hash.to_json
  end

  private
    def self.total_of_pages(text)
      monsters_per_page = 12
      total_of_monsters = text.gsub(/[^0-9]/, "").to_i

      return (total_of_monsters / monsters_per_page).ceil
    end

    def self.get_id(href)
      href.slice!("monstros/detalhes/")
      href
    end

    def self.extract_single_monster(html)
      monster_info = html.css("div#itemDescription")[0]
      image = monster_info.css("img#monster")[0].attr('src')
      name = monster_info.css("h1").text

      basic_info_list = monster_info.css("ul#informacoes-list")[0]
      level = basic_info_list.css("li")[1].text
      race = basic_info_list.css("li")[3].text
      property = basic_info_list.css("li")[5].text
      size = basic_info_list.css("li")[7].text
      exp_base = basic_info_list.css("li")[9].text
      exp_class = basic_info_list.css("li")[11].text

      return {
        image: image,
        name: name,
        level: level,
        race: race,
        property: property,
        size: size,
        exp_base: exp_base,
        exp_class: exp_class
      }
    end

    def self.extract_multiple_monsters(html)
      itens = []

      html.css("li.monstros").each do |monster|
        id = get_id(monster.css("a")[0].attr('href'))
        image = monster.css("img")[0].attr('src')
        name = monster.css("h5").text
        level = monster.css("label")[1].text
        size = monster.css("label")[2].text
        race = monster.css("label")[3].text
        monster = Monster.new(id, name, level, size, race, image)

        itens.push(monster)
      end

      return itens
    end
end