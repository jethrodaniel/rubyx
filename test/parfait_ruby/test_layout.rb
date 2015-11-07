require_relative "../helper"

class TestLayout < MiniTest::Test

  def setup
    @mess = Register.machine.boot.space.first_message
  end

  def test_message_layout
    layout = @mess.get_layout
    assert layout
    assert @mess.instance_variable_defined :next_message
    assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
  end

  def test_message_by_index
    assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
    index = @mess.get_layout.variable_index :next_message
    assert_equal 2 , index
    assert_equal @mess.next_message , @mess.get_internal(index)
  end

  def test_layout_index
    assert_equal @mess.get_layout , @mess.get_internal(Parfait::LAYOUT_INDEX) , "mess"
  end

  def test_inspect
    assert @mess.get_layout.inspect.start_with?("Layout")
  end
  def test_layout_is_first
    layout = @mess.get_layout
    assert_equal 1 , layout.variable_index(:layout)
  end

  def test_length
    assert_equal 9 , @mess.get_layout.instance_length , @mess.get_layout.inspect
  end

  def test_layout_length
    assert_equal 9 , @mess.get_layout.instance_length , @mess.get_layout.inspect
    assert_equal 18 , @mess.get_layout.get_internal(4)
  end

  def test_layout_length_index
    assert_equal 4 , @mess.get_layout.get_layout.variable_index(:indexed_length)
    assert_equal 4 , @mess.get_layout.get_layout.get_offset
    assert_equal 4 , @mess.get_layout.get_offset
    assert_equal 8 , @mess.get_layout.get_layout.indexed_length
    assert_equal 8 , @mess.get_layout.get_layout.get_internal(4)
  end

  def test_layout_methods
    assert_equal 3 , @mess.get_layout.get_layout.variable_index(:instance_methods)
  end

  def test_no_index_below_1
    layout = @mess.get_layout
    names = layout.instance_names
    assert_equal 9 , names.get_length , names.inspect
    names.each do |n|
      assert layout.variable_index(n) >= 1
    end
  end

  def test_class_layout
    oc = Register.machine.boot.space.get_class_by_name( :Object )
    assert_equal Parfait::Class , oc.class
    layout = oc.object_layout
    assert_equal Parfait::Layout , layout.class
    assert_equal 1 , layout.instance_names.get_length
    assert_equal layout.first , :layout
  end

  def test_attribute_set
    @mess.receiver = 55
    assert_equal 55 , @mess.receiver
  end

  def test_add_name
    layout = Parfait::Layout.new Register.machine.space.get_class_by_name(:Layout)
    layout.add_instance_variable :boo , :Object
    assert_equal 2 , layout.variable_index(:boo)
    assert_equal 4 , layout.get_length
    assert_equal :layout , layout.get(1)
    assert_equal :boo , layout.get(3)
    layout
  end

  def test_inspect
    layout = test_add_name
    assert layout.inspect.include?("boo") , layout.inspect
  end

  def test_each
    layout = test_add_name
    assert_equal 4 , layout.get_length
    counter = [:boo , :Object, :layout , :Layout]
    layout.each do |item|
      assert_equal item , counter.delete(item)
    end
    assert counter.empty?
  end

  # not really parfait test, but related and no other place currently
  def test_reg_index
    message_ind = Register.resolve_index( :message , :receiver )
    assert_equal 3 , message_ind
    @mess.receiver = 55
    assert_equal 55 , @mess.get_internal(message_ind)
  end

  def test_object_layout
    assert_equal 2 , @mess.get_layout.variable_index(:next_message)
  end

  def test_remove_me
    layout = @mess.get_layout
    assert_equal layout , @mess.get_internal(1)
  end
end