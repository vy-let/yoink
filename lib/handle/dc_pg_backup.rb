

# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



require 'open3'
require_relative './typecheck'

class Plugins
  def self.dc_pg_backup args
    typecheck args, {
      container: String,
      user: String,
      database: String,
      output: String
    }

    finished_ok = false

    Open3.popen2( "docker-compose", "exec",
                  "-T",  # because no tty available
                  args['container'],
                  "pg_dump", "-Fc", "-U", args['user'], args['database']

                ) do |pg_in, pg_out, thr|

      pg_out.binmode

      File.open(args['output'], 'w+') do | backup_io |
        backup_io.binmode
        File.copy_stream pg_out, backup_io
      end

      finished_ok = thr.value.success?
    end

    raise "pg_dump exited with nonzero status!" unless finished_ok
  end
end
