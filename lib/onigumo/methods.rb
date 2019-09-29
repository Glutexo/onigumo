module Onigumo
  def spider_by_name(spider)
    Object.const_get("Onigumo::Spiders::#{spider}")
  end
  
  def spider_method_exist?(spider, meth)
    begin
      cls = spider_by_name(spider)
    rescue NameError
      return false
    end
    cls.methods.include?(meth.to_sym)
  end
  
  module_function(:spider_by_name, :spider_method_exist?)
end