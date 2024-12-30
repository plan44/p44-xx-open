# P44-XX-OPEN - (Home)Automation controller for SmartLEDs and more

## What is the P44-XX-OPEN?

In short: this P44-XX-OPEN repository collects the resources (mostly as submodules) which allow to build OpenWrt/Linux firmware images configured as a **ready-to-use controller platform for cool, (home) automatable things** with addressable SmartLEDs, motors, sensors, GPIOs and much more.

Note: this github repo also contains ready-to-use [release images](https://github.com/plan44/p44-xx-open/releases/latest).

![P44-mini-LX with Omega2, Omega2+Dock+Ethernet Extension, RaspberryPi B+](readme_assets/omega2%2Braspberry%2Ejpeg)

At [38c3](https://media.ccc.de/c/38c3) I had the opportunity to give a [lightning talk](https://media.ccc.de/v/38c3-lightning-talks-tag-3) (at around 1h30 in the video), here is the slightly updated [final version of the PDF slides](readme_assets/38c3-lightning-talk-slides.pdf) that did not make it into the talk.

## Playing with LEDs is possibly in many other ways. What is special in the P44-XX-OPEN?

Basically, P44-XX-OPEN is the toolbox I found necessary to be able to develop and maintain lighting and automation projects efficiently - while strictly avoiding spreading technical debt that would haunt me more and more with every additional project ;-)

This boils down to:

- **autonomous operation** - everything needed to operate and maintain it is built-in, up to a full featured IDE. Zero dependencies on any external resources, clouds, or worse! All you need is local IP connectivity and a web browser. This way, the decision to update to a newer version of the platform or stay with what is already there remains *yours*, and is not dictated by circumstances. 
- **longterm maintainability** - project specifics (all settings, scripting) are strictly separated from the platform itself, can be saved as a single file of only few KBytes size. The archived settings can be restored on the same or different hardware, on the same or future firmware versions. The built-in JS-like p44script language is precisely tuned for automation, so project logic can be laid down in small, easy to understand scripts, and debugged on-device with the built-in IDE.
- **home automation compatibility** - while there's no need to use that part, the P44-xx is based on a solid device model, featuring all the basic mechanisms like rooms/zones, groups, scenes and triggers (automations) to structure a home installation. It even contains a matter bridge, so any cool LED thingie you are building can become a luminaire in a matter SmartHome with a few clicks.
- **full featured Linux but still efficiently 24/7 suitable, thanks to OpenWrt** - while OpenWrt is a Linux based distribution with a wide selection of tools, as a network router OS it is tailored for 24/7 operation, has focus on secure network tooling, supports factory reset, strictly avoids unnecessary flash writes and has a very small footprint (fits in 16Mbytes of flash - yes, mega, not giga!).

## How did it come to be? And why only now?

The project started as a a bridge to a specific home automation system, and still does when needed, but evolved over time to become a foundation for automations in exhibitions, art and pure fun projects. 

So I spent the last 11 years collecting the experience and bringing together the parts in a way that not only *using* P44-XX-OPEN in many different contexts is efficient, but also *building it from sources* and maintaining *those*, based on original OpenWrt and not a fork.

While the parts have been published as OpenSource all the way (e.g. the main automation engine [vdcd](https://github.com/plan44/vdcd) with all its submodules are GPLv3, as is the matter bridge [p44mbrd](https://github.com/plan44/p44mbrd)), and [free pre-built images for RaspberryPi](https://plan44.ch/automation/p44-lc-x.php) existed for many years already - only recently it reached a form where enough was in a place, [reasonably documented](https://plan44.ch/p44-techdocs/en/) and automated enough to be (hopefully) buildable as a whole with a minimal number of manual steps.

This is what I now call P44-XX-OPEN and can be built and extended from this repo as a starting point.

# <a id="install"></a>Install the pre- or self-built firmware images on a Omega2 or a Raspberry Pi

Note: see [below](#build) for instructions on how to *build* these images yourselves.

## Install on Omega2

If OpenWrt (OnionOS for example) is already running on the device, you can cross-grade to the p44-xx-diy using `sysupgrade`:

- visit [p44-xx-open github releases](https://github.com/plan44/p44-xx-open/releases/latest) to find the version number of the latest release

- log in to your Omega2 and download/install the image

    ```bash
    # get the release (replace vXX in the URL below with actual version number)
    cd /tmp
    wget https://github.com/plan44/p44-xx-open/releases/latest/download/p44-xx-diy-vXX-ramips-mt76x8-sysupgrade.bin
    # when download was successful: cross-upgrade to p44-xx-diy
    sysupgrade -F -n /tmp/p44-xx-diy-*
    ```
        
You can also use the Omega2 bootloader's "web recovery" mechanism on the omega2 dock + ethernet extension or with any other Omega2 setup with Ethernet and a way to pull up GPIO38, e.g. the [p44-mini-lx](https://github.com/plan44/p44-mini-lx)

- download the latest `p44-xx-diy-vXX-ramips-mt76x8-sysupgrade` (vXX = version number) from [github releases](https://github.com/plan44/p44-xx-open/releases/latest)
- connect the dock to your LAN with ethernet
- also connect serial/usb console, hold the reset button on Omega dock at powerup, type 0 at the menu
- bring your computer into the `192.168.8.0/24` subnet (e.g. set it to a fixed IP of 192.168.8.3)
- and then open `http://192.168.8.8` in a browser to upload the image.

## <a id="flash_rpi"></a>Create SD-Card for RaspberryPi

- On your computer download the latest release from [p44-xx-open github releases](https://github.com/plan44/p44-xx-open/releases/latest)
    - For RaspberryPi B/B+: `p44-xx-diy-vXX-bcm27xx-bcm2708-rpi-sysupgrade.img.gz` (vXX = version number) 
    - For RaspberryPi 2,3,4: `p44-xx-diy-vXX-bcm27xx-bcm2709-rpi-2-squashfs-sysupgrade.img.gz` (vXX = version number)

- Unzip the image to get the uncompressed image file
    ```bash
    gzip -f -d -k p44-xx-diy-*.img.gz
    # might complain about "trailing garbage"
    ```

- Flash the `.img` onto a SD card (`dd` from the command line if you know what you are doing, or GUI tools like Etcher).

    Note: some tools (e.g RaspberrPi Imager) might be unhappy (will fail) with images that are not sized an integer multiple of 512 bytes, which is often the case with these OpenWrt images.

# <a id="run"></a>Start using P44-XX-DIY

## Connecting to a P44-XX-DIY device

### Via Ethernet
- The easiest way is to connect the device via Ethernet to a LAN

### Via WiFi
- When the p44-xx-diy does not see a network connection for a while, it enables WiFi in access point mode and provides a WiFi network with SSID `p44-xx-diy`. Connect your computer to that, and you should be able to access the WebUI under [192.168.44.1](http://192.168.44.1).

### Finding the WebUI in the LAN

- The device advertises its Web UI and ssh port via DNS-SD (Zeroconfig/Bonjour/Avahi). So if you have a DNS-SD browsing tool like [Localsites](https://apps.apple.com/us/app/localsites/id1289088707) (macOS, CHF 1.- to me ;-), [Discovery - DNS-SD Browser](https://apps.apple.com/ch/app/discovery-dns-sd-browser/id1381004916) (macOS, free), *Avahi Zeroconf Browser* (Linux), you'll find the device with those.
- On systems with avahi installed (most linux distros), you can also use the command line:
    ```bash
    avahi-browse -t -r _http._tcp
    ```
  Should give output similar to:
  
    ```
    +   eth0 IPv4 plan44.ch P44-XX-DIY #62971029                _http._tcp           local
    ...
    =   eth0 IPv4 plan44.ch P44-XX-DIY #62971029                _http._tcp           local
        hostname = [p44xxdiy62971029.local]
        address = [192.168.59.51]
        port = [80]
        txt = ["path=/index.html"]
    ```

- On Windows, the P44-XX-DIY should be visible in the network environment, as it uses `u2npnd` to advertise itself via UPnP.
- As a fallback when everything else fails, and you have access to your LAN's DHCP server's client list - you'll learn the IP from there.
- And finally, you can use the console (see below) to login and type `ip addr`.

### Logging into the webUI
- The webui has a http auth login, which is set to user and password both `p44lcadmin` by default. **It is strongly recommended to set your own webUI password as one of the first actions!** There is a button in the WebUI for doing that.

### Accessing the somewhat hidden WiFi settings
- Using WiFi instead of long term stable Ethernet is often a bad idea for things meant to run for years or decades, so I strongly recommend wired networking for (home)automation in general. But WiFi is a thing, and most hardware supports it, so there *are* WiFi settings in the P44-XX-DIY, only a bit *hidden*: On the `System` tab of the WebUI, there's a button `Edit network settings...`. Press *and hold* that button to open the WiFi settings instead of the wired (Ethernet) settings.

### Acessing the command line via ssh
- You can ssh into the root account P44-XX-DIY via ssh. By default, there is **no password set, it is strongly recommended to set one as one of the first actions!**. The ssh port is also advertised via DNS-SD, so if your terminal app (e.g. macOS) can browse DNS-SD, you can open ssh connections just by clicking in the list.

### Acessing the console
- if you have access to the console (HDMI screen + USB keyboard on the RaspberryPi, USB/UART connection on the Omega2), you can just press enter to get a root shell. **It is strongly recommended to set a password as one of the first actions!** 

## Some First steps (Suggestions)
- Grab a WS2813 addressable LED strip, connect to 5V power, and connect the DIN data line to GPIO18 (pin10) of the RaspberryPi. On the Omega2, connect DIN to GPIO46 (but you might get flicker without a 3.3V->5V level shifter in between). Then, in the WebUI, go to "Hardware", click "+Device" in the "P44-XX-DIY Smart LED Chains" row, and define your first full color LED device.
- If you have hue lights and a hue bridge in the same LAN as the P44-XX-DIY - why not add the hues as lights? In the "Hardware" tab, just click "Device learn in/out...", then press the button on the hue bridge - and you'll have the hues connected.
- Connect a LED or relay or Rocket launcher to one of the GPIOs, and use the "+Device" button on the "P44-XX-DIY GPIO,I2C,console" row in the "Hardware" tab to make this GPIO a output or input device (complete with debouncing, long-press for dimming etc.)

## More information and documentation

As the P44-XX-OPEN is identical (except no dependencies on plan44 infrastructure: no updater, no reverse proxy) to the [free P44-LC-X images](https://plan44.ch/automation/p44-lc-x.php) or generally the entire [plan44 product palette](https://plan44.ch/automation), the documentation applies to all of these likewise.

Good starting points:

- the [Tutorials](https://plan44.ch/p44-techdocs/en/tutorials/#self-build-of-a-p44-lc-x-or-p44-dsb-x-based-on-raspberrypi) about how to connect and configure SmartLEDs (Note: at the time of writing, these are RaspberryPi only - update tbd. - but the topics covered are mostly independent of the target platform).

- Once you have set-up a WS28xx LED strip or even just a LED connected to a GPIO as a light device, the [manual for P44-LC devices](https://plan44.ch/downloads/P44-LC-DE-manual_e.pdf) applies for how to use light devices.

- If you are interested to integrate your P44-XX based lights and other devices into a matter smarthome, see the [matter beta readme](https://plan44.ch/p44-techdocs/en/matter/beta_readme/).

- The [tech docs](https://plan44.ch/p44-techdocs/) cover all details about the built-in scripting language, the SmartLED graphics subsystem *p44lrgraphics* and much more.

- **There's also a [community forum](https://forum.plan44.ch/t/p44-xx-x-diy-maker) for asking and answering questions.**


# <a id="build"></a>How to build the P44-xx-open firmware images based on OpenWrt

## Preparations

### prerequisites for OpenWrt on Linux (Debian 11, 12)

Install packages [according to OpenWrt Wiki](https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem#debianubuntu):

```bash
sudo apt update
sudo apt install git
sudo apt install quilt
sudo apt install build-essential clang \
flex bison g++ gawk gcc-multilib g++-multilib \
gettext git libncurses-dev \
libssl-dev python3-distutils rsync unzip zlib1g-dev \
file wget quilt \
python2.7-dev
```

### prerequisites for OpenWrt on macOS

1. OpenWrt needs a case sensitive file system, but macOS by default has a case insensitive file system. So OpenWrt needs to be put on a volume with case sensitive file system.

    The APFS file system allows creating extra volumes without partitioning or reserving any space - this is much better than a disk image (*Disk Utility -> Edit -> Add APFS volume...*)

2. XCode needs to be installed (to get the basic build tools)
   - Note that command line tools also need to be installed (`/usr/bin/xcode-select --install`).


3. Some utilities are needed from homebrew
   - install brew [as described here](https://brew.sh)


   ```bash
   #brew tap homebrew/dupes # deprecated
   brew install coreutils findutils gawk gnu-getopt gnu-tar gnu-time grep wget quilt xz
   brew ln gnu-getopt --force

   # needed for p44mbrd (matter) build
   brew install pkg-config
   ```

4. Openwrt (at least 22.x and later) need gnu make >= v4.

   ```bash
   # links as gmake to prevent conflict with macOS make version
   brew install make
   # need to link it, because `./scripts/feeds` calls `make` and expects `gmake`
   mkdir ~/bin
   ln -s /opt/homebrew/bin/gmake ~/bin/make
   ```

### Submodules

This repo acts as an umbrella for the exact build setup, so it contains
openwrt and the p44build utility as submodules.

To get these two basic dependencies:

```bash
git submodule init
git submodule update
```


## Start working with OpenWrt

Go to openwrt submodule, check out correct commit.

**Important Note:** it is essential to actually have a **version tag** commit checked out, because only those have a `feeds.conf.default` with SHAs fixed to the correct feed commits actually compatible with that version of openwrt itself.

```bash
# go to openwrt root
cd openwrt
# that's the version tag used at the time of writing
git checkout v22.03.5
```

### Configure the extra feeds we need

```bash
# from openwrt root
# - do NOT change feeds.conf.default - custom changes belong into feeds.conf!
cp feeds.conf.default feeds.conf
# - plan44.ch public feed
echo "src-git plan44 https://github.com/plan44/plan44-feed.git;p44-xx-open" >>feeds.conf
# - project chip / matter feed for matter SDK build support
echo "src-git matter https://github.com/project-chip/matter-openwrt.git" >>feeds.conf
# - Onion's feed for the Omega2
echo "src-git onion https://github.com/OnionIoT/OpenWRT-Packages.git" >>feeds.conf
# - disable OpenWrt feeds we don't need
sed -r -i -e 's/(src-git.*(luci|routing|telephony).*)/#\1/' feeds.conf

# update all feeds
./scripts/feeds update -a
```

#### Optional: unshallow plan44 feed when you want to work in this repo

OpenWrt clones only a shallow (no history) copy of the feed repository. This saves space, but limits git operations (and crashes tools like GitX). The following steps converts the feed into a regular repository:

```bash
# from openwrt root
pushd feeds/plan44
git fetch --unshallow
popd
```

## Initialize p44b(uild) for P44-xx

### Direct p44b to the information that will control everything

```bash
# from openwrt root
../p44build/p44b init feeds/plan44/p44-xx-diy-config/p44build
```

Note: p44b init creates a softlink to itself called `p44b` in the openwrt root. So we can use just `./p44b` to use it.


### Prepare (patch) the OpenWrt tree

```bash
# from openwrt root
./p44b prepare
```

### Install needed packages from feeds

You can install (= make ready for OpenWrt to potentially build at all) only those packages that were recorded present at last './p44b save' (which are those actually needed, so sufficient for building the image)

```bash
# from openwrt root
./p44b instpkg
```

Or just install everything (a lot):

```bash
# from openwrt root
./scripts/feeds install -a
```

### Some tweaks apparently needed (for now, on macOS)

If python/python3 package is installed, make will try to host-compile it and fail on macOS. As we don't need python at all, just make sure those packages are not installed:

```bash
./scripts/feeds uninstall python
./scripts/feeds uninstall python3
```

## Configure OpenWrt for the target platform

At this time, three target configs/setups are available
- **omega2**: Omega2/MT7688, MIPS architecture
- **raspberrypi-1**: RaspberryPi B,B+/bcm2708, ARM architecture
- **raspberrypi-2**: RaspberryPi 2,3,4/bcm2709, ARM architecture

```bash
# shows all possible targets
./p44b target

# select the target, we use Omega2 here as an example
./p44b target omega2
```

### optionally: Inspect/change config to add extra features

```bash
./p44b build menuconfig
```

## Build Image

```bash
# Note: this calls the p44-open-config package's build script, which basically just calls make
#   but makes sure PATH does not contain spaces (some macOS utils insert those) and also
#   always calls gmake, not make, to get the right version.
./p44b build

# or, if you have multiple CPU cores you want to use (5, here)
# to speed up things, allow parallelizing jobs (here for MBA15-2023, which has 8):
./p44b build -j 5
```

**Note:** when doing this for the first time, it takes a looooong time (hours). This is because initial OpenWrt build involves creating the compiler toolchain, and the complete linux kernel and tools. Subsequent builds will be much faster.

If everything went well, the OpenWrt build process will have produced a firmware image in `bin/targets/ramips/mt76x8` for the Omega2 as selected above - for RaspberryPi it will be `bin/targets/bcm27xx/bcm270` (B,B+) and `bin/targets/bcm27xx/bcm2709` (2,3,4).

## Install built image

### install to a target already running OpenWrt

If you have a target already running OpenWrt, with openssh-sftp-server installed, for example a Omega2 with original firmware `omega2-v0.2.0-b188` or newer, then you can send the just built image to that target using *./p44b send*:

```bash
# insert the IP address or host name of your target
export TARGET_HOST=123.45.67.8
# send the built image to the target to /tmp
# When the target is tight on ram, kill running programs and delete
# unneeded stuff from /tmp first
./p44b send
``` 

Now the image is on the RAM disk (/tmp), and can be installed using standard openwrt `sysupgrade`:

- To login to the device via ssh (just a convenience to start an ssh session):

    ```bash
    # insert the IP address or host name of your target
    export TARGET_HOST=123.45.67.8
    ./p44b login
    ```

- For first flash of a p44-xx-diy over a different kind of openwrt firmware (such as OnionOS), log into the target using ssh or the console:

    ```bash
    # On the target device logged in via console or ssh
    # (-n prevents retaining likely incompatible settings from the current os)
    sysupgrade -n /tmp/p44-xx-diy*
    # upgrade starts and needs some minutes to complete (do not interrupt power!)
    ```

- For upgrading an older version of p44-xx-diy:

    ```bash
    # On the target device logged in via console or ssh
    sysupgrade /tmp/p44-xx-diy*
    # upgrade starts and needs some minutes to complete (do not interrupt power!)
    ```

### flash on ethernet connected Omega2 targets

For deploying P44-xx images to Onion Omega2 based hardware with an Ethernet interface (such as the Onion Dock or Onion Eval Boards, or the open source [P44-mini-lx PCB with WS28xx and DMX outputs, and WS2816 test area](https://github.com/plan44/p44-mini-lx)), you can use the `omega2flash.sh` script included in the p44-xx-open as a submodule. It allows flashing targets without any manual operation except connecting to ethernet.

### install on a SD card (RaspberryPi)

Images built for RaspberryPi B/B+ are called something like:

  `p44-xx-diy-1.8.2.0-r20134-5f15225c1e-bcm27xx-bcm2708-rpi-squashfs-factory.img.gz`

Grab the correct image from `bin/targets/bcm27xx/bcm270` (B,B+) or `bin/targets/bcm27xx/bcm2709` (2,3,4) and then proceed as described [in the image installation instructions above](#flash_rpi).


### Run the P44-XX-DIY

See section "[Start using P44-XX-DIY](#run)" above.

