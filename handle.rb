#!/usr/bin/env ruby


# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



# Always use the UNIX line separator
$/ = "\n"

require 'yaml'
require_relative 'lib/common/deverbosify'
require_relative 'lib/handle/dc_pg_backup'
require_relative 'lib/handle/rm_if_present'
require_relative 'lib/handle/check_do_with'



Common.deverbosify do



  $stdout.sync = true



  begin  # to handle cleanup

    manifest = YAML.parse_file("#{__dir__}/manifest.yaml").to_ruby

    if manifest['prepare']
      manifest['prepare'].each_with_index do | args, idex |

        Plugins.check_do_with 'prepare', idex, args

        pwd = args['in'] || '.'
        Dir.chdir pwd do
          Plugins.send( args['do'], args['with'] )
        end

      end
    end



    # Write the backups section of the manifest back to the calling party

    puts manifest['backups'].to_yaml
    puts '...'



    # Wait for client to signal it's done

    code = $stdin.gets.chomp



    if code == "ok"
    # In the future, we could run success-specific handlers here.
    else
      raise "calling party indicated a transfer failure with code: #{code.inspect}"
    end


    # Could rescue here for error-specific handlers.

  ensure
    if manifest['cleanup']
      manifest['cleanup'].each_with_index do | args, idex |

        Plugins.check_do_with 'cleanup', idex, args

        pwd = args['in'] || '.'
        Dir.chdir pwd do
          Plugins.send( args['do'], args['with'] )
        end

      end
    end
  end



end # deverbosify
