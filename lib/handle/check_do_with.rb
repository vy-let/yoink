

# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



class Plugins
  def self.check_do_with section, idex, args

    unless args['do'].is_a? String
      raise "at '#{section}' unit number #{idex + 1}, missing a 'do' command"
    end

    unless Plugins.respond_to?( args['do'] )
      raise "at '#{section}' unit number #{idex + 1}, command #{args['do'].inspect} not understood"
    end

  end
end
