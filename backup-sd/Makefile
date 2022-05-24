# Makefile
#
# copy/backup sd images
#

USER=peter

SD_CARD=/dev/sdb
PART1=$(SD_CARD)1
PART2=$(SD_CARD)2
MAX_CARD_COUNT=1000 # 4G

TMPDIR=tmp
help: 
	@echo "Backup sd-cards\n"
	@echo "make full-backup\tTake full backup of a sd card"
	@echo "make backup\tBackup the partitions"
	@echo "make list-part\tList partitions at card"
	@echo "make compress-image\tCompress downloaded image"
	@echo "make clean\tClean tmp folder"

$(TMPDIR)/sd_card.img:
	sudo dd bs=4M if=$(SD_CARD) status=progress of=$(TMPDIR)/sd_card.img
	sudo chown $(USER) of=$(TMPDIR)/sd_card.img

full-backup:
	@echo creating full image from SD $(SD_CARD) card
	df -h $(PART1) $(PART2)
	sudo dd bs=4M if=$(SD_CARD) status=progress of=$(TMPDIR)/sd_card.img 
	sudo chown $(USER) $(TMPDIR)/sd_card.img 
	@echo "Backup done"

backup:
	@echo "Copy active part of sd-card"
	SDSIZE=$(shell sudo parted $(SD_CARD) u s print | sed -n -e '/ext4/s/.*s.* \(.*\)s.*s.*/\1/p' ;) ;\
	echo Partition size $$(($$SDSIZE + 1));\
	sudo dd bs=1b if=$(SD_CARD) of=$(TMPDIR)/sd_part.img status=progress count=$$(($$SDSIZE + 1))
	sudo chown $(USER) $(TMPDIR)/sd_part.img 

list-part:	$(TMPDIR)/sd_card.img
	fdisk -lu $(TMPDIR)/sd_card.img
	sudo parted $(SD_CARD) print ;

compress-img:
	xzcat -z -v -k -9 -f $(TMPDIR)/sd_part.img >$(TMPDIR)/sd_part.img.xz

compress-card:
	xzcat -z -v -k -9 -f $(TMPDIR)/sd_card.img >$(TMPDIR)/sd_card.img.xz

clean:
	rm $(TMPDIR)/*
