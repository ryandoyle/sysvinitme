require 'erb'

module SysVInitMe
    class Template

        attr_accessor :template_data


        def generate(opts = {})
            # Sanity check arguments
            raise ArgumentError, 'Argument :target is required' if not defined? opts[:target]
            raise ArgumentError, 'Argument :name is required' if not defined? opts[:name] 
            raise ArgumentError, 'Argument :description is required' if not defined? opts[:description] 
            raise ArgumentError, 'Argument :daemon_path is required' if not defined? opts[:daemon_path]
            raise ArgumentError, 'Argument :daemon_needs_background is required' if not defined? opts[:daemon_needs_background]
            raise ArgumentError, 'Argument :can_reload is required' if not defined? opts[:can_reload]
            
            # Must have
            @target                  = opts[:target]
            @name                    = opts[:name]
            @description             = opts[:description]
            @daemon_path             = opts[:daemon_path]
            @daemon_needs_background = opts[:daemon_needs_background]
            @can_reload              = opts[:can_reload]
            # Optional, we evaluate these in the ERB
            @user        = opts[:user] 
            @start_args  = opts[:start_args]

            case @target
                when :debian
                    @deb_start_dep = opts[:deb_start_dep]
                    @deb_start_dep ||= [] # If it's still nil, assign an empty array
                    @deb_stop_dep = opts[:deb_stop_dep]
                    @deb_stop_dep ||= [] 
                when :redhat
                    # TODO: chkconfig levels
                else
                    raise ArgumentError, 'Argument :target must be :debian or :redhat'
            end

            render!

        end

        private 

        def render!
                project_root = File.expand_path(File.dirname(__FILE__) + "/../")
                erb_template = File.open(project_root + "/erb/" + @target.to_s + "-init.erb").read
                @template_data = ERB.new(erb_template,0,'-').result(binding)
        end
    end

end
