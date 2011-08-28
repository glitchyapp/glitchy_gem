require 'spec_helper'

describe GlitchyGem::Glitch do
  subject { GlitchyGem::Glitch }

  before(:each) do
    GlitchyGem.configure do |config|
      config.environments = ["test"]
    end

    @stub_exception = Exception.new
  end

  it "should contain the exception" do
    subject.new(@stub_exception).exception.should == @stub_exception
  end
end
