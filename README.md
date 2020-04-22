# Zeek Sonification

Sonification is a process in which data is converted to sound. This can be useful to exploit our brain's excellent ability to
detect subtle changes in sound which can be mapped to subtle changes in data.

This simple script takes a Zeek conn.log file and turns it into an audio file that you can listen to. This allows you to 
hear areas in the conn log where there are periodic (frequent) events and otherwise might hear things you normally didn't know.

## Usage
1. Ensure that you have the program `sox` installed (http://sox.sourceforge.net/)
1. Generate a Zeek conn.log file (longer files are much better, as are files with more data in general)
1. Run the application: `ruby zeek_to_audio.rb <sample_rate> <path_to_conn_file>`
1. Play the "output.wav" file that was generated using an audio player of your choice

## About the sample rate
This application works by taking your conn.log file and moving it from a "random sample rate" (zeek only logs things when they 
happen, not when they don't) to a fixed sample rate (one sample per second). From there, we create an audio file that represents
your data, however if we played it at 1hz (one sample per second) it wouldn't sound like anything. We need to play it much much
faster. This is where the sample rate parameter comes in! You can change the sample rate to affect how long the audio output will
be and how easy it is to hear different changes in the data. I recommend starting with a sample rate of 5000-10000 and seeing how it
works for you.

## Interpreting The Output
1. Volume is determined by number of conn log entries at that given time, so louder output means more connections
1. The pitches you hear are determined by your brain's perception of the audio as it comes out of your speakers. The cool part
about this is that any change in pitch can indicate that there was some periodic (frequent) component in the dataset at that time.
This can indicate any number of interesting things!
1. Rhythms are created when frequent components happen at a periodic interval (frequent frequencies, ha!)
