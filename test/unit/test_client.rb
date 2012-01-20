require 'test_helper'

class TestClient < Test::Unit::TestCase
  context "creating a new client" do
    should "initialize with ApiKey strategy" do
      assert_nothing_raised do
        Bitlyr::Client.new Bitlyr::Strategy::ApiKey.new(login_fixture, api_key_fixture)
      end
    end
    should "initialize with OAuth strategy" do
      assert_nothing_raised do
        Bitlyr::Client.new Bitlyr::Strategy::OAuth.new(client_id_fixture, client_secret_fixture)
      end
    end
    should "raise an exception when bad arguments are used" do
      assert_raise ArgumentError do
        Bitlyr::Client.new("Something Else")
      end
    end
  end
  context "#referring_domains" do
    setup do
      strategy = Bitlyr::Strategy::OAuth.new('id', 'secret')
      strategy.set_access_token_from_token!('token')
      strategy.stubs(:request => { "referring_domains" => [ {'domain' => 'direct', 'clicks' => 700} ] } )
      @client = Bitlyr::Client.new(strategy)
    end
    should "return an array" do
      assert @client.referring_domains('http://bit.ly/somelink/').is_a?(Array)
    end
    should "return an array of referring domains" do
      assert_equal 1, @client.referring_domains('http://bit.ly/somelink/').map(&:class).uniq.size
      assert @client.referring_domains('http://bit.ly/somelink/').first.is_a?(Bitlyr::ReferringDomain)
    end
  end
end
