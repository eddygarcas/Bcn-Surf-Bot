class DataBuilder

  def accesor_builder k, v
    #First will create a new instance variable, value if it wasn't a Hash or Hash type instead.
    self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hash.new(v) : v)
    #Secondly will define a get instance method for the given value
    self.class.send(:define_method, "#{k}", proc {self.instance_variable_get("@#{k}")})
    #Finally will define a set instance method for the given value. Notice the proc block
    # to be called every time the set method is called.
    self.class.send(:define_method, "#{k}=", proc {|v| self.instance_variable_set("@#{k}", v)})
  end

end