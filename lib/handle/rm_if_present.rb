

# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



require_relative './typecheck'

class Plugins
  def self.rm_if_present args

    typecheck args, { file: String }

    # This will currently only delete a regular file.
    if File.file? args['file']
      File.unlink args['file']

    elsif File.exist? args['file']
      raise "the delete target #{args['file'].inspect} exists but is not a file"
    end

  end
end
