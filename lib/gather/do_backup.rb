

# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



require 'open3'
require 'fileutils'

class DoBackup
  def self.with(spec, into:, host:, user:, privkey:)

    #
    # Process and validate inputs
    #

    remote_loc = spec['location']
    raise "got a non-string remote location \"#{remote_loc.inspect}\" from the remote" unless remote_loc.is_a?(String)
    raise "got an empty remote location from the remote" unless remote_loc.length > 0

    remote_loc += '/' unless remote_loc.end_with?('/')

    # Aliases are used to separate different backups from the remote
    # party---though if there's only one it might not be useful, so
    # we'll allow an empty alias if unspecified:
    dest_alias = spec['alias'] || ''
    raise "got a non-string alias \"#{dest_alias.inspect}\" from the remote" unless dest_alias.is_a?(String)

    dest = File.join into, spec['alias']

    # A trailing slash is essential for rsync:
    dest += '/' unless dest.end_with?('/')

    excludes = spec['exclude'] || []
    raise "got a non-array of exclusions from the remote" unless excludes.is_a?(Array)



    #
    # Build args to rsync
    #

    args = %w( rsync -azxx --stats --partial --rsync-path=sudo\ rsync )

    if privkey
      args.concat [ '-e', "ssh -i #{privkey}" ]
    end

    excludes.each do | exc |
      args.concat [ '--exclude', exc ]
    end

    args << "#{user}@#{host}:#{remote_loc}"
    args << dest



    #
    # Call rsync
    #

    # Make sure that the destination folder exists
    FileUtils.mkdir_p dest

    $stderr.puts "\n\nGoing to run:"
    $stderr.puts args.join(' ')
    outs, errs, stats = Open3.capture3( *args )

    $stdout.puts outs

    unless stats.success?
      $stderr.puts errs
      raise "rsync exited with a nonzero status"
    end


  end
end
