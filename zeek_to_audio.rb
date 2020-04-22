require "tempfile"
require "fileutils"

sample_rate = ARGV.shift.to_i

if sample_rate < 1
  puts "Sample rate cannot be less than 1!"
  exit(1)
end

puts "Loading the conn file"

timestamps = {}
max_value = 0
min_ts = 99999999999
max_ts = 0

ARGF.each_line do |line|
  next if line[0] == '#'
  parts = line.split("\t")
  timestamp = parts[0].to_i

  min_ts = timestamp if timestamp < min_ts
  max_ts = timestamp if timestamp > max_ts

  timestamps[timestamp] ||= 0
  timestamps[timestamp] += 1
  max_value = timestamps[timestamp] if timestamps[timestamp] > max_value
end


puts "Minimum timestamp in your conn.log: #{min_ts}"
puts "Maximum timestamp in your conn.log: #{max_ts}"
puts "Maximum amplitude in your conn.log: #{max_value}"

puts "Generating Audio"
# Our max volume is 1 for audio output. Let's use 0.9 to make sure we don't have any volume issues
volume_step_factor = 0.9 / max_value

num_timestamps = max_ts - min_ts
time_length = (num_timestamps * 1.0) / sample_rate

puts "Output file will be #{time_length} seconds long. Choose a higher sample rate if you want to make the output file shorter"

steps_per_timestamp = 1.0 / sample_rate

file = Tempfile.new("zeektoaudio")
file.puts "; Sample Rate #{sample_rate}"
file.puts "; Channels 1"

min_ts.upto(max_ts) do |x|
  file.puts "\t#{(x - min_ts) * steps_per_timestamp}\t#{(timestamps[x] || 0) * volume_step_factor}"
end
file.close

# Change file to a .dat
File.rename(file.path, file.path + ".dat")

# Create the WAV file using sox
puts "Creating final WAV file (output.wav)"
`sox #{file.path}.dat output.wav`
file.unlink

puts "Done, hopefully your conn.log file is music to your ears!"
puts "If you want to map a timestamp in the audio of your output file to an approximate timestamp in your log file, use the following formula: "
puts "<audio_timestamp_in_seconds> * #{sample_rate} + #{min_ts}"
puts
puts "Hint: to play your file from the command line use `play output.wav`"
