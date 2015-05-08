class Data_source
  
  def put_item( attributes )
      raise "Subcalss declaration needed"
  end
  
  def get_primary_key( key )
    raise "Subcalss declaration needed"
  end
  
  def get_item_by_secondary_index( key, value )
    raise "Subcalss declaration needed"
  end
  
  def exists( key )
    raise "Subcalss declaration needed"
  end
  
end