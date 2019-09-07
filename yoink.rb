#!/usr/bin/env ruby


# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



# Always use the UNIX line separator
$/ = "\n"

require 'yaml'
require 'open3'
require_relative 'lib/common/deverbosify'
require_relative 'lib/gather/yaml_load_from_io'
require_relative 'lib/gather/do_backup'



Common.deverbosify do

  config = YAML.load_file("#{__dir__}/config.yaml")

  privkey = config['ssh_privkey']

  raise "no hosts in the config" unless config['hosts']&.any?
  config['hosts'].each_with_index do | hostspec, idex |

    host = hostspec['host']
    user = hostspec['user']
    dest = hostspec['into']

    # This is important for rsync:
    dest += '/' unless dest.end_with?('/')



    # Open the controlling connection
    finished_ok = false
    privkey_args = privkey ? ['-i', privkey] : []
    Open3.popen2("ssh", *privkey_args, "#{user}@#{host}", ".yoink/handle.rb") do | standin, standout, thr |

      # Wait for yaml
      remote_manifest = YAML.load_from_io standout

      # Rsync each location in sequence
      remote_manifest.each do | spec |
        DoBackup.with spec, into: dest, host: host, user: user, privkey: privkey
      end

      # Write status and wait for server to close:
      standin.puts "ok"
      finished_ok = thr.value.success?

    end

  end


end # deverbosify
