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

#### Packet Framing
Once you've gotten a packet, it's time to figure out what it does. KINP packets are always framed in the same way. Each packet begins with a 2-byte header "F00D" in little-endian. This is referred to as the *startSignal*. After the *startSignal* comes a 2-byte integer in little-endian referrred to as the *length* which describes the length of the message payload in bytes. Lastly, we get the *payload* sequence, which contains the data for either the control or DML message. Here is a packet I sniffed with Wireshark (shortened as an example):

`0DF0600000000000056f5B00`

To break this down:

The first 2 bytes of this packet are our *startSignal*. `0DF0` is in little endian order, so it would actually be F00D. This tells us we are seeing the start of a KINP message.

The next 2 bytes are the *length*, again in little endian. `6000` becomes `00 60` and we convert that from hexadecimal to decimal to see that the length of the payload is 96 bytes. (Only eight are shown in the excerpt above.)

Everything after that is the *payload* message which has its own structure.

##### Payload Structure
The payload of this packet is `00000000056F5B00` which breaks down as follows:

The first byte `00` denotes *isControl* - Whether this is a control message or a DML message. (A value of 0 denotes DML)

The second byte `00` denotes *opCode* - This is only not 0 when the message is a control message, in which case it indicates the type of control message.

The third and fourth bytes, `00 00`, are *unknown* - having only ever been observed as 0.

Everything following this is data that is interpreted based on whether this is a Control or DML message. With the *isControl* sent as 00, the message is not a control message, so it must be a DML message.

#### DML Messages
DML message are framed similarly to the initial packet. The header consists of a 1 Byte *serviceId* (svcid) which determines which service the message is meant for. Then comes a 1 Byte *messageType* (msgid) which determines which message template from the previously determined service is used. Lastly we get 2 bytes in little-endian representing *length* which indicate the length of the DML message (including this header, which is 4 bytes). Everything after this header will be data for the service:message being called.

The remainder of our (shortened) packet is this: `056F5B00`

The first byte `05` is our *serviceId* - This tells us which service the message is going to. In this case, it's service 5, GAME.

The second byte `6F` is our *messageType* - This tells us which message template from the service is used. In this case, it's GAME message 111, or "MSG_MARK_LOCATION_RESPONSE".

The third and fourth bytes are `5B 00` in little-endian and represent our DML message *length* (including the header bytes). In this case, it's 91 bytes. Everything else in this packet would be data for the GAME message MSG_MARK_LOCATION_RESPONSE. More on serices and their respective messages will be covered later under the "Game Files" section.

#### Control Messages

## Game Files
Everything the client requires to run is stored in the installation directory of the client.
