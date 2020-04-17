# Wizard101 Data Mining
Whatever your goal is, if you have an interest in what happens behind-the-scenes in Wizard101, this is the place to start. While I don't plan on covering every aspect of the game, I will be covering the essentials. Requirements will be posted by section.

## W101 Network Communications
The Wizard101 client requires an active connection to a server to load the game. This section will cover how the client communicates with the server.

More in-depth information about the KingsIsle Networking Protocol can be found in the [libki project by Joshsora](https://github.com/Joshsora/libki/wiki/Introduction), without which *many* more hours would have been spent researching.

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
A packet is a message sent between the server and client to communicate. Game packets can be divided into two categories: Control Messages and DML Messages. Capturing these packets is done through Wireshark. To limit the packets you'll have to look through I reccomend setting a capture filter: `src net 165.193.0.0/16 or dst net 165.193.0.0/16` - This will limit the traffic to what we want.

#### Control Messages

#### DML Messages

#### An Example

## Game Files
Everything the client requires to run is stored in the installation directory of the client.
