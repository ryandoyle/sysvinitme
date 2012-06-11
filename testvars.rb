@name="netcat"
@description="Netcat Test Daemon"
@daemon_path="/bin/nc"
@user="ryan"
@static_start_args="-l 12345"
@optional_start_args=""
@daemon_needs_background=true

@start_dep  = ['$network', '$local_fs', '$remote_fs']
@stop_dep = ['$network', '$local_fs', '$remote_fs']

#@should_start_dep = []
#@should_stop_dep = []
