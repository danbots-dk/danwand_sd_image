# 
# generate Rasbian SD card with power init
#
RASPBIAN_DIR=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07
RASPBIAN_FILE=2022-04-04-raspios-bullseye-armhf-lite.img.xz
# partition sizes  boot=253M  rootfs=x
BOOT_FS=mnt/boot
ROOT_FS=mnt/rootfs

help:
	@echo "Make an raspberry image including power init files\n\n"
	@echo "Use the following commands:\n"
	@echo "make get-image\tto download new raspbianos image"
	@echo "make mount-image\tto mount the current immage"""""""
	@echo "make copy-files\tto copy power init files to image"
	@echo "make umount\tto unmount image"
	@echo "make list-image\tto display partition information"
	@echo "make list-mount\tto display fs information"
	@echo "make sd-image\tto generate compressed image"
	@echo "make clean\tto clean all temp image files"

# get raspberry image

tmp/raspbian.img.xz:
	wget --progress=bar -P tmp $(RASPBIAN_DIR)/$(RASPBIAN_FILE)
	mv tmp/$(RASPBIAN_FILE) tmp/raspbian.img.xz

# decompress it

tmp/raspbian.img: tmp/raspbian.img.xz
	xz -k -d tmp/raspbian.img.xz


get-image:	tmp/raspbian.img

bstart1=4194304
bstart2=272629760

list-image: tmp/raspbian.img
	fdisk -lu tmp/raspbian.img
	@echo
	parted tmp/raspbian.img u B print
	@echo Part1 start $(bstart1)
	@echo Part2 start $(bstart2)

# mount file image

mount-image:
	#mkdir -p mnt/boot
	mkdir -p mnt/rootfs
	#sudo mount -r -o loop,offset=$(bstart1) tmp/raspbian.img $(BOOT_FS)
	sudo mount -o loop,offset=$(bstart2) tmp/raspbian.img $(ROOT_FS)

mount-boot:
	mkdir -p mnt/boot
	sudo mount -o loop,offset=$(bstart1) tmp/raspbian.img $(BOOT_FS)

umount:
#-sudo umount $(BOOT_FS)
	-sudo umount $(ROOT_FS)
	-sudo umount $(BOOT_FS)
list-mount:
	#df $(BOOT_FS)
	df $(ROOT_FS)

clean: umount
	rm -f tmp/*

# copy image files

copy-files:
	sudo mkdir -p $(ROOT_FS)/usr/local/bin/danwand
	sudo cp ./bin/power_init $(ROOT_FS)/usr/local/bin/danwand
	sudo cp ./systemd/power_init.service $(ROOT_FS)/etc/systemd/system
	sudo ln -s /etc/systemd/system/power_init.service $(ROOT_FS)/etc/systemd/system/multi-user.target.wants/power_init.service

sd-image:	tmp/raspbian.img
	xzcat -z -k -9 -f tmp/raspbian.img >tmp/danwand.img.xz
