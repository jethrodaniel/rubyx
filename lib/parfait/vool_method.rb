module Parfait

  # This represents the method at source code level (sis vool)
  #
  # Type objects are already created for args and locals, but the main attribute
  # is the source, which is a Vool::Statement
  #
  # Classes store VoolMethods, while Types store Risc::CallableMethod
  # A Type referes to a Class , but a Class (interface) is implemented by many types
  # as it changes during the course of it's life. Types do not change. Objects have
  # type, and so only indirectly a class.
  #
  class VoolMethod < Object

    attr_reader :name , :args_type , :frame_type
    attr_reader :source

    def initialize(name , args_type , frame_type , source )
      @name = name
      @args_type = args_type
      @frame_type = frame_type
      @source = source
      #raise source.to_s if name == :type_length
      raise "Name must be symbol" unless name.is_a?(Symbol)
      raise "args_type must be type" unless args_type.is_a?(Parfait::Type)
      raise "frame_type must be type" unless frame_type.is_a?(Parfait::Type)
      raise "source must be vool not#{source.class}" unless source.is_a?(Vool::Statement)
      raise "Empty bod" if(@source.is_a?(Vool::Statements) and @source.empty?)
    end

    def create_callable_method_for( type )
      raise "create_method #{type.inspect} is not a Type" unless type.is_a? Parfait::Type
      #puts "Create #{name} for #{type.object_class.name}.#{type.hash}"
      type.create_method( @name , @args_type , @frame_type)
    end

    def compiler_for(self_type)
      callable_method = self_type.get_method(@name)
      #puts "Using #{name} for #{self_type.object_class.name}.#{self_type.hash}" unless callable_method
      raise "Callable not found #{@name}" unless callable_method
      compiler = Mom::MethodCompiler.new( callable_method )
      head = @source.to_mom( compiler )
      compiler.add_code(head)
      compiler
    end
    def to_s
      "def #{name}(#{args_type.names})\n  #{source}\nend"
    end
  end
end
