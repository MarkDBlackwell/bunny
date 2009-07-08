module Bunny
	class Channel
		attr_accessor :number, :active
		attr_reader :client
		
		def initialize(client, zero = false)
			@client = client
			zero ? @number = 0 : @number = client.channels.size
			@active = false
			client.channels[@number] ||= self
		end
		
		def open
			client.send_frame(Qrack::Protocol09::Channel::Open.new)
      raise Bunny::ProtocolError, "Cannot open channel #{client.channel.number}" unless client.next_method.is_a?(Qrack::Protocol09::Channel::OpenOk)

			@active = true
		end
		
		def close
			client.send_frame(
	      Qrack::Protocol09::Channel::Close.new(:reply_code => 200, :reply_text => 'bye', :method_id => 0, :class_id => 0)
	    )
	    raise Bunny::ProtocolError, "Error closing channel #{client.channel.number}" unless client.next_method.is_a?(Qrack::Protocol09::Channel::CloseOk)
		end
		
		def open?
			active
		end
		
	end
end