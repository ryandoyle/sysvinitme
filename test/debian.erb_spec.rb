require 'erb'
require File.expand_path(File.dirname(__FILE__) + '/../lib/sysvinitme')


describe "creating Debain dummy foreground service" do

    before(:each) do

        @t = SysVInitMe::Template.new
        @t.generate(
            :target => :debian,
            :name => 'netcat',
            :description => 'Netcat Test Daemon',
            :user => 'nobody',
            :daemon_path => '/bin/nc',
            :daemon_needs_background => true,
            :can_reload => false,
            :start_args => '-l 12233',
            :deb_start_dep => ['$network', '$local_fs', '$remote_fs'],
            :deb_stop_dep => ['$network', '$local_fs', '$remote_fs']
        )
        @init = @t.template_data
    end

    it "renders the init info comment section" do
        @init.should match /^# Provides:          netcat/
    end

    it "renders the start dependencies" do
        @init.should match /^# Required-Start:    \$network \$local_fs \$remote_fs/
    end

    it "renders the stop dependencies" do
        @init.should match /^# Required-Stop:     \$network \$local_fs \$remote_fs/
    end

    it "renders the short description" do
        @init.should match /^# Short-Description: Netcat Test Daemon/
    end

    it "sources the optional argument file" do
        @init.should match /source \/etc\/default\/netcat/
    end

    it "starts as the user nobody" do
        @init.should match /--chuid nobody/
    end

    it "runs in the foreground so daemonises it to the background and creates a PID file" do
        @init.should match /--background/
        @init.should match /--make-pidfile/
    end

    it "starts the process with the supplied startup arguments" do
        @init.should match /-l 12233 \$OPTIONAL_START_ARGUMENTS/
    end

    it "doesn't have the capability to reload the service" do
        @init.should match /log_daemon_msg "Reload is not supported"/
        @init.should match /# We can't reload this service so restart it/
    end

end 

describe "creating a Debian dummy background service that can reload" do
    before(:each) do

        @t = SysVInitMe::Template.new
        @t.generate(
            :target => :debian,
            :name => 'netcat',
            :description => 'Netcat Test Daemon',
            :daemon_path => '/bin/nc',
            :daemon_needs_background => false,
            :can_reload => true,
            :deb_start_dep => ['$network', '$local_fs', '$remote_fs'],
            :deb_stop_dep => ['$network', '$local_fs', '$remote_fs']
        )
        @init = @t.template_data
    end

    it "does not specify the user to run as" do 
        @init.should_not match /--chuid nobody/
    end

    it "does not need to be daemonised" do
        @init.should_not match /--background/
        @init.should_not match /--make-pidfile/
    end

    it "can reload the service by sending a SIGHUP" do
        @init.should match /--signal 1/
        @init.should match /# We are able to reload this service/
    end

end
