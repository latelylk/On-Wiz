# Wizard101 Data Mining
Whatever your goal is, if you have an interest in what happens behind-the-scenes in Wizard101, this is the place to start. While I don't plan on covering every aspect of the game, I will be covering the essentials. Requirements will be posted by section.

## W101 Network Communications
The Wizard101 client requires an active connection to a server to load the game. This section will cover how the client communicates with the server.

More in-depth information about the KingsIsle Networking Protocol (KINP) can be found in the [libki project by Joshsora](https://github.com/Joshsora/libki/wiki/Introduction), without which *many* more hours would have been spent researching.

### What You Need To Know
* [Hex editing](https://en.wikipedia.org/wiki/Hex_editor)
  * Decimal
  * Hexadecimal
  * [Binary](https://en.wikipedia.org/wiki/Finger_binary)
  * Be able to convert between Decimal/Hexadecimal/Binary
* [Endianness](https://en.wikipedia.org/wiki/Endianness)
  * Know about [little vs big endian](https://www.geeksforgeeks.org/little-and-big-endian-mystery/)
* [Wireshark](https://www.wireshark.org/)

### Your Tools
* Hex Editor - [HxD](https://mh-nexus.de/en/hxd/) (Free)
* Packet Analyzer - [Wireshark](https://www.wireshark.org/) (Free)

### Packets
A packet is a message sent between the server and client to communicate. Game packets can be divided into two categories: Control Messages and DML Messages. Capturing these packets is done through Wireshark. To limit the packets you'll have to look through I reccomend setting a capture filter: `(src net 165.193.0.0/16 or dst net 165.193.0.0/16) and greater 61` - This will limit the traffic to what we want.

#### Message Framing
Once you've gotten a packet, it's time to figure out what it does. KINP messages are always framed in the same way. Each message begins with a 2-byte sequence "F00D" in little-endian. This is referred to as the *startSignal*. After the *startSignal* comes a 2-byte integer in little-endian referrred to as the *length* which describes the length of the message payload in bytes. Lastly, we get the *payload* sequence. Here is a packet I sniffed with Wireshark (shortened as an example):

`0DF0600000000000056f`

To break this down:

The first 2 bytes of this packet are our startSignal. `0DF0` is in little endian order, so it would actually be F00D. This tells us we are seeing the start of a KINP message.

The next 2 bytes are the length, again in little endian. `6000` becomes `00 60` and we convert that from hexadecimal to decimal to see that the length of the payload is 96 bytes. (Only six are shown in the excerpt above.

Everything after that is the payload message which has its own structure.

##### Payload Structure
The payload of this packet is `00000000056f` which breaks down as follows:

The first byte `00` denotes isControl - Whether this is a control message or a DML message. (A value of 0 denotes DML)

The second byte `00` denotes opCode - This is only not 0 when the message is a control message, in which case it indicates the type of control message.

The third and fourth bytes are unknown having only ever been observed as 0.

Everything following this is data that is interpreted based on whether this is a Control or DML message.

#### DML Messages
`056f`

#### Control Messages

## Game Files
Everything the client requires to run is stored in the installation directory of the client.
