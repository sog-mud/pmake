#
# Makefile for gmake
CC=	gcc
CFLAGS=	-I. -O2 "-D__FBSDID(x)=" -DDEFSHELL=1
LD=	gcc
MKDIR=	mkdir
GZIP=	gzip
INSTALL=install -o root -g bin

#
# uncomment this for Linux (gmake + bsd install)
INSTALL_BIN=	$(INSTALL) -m 755 -s
INSTALL_FILE=	$(INSTALL) -m 644

#
# uncomment this for Solaris (Solaris make + no bsd install)
#INSTALL_BIN=	cp
#INSTALL_FILE=	cp
#.c.o:
#	$(CC) $(CFLAGS) -c -o $(<:.c=.o) $<

TARGET=	pmake
PREFIX=	/usr/local
MANDIR=	$(PREFIX)/man

OBJS=	arch.o buf.o compat.o cond.o dir.o err.o for.o hash.o job.o \
	main.o make.o parse.o str.o suff.o targ.o util.o var.o var_modify.o \
	lst.lib/lstAppend.o lst.lib/lstAtEnd.o lst.lib/lstAtFront.o \
	lst.lib/lstClose.o lst.lib/lstConcat.o lst.lib/lstDatum.o \
	lst.lib/lstDeQueue.o lst.lib/lstDestroy.o lst.lib/lstDupl.o \
	lst.lib/lstEnQueue.o lst.lib/lstFind.o lst.lib/lstFindFrom.o \
	lst.lib/lstFirst.o lst.lib/lstForEach.o lst.lib/lstForEachFrom.o \
	lst.lib/lstInit.o lst.lib/lstInsert.o lst.lib/lstIsAtEnd.o \
	lst.lib/lstIsEmpty.o lst.lib/lstLast.o lst.lib/lstMember.o \
	lst.lib/lstNext.o lst.lib/lstOpen.o lst.lib/lstRemove.o \
	lst.lib/lstReplace.o lst.lib/lstSucc.o

all:	$(TARGET) $(TARGET).1.gz

$(TARGET): $(OBJS)
	$(LD) -o $(TARGET) $(OBJS)

$(TARGET).1.gz: $(TARGET).1
	$(GZIP) -c $(TARGET).1 > $(TARGET).1.gz

clean:
	rm -f $(OBJS) $(TARGET) $(TARGET).1.gz

install_dirs:
	[ -d $(PREFIX)/bin ] || $(MKDIR) -p $(PREFIX)/bin
	[ -d $(PREFIX)/share/mk ] || $(MKDIR) -p $(PREFIX)/share/mk
	[ -d $(MANDIR)/man1 ] || $(MKDIR) -p $(MANDIR)/man1

install: install_dirs $(TARGET) $(TARGET).1.gz
	$(INSTALL_BIN) $(TARGET) $(PREFIX)/bin
	$(INSTALL_FILE) mk/*.mk $(PREFIX)/share/mk
	$(INSTALL_FILE) $(TARGET).1.gz $(MANDIR)/man1
