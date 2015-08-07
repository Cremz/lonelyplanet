class Taxonomy
  attr_accessor :hash, :content

  def initialize(hash)
    @hash = hash
    @content = []
    generate_content
  end

  def children(id)
    content.select{|object| object[:parent] == id}
  end

  def parent_name(id)
    content.select{|object| object[:id] == id}.first[:name]
  end

  private

  def generate_content
    parent = continents_nodes['atlas_node_id']
    content << {id: continents_nodes['atlas_node_id'], name: continents_nodes['node_name'], }
    hash['taxonomies']['taxonomy']['node']['node'].each do |country|
      content << { id: country['atlas_node_id'], name: country['node_name'], parent: parent}
      if country['node']
        country['node'].each do |province|
          content << { id: province['atlas_node_id'], name: province['node_name'], parent: country['atlas_node_id']}
          if province['node']
            if province['node'].class == Array
              province['node'].each do |city|
                content << { id: city['atlas_node_id'], name: city['node_name'], parent: province['atlas_node_id']}
              end
            else
              content << { id: province['node']['atlas_node_id'], name: province['node']['node_name'], parent: province['atlas_node_id']}
            end
          end
        end
      end
    end
  end

  def continents_nodes
    hash['taxonomies']['taxonomy']['node']
  end
end
