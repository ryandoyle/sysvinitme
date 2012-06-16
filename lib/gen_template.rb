#!/usr/bin/env ruby
require 'sysvinitme'

@t = SysVInitMe::Template.new

@t.generate(
            :target => :debian,
            :name => 'netcat',
            :description => 'Netcat testing service',
            :daemon_path => '/usr/bin/nc',
            :daemon_needs_background => true,
            :can_reload => false,
            :start_args => '-l 12233'
            )

puts @t.template_data
