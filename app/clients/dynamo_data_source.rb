require 'singleton'

class Dynamo_data_source < Data_source
  
  include Singleton
  
  def initialize
    @dynamodb = Aws::DynamoDB::Client.new
  end
  
  def put_item( table_name, attributes )
      @dynamodb.put_item(
        table_name: table_name,
        item: attributes
      )
  end
  
  def get_primary_key( table_name, key, value )
    puts "looking up key:#{key} value:#{value} in table:#{table_name}"
    @dynamodb.get_item(
      table_name: table_name,
      key: { key => value }
    )
  end
  
  def get_item_by_secondary_index( table_name, key, value )
    # dynamo's syntax for calling by a secondary index is weird
    # since it can be more than one value, the logic for what
    # is looked up is in the key_condition_expression and then 
    # the possible values are in the expression_attribute_values
    @dynamodb.query(
      table_name: table_name,
      index_name: key+"-index",
      select: "ALL_ATTRIBUTES",
      key_condition_expression: "#{key} = :value",
      expression_attribute_values: { ":value" => value }
    )
  end
  
  def exists( table_name, key, value )
    !get_primary_key( table_name, key, value ).item.nil?
  end
end