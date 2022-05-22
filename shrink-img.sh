#!/bin/bash
#
# shrink sd card to min partition size
#
SD_CARD=/dev/sdb
PART_NUM=2
PART1=${SD_CARD}1
PART2=${SD_CARD}2
#PARTITION_SIZE=4G

echo "Initial partitions sizes for $SD_CARD"
sudo parted $SD_CARD p
#sudo parted $SD_CARD u s p
#df $PART2

echo "Estimated minimum size"
sudo resize2fs -P $PART2

echo "Rezizing file system"
sudo umount -A $PART2
sudo e2fsck -fyv $PART2
RES=$?
if [ $RES -gt 1 ]; then
    echo "Fscheck gik galt $RES"
    exit 1
fi

# scrink to minimum

sudo resize2fs -p -M $PART2
#df $PART2

# get filesystem size
TUNEOUT=`sudo tune2fs -l $PART2 | grep -i "block"`
BLOCK_SIZE=`echo "$TUNEOUT" | sed -n -e '/Block size/s/Blo.* //p'` 
BLOCK_COUNT=`echo "$TUNEOUT" | sed -n -e '/Block count/s/Blo.* //p'`
#echo "Blocksize $BLOCK_SIZE"
#echo "Block count $BLOCK_COUNT"
FS_SIZE=$((BLOCK_SIZE * BLOCK_COUNT))
FS_SEC=$((FS_SIZE / 512))
echo -e "Filesystemsize $FS_SIZE Bytes,  segments $FS_SEC \n"

# Find start of partition

#sudo parted $SD_CARD P
sudo parted $SD_CARD unit s P

# Get the starting offset of the root partition
PART_START=$(sudo parted "$SD_CARD" -ms unit s p | grep "^${PART_NUM}" | cut -f 2 -d: | sed 's/[^0-9]//g')
[ "$PART_START" ] || exit 1

PART_END=$((PART_START + FS_SEC))

echo "Partition start $PART_START End: $PART_END  Size: $FS_SIZE"

sudo parted $SD_CARD u s resizepart 2 $PART_END

