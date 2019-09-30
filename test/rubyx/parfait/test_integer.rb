require_relative "../helper"

module RubyX
  class TestIntegerCompile < MiniTest::Test
    include ParfaitHelper
    def setup
      @compiler = compiler
      @compiler.ruby_to_vool load_parfait(:object)
      @compiler.ruby_to_vool load_parfait(:data_object)
    end
    def source
      get_preload("Space.main") + load_parfait(:integer)
    end
    def test_load
      assert source.include?("class Integer")
      assert source.length > 1500 , source.length
    end
    def test_vool
      vool = @compiler.ruby_to_vool source
      assert_equal Vool::ScopeStatement , vool.class
      assert_equal Vool::ClassExpression , vool[0].class
      assert_equal Vool::ClassExpression , vool[1].class
      assert_equal Vool::ClassExpression , vool[2].class
      assert_equal :DataObject , vool[1].name
      assert_equal :Data4 , vool[2].name
      assert_equal :Data8 , vool[3].name
    end
    def test_mom
      vool = @compiler.ruby_to_vool source
      vool.to_parfait
      #puts vool
      mom = vool.to_mom(nil)
      assert_equal Mom::MomCollection , mom.class
    end
    def est_risc
      risc = compiler.ruby_to_risc source
      assert_equal Risc::RiscCollection , risc.class
    end
    def est_binary
      risc = compiler.ruby_to_binary source , :interpreter
      assert_equal Risc::Linker , risc.class
    end
  end
end
