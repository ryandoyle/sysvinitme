require 'erb'

@name = "netcat"
@description="Netcat Test Daemon"
@daemon_path="/bin/nc"
@user="ryan"
@static_start_args="-l 12345"
@optional_start_args=""
@daemon_needs_background=true
@start_dep  = ['$network', '$local_fs', '$remote_fs']
@stop_dep = ['$network', '$local_fs', '$remote_fs']

$render = ERB.new(File.open('../erb/debian-init.erb').read,0,'-').result

describe "creating the Debian init script" do

    it "renders the name in the init info" do
        $render.should match /^# Provides:          netcat/
    end

    it "renders the rquired start dependencies" do
        $render.should match /^# Required-Start:    \$network \$local_fs \$remote_fs/
    end

    it "renders the rquired stop dependencies" do
        $render.should match /^# Required-Stop:     \$network \$local_fs \$remote_fs/
    end

    it "renders the short description" do
        $render.should match /^# Short-Description: Netcat Test Daemon/
    end

    it "sources the optional argument file" do
        $render.should match /source \/etc\/default\/netcat/
    end

    
end 
