# Makefile
#
# copy/backup sd images
#

USER=peter

SD_CARD=/dev/sda
#SD_CARD=/dev/sdc
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
	@echo "make shrink-compress-image\tShrink and Compress downloaded image"
	@echo "make clean\tClean tmp folder"

$(TMPDIR):
	mkdir -p $(TMPDIR)

$(TMPDIR)/sd_card.img:
	sudo dd bs=4M if=$(SD_CARD) status=progress of=$(TMPDIR)/sd_card.img
	sudo chown $(USER) of=$(TMPDIR)/sd_card.img

full-backup:	$(TMPDIR)
	@echo creating full image from SD $(SD_CARD) card
	df -h $(PART1) $(PART2)
	sudo dd bs=4M if=$(SD_CARD) status=progress of=$(TMPDIR)/sd_card.img 
	sudo chown $(USER) $(TMPDIR)/sd_card.img 
	@echo "Backup done"

list-part:	$(TMPDIR)/sd_card.img
	fdisk -lu $(TMPDIR)/sd_card.img
	sudo parted $(SD_CARD) print ;

compress-img:
	xzcat -z -v -k -9 -f $(TMPDIR)/sd_part.img >$(TMPDIR)/sd_part.img.xz

compress-card:
	xzcat -z -v -k -9 -f $(TMPDIR)/sd_card.img >$(TMPDIR)/sd_card.img.xz

shrink-card:
	../PiShrink-master/pishrink.sh -d $(TMPDIR)/sd_card.img $(TMPDIR)/sd_card_small.img

shrink-compress-card:
	rm -f $(TMPDIR)/sd_card_small.xz
	../PiShrink-master/pishrink.sh -d -Z -a $(TMPDIR)/sd_card.img $(TMPDIR)/sd_card_small.xz

clean:
	rm $(TMPDIR)/*
