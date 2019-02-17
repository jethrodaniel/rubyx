#
# In many respects a MetaClass is like a Class. We haven't gone to the full ruby/oo level
# yet, where the metaclass is actually a class instance, but someday.

# A Class in general can be viewed as a way to generate methods for a group of objects.

# A MetaClass serves the same function, but just for one object, the class object that
# is the meta_class of.
# This is slightnly different in the way that the type of the class must actually
# change, whereas for a class the instance type changes and only objects generated
# henceafter have a different type.

# This is still a first version, this change is not implemeted, also classes at boot don't
# have metaclasses yet, so still a bit TODO

# Another current difference is that a metaclass has no superclass. Also no name.
# There is a one to one relationship between a class instance and it's meta_class instance.

module Parfait
  class MetaClass < Object
    include Behaviour

    attr :type, :instance_type , :instance_methods , :clazz

    def self.type_length
      4
    end

    def initialize( clazz )
      super()
      self.clazz = clazz
      self.instance_methods = List.new
      set_instance_type( clazz.get_type() )
    end

    def rxf_reference_name
      clazz.name
    end

    def inspect
      "MetaClass(#{clazz.name})"
    end

    def add_method_for(name , type , frame , body )
      method = Parfait::VoolMethod.new(name , type , frame , body )
      add_method( method )
      method
    end

    def add_method(method)
      raise "Must be untyped method #{method}" unless method.is_a? Parfait::VoolMethod
      instance_methods.push(method)
    end

    def get_method(name)
      instance_methods.find{|m| m.name == name }
    end

    # adding an instance changes the instance_type to include that variable
    def add_instance_variable( name , type)
      self.instance_type = instance_type.add_instance_variable( name , type )
    end

    # setting the type generates all methods for this type
    # (or will do, once we store the methods code to do that)
    def set_instance_type( type )
      raise "type must be type #{type}" unless type.is_a?(Type)
      self.instance_type = type
    end

    # Nil name means no superclass, and so nil returned
    def super_class
      return nil
    end

    # no superclass, return nil to signal
    def super_class_name
      nil
    end

  end
end
