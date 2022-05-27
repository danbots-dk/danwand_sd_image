#!/bin/bash
#
# shrink sd card to min partition size
#
SD_CARD=/dev/sdb
PART1=${SD_CARD}1
PART2=${SD_CARD}2
PARTITION_SIZE=4G

echo "Initial partitions sizes for $SD_CARD"
sudo parted $SD_CARD p

#fsck $PART2

df $PART2

#sudo e2fsck -v -f /dev/loop29
echo miminimum size 
sudo resize2fs -P $PART2

echo Chekking fs

sudo umount -A $PART2
sudo e2fsck -fpyv  $PART2

sudo resize2fs -p -M $PART2

# expand to partition

#sudo resize2fs -p $PART2

# mount
#mkdir /tmp/mnt
#sudo mount $PART2

df $PART2

sudo parted $SD_CARD P

#sudo parted $SD_CARD resizepart 2 $PARTITION_SIZE

