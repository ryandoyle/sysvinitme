#!/usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + '/../lib/sysvinitme')

def ask(for_input)
    print for_input
    gets
end

puts "sysvinitme interactive init script generator"
@target         = ask 'What is your target platform? (debian or redhat): '
@name           = ask 'What is the short name of your daemon?: '
@description    = ask 'What is the description for your daemon?: '
@daemon_path    = ask 'What is the full path to your daemon?: '
@start_args     = ask 'What arguments do you start the process with?: '
@daemon_needs_background = ask 'Does your daemon run in the foreground? (y/n): '
@can_reload     = ask 'Does your daemon trap SIGHUPs for reload? (y/n): '

# "Convert" to booleans
@daemon_needs_background = true if @daemon_needs_background.strip.eql? 'y'
@daemon_needs_background = false if @daemon_needs_background.strip.eql? 'n'
@can_reload = true if @can_reload.strip.eql? 'y'
@can_reload = false if @can_reload.strip.eql? 'n'

@t = SysVInitMe::Template.new

@t.generate(
            :target => @target.strip.to_sym,
            :name => @name.strip,
            :description => @description.strip,
            :daemon_path => @daemon_path.strip,
            :daemon_needs_background => @daemon_needs_background,
            :can_reload => @can_reload,
            :start_args => @start_args.strip
            )

puts @t.template_data
