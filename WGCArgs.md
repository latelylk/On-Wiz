I found these strings by dumping the strings of WizardGraphicalClient.exe with [Process Explorer](https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer)

Usage: WizardGraphicalClient.exe [Options]

Options:

-? Display Help\

-L <login server name | IP> <Port> -- This skips patcher (?)

-U <user name> <password> -- Doesn't appear to work. Need to test more

-C <character name | GID>

-Z <zone server name | IP>

-T <Zone Name> - Test Local Zone

-E <Equipment ID> - Equip this item on local player.  Must be used with -T

-R <Zone Name> - Run Zone

-R2 <Zone Name> <user_id> - Run Zone as secondary test player user_id (2..n), connecting to existing -R zoneserver

-D <data root dir>

-S <script name>

-SR <screen resolution> - i.e. 1280x1024

-K <Enable Script Debugger (0|1)>

-HS - Enable Heap Server

-HD - Enable Heap Debugging

-EF_OVERFLOW - Enable overflow detection

-EF_UNDERFLOW - Enable underflow detection

-G <log file>

-P <Patching Enabled (0|1)>

-M <Maintenance Mode (0|1)>

-X <Dump Classes to Filename>

-O <Log all Resource requests>

-A <locale>

-UN <Force Unique Character Names(0|1)>

-ST - Steam Required
