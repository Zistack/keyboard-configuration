XKBMAPFILES = $(shell find xkb -type f -regex '.*custom.*' | grep -v rules)
XKBRULEFILES = $(shell find xkb -type f -regex '.*evdev.*')
XKBMAPDIR = /usr/share/X11
XKBRULEDIR = /usr/local/share/X11
XKBINSTALL = $(XKBMAPFILES:%=$(XKBMAPDIR)/%) $(XKBRULEFILES:%=$(XKBRULEDIR)/%)
KMAPFILE = custom.kmap
KMAPINSTALLDIR = /usr/local/share/kbd/keymaps
KMAPINSTALL = $(KMAPFILE:%=$(KMAPINSTALLDIR)/%)
XORGCONFIGDIR = /etc/X11/xorg.conf.d

.PHONY : all
all : $(KMAPFILE)

.PHONY : install
install : $(XKBINSTALL) $(KMAPINSTALL)

$(XKBMAPDIR)/% : %
	mkdir -p $(XKBMAPDIR)
	cp $^ $@

$(XKBRULEDIR)/% : %
	mkdir -p $(XKBRULEDIR)
	cp $^ $@

$(KMAPINSTALLDIR)/% : %
	mkdir -p $(KMAPINSTALLDIR)
	cp $^ $@

$(KMAPFILE) : $(KMAPFILE).src
	./compile.sh $^ > $@

.PHONY : setconf
setconf : $(XORGCONFIGDIR)/00-files.conf

.PHONY : unsetconf
unsetconf :
	rm -f $(XORGCONFIGDIR)/00-files.conf

$(XORGCONFIGDIR)/% : %
	cp $< $@

.PHONY : uninstall
uninstall :
	rm -f $(XKBINSTALL) $(KMAPINSTALL)

.PHONY : resetcurrent
resetcurrent :
	xkbcomp $$DISPLAY current.xkb
	./decompose.sh

.PHONY : resettest
resettest :
	$(shell ls -1 xkb/*/current | grep -v rules | sed -e 's~\(.*\)/current~cp \1/current \1/test;~')

.PHONY : loadcurrent
loadcurrent :
	setxkbmap -Ixkb -rules current -layout current -model current -print | xkbcomp -w 10 -Ixkb - $$DISPLAY

.PHONY : loadtest
loadtest :
	setxkbmap -Ixkb -rules test -layout test -model test -print | xkbcomp -w 10 -Ixkb - $$DISPLAY

.PHONY : loadcustom
loadcustom :
	setxkbmap -Ixkb -rules custom -layout custom -model custom -print | xkbcomp -w 10 -Ixkb - $$DISPLAY
