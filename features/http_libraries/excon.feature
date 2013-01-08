Feature: Bug, Excon body responses are empty when the webmock adapter is used

  Scenario: Multiple filterings
    Given a file named "fog-using-excon.rb" with:
      """ruby
      require 'vcr'
      require 'fog'

      VCR.configure do |c|
        c.hook_into :webmock # with :excon works fine
        c.cassette_library_dir = 'cassettes'
        c.default_cassette_options = {  :record => :once }
      end
      
      def ec2_interface
        @ec2_interface ||= Fog::Compute.new({
          :provider => 'AWS',
          :aws_access_key_id => ENV['AWS_BLUE_ACCESS_KEY_ID'],
          :aws_secret_access_key => ENV['AWS_BLUE_SECRET_ACCESS_KEY_ID']
        })
      end

      VCR.use_cassette('fog-using-excon') do
        output = ec2_interface.servers.all
        puts output.to_s
      end
      """
    When I run `ruby fog-using-excon.rb`
    # i wish there was a cucumber step with "should not" so i could make it fail
    Then the file "cassettes/fog-using-excon.yml" should contain:
       """
           body: 
             encoding: US-ASCII
             string: ""
       """
