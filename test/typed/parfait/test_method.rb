require_relative "../helper"

class TestMethod < MiniTest::Test

  def setup
    obj = Register.machine.space.get_class_by_name(:Object)
    args = Parfait::Type.new_for_hash( obj , { bar: :Integer , foo: :Type})
    @method = ::Parfait::TypedMethod.new obj , :meth , args
  end

  def test_method_name
    assert_equal :meth , @method.name
  end

  def test_class_for
    assert_equal :Object , @method.for_class.name
  end

  def test_arg1
    assert_equal 2 , @method.arguments_length , @method.arguments.inspect
    assert_equal Symbol , @method.arguments.first.class
    assert_equal :bar , @method.argument_name(1)
  end

  def test_has_arg
    assert_equal 1 , @method.has_arg(:bar)
    assert_equal 2 , @method.has_arg(:foo)
  end

  def test_add_arg
    @method.add_argument(:foo2 , :Object)
    assert_equal 3 , @method.arguments_length
    assert_equal :foo2 , @method.argument_name(3)
    assert_equal :Object , @method.argument_type(3)
  end

  def test_get_arg_name1
    index = @method.has_arg(:bar)
    assert_equal 1 , index
    assert_equal :bar , @method.argument_name(index)
  end
  def test_get_arg_name1
    index = @method.has_arg(:bar)
    assert_equal :Integer , @method.argument_type(index)
  end
  def test_get_arg_name2
    index = @method.has_arg(:foo)
    assert_equal 2 , index
    assert_equal :foo , @method.argument_name(index)
  end
  def test_get_arg_name2
    index = @method.has_arg(:foo)
    assert_equal :Type , @method.argument_type(index)
  end
end
