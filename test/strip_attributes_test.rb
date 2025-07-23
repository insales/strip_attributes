require 'test_helper'

class Model
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attribute :foo, :string, default: nil
  attribute :bar, :string, default: nil
  attribute :biz, :string, default: nil
  attribute :baz, :string, default: nil
  attribute :bang, :string, default: nil
end

class StripAllMockRecord < Model
  strip_attributes!
end

class StripOnlyOneMockRecord < Model
  strip_attributes! :only => :foo
end

class StripOnlyThreeMockRecord < Model
  strip_attributes! :only => [:foo, :bar, :biz]
end

class StripExceptOneMockRecord < Model
  strip_attributes! :except => :foo
end

class StripExceptThreeMockRecord < Model
  strip_attributes! :except => [:foo, :bar, :biz]
end

class StripAttributesTest < Test::Unit::TestCase
  def setup
    @init_params = { :foo => "\tfoo", :bar => "bar \t ", :biz => "\tbiz ", :baz => "", :bang => " " }
  end

  def test_should_exist
    assert Object.const_defined?(:StripAttributes)
  end

  def test_should_strip_all_fields
    record = StripAllMockRecord.new(@init_params)
    record.valid?
    assert_equal "foo", record.foo
    assert_equal "bar", record.bar
    assert_equal "biz", record.biz
    assert_nil record.baz
    assert_nil record.bang
  end

  def test_should_strip_only_one_field
    record = StripOnlyOneMockRecord.new(@init_params)
    record.valid?
    assert_equal "foo",     record.foo
    assert_equal "bar \t ", record.bar
    assert_equal "\tbiz ",  record.biz
    assert_equal "",        record.baz
    assert_equal " ",       record.bang
  end

  def test_should_strip_only_three_fields
    record = StripOnlyThreeMockRecord.new(@init_params)
    record.valid?
    assert_equal "foo", record.foo
    assert_equal "bar", record.bar
    assert_equal "biz", record.biz
    assert_equal "",    record.baz
    assert_equal " ",   record.bang
  end

  def test_should_strip_all_except_one_field
    record = StripExceptOneMockRecord.new(@init_params)
    record.valid?
    assert_equal "\tfoo", record.foo
    assert_equal "bar",   record.bar
    assert_equal "biz",   record.biz
    assert_nil record.baz
    assert_nil record.bang
  end

  def test_should_strip_all_except_three_fields
    record = StripExceptThreeMockRecord.new(@init_params)
    record.valid?
    assert_equal "\tfoo",   record.foo
    assert_equal "bar \t ", record.bar
    assert_equal "\tbiz ",  record.biz
    assert_nil record.baz
    assert_nil record.bang
  end

  def test_should_strip_non_break_space
    record = StripOnlyOneMockRecord.new(:foo => "\xC2\xA0foo\xC2\xA0bar\xC2\xA0")
    record.valid?
    assert_equal 'foo bar',   record.foo
  end

end
