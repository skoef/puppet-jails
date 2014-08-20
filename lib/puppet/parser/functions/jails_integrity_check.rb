
module Puppet::Parser::Functions
  newfunction(:jails_integrity_check, :type => :rvalue, :doc => <<-EOS
Check given arguments on validity for running a jail.
    EOS
  ) do |args|

    # mounting filesystems
    ['allow_mount_devfs', 'allow_mount_nullfs',
     'allow_mount_procfs', 'allow_mount_tmpfs', 'allow_mount_zfs'].each {|afs|
        if self.resource[afs].to_s == 'true'
            raise(ArgumentError, "allow_mount is required when enabling #{afs}") unless self.resource[:allow_mount].to_s == 'true'
            raise(ArgumentError, "enforce_statfs should be less than 2 when enabling #{afs}") unless self.resource[:enforce_statfs].to_s.match(/^[0-9]+$/) and self.resource[:enforce_statfs].to_i < 2
        end
    }

  end
end
