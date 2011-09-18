require 'spec_helper'

describe GlitchyGem::Glitch do
  before(:each) do
    GlitchyGem.configure do |config|
      config.environments = ["test"]
    end

    @stub_exception = Exception.new
  end

  describe "attribute readers" do
    context "exception" do
      it "should read the exception" do
        glitch = described_class.new(@stub_exception)
        glitch.exception.should == @stub_exception
      end
    end

    context "controller" do
      before(:each) do
        @controller = "some_controller"
      end

      it "should read from options" do
        glitch = described_class.new(@stub_exception, :controller => @controller)
        glitch.controller.should == @controller
      end

      it "should fallback to params" do
        glitch = described_class.new(@stub_exception, :params => { 'controller' => @controller })
        glitch.controller.should == @controller
      end
    end

    context "action" do
      before(:each) do
        @action = "some_action"
      end

      it "should read from options" do
        glitch = described_class.new(@stub_exception, :action => @action)
        glitch.action.should == @action
      end

      it "should fallback to params" do
        glitch = described_class.new(@stub_exception, :params => { 'action' => @action })
        glitch.action.should == @action
      end
    end

    context "url" do
      before(:each) do
        @url = "http://example.org/some_controller"
      end

      it "should read from options" do
        glitch = described_class.new(@stub_exception, :url => @url)
        glitch.url.should == @url
      end

      it "should fallback to the rack request" do
        env = Rack::MockRequest.env_for('/some_controller')
        glitch = described_class.new(@stub_exception, :rack_env => env)
        glitch.url.should == @url
      end
    end

    context "session" do
      before(:each) do
        @session = { "some_key" => "some_value" }
      end

      it "should read from options" do
        glitch = described_class.new(@stub_exception, :session => @session)
        glitch.session.should == @session
      end

      it "should fallback to the rack request" do
        env = Rack::MockRequest.env_for('/', { "rack.session" => @session })
        glitch = described_class.new(@stub_exception, :rack_env => env)
        glitch.session.should == @session
      end
    end

    context "params" do
      before(:each) do
        @params = { "some_key" => "some_value" }
      end

      it "should read from options" do
        glitch = described_class.new(@stub_exception, :params => @params)
        glitch.params.should == @params
      end

      it "should first fallback to action_dispatch on the rack request" do
        env = Rack::MockRequest.env_for('/', { 'action_dispatch.request.parameters' => @params })
        glitch = described_class.new(@stub_exception, :rack_env => env)
        glitch.params.should == @params
      end

      it "should finally fallback to the rack request" do
        env = Rack::MockRequest.env_for('/', { :params => @params })
        glitch = described_class.new(@stub_exception, :rack_env => env)
        glitch.params.should == @params
      end

      it "should filter out fields from the params" do
        GlitchyGem.filter_params = ["password", "password_confirmation"]
        params = {
          "password" => "somepassword",
          "password_confirmation" => "somepassword",
          "controller" => "dashboard"
        }
        filtered_params = {
          "password" => "[FILTERED]",
          "password_confirmation" => "[FILTERED]",
          "controller" => "dashboard"
        }
        glitch = described_class.new(@stub_exception, :params => params)
        glitch.params.should == filtered_params
      end
    end

    context "connection" do
      it "should set up an http connection to glitchyapp.com" do
        glitch = described_class.new(@stub_exception)
        glitch.connection.address.should == "glitchyapp.com"
      end
    end
  end
end
