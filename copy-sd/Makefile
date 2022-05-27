# 
# generate sd images
#

RASPBIAN_DIR=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07
RASPBIAN_FILE=2022-04-04-raspios-bullseye-armhf-lite.img.xz
# partition sizes  boot=253M  rootfs=x
MIN_ROOT_SIZE=2G
BOOT_FS=mnt/boot
ROOT_FS=mnt/rootfs

SD_CARD=/dev/sdb
PART1=$(SD_CARD)1
PART2=$(SD_CARD)2

MOUNTPOINT=/media/peter
SD_ROOT=$(MOUNTPOINT)/rootfs
SD_BOOT=$(MOUNTPOINT)/boot

ENDSECTOR=3940351
COUNT=500
# * 512 = 1744830976
MAX_CARD_SIZE=1800000000

start=8152
start2=532480
bstart1=4194304
bstart2=272629760

make:
	@echo "Make different images\n\n"
	@echo "make extract-image\t extract to imagefile"


# install gparted
# get raspberry image

tmp/raspbian.img.xz:
	wget --progress=bar -P tmp $(RASPBIAN_DIR)/$(RASPBIAN_FILE)
	mv tmp/$(RASPBIAN_FILE) tmp/raspbian.img.xz

get-image:	tmp/raspbian.img.xz

extract-image: tmp/raspbian.img.xz
	xz -k -d tmp/raspbian.img.xz

#

list-image:
	fdisk -lu tmp/raspbian.img
	echo $(start)*256 | bc
	echo $(start1)*256 | bc

	# ls -l tmp/raspbian.img
	# ls -l -s tmp/raspbian.img
	# SIZE = $(shell ls -s tmp/raspbian.img | cut -d ' ' -f1)
	# echo $(SIZE)
	# echo "Size " ${SIZE} "512 blocks" 
	# echo ${PATH}

# mount file image

mount-file:
	mkdir -p mnt/boot
	mkdir -p mnt/rootfs
	#sudo mount -o loop,offset=$(bstart1) tmp/raspbian.img $(BOOT_FS)
	sudo mount -o loop,offset=$(bstart2) tmp/raspbian.img $(ROOT_FS)

umount:
	sudo umount $(BOOT_FS)
	sudo umount $(ROOT_FS)

clean:	umount
	rm tmp/*


#dd bs=4M if=$SD_CARD status=progress | xz > my-raspberry-pi.img.xz
list-sd:
	sudo fdisk -lu $(SD_CARD)
	df $(PART1)
	df $(PART2)

sd2img:
	@echo creating image from SD $(SD_CARD) card
	#df $(PART1)
	df -h $(SD_BOOT) $(SD_ROOT)
	#df $(SD_ROOT)
	sudo dd bs=4M if=$(SD_CARD) status=progress of=tmp/sd_card.img 
	#dd bs=4M if=/dev/sdc status=progress of=danwand.img --size $(MAX_CARD_SIZE)

	#fdisk -lu my-raspberry-pi.img

#((532480*512))
start_root=532480
ROOTFS_START=272629760
ROOTFS_SIZE=15G

new_card=tmp/new_card.img

$(new_card):	tmp/sd_card.img
	@echo "Copy card image"
	cp tmp/sd_card.img $(new_card)

resize:	$(new_card)
# copy danwand data
	@echo "---- resize ----"
	fdisk -lu $(new_card)
	@echo start på rootfs $(start_root)
	@echo Calculated $$((${start_root}*512))
	@echo start $(ROOTFS_START)
	-sudo losetup -d /dev/loop29
	sudo losetup /dev/loop29 $(new_card) -o $(ROOTFS_START)
	df -h /dev/loop29
	sudo e2fsck -v -f /dev/loop29
	sudo resize2fs -p /dev/loop29 $(ROOTFS_SIZE)
	df -h /dev/loop29
	sudo parted $(new_card) resizepart 2 5G
	df -h /dev/loop29

copy_files:
	mkdir -p $(ROOT_FS)/usr/local/bin/danwand
	cp ./bin/power_init $(ROOT_FS)/usr/local/bin/danwand
	cp ./systemd/power_init.service $(ROOT_FS)/etc/systemd/system



danwand-image:	

make-sd-image:	tmp/raspbian.img
	xzcat -z -k -9 -f tmp/raspbian.img >tmp/danwand.img.xz

sdimagefile: danwand.img
	xz -z -k -9 -f danwand.img
