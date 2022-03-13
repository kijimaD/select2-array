class Select2Array
  attr_reader :item_format

  def initialize(&block)
    @groups = []
    instance_eval(&block) if block_given?
  end

  def group(group_name, &block)
    group = Select2ArrayGroup.new(self, group_name)
    @groups << group
    yield group if block_given?
  end

  def set_item_format(lambda)
    @item_format = lambda
  end

  def export
    @groups.map(&:export)
  end
end

class Select2ArrayGroup
  def initialize(config, group_name)
    @config = config
    @items = []
    @group_name = group_name
  end

  def item(name, path, romaji = '')
    @items << Select2ArrayItem.new(@config, name, path, romaji)
  end

  def export
    [@group_name, @items.map(&:export).compact]
  end
end

class Select2ArrayItem
  def initialize(config, name, path, romaji = '')
    @config = config
    @name = name
    @path = path
    @romaji = romaji
  end

  def export
    @config.item_format.call(@name, @path, @romaji)
  end
end

def menu_array
  item_format = ->(name, path, romaji) { ["#{name} - #{romaji} - #{path}", path] if p path }

  Select2Array.new do |c|
    c.set_item_format(item_format)

    c.group('👤メインメニュー') do |g|
      g.item('機能1', '/feature1', 'kinou1')
      g.item('機能2', '/feature2', 'kinou2')
      g.item('設定', '/config', 'settei')
    end
  end.export
end

menu_array
