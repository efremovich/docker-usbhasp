FROM ubuntu:bionic
LABEL com.example.version="0.6" \
      description="USB HASP emulator daemon"

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ARG DEBIAN_FRONTEND=noninteractive

COPY files/haspd_7.90-eter2ubuntu_amd64.deb files/haspd-modules_7.90-eter2ubuntu_amd64.deb files/libusb-vhci_0.8-2_amd64.deb files/usb-vhci-hcd-dkms_1.15.1_amd64.deb files/usbhasp_0.1-2_amd64.deb /tmp/
COPY keys /etc/usbhaspd/keys

RUN dpkg --add-architecture i386; \
    apt-get update; \
    # ---- Install packages ------------------------------------------------------------
    #apt-cache search linux-headers; \
    #apt-get install -y --no-install-recommends linux-headers-$(uname -r) build-essential automake autoconf libtool libusb-0.1-4:i386 libjansson-dev kmod git; \
    cd /tmp; \
    apt-get install -y ./*.deb; \
    cp /lib/modules/4.15.0-118-generic/updates/dkms/usb-vhci-hcd.ko /lib/modules/$(uname -r); \
    cp /lib/modules/4.15.0-118-generic/updates/dkms/usb-vhci-iocifc.ko /lib/modules/$(uname -r); \
    # ---- Compile and install libusb_vhci ---------------------------------------------
    ldconfig; \
    rm -rf /tmp/*; \
CMD /usr/bin/usbhaspd; tail -f /dev/null
