# Wizard101 Data Mining

# Important News

## On November 18, 2020 Kingsisle pushed Karamelle to the live realm in `V_r692052.Wizard_1_440`. Unfortunately for us, this revision marks the introduction of encryption to packets containing messages from the GAME service. The below information is not outdated per se, but it is now behind encryption. Fortunately for us, said encryption is.. weak to say the least. GAME service packets are still readable simply by shifting until you find the F00D startsignal.

Whatever your goal is, if you have an interest in what happens behind-the-scenes in Wizard101, this is the place to start. While I don't plan on covering every aspect of the game, I will be covering the essentials. Requirements will be posted by section.

## W101 Network Communications

The Wizard101 client requires an active connection to a server to load the game. This section will cover how the client communicates with the server.

More in-depth information about the KingsIsle Networking Protocol (KINP) can be found in the [libki project by Joshsora](https://github.com/Joshsora/libki/wiki/Introduction), without which *many* more hours would have been spent researching.

### Login Servers

Live Realm (US) - login.us.wizard101.com

Test Realm (US) - testlogin.us.wizard101.com

### What You Need To Know

* [Hex editing](https://en.wikipedia.org/wiki/Hex_editor)
  * Decimal
  * Hexadecimal
  * [Binary](https://en.wikipedia.org/wiki/Finger_binary)
  * [This is a good video for learning.](https://youtu.be/nA7o5kmH6wg) Bonus: It shows you how to use your computer's calculator to do the conversions.
  * Be able to convert between Decimal/Hexadecimal/Binary
* [Endianness](https://en.wikipedia.org/wiki/Endianness)
  * Know about [little vs big endian](https://www.geeksforgeeks.org/little-and-big-endian-mystery/)
* [Wireshark](https://www.wireshark.org/)
* [Visual Studio](https://visualstudio.microsoft.com/vs/) debugging

### Your Tools

* Hex Editor - [HxD](https://mh-nexus.de/en/hxd/) (Free)
* Packet Analyzer - [Wireshark](https://www.wireshark.org/) (Free)
* A debugger - [Visual Studio](https://visualstudio.microsoft.com/vs/) (Free)

### Packets

A packet is a message sent between the server and client to communicate. Game packets can be divided into two categories: Control Messages and DML Messages. Capturing these packets is done through Wireshark. To limit the packets you'll have to look through I recommend setting a capture filter: 

	(src net 165.193.0.0/16 or dst net 165.193.0.0/16) and greater 61

This will limit the traffic to what we want (Wizard101 communicates from 165.193.X.X addresses & ports in the 12000 range. All data packets will be 61 bytes or larger.) Additional information on client-server packet communication can be gathered by opening the WizardGraphicalClient.exe located in the game's bin folder through the Visual Studio debugger. Additional arguments that can be passed to WizardGraphicalClient.exe can be found in [WGCArgs.md](https://github.com/latelylk/On-Wiz/tree/master/Client/WGCArgs.md).

#### Packet Framing

Once you've gotten a packet, it's time to figure out what it does. KINP packets are always framed in the same way. Each packet begins with a 2-byte header "F00D" in little-endian. This is referred to as the *startSignal*. After the *startSignal* comes a 2-byte integer in little-endian referred to as the *length* which describes the length of the message payload in bytes. Lastly, we get the *payload* sequence, which contains the data for either the control or DML message. Here is a packet I sniffed with Wireshark (shortened as an example):

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

The third and fourth bytes are `5B 00` in little-endian and represent our DML message *length* (including the header bytes). In this case, it's 91 bytes. Everything else in this packet would be data for the GAME message MSG_MARK_LOCATION_RESPONSE. More on services and their respective messages will be covered later under the "Game Files" section.

#### Control Messages

--Will come back here as I learn more

## Game Files

By default the Wizard101 game files are installed to `C:\ProgramData\KingsIsle Entertainment\Wizard101`. Everything the client requires to run is stored in that installation directory.

In the root of the installation directory there are four folders and 5 files. These folders are `Bin`, `Data`, `PatchClient`, and `PatchInfo`. The 5 files are `AppStart.dat`, `Install Log.txt`, `LocalPackagesList.txt`, `Wiz.ico`, and `Wizard101.exe`.

Of the files, the only two of interest are `AppStart.dat` and `LocalPackagesList.txt`. 

`AppStart.dat` is checked by `Wizard101.exe` to determine where to install the new PatchClient. When debugging, I saw mention of a registry key for this, but have not yet looked into the registry keys created by Wizard101. 

`LocalPackagesList.txt` is a list of the data your client has downloaded to the GameData folder. It appears to be mostly Zones.

The directories will each be covered in their own sections.

### What You Need To Know

### Your Tools

### Bin

Binaries for the game are installed here.

`WizardClient.log` - Contains tons of useful information from the client. Useful for seeing what the client is up to.

`WizardGraphicalClient.exe` - The main executable for Wizard101. This can be coupled with the arguments I linked to earlier: [WGCArgs.md](https://github.com/latelylk/On-Wiz/tree/master/Client/WGCArgs.md).

`EmbeddedBrowserConfig.xml` - Not extremely important, but this file contains the links used by the game. If, like me, you hate the browser pop-up that happens after you exit the game, editing this file should disable it. ~~The only problem is this gets rewritten by the PatchClient every time the game is launched. When trying to find if anybody else had already found the arguments for Wizard101, I came across only [this thread.](http://www.wizard101central.com/forums/showthread.php?461393-Alright-I-m-new-and-I-need-help) In it, bypassing the PatchClient is mentioned - I'll update this when I find out how that is done. For now changing this file to only contain the fallback page does nothing, but once the patcher is bypassed this should eliminate the browser pop-up.~~ This thread is interestingly made by a user called Coridex73, who has shown up in many searches for Wizard101 information. They were the only person I could find who was actively developing and selling cheats for the game, but they've since disappeared. Do you know anything about them?

* The -L argument appears to bypass the PatchClient ~~, but further testing needs to be done to confirm~~. It is 100% bypassed because the PatchClient is only called by the launcher, not WizardGraphicalClient.

* [I've created a PowerShell script which replaces this and ~~(probably?)~~ bypasses the PatchClient.](https://github.com/latelylk/On-Wiz/tree/master/Scripts/NoBrowser.ps1) Initial attempt was to erase this file which didn't work. Another URL stored elsewhere? Setting the fallback page to nothing seems to accomplish the goal so leave this for now. ~~Note that the script may need to be changed to have the login server for your region (are they regional?)~~. Servers are indeed regional with EU servers being hosted by [GameForge](https://en.wizard101.gameforge.com/wizard101/en/game) - I do not know if this script will work on the GameForge client.

  * The PowerShell script replaces `EmbeddedBrowserConfig.xml` with this block:

    `<Objects>
       <Class Name="class EmbeddedBrowserConfig">
          <m_sFallbackPage></m_sFallbackPage>	  
       </Class>
    </Objects>`

`PatchConfig.xml` - Just gives some basic info for what the PatchClient is supposed to do once it's done updating. Apparently there is a `SilentMetricsURL` that the game uses at [wizard101.com/static/noop.html](https://www.wizard101.com/static/noop.html). I wonder what data it collects?

### Data

GameData

### PatchClient



## Internal Tools

* Kobol

The first mention of `Kobol` I found was on the [portfolio website](https://kryskozlowski.myportfolio.com/wizard101) of [Krystian Kozlowski](https://www.linkedin.com/in/kryskozlowski), a former sound designer for KingsIsle (2017/18). He lists `Kobol` as an engine used by the studio. It is again mentioned on the [LinkedIn](https://www.linkedin.com/in/meaganquinn) profile of another KI employee, [Meagan Quinn](https://www.freekigames.com/girl-gamers-meagan) and on the [LinkedIn](https://www.linkedin.com/in/nbmayes) profile of former Senior Game Designer for KI, [Nathan Mayes](https://www.dignitymemorial.com/obituaries/austin-tx/nathan-mayes-7944261) (May he rest in peace.) 

`Kobol` is, from what I've found, a proprietary KingsIsle tool for zone management. What extent of power this tool has is unknown.

[This thread](https://www.playerup.com/threads/comissioning-someone-to-retrieve-files-from-company-in-round-rock-tx.4110102/#post-10622529) from the PlayerUp forum describes contacting an employee who spilled some info on `Kobol` as well as a previously unknown 3DS Max plugin called `KI Tools`. If you have any more information regarding these tools or additional tools in the KI vault, please create an issue with a way to contact you.

* KI Tools

No information is known about this tool at this time.

## Registry Keys (?)

## Bans
