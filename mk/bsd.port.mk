#-*- mode: Fundamental; tab-width: 4; -*-
# ex:ts=4
#
# $FreeBSD: ports/Mk/bsd.port.mk,v 1.327 2000/02/06 16:27:38 asami Exp $
#	$NetBSD: $
#
#	bsd.port.mk - 940820 Jordan K. Hubbard.
#	This file is in the public domain.
#
# Please view me with 4 column tabs!

# There are two different types of "maintainers" in the whole ports
# framework concept.  The maintainer of the bsd.port*.mk files
# is listed below in the ${OPSYS}_MAINTAINER entries (this file
# is used by multiple *BSD flavors).  You should consult him
# if you have any questions/suggestions regarding this file.
#
# DO NOT COMMIT CHANGES TO THIS FILE BY YOURSELF!

FreeBSD_MAINTAINER=	asami@FreeBSD.org

# For each port, the MAINTAINER variable is what you should consult for
# contact information on the person(s) to contact if you have questions/
# suggestions about that specific port.  By default (if no MAINTAINER
# is listed), a port is maintained by the subscribers of the ports@FreeBSD.org
# mailing list, and any correspondece should be directed there.
#
# MAINTAINER	- The e-mail address of the contact person for this port
#				  (default: ports@FreeBSD.org).
#
# These are meta-variables that are automatically set to the system
# you are running on.
# 
# ARCH			- The architecture, as returned by "uname -m".
# OPSYS			- Portability clause.  This is the operating system the
#				  makefile is being used on.  Automatically set to
#				  "FreeBSD," "NetBSD," or "OpenBSD" as appropriate.
# OSREL			- The release version (numeric) of the operating system.
# OSVERSION		- The value of __FreeBSD_version.
# PORTOBJFORMAT	- The object format ("aout" or "elf").
#
# These variables are used to identify your port.
#
# DISTNAME		- Name of port or distribution.
# PKGNAME		- Name of the package file to create if the DISTNAME 
#				  isn't really relevant for the port/package
#				  (default: ${DISTNAME}).
# CATEGORIES	- A list of descriptive categories into which this port falls.
#
# These variable describe how to fetch files required for building the port.
#
# DISTFILES		- Name(s) of archive file(s) containing distribution
#				  (default: ${DISTNAME}${EXTRACT_SUFX}).  Set this to
#				  an empty string if the port doesn't require it.
# EXTRACT_SUFX	- Suffix for archive names (default: .tar.bz2 if USE_BZIP2
#				  is set, .zip if USE_ZIP is set, .tar.gz otherwise).  
#				  You never have to set both DISTFILES and EXTRACT_SUFX.
# MASTER_SITES	- Primary location(s) for distribution files if not found
#				  locally.
# PATCHFILES	- Name(s) of additional files that contain distribution
#				  patches (default: none).  make will look for them at
#				  PATCH_SITES (see below).  They will automatically be
#				  uncompressed before patching if the names end with
#				  ".gz" or ".Z".
# PATCH_SITES	- Primary location(s) for distribution patch files
#				  if not found locally.
# DIST_SUBDIR	- Suffix to ${DISTDIR}.  If set, all ${DISTFILES} 
#				  and ${PATCHFILES} will be put in this subdirectory of
#				  ${DISTDIR} (see below).  Also they will be fetched in
#				  this subdirectory from FreeBSD mirror sites.
# ALLFILES		- All of ${DISTFILES} and ${PATCHFILES}.
# IGNOREFILES	- If some of the ${ALLFILES} are not checksum-able, set
#				  this variable to their names.
# EXTRACT_ONLY	- If defined, a subset of ${DISTFILES} you want to
#			  	  actually extract.
#
# These three variables are typically set in /etc/make.conf to indicate
# the user's preferred location to fetch files from.
#
# MASTER_SITE_BACKUP - Backup location(s) for distribution files and patch
#				  files if not found locally and ${MASTER_SITES}/${PATCH_SITES}
#				  (default:
#				  ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/${DIST_SUBDIR}/)
# MASTER_SITE_OVERRIDE - If set, override the MASTER_SITES setting with this
#				  value.
# MASTER_SITE_FREEBSD - If set, only use ${MASTER_SITE_BACKUP} for
#				  MASTER_SITES.
#
# Set these if your port should not be built under certain circumstances.
# These are string variables; you should set them to the reason why
# they are necessary.
#
# RESTRICTED	- Port is restricted (e.g., contains cryptography, etc.).
# NO_CDROM		- Port may not go on CDROM.
# NO_PACKAGE	- Port should not be packaged but distfiles can be put on
#				  ftp sites and CDROMs.
# BROKEN_ELF	- Port doesn't build on ELF machines.
# BROKEN		- Port is broken.
#
# This variable is a boolean, so you don't need to set it to the reason.
#
# IS_INTERACTIVE - Set this if your port needs to interact with the user
#				  during any step in a package build.  User can then decide
#				  to skip this port by setting ${BATCH}, or compiling only
#				  the interactive ports by setting ${INTERACTIVE}.
#
# Set these if your port only makes sense to certain archetictures.
# They are lists containing names for them (e.g., "alpha i386").
#
# ONLY_FOR_ARCHS - Only build ports if ${ARCH} matches one of these.
# NOT_FOR_ARCHS  - Only build ports if ${ARCH} doesn't match one of these.
#
# Use these if your port uses some of the common software packages.
#
# USE_BZIP2		- Says that the port tarballs use bzip2, not gzip, for
#				  compression.
# USE_ZIP		- Says that the port distfile uses zip, not tar w/[bg]zip
#				  for compression.
# USE_NEWGCC	- Says that the port requirest the latest gcc, either in
#				  the system or installed from a port.
# USE_GMAKE		- Says that the port uses gmake.
# GMAKE			- Set to path of GNU make if not in $PATH (default: gmake).
# USE_AUTOCONF	- Says that the port uses autoconf.  Implies GNU_CONFIGURE.
# AUTOCONF		- Set to path of GNU autoconf if not in $PATH (default:
#				  autoconf).
# USE_LIBTOOL	- Says that the port uses Libtool.  Implies GNU_CONFIGURE.
# LIBTOOL		- Set to path of libtool (default: libtool).
# LIBTOOLFILES	- Files to patch for libtool (defaults: "aclocal.m4" if
#				  USE_AUTOCONF is set, "configure" otherwise).
# LIBTOOLFLAGS	- Additional flags to pass to ltconfig.
# USE_PERL5		- Says that the port uses perl5 for building and running.
# PERL5			- Set to full path of perl5, either in the system or
#				  installed from a port.
# PERL			- Set to full path of perl5, either in the system or
#				  installed from a port, but without the version number.
#				  Use this if you need to replace "#!" lines in scripts.
# PERL_VERSION	- Full version of perl5 (see below for current value).
# PERL_VER		- Short version of perl5 (see below for current value).
# PERL_ARCH		- Directory name of architecture dependent libraries
#				  (value: ${ARCH}-freebsd).
# USE_BISON		- Says that the port uses bison for building.
# USE_IMAKE		- Says that the port uses imake.  Implies USE_X_PREFIX.
# XMKMF			- Set to path of `xmkmf' if not in $PATH (default: xmkmf -a ).
# NO_INSTALL_MANPAGES - For imake ports that don't like the install.man
#						target.
# USE_X_PREFIX	- Says that the port installs in ${X11BASE}.  Implies USE_XLIB.
# USE_XLIB		- Says that the port uses X libraries.
# USE_QT		- Says that the port uses version 1 of the qt toolkit.
# USE_QT2		- Says that the port uses version 2 of the qt toolkit.
#				  Implies USE_NEWGCC.
#
# Dependency checking.  Use these if your port requires another port
# not in the list above.
#
# FETCH_DEPENDS - A list of "path:dir[:target]" tuples of other ports this
#				  package depends in the "fetch" stage.  "path" is the
#				  name of a file if it starts with a slash (/), an
#				  executable otherwise.  make will test for the
#				  existence (if it is a full pathname) or search for
#				  it in your $PATH (if it is an executable) and go
#				  into "dir" to do a "make all install" if it's not
#				  found.  If the third field ("target") exists, it will
#				  be used instead of ${DEPENDS_TARGET}.
# BUILD_DEPENDS - A list of "path:dir[:target]" tuples of other ports this
#				  package depends to build (between the "extract" and
#				  "build" stages, inclusive).  The test done to
#				  determine the existence of the dependency is the
#				  same as FETCH_DEPENDS.  If the third field ("target")
#				  exists, it will be used instead of ${DEPENDS_TARGET}.
# RUN_DEPENDS	- A list of "path:dir[:target]" tuples of other ports this
#				  package depends to run.  The test done to determine
#				  the existence of the dependency is the same as
#				  FETCH_DEPENDS.  This will be checked during the
#				  "install" stage and the name of the dependency will
#				  be put into the package as well.  If the third field
#				  ("target") exists, it will be used instead of
#				  ${DEPENDS_TARGET}.
# LIB_DEPENDS	- A list of "lib:dir[:target]" tuples of other ports this
#				  package depends on.  "lib" is the name of a shared library.
#				  make will use "ldconfig -r" to search for the
#				  library.  Note that lib can not contain regular expressions.
# DEPENDS		- A list of "dir[:target]" tuples of other ports this
#				  package depends on being made first.  Use this only for
#				  things that don't fall into the above four categories.
#				  If the second field ("target") exists, it will be used
#				  instead of ${DEPENDS_TARGET}.
# DEPENDS_TARGET - The default target to execute when a port is calling a
#				  dependency (default: "install").
#
# Various directory definitions and variables to control them.
# You rarely need to redefine any of these except WRKSRC and NO_WRKSUBDIR.
#
# X11BASE		- Where X11 ports install things (default: /usr/X11R6).
# LOCALBASE		- Where non-X11 ports install things (default: /usr/local).
# PREFIX		- Where *this* port installs its files (default: ${X11BASE}
#				  if USE_X_PREFIX is set, otherwise ${LOCALBASE}).
# MASTERDIR		- Where the port finds patches, package files, etc.  Define
#				  this is you have two or more ports that share most of the
#				  files (default: ${.CURDIR}).
# PORTSDIR		- The root of the ports tree.  Defaults:
#					FreeBSD/OpenBSD: /usr/ports
#					NetBSD:          /usr/opt
# DISTDIR 		- Where to get gzip'd, tarballed copies of original sources
#				  (default: ${PORTSDIR}/distfiles).
# PACKAGES		- A top level directory where all packages go (rather than
#				  going locally to each port). (default: ${PORTSDIR}/packages).
# WRKDIRPREFIX	- The place to root the temporary working directory
#				  hierarchy (default: none).
# WRKDIR 		- A temporary working directory that gets *clobbered* on clean
#				  (default: ${WRKDIRPREFIX}${.CURDIR}/work).
# WRKSRC		- A subdirectory of ${WRKDIR} where the distribution actually
#				  unpacks to.  (Default: ${WRKDIR}/${DISTNAME} unless
#				  NO_WRKSUBDIR is set, in which case simply ${WRKDIR}).
# NO_WRKSUBDIR	- Assume port unpacks directly into ${WRKDIR}.
# PATCHDIR 		- A directory containing any additional patches you made
#				  to port this software to FreeBSD (default:
#				  ${MASTERDIR}/patches)
# SCRIPTDIR 	- A directory containing any auxiliary scripts
#				  (default: ${MASTERDIR}/scripts)
# FILESDIR 		- A directory containing any miscellaneous additional files.
#				  (default: ${MASTERDIR}/files)
# PKGDIR 		- A direction containing any package creation files.
#				  (default: ${MASTERDIR}/pkg)
#
# Motif support:
#
# REQUIRES_MOTIF - Set this in your port if it requires Motif.  It will  be
#				  built only if HAVE_MOTIF is set.
# HAVE_MOTIF	- If set, means system has Motif.  Typically set in
#				  /etc/make.conf.
# MOTIF_STATIC	- If set, link libXm statically; otherwise, link it
#				  dynamically.  Typically set in /etc/make.conf.
# MOTIFLIB		- Set automatically to appropriate value depending on
#				  ${MOTIF_STATIC}.  Substitute references to -lXm with 
#				  patches to make your port conform to our standards.
# MOTIF_ONLY	- If set, build Motif ports only.  (Not much use except for
#				  building packages.)
#
# Variables that serve as convenient "aliases" for your *-install targets.
# Use these like: "${INSTALL_PROGRAM} ${WRKSRC}/prog ${PREFIX}/bin".
#
# INSTALL_PROGRAM - A command to install binary executables.
# INSTALL_SCRIPT - A command to install executable scripts.
# INSTALL_DATA	- A command to install sharable data.
# INSTALL_MAN	- A command to install manpages (doesn't compress).
#
# Set the following to specify all manpages that your port installs.
# These manpages will be automatically listed in ${PLIST}.  Depending
# on the setting of NOMANCOMPRESS, the make rules will compress the
# manpages for you.
#
# MAN<sect>		- A list of manpages, categorized by section.  For
#				  example, if your port has "man/man1/foo.1" and
#				  "man/mann/bar.n", set "MAN1=foo.1" and "MANN=bar.n".
#				  The available sections chars are "123456789LN".
# MLINKS		- A list of <target, source> tuples for creating links
#				  for manpages.  For example, "MLINKS= a.1 b.1 c.3 d.3"
#				  will do an "ln -sf a.1 b.1" and "ln -sf c.3 and d.3" in
#				  appropriate directories.  (Use this even if the port
#				  installs its own manpage links so they will show up
#				  correctly in ${PLIST}.)
# MANPREFIX		- The directory prefix for ${MAN<sect>} and ${MLINKS}
#				  (default: ${PREFIX}).
# MAN<sect>PREFIX - If manual pages of some sections install in different
#				  locations than others, use these (default: ${MANPREFIX}).
# MANCOMPRESSED - This variable can take values "yes", "no" or
#				  "maybe".  "yes" means manpages are installed
#				  compressed; "no" means they are not; "maybe" means
#				  it changes depending on the value of
#				  NOMANCOMPRESS.  The default is "yes" if USE_IMAKE
#				  is set and NO_INSTALL_MANPAGES is not set, and
#				  "no" otherwise.
#
# Default targets and their behaviors:
#
# fetch			- Retrieves ${DISTFILES} (and ${PATCHFILES} if defined)
#				  into ${DISTDIR} as necessary.
# fetch-list	- Show list of files that would be retrieved by fetch
# extract		- Unpacks ${DISTFILES} into ${WRKDIR}.
# patch			- Apply any provided patches to the source.
# configure		- Runs either GNU configure, one or more local configure
#				  scripts or nothing, depending on what's available.
# build			- Actually compile the sources.
# install		- Install the results of a build.
# reinstall		- Install the results of a build, ignoring "already installed"
#				  flag.
# deinstall		- Remove the installation.
# package		- Create a package from an _installed_ port.
# describe		- Try to generate a one-line description for each port for
#				  use in INDEX files and the like.
# checkpatch	- Do a "patch -C" instead of a "patch".  Note that it may
#				  give incorrect results if multiple patches deal with
#				  the same file.
# checksum		- Use files/md5 to ensure that your distfiles are valid.
# makesum		- Generate files/md5 (only do this for your own ports!).
#
# Default sequence for "all" is:  fetch checksum extract patch configure build
#
# Please read the comments in the targets section below, you
# should be able to use the pre-* or post-* targets/scripts
# (which are available for every stage except checksum) or
# override the do-* targets to do pretty much anything you want.
#
# NEVER override the "regular" targets unless you want to open
# a major can of worms.
#
# Set these variables if your port doesn't need some of the steps.
# Note that there are no NO_PATCH or NO_CONFIGURE variables becuase
# those steps are empty by default.  NO_EXTRACT is not allowed anymore
# since we need to at least create ${WRKDIR}.  Also, NO_CHECKSUM is a user
# variable and is not to be set in a port's Makefile.  See above for NO_PACKAGE.
#
# NO_BUILD		- Use a dummy (do-nothing) build target.
# NO_INSTALL	- Use a dummy (do-nothing) install target.
#
# Here are some variables used in various stages.
#
# For fetch:
#
# FETCH_CMD		- Full path to ftp/http fetch command if not in $PATH
#				  (default: "/usr/bin/fetch -A").
# FETCH_BEFORE_ARGS -
#				  Arguments to ${FETCH_CMD} before filename (default: none).
# FETCH_AFTER_ARGS -
#				  Arguments to ${FETCH_CMD} following filename (default: none).
# FETCH_ENV		- Environment to pass to ${FETCH_CMD} (default: none).
#
# For extract:
#
# EXTRACT_CMD	- Command for extracting archive (default: "bzip2" if
#				  USE_BZIP2 is set, "unzip" if USE_ZIP is set, "gzip" 
#				  otherwise).
# EXTRACT_BEFORE_ARGS -
#				  Arguments to ${EXTRACT_CMD} before filename
#				  (default: "-dc").
# EXTRACT_AFTER_ARGS -
#				  Arguments to ${EXTRACT_CMD} following filename
#				  (default: "| tar -xf -").
# EXTRACT_PRESERVE_OWNERSHIP -
#				  Normally, when run as "root", the extract stage will
#				  change the owner and group of all files under ${WRKDIR}
#				  to 0:0.  Set this variable if you want to turn off this
#				  feature.
#
# For patch:
#
# EXTRA_PATCHES - Define this variable if you have patches not in
#				  ${PATCHDIR}.  This usually happens when you need to
#				  do some pre-processing before some distribution
#				  patches can be applied.  In that case, fetch them as
#				  extra distfiles, put the processed results in
#				  ${WRKDIR}, then point EXTRA_PATCHES to them.
#
#				  The patches specified by this variable will be
#				  applied after the normal distribution patches but
#				  before those in ${PATCHDIR}.
#
# For configure:
#
# HAS_CONFIGURE	- Says that the port has its own configure script.  The
#				  configure stage will not do anything if this is not set.
# GNU_CONFIGURE	- Set if you are using GNU configure (optional).  Implies
#				  HAS_CONFIGURE.
# CONFIGURE_SCRIPT - Name of configure script (defaults: configure).
# CONFIGURE_TARGET - The name of target to call when GNU_CONFIGURE is
#				  defined (default: ${MACHINE_ARCH}--freebsd${OSREL}).
# CONFIGURE_ARGS - Pass these args to configure if ${HAS_CONFIGURE} is set
#				  (default: "--prefix=${PREFIX} ${CONFIGURE_TARGET}" if
#				  GNU_CONFIGURE is set, empty otherwise).
# CONFIGURE_ENV - Pass these env (shell-like) to configure if
#				  ${HAS_CONFIGURE} is set.
# CONFIGURE_LOG - The name of configure log file (default: config.log).
#				  It will be printed to the screen if configure fails.
#
# For build and install:
#
# MAKE_ENV		- Additional environment vars passed to sub-make in build
#				  and install stages (default: see below).
# MAKE_ARGS		- Any extra arguments to sub-make in build and install
#				  stages (default: none).
#
# For install:
#
# NO_MTREE		- If set, will not invoke mtree from bsd.port.mk from
#				  the "install" target.
# MTREE_FILE	- The name of the mtree file (default: /etc/mtree/BSD.x11.dist
#				  if USE_X_PREFIX is set, /etc/mtree/BSD.local.dist
#				  otherwise.)
# PLIST			- Name of the `packing list' file (default: ${PKGDIR}/PLIST).
#				  Change this to ${WRKDIR}/PLIST or something if you
#				  need to write to it.  (It is not a good idea for a port
#				  to write to any file outside ${WRKDIR} during a normal
#				  build.)
# TMPPLIST		- Name of the `packing list' file after processing
#				  (default: ${WRKDIR}/.PLIST.mktmp).
# PLIST_SUB		- List of "variable=value" pair for substitution in ${PLIST}
# 				  (default: see below).
# 
# Note that the install target will automatically add manpages (see
# above) and also substitute special sequences of characters (delimited
# by "%%") as defined in PLIST_SUB to generate ${TMPPLIST}.  For
# instance, "OSREL=${OSREL}" in PLIST_SUB causes all occurrences of
# "%%OSREL%%" in ${PLIST} to be substituted by the value of OSREL.
# ${TMPPLIST} is generated between the do-install and post-install
# stages.  If you are generating the packing list on-the-fly, make
# sure it's generated by the end of do-install!
#
# For package:
#
# NO_LATEST_LINK - Do not install the "Latest" link for package.  Define this
#				  if this port is a beta version of another stable port
#				  which is also in the tree.
#
# This is used in all stages:
#
# SCRIPTS_ENV	- Additional environment vars passed to scripts in
#                 ${SCRIPTDIR} executed by bsd.port.mk (default: see below).
#
# Finally, variables to change if you want a special behavior.  These
# are for debugging purposes.  Don't set them in your Makefile.
#
# ECHO_MSG		- Used to print all the '===>' style prompts - override this
#				  to turn them off (default: /bin/echo).
# PATCH_DEBUG	- If set, print out more information about the patches as
#				  it attempts to apply them.
# PKG_DBDIR		- Where package installation is recorded (default: /var/db/pkg)
# NO_PKG_REGISTER - Don't register a port install as a package.
# FORCE_PKG_REGISTER - If set, it will overwrite any existing package
#				  registration information in ${PKG_DBDIR}/${PKGNAME}.
# NO_DEPENDS	- Don't verify build of dependencies.
# NO_CHECKSUM	- Don't verify the checksum.  Typically used when
#				  when you noticed the distfile you just fetched has
#				  a different checksum and you intend to verify if
#				  the port still works with it.

# Start of pre-makefile section.
.if !defined(AFTERPORTMK)

.if defined(_PREMKINCLUDED)
.BEGIN:
	@${ECHO} "${PKGNAME}: You cannot include bsd.port[.pre].mk twice"
	@${FALSE}
.endif

_PREMKINCLUDED=	yes

.if exists(/bin/uname)
UNAME=	/bin/uname
.else
UNAME=	/usr/bin/uname
.endif

# Get the architecture
.if !defined(ARCH)
ARCH!=	${UNAME} -m
.endif

# Kludge for pre-3.0 systems
MACHINE_ARCH?=	i386

# Get the operating system type
.if !defined(OPSYS)
OPSYS!=	${UNAME} -s
.endif

# Get the operating system revision
.if !defined(OSREL)
OSREL!=	${UNAME} -r | sed -e 's/[-(].*//'
.endif

# Get __FreeBSD_version
.if !defined(OSVERSION)
.if exists(/sbin/sysctl)
OSVERSION!=	/sbin/sysctl -n kern.osreldate
.elif exists(/usr/sbin/sysctl)
OSVERSION!=	/usr/sbin/sysctl -n kern.osreldate
.else
OSVERSION=	300000
.endif
.endif

.if ${OPSYS} == "SunOS"
NO_MTREE=
.endif

# Get the object format.
.if !defined(PORTOBJFORMAT)
PORTOBJFORMAT!=	test -x /usr/bin/objformat && /usr/bin/objformat || echo aout
.endif

MASTERDIR?=	${.CURDIR}

# If they exist, include Makefile.inc, then architecture/operating
# system specific Makefiles, then local Makefile.local.

.if exists(${MASTERDIR}/../Makefile.inc)
.include "${MASTERDIR}/../Makefile.inc"
.endif

.if exists(${MASTERDIR}/Makefile.${ARCH}-${OPSYS})
.include "${MASTERDIR}/Makefile.${ARCH}-${OPSYS}"
.elif exists(${MASTERDIR}/Makefile.${OPSYS})
.include "${MASTERDIR}/Makefile.${OPSYS}"
.elif exists(${MASTERDIR}/Makefile.${ARCH})
.include "${MASTERDIR}/Makefile.${ARCH}"
.endif

.if exists(${MASTERDIR}/Makefile.local)
.include "${MASTERDIR}/Makefile.local"
.endif

# These need to be absolute since we don't know how deep in the ports
# tree we are and thus can't go relative.  They can, of course, be overridden
# by individual Makefiles or local system make configuration.
.if (${OPSYS} == "NetBSD")
PORTSDIR?=		/usr/opt
.else
PORTSDIR?=		/usr/ports
.endif
LOCALBASE?=		${DESTDIR}/usr/local
X11BASE?=		${DESTDIR}/usr/X11R6
DISTDIR?=		${PORTSDIR}/distfiles
_DISTDIR?=		${DISTDIR}/${DIST_SUBDIR}
.if defined(USE_BZIP2)
EXTRACT_SUFX?=			.tar.bz2
.elif defined(USE_ZIP)
EXTRACT_SUFX?=			.zip
.else
EXTRACT_SUFX?=			.tar.gz
.endif
PACKAGES?=		${PORTSDIR}/packages
TEMPLATES?=		${PORTSDIR}/Templates

.if exists(${MASTERDIR}/patches.${ARCH}-${OPSYS})
PATCHDIR?=		${MASTERDIR}/patches.${ARCH}-${OPSYS}
.elif exists(${MASTERDIR}/patches.${OPSYS})
PATCHDIR?=		${MASTERDIR}/patches.${OPSYS}
.elif exists(${MASTERDIR}/patches.${ARCH})
PATCHDIR?=		${MASTERDIR}/patches.${ARCH}
.else
PATCHDIR?=		${MASTERDIR}/patches
.endif

.if exists(${MASTERDIR}/scripts.${ARCH}-${OPSYS})
SCRIPTDIR?=		${MASTERDIR}/scripts.${ARCH}-${OPSYS}
.elif exists(${MASTERDIR}/scripts.${OPSYS})
SCRIPTDIR?=		${MASTERDIR}/scripts.${OPSYS}
.elif exists(${MASTERDIR}/scripts.${ARCH})
SCRIPTDIR?=		${MASTERDIR}/scripts.${ARCH}
.else
SCRIPTDIR?=		${MASTERDIR}/scripts
.endif

.if exists(${MASTERDIR}/files.${ARCH}-${OPSYS})
FILESDIR?=		${MASTERDIR}/files.${ARCH}-${OPSYS}
.elif exists(${MASTERDIR}/files.${OPSYS})
FILESDIR?=		${MASTERDIR}/files.${OPSYS}
.elif exists(${MASTERDIR}/files.${ARCH})
FILESDIR?=		${MASTERDIR}/files.${ARCH}
.else
FILESDIR?=		${MASTERDIR}/files
.endif

.if exists(${MASTERDIR}/pkg.${ARCH}-${OPSYS})
PKGDIR?=		${MASTERDIR}/pkg.${ARCH}-${OPSYS}
.elif exists(${MASTERDIR}/pkg.${OPSYS})
PKGDIR?=		${MASTERDIR}/pkg.${OPSYS}
.elif exists(${MASTERDIR}/pkg.${ARCH})
PKGDIR?=		${MASTERDIR}/pkg.${ARCH}
.else
PKGDIR?=		${MASTERDIR}/pkg
.endif

.if defined(USE_IMAKE)
USE_X_PREFIX=	yes
.endif
.if defined(USE_X_PREFIX)
USE_XLIB=		yes
.endif
.if defined(USE_X_PREFIX)
PREFIX?=		${X11BASE}
.else
PREFIX?=		${LOCALBASE}
.endif

.if defined(USE_OPENSSL)
.if ${OSVERSION} >= 400014
.if !exists(/usr/lib/libcrypto.a)
	@${ECHO} "This port requires the OpenSSL library, which is part of"
	@${ECHO} "the FreeBSD crypto distribution but not installed on your
	@${ECHO} "machine. Please see Chapter 6.5 in the handbook for"
	@${ECHO} "instructions on how to obtain and install the FreeBSD"
	@${ECHO} "OpenSSL distribution."
	@${FALSE}
.else
.if ${USE_OPENSSL} == RSA
_HASRSA= "`/usr/bin/nm /usr/lib/libcrypto.a | /usr/bin/grep RSA_free`"
.if empty(_HASRSA)
.BEGIN:
	@${ECHO} "This port requires RSA crypto, which is not present in your"
	@${ECHO} "version of OpenSSL. Please see Chapter 6.5 in the handbook"
	@${ECHO} "for a description of the problem and alternative solutions."
	@${FALSE}
.endif
.endif
OPENSSLBASE=	/usr
OPENSSLDIR=		/etc/ssl
# OpenSSL in the base system doesn't include IDEA for patent reasons.
OPENSSL_IDEA=	no
# XXX This is a hack to work around the fact that /etc/make.conf clobbers
#     our CFLAGS. It might not be enough for all future ports.
.if defined(HAS_CONFIGURE)
CFLAGS+=		-DNO_IDEA
.else
OPENSSL_CFLAGS+=-DNO_IDEA
MAKE_ARGS+=		OPENSSL_CFLAGS="${OPENSSL_CFLAGS}"
.endif
.endif
.else
LIB_DEPENDS+=	crypto.1:${PORTSDIR}/security/openssl
OPENSSLBASE?=	${LOCALBASE}
OPENSSLDIR?=	${OPENSSLBASE}/openssl
.endif
.if ${USE_OPENSSL} == RSA && defined(USA_RESIDENT) && ${USA_RESIDENT} == YES
LIB_DEPENDS+=	rsaref.2:${PORTSDIR}/security/rsaref
# We set this so ports can decide whether or not to link against librsaref
# and libRSAglue
OPENSSL_RSAREF=	yes
MAKE_ENV+=		EXTRA_SSL_LIBS="-L${OPENSSLBASE}/lib -L${LOCALBASE}/lib -lRSAglue -lrsaref"
.endif
OPENSSLLIB=		${OPENSSLBASE}/lib
OPENSSLINC=		${OPENSSLBASE}/include
MAKE_ENV+=		OPENSSLLIB=${OPENSSLLIB} OPENSSLINC=${OPENSSLINC} \
				OPENSSLBASE=${OPENSSLBASE} OPENSSLDIR=${OPENSSLDIR}
RESTRICTED=		"Contains cryptography."
.endif

.endif
# End of pre-makefile section.

# Start of post-makefile section.
.if !defined(BEFOREPORTMK)

.if defined(_POSTMKINCLUDED)
.BEGIN:
	@${ECHO} "${PKGNAME}: You cannot include bsd.port[.post].mk twice"
	@${FALSE}
.endif

_POSTMKINCLUDED=	yes

WRKDIR?=		${WRKDIRPREFIX}${.CURDIR}/work
.if defined(NO_WRKSUBDIR)
WRKSRC?=		${WRKDIR}
.else
WRKSRC?=		${WRKDIR}/${DISTNAME}
.endif

PLIST_SUB+=	OSREL=${OSREL}

CONFIGURE_ENV+=	PORTOBJFORMAT=${PORTOBJFORMAT}
SCRIPTS_ENV+=	PORTOBJFORMAT=${PORTOBJFORMAT}
MAKE_ENV+=		PORTOBJFORMAT=${PORTOBJFORMAT}
PLIST_SUB+=		PORTOBJFORMAT=${PORTOBJFORMAT}

.if defined(MANCOMPRESSED)
.if ${MANCOMPRESSED} != yes && ${MANCOMPRESSED} != no && \
	${MANCOMPRESSED} != maybe
.BEGIN:
	@${ECHO} "${PKGNAME}: Value of MANCOMPRESSED (is \"${MANCOMPRESSED}\") can only be \"yes\", \"no\" or \"maybe\"".
	@${FALSE}
.endif
.endif

.if defined(USE_IMAKE) && ${OPSYS} != OpenBSD && !defined(NO_INSTALL_MANPAGES)
MANCOMPRESSED?=	yes
.else
MANCOMPRESSED?=	no
.endif

.if defined(USE_QT)
LIB_DEPENDS+=	qt.2:${PORTSDIR}/x11-toolkits/qt142
.endif

.if defined(USE_QT2)
LIB_DEPENDS+=	qt2.2:${PORTSDIR}/x11-toolkits/qt20
USE_NEWGCC=	yes
.endif

.if defined(USE_BZIP2)
BUILD_DEPENDS+=		bzip2:${PORTSDIR}/archivers/bzip2
.endif
.if defined(USE_ZIP)
BUILD_DEPENDS+=		unzip:${PORTSDIR}/archivers/unzip
.endif
.if defined(USE_GMAKE)
BUILD_DEPENDS+=		gmake:${PORTSDIR}/devel/gmake
.endif
.if defined(USE_AUTOCONF)
GNU_CONFIGURE=	yes
BUILD_DEPENDS+=		autoconf:${PORTSDIR}/devel/autoconf
.endif
.if defined(USE_LIBTOOL)
GNU_CONFIGURE=	yes
BUILD_DEPENDS+=		libtool:${PORTSDIR}/devel/libtool
.if defined(USE_AUTOCONF)
LIBTOOLFILES?=		aclocal.m4
.else
LIBTOOLFILES?=		configure
.endif
LIBTOOLFLAGS?=		--disable-ltlibs
.endif
.if defined(USE_NEWGCC) && ${OSVERSION} < 400012
CC=				gcc295
CXX=			g++295
BUILD_DEPENDS+=	gcc295:${PORTSDIR}/lang/egcs
MAKE_ENV+=		CC=${CC} CXX=${CXX}
.endif

.if defined(REQUIRES_MOTIF)
LIB_DEPENDS+=		Xpm.4:${PORTSDIR}/graphics/xpm
.if defined(PARALLEL_PACKAGE_BUILD)
BUILD_DEPENDS+=		${X11BASE}/lib/libXm.a:${PORTSDIR}/x11-toolkits/Motif-dummy
.endif
.endif

PKG_IGNORE_DEPENDS?=		'(XFree86-3\.3\.6|Motif-2\.1\.10)'

.if defined(USE_BISON)
.if ${OSVERSION} >= 400014
BUILD_DEPENDS+=	bison:${PORTSDIR}/devel/bison
.endif
.endif

.if ${OSVERSION} >= 300000
PERL_VERSION=	5.00503
.else
PERL_VERSION=	5.00502
.endif
PERL_VER=		5.005
PERL_ARCH=		${ARCH}-freebsd
PLIST_SUB+=		PERL_VERSION=${PERL_VERSION} \
				PERL_VER=${PERL_VER} \
				PERL_ARCH=${PERL_ARCH}

.if (exists(/usr/bin/perl5) || exists(/usr/bin/perl${PERL_VERSION})) && ${OSVERSION} >= 300000
# 3.0-current after perl5 import
.if !exists(/usr/bin/perl${PERL_VERSION}) && defined(USE_PERL5)
.BEGIN:
	@${ECHO} "Error: you don't have the right version of perl in /usr/bin."
	@${FALSE}
.endif
PERL5=			/usr/bin/perl${PERL_VERSION}
PERL=			/usr/bin/perl
.else
PERL5=			${LOCALBASE}/bin/perl${PERL_VERSION}
PERL=			${LOCALBASE}/bin/perl
.if defined(USE_PERL5)
BUILD_DEPENDS+=	perl${PERL_VERSION}:${PORTSDIR}/lang/perl5
RUN_DEPENDS+=	perl${PERL_VERSION}:${PORTSDIR}/lang/perl5
.endif
.endif

# Don't try to build XFree86 even if ALWAYS_BUILD_DEPENDS is defined --
# it's just too big....
.if defined(USE_XLIB) && !defined(ALWAYS_BUILD_DEPENDS)
LIB_DEPENDS+=	X11.6:${PORTSDIR}/x11/XFree86
.endif

.if exists(${PORTSDIR}/../Makefile.inc)
.include "${PORTSDIR}/../Makefile.inc"
.endif

# Don't change these!!!  These names are built into the _TARGET_USE macro,
# there is no way to refer to them cleanly from within the macro AFAIK.
EXTRACT_COOKIE?=	${WRKDIR}/.extract_done
CONFIGURE_COOKIE?=	${WRKDIR}/.configure_done
INSTALL_COOKIE?=	${WRKDIR}/.install_done
BUILD_COOKIE?=		${WRKDIR}/.build_done
PATCH_COOKIE?=		${WRKDIR}/.patch_done
PACKAGE_COOKIE?=	${WRKDIR}/.package_done

# How to do nothing.  Override if you, for some strange reason, would rather
# do something.
DO_NADA?=		${TRUE}

# Miscellaneous overridable commands:
GMAKE?=			gmake
AUTOCONF?=		autoconf
LIBTOOL?=		libtool
XMKMF?=			xmkmf -a
.if exists(/sbin/md5)
MD5?=			/sbin/md5
.elif exists(/bin/md5)
MD5?=			/bin/md5
.elif exists(/usr/bin/md5)
MD5?=			/usr/bin/md5
.else
MD5?=			md5
.endif
MD5_FILE=		${FILESDIR}/md5

MAKE_FLAGS?=	-f
MAKEFILE?=		Makefile
MAKE_ENV+=		PREFIX=${PREFIX} LOCALBASE=${LOCALBASE} X11BASE=${X11BASE} MOTIFLIB="${MOTIFLIB}" CFLAGS="${CFLAGS}" LIBDIR="${LIBDIR}"

.if exists(/usr/bin/fetch)
# avoid -A for 2.2 -- it's not ported to that branch
.if ${OSVERSION} < 300000
FETCH_CMD?=		/usr/bin/fetch
.else
FETCH_CMD?=		/usr/bin/fetch -A
.endif
#FETCH_BEFORE_ARGS+=	$${CKSIZE:+-S $$CKSIZE}
.else
FETCH_CMD?=		/usr/bin/ftp
.endif

.if exists(/bin/touch)
TOUCH?=			/bin/touch
.else
TOUCH?=			/usr/bin/touch
.endif
TOUCH_FLAGS?=	-f

.if exists(/usr/local/bin/patch)
PATCH?=			/usr/local/bin/patch
.else
PATCH?=			/usr/bin/patch
.endif
PATCH_STRIP?=	-p0
PATCH_DIST_STRIP?=	-p0
.if defined(PATCH_DEBUG)
PATCH_DEBUG_TMP=	yes
PATCH_ARGS?=	-d ${WRKSRC} -E ${PATCH_STRIP}
PATCH_DIST_ARGS?=	-d ${WRKSRC} -E ${PATCH_DIST_STRIP}
.else
PATCH_DEBUG_TMP=	no
PATCH_ARGS?=	-d ${WRKSRC} --forward --quiet -E ${PATCH_STRIP}
PATCH_DIST_ARGS?=	-d ${WRKSRC} --forward --quiet -E ${PATCH_DIST_STRIP}
.endif
.if defined(BATCH)
PATCH_ARGS+=		--batch
PATCH_DIST_ARGS+=	--batch
.endif

.if defined(PATCH_CHECK_ONLY)
PATCH_ARGS+=	-C
PATCH_DIST_ARGS+=	-C
.endif

.if exists(/usr/local/bin/gtar)
TAR?=	/usr/local/bin/gtar
.elif exists(/bin/tar)
TAR?=	/bin/tar
.else
TAR?=	/usr/bin/tar
.endif

# EXTRACT_SUFX is defined in .pre.mk section
.if defined(USE_ZIP)
EXTRACT_CMD?=			unzip
EXTRACT_BEFORE_ARGS?=	-q
EXTRACT_AFTER_ARGS?=	-d ${WRKDIR}
.else
EXTRACT_BEFORE_ARGS?=	-dc
EXTRACT_AFTER_ARGS?=	| ${TAR} -xf -
.if defined(USE_BZIP2)
EXTRACT_CMD?=			bzip2
.else
EXTRACT_CMD?=			${GZIP_CMD}
.endif
.endif

# Figure out where the local mtree file is
.if !defined(MTREE_FILE)
.if defined(USE_X_PREFIX)
MTREE_FILE=	/etc/mtree/BSD.x11.dist
.else
MTREE_FILE=	/etc/mtree/BSD.local.dist
.endif
.endif
MTREE_CMD?=	/usr/sbin/mtree
MTREE_ARGS?=	-U -f ${MTREE_FILE} -d -e -p

# A few aliases for *-install targets
INSTALL_PROGRAM= \
	${INSTALL} ${COPY} ${STRIP} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
INSTALL_SCRIPT= \
	${INSTALL} ${COPY} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
INSTALL_DATA= \
	${INSTALL} ${COPY} -o ${SHAREOWN} -g ${SHAREGRP} -m ${SHAREMODE}
INSTALL_MAN= \
	${INSTALL} ${COPY} -o ${MANOWN} -g ${MANGRP} -m ${MANMODE}

INSTALL_MACROS=	BSD_INSTALL_PROGRAM="${INSTALL_PROGRAM}" \
			BSD_INSTALL_SCRIPT="${INSTALL_SCRIPT}" \
			BSD_INSTALL_DATA="${INSTALL_DATA}" \
			BSD_INSTALL_MAN="${INSTALL_MAN}"
MAKE_ENV+=	${INSTALL_MACROS}
SCRIPTS_ENV+=	${INSTALL_MACROS}

# The user can override the NO_PACKAGE by specifying this from
# the make command line
.if defined(FORCE_PACKAGE)
.undef NO_PACKAGE
.endif

COMMENT?=	${PKGDIR}/COMMENT
DESCR?=		${PKGDIR}/DESCR
PLIST?=		${PKGDIR}/PLIST
TMPPLIST?=	${WRKDIR}/.PLIST.mktmp
PKGINSTALL?=		${PKGDIR}/INSTALL
PKGDEINSTALL?=		${PKGDIR}/DEINSTALL
PKGREQ?=			${PKGDIR}/REQ
PKGMESSAGE?=		${PKGDIR}/MESSAGE

PKG_CMD?=		/usr/sbin/pkg_create
PKG_DELETE?=	/usr/sbin/pkg_delete
.if !defined(PKG_ARGS)
PKG_ARGS=		-v -c ${COMMENT} -d ${DESCR} -f ${TMPPLIST} -p ${PREFIX} -P "`${MAKE} package-depends | ${GREP} -v -E ${PKG_IGNORE_DEPENDS} | sort -u`" ${EXTRA_PKG_ARGS}
.if exists(${PKGINSTALL})
PKG_ARGS+=		-i ${PKGINSTALL}
.endif
.if exists(${PKGDEINSTALL})
PKG_ARGS+=		-k ${PKGDEINSTALL}
.endif
.if exists(${PKGREQ})
PKG_ARGS+=		-r ${PKGREQ}
.endif
.if exists(${PKGMESSAGE})
PKG_ARGS+=		-D ${PKGMESSAGE}
.endif
.if !defined(NO_MTREE)
PKG_ARGS+=		-m ${MTREE_FILE}
.endif
.endif
.if defined(PKG_NOCOMPRESS)
PKG_SUFX?=		.tar
.else
PKG_SUFX?=		.tgz
.endif
# where pkg_add records its dirty deeds.
PKG_DBDIR?=		/var/db/pkg

# shared/dynamic motif libs
.if defined(HAVE_MOTIF)
.if defined(MOTIF_STATIC)
MOTIFLIB?=	${X11BASE}/lib/libXm.a -L${X11BASE}/lib -lXp
.else
MOTIFLIB?=	-L${X11BASE}/lib -lXm -lXp
.endif
.endif

AWK?=		/usr/bin/awk
.if exists(/bin/basename)
BASENAME?=	/bin/basename
.else
BASENAME?=	/usr/bin/basename
.endif
CAT?=		/bin/cat
.if exists(/usr/bin/chmod)
CHMOD?=		/usr/bin/chmod
.else
CHMOD?=		/bin/chmod
.endif
.if exists(/usr/bin/chown)
CHOWN?=		/usr/bin/chown
.elif exists(/bin/chown)
CHOWN?=		/bin/chown
.else
CHOWN?=		/usr/sbin/chown
.endif
CP?=		/bin/cp
ECHO?=		/bin/echo
.if exists(/usr/bin/expr)
EXPR?=		/usr/bin/expr
.else
EXPR?=		/bin/expr
.endif
.if exists(/bin/false)
FALSE?=		/bin/false
.else
FALSE?=		/usr/bin/false
.endif
.if exists(/bin/grep)
GREP?=		/bin/grep
.elif exists(/usr/xpg4/bin/grep)
GREP?=		/usr/xpg4/bin/grep
.else
GREP?=		/usr/bin/grep
.endif
.if exists(/usr/local/bin/gunzip)
GUNZIP_CMD?=	/usr/local/bin/gunzip -f
.else
GUNZIP_CMD?=	/usr/bin/gunzip -f
.endif
.if (${OPSYS} == "Linux")
GZCAT?=		/usr/bin/gzip -cd
.elif exists(/usr/local/bin/gzcat)
GZCAT?=		/usr/local/bin/gzcat
.else
GZCAT?=		/usr/bin/gzcat
.endif
GZIP?=		-9
.if exists(/usr/local/bin/gzip)
GZIP_CMD?=	/usr/local/bin/gzip -nf ${GZIP}
.else
GZIP_CMD?=	/usr/bin/gzip -nf ${GZIP}
.endif
.if exists(/usr/xpg4/bin/id)
ID?=		/usr/xpg4/bin/id -u
.else
ID?=		/usr/bin/id -u
.endif
LDCONFIG?=	/sbin/ldconfig
LN?=		/bin/ln
MKDIR?=		/bin/mkdir -p
MV?=		/bin/mv
RM?=		/bin/rm
RMDIR?=		/bin/rmdir
.if exists(/bin/sed)
SED?=		/bin/sed
.else
SED?=		/usr/bin/sed
.endif
SETENV?=	/usr/bin/env
.if exists(/usr/local/bin/sh)
SH?=		/usr/local/bin/sh
.else
SH?=		/bin/sh
.endif
TR?=		/usr/bin/tr
.if exists(/bin/true)
TRUE?=		/bin/true
.else
TRUE?=		/usr/bin/true
.endif
.if exists(/usr/local/bin/which)
WHICH?=		/usr/local/bin/which
.else
WHICH?=		/usr/bin/which
.endif

# Used to print all the '===>' style prompts - override this to turn them off.
ECHO_MSG?=		${ECHO}

ALL_TARGET?=		all
INSTALL_TARGET?=	install

# Popular master sites
MASTER_SITE_XCONTRIB+=	\
	ftp://crl.dec.com/pub/X11/contrib/%SUBDIR%/ \
	ftp://uiarchive.uiuc.edu/pub/X11/contrib/%SUBDIR%/ \
	ftp://ftp.duke.edu/pub/X11/contrib/%SUBDIR%/ \
	ftp://ftp.sunet.se/pub/X11/contrib/%SUBDIR%/ \
	ftp://sunsite.sut.ac.jp/pub/archives/X11/contrib/%SUBDIR%/

MASTER_SITE_GNU+=	\
	ftp://ftp.gnu.org/gnu/%SUBDIR%/ \
	ftp://ftp.cdrom.com/pub/gnu/%SUBDIR%/ \
	ftp://ftp.digital.com/pub/GNU/%SUBDIR%/ \
	ftp://ftp.uu.net/archive/systems/gnu/%SUBDIR%/ \
	ftp://ftp.de.uu.net/pub/gnu/%SUBDIR%/ \
	ftp://ftp.ecrc.net/pub/gnu/%SUBDIR%/ \
	ftp://ftp.funet.fi/pub/gnu/prep/%SUBDIR%/ \
	ftp://ftp.leo.org/pub/comp/os/unix/gnu/%SUBDIR%/ \
	ftp://ftp.digex.net/pub/gnu/%SUBDIR%/ \
	ftp://ftp.wustl.edu/systems/gnu/%SUBDIR%/ \
	ftp://ftp.kddlabs.co.jp/pub/gnu/%SUBDIR%/

MASTER_SITE_PERL_CPAN+=	\
	ftp://ftp.digital.com/pub/plan/perl/CPAN/modules/by-module/%SUBDIR%/ \
	ftp://ftp.cdrom.com/pub/perl/CPAN/modules/by-module/%SUBDIR%/

MASTER_SITE_TEX_CTAN+=  \
	ftp://ftp.cdrom.com/pub/tex/ctan/%SUBDIR%/  \
	ftp://wuarchive.wustl.edu/packages/TeX/%SUBDIR%/  \
	ftp://ftp.funet.fi/pub/TeX/CTAN/%SUBDIR%/  \
	ftp://ftp.tex.ac.uk/tex-archive/%SUBDIR%/  \
	ftp://ftp.dante.de/tex-archive/%SUBDIR%/

MASTER_SITE_SUNSITE+=	\
	ftp://metalab.unc.edu/pub/Linux/%SUBDIR%/ \
	ftp://ftp.infomagic.com/pub/mirrors/linux/sunsite/%SUBDIR%/ \
	ftp://ftp.cdrom.com/pub/linux/sunsite/%SUBDIR%/

MASTER_SITE_KDE+=	\
	ftp://ftp.us.kde.org/pub/kde/%SUBDIR%/ \
	ftp://ftp.kde.org/pub/kde/%SUBDIR%/ \
	ftp://ftp.tuniv.szczecin.pl/pub/kde/%SUBDIR%/ \
	ftp://ftp.fu-berlin.de/pub/unix/X11/gui/kde/%SUBDIR%/ \
	ftp://ftp.dataplus.se/pub/linux/kde/%SUBDIR%/

MASTER_SITE_COMP_SOURCES+=	\
	ftp://gatekeeper.dec.com/pub/usenet/comp.sources.%SUBDIR%/ \
	ftp://ftp.uu.net/usenet/comp.sources.%SUBDIR%/ \
	ftp://rtfm.mit.edu/pub/usenet/comp.sources.%SUBDIR%/

MASTER_SITE_GNOME+=	\
	ftp://ftp.gnome.org/pub/GNOME/%SUBDIR%/ \
	ftp://download.sourceforge.net/pub/mirrors/gnome/%SUBDIR%/ \
	ftp://ftp.cybertrails.com/pub/gnome/%SUBDIR%/ \
	ftp://ftp.snoopy.net/pub/mirrors/GNOME/%SUBDIR%/

MASTER_SITE_AFTERSTEP+=	\
	ftp://ftp.afterstep.org/%SUBDIR%/ \
	ftp://ftp.digex.net/pub/X11/window-managers/afterstep/%SUBDIR%/ \
	ftp://ftp.alpha1.net/pub/mirrors/ftp.afterstep.org/%SUBDIR%/ \
	ftp://ftp.math.uni-bonn.de/pub/mirror/ftp.afterstep.org/pub/%SUBDIR%/ \
	ftp://ftp.dti.ad.jp/pub/X/AfterStep/%SUBDIR%/ \
	ftp://casper.yz.yamagata-u.ac.jp/pub/X11/apps/afterstep/%SUBDIR%/

MASTER_SITE_WINDOWMAKER+= \
	ftp://ftp.windowmaker.org/pub/%SUBDIR%/ \
	ftp://ftp.goldweb.com.au/pub/WindowMaker/%SUBDIR%/ \
	ftp://ftp.io.com/pub/%SUBDIR%/ \
	ftp://ftp.ameth.org/pub/mirrors/ftp.windowmaker.org/%SUBDIR%/

MASTER_SITE_PORTS_JP+=	\
	ftp://ports.jp.FreeBSD.org/pub/FreeBSD-jp/ports-jp/LOCAL_PORTS/%SUBDIR%/ \
	ftp://ftp4.jp.FreeBSD.org/pub/FreeBSD-jp/ports-jp/LOCAL_PORTS/%SUBDIR%/ \
	ftp://ftp.ics.es.osaka-u.ac.jp/pub/mirrors/FreeBSD-jp/ports-jp/LOCAL_PORTS/%SUBDIR%/

MASTER_SITE_TCLTK+= \
	ftp://ftp.scriptics.com/pub/tcl/%SUBDIR%/ \
	ftp://mirror.neosoft.com/pub/tcl/mirror/ftp.scriptics.com/%SUBDIR%/ \
	ftp://sunsite.utk.edu/pub/tcl/%SUBDIR%/ \
	ftp://ftp.funet.fi/pub/languages/tcl/tcl/%SUBDIR%/ \
	ftp://ftp.cs.tu-berlin.de/pub/tcl/distrib/%SUBDIR%/ \
	ftp://ftp.srcc.msu.su/mirror/ftp.scriptics.com/pub/tcl/%SUBDIR%/ \
	ftp://ftp.lip6.fr/pub/tcl/distrib/%SUBDIR%/

# Empty declaration to avoid "variable MASTER_SITES recursive" error
MASTER_SITES?=
PATCH_SITES?=

# Substitute subdirectory names
.if defined(MASTER_SITE_SUBDIR)
.for dir in ${MASTER_SITE_SUBDIR}
MASTER_SITES_TMP+=	${MASTER_SITES:S^%SUBDIR%^${dir}^}
.endfor
.else
MASTER_SITES_TMP=	${MASTER_SITES:S^%SUBDIR%/^^}
.endif
MASTER_SITES:=	${MASTER_SITES_TMP}
.if defined(PATCH_SITE_SUBDIR)
.for dir in ${PATCH_SITE_SUBDIR}
PATCH_SITES_TMP+=	${PATCH_SITES:S^%SUBDIR%^${dir}^}
.endfor
.else
PATCH_SITES_TMP=	${PATCH_SITES:S^%SUBDIR%/^^}
.endif
PATCH_SITES:=	${PATCH_SITES_TMP}

# The primary backup site.
MASTER_SITE_BACKUP?=	\
	ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/${DIST_SUBDIR}/
MASTER_SITE_BACKUP:=	${MASTER_SITE_BACKUP:S^\${DIST_SUBDIR}/^^}

# Where to put distfiles that don't have any other master site
MASTER_SITE_LOCAL?= \
	ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/LOCAL_PORTS/

# If the user has MASTER_SITE_FREEBSD set, go to the FreeBSD repository
# for everything, but don't search it twice by appending it to the end.
.if !defined(MASTER_SITE_FREEBSD)
MASTER_SITES+=	${MASTER_SITE_BACKUP}
PATCH_SITES+=	${MASTER_SITE_BACKUP}
.if defined(MASTER_SITE_OVERRIDE)
MASTER_SITES:=	${MASTER_SITE_OVERRIDE} ${MASTER_SITES}
PATCH_SITES:=	${MASTER_SITE_OVERRIDE} ${PATCH_SITES}
.endif
.else
MASTER_SITES:=	${MASTER_SITE_BACKUP} ${MASTER_SITES}
PATCH_SITES:=	${MASTER_SITE_BACKUP} ${PATCH_SITES}
.endif

# Search CDROM first if mounted, symlink instead of copy if
# FETCH_SYMLINK_DISTFILES is set
CD_MOUNTPT?=	/cdrom
.if exists(${CD_MOUNTPT}/ports/distfiles)
MASTER_SITES:=	file:${CD_MOUNTPT}/ports/distfiles/${DIST_SUBDIR}/ ${MASTER_SITES}
PATCH_SITES:=	file:${CD_MOUNTPT}/ports/distfiles/${DIST_SUBDIR}/ ${PATCH_SITES}
.if defined(FETCH_SYMLINK_DISTFILES)
FETCH_BEFORE_ARGS+=	-l
.endif
.endif

# Derived names so that they're easily overridable.
DISTFILES?=		${DISTNAME}${EXTRACT_SUFX}
PKGNAME?=		${DISTNAME}

ALLFILES?=	${DISTFILES} ${PATCHFILES}

.if defined(IGNOREFILES)
.if !defined(CKSUMFILES)
CKSUMFILES!=	\
	for file in ${ALLFILES}; do \
		ignore=0; \
		for tmp in ${IGNOREFILES}; do \
			if [ "$$file" = "$$tmp" ]; then \
				ignore=1; \
			fi; \
		done; \
		if [ "$$ignore" = 0 ]; then \
			echo "$$file"; \
		fi; \
	done
.endif
.else
CKSUMFILES=		${ALLFILES}
.endif

# List of all files, with ${DIST_SUBDIR} in front.  Used for checksum.
.if defined(DIST_SUBDIR)
_CKSUMFILES?=	${CKSUMFILES:S/^/${DIST_SUBDIR}\//}
_IGNOREFILES?=	${IGNOREFILES:S/^/${DIST_SUBDIR}\//}
.else
_CKSUMFILES?=	${CKSUMFILES}
_IGNOREFILES?=	${IGNOREFILES}
.endif

# This is what is actually going to be extracted, and is overridable
#  by user.
EXTRACT_ONLY?=	${DISTFILES}

# Documentation
MAINTAINER?=	ports@FreeBSD.org

.if !target(maintainer)
maintainer:
	@${ECHO} ${MAINTAINER}
.endif

.if !defined(CATEGORIES)
.BEGIN:
	@${ECHO} "${PKGNAME}: CATEGORIES is mandatory."
	@${FALSE}
.else
VALID_CATEGORIES+=	afterstep archivers astro audio benchmarks biology \
	cad chinese comms converters databases deskutils devel \
	editors elisp emulators ftp games german gnome graphics \
	ipv6 irc japanese java kde korean lang \
	mail math mbone misc net news \
	offix palm perl5 plan9 print python russian \
	security shells sysutils \
	tcl76 tcl80 tcl81 tcl82 tcl83 textproc \
	tk42 tk80 tk82 tk83 tkstep80 \
	vietnamese windowmaker www \
	x11 x11-clocks x11-fm x11-fonts x11-servers x11-toolkits x11-wm
check-categories:
.for cat in ${CATEGORIES}
	@if ${ECHO} ${VALID_CATEGORIES} | ${GREP} -wq ${cat}; then \
		${TRUE}; \
	else \
		${ECHO} "${PKGNAME}: category ${cat} not in list of valid categories."; \
		${FALSE}; \
	fi
.endfor
.endif

PKGREPOSITORYSUBDIR?=	All
PKGREPOSITORY?=		${PACKAGES}/${PKGREPOSITORYSUBDIR}
.if exists(${PACKAGES})
PKGFILE?=		${PKGREPOSITORY}/${PKGNAME}${PKG_SUFX}
.else
PKGFILE?=		${.CURDIR}/${PKGNAME}${PKG_SUFX}
.endif

# The "latest version" link -- ${PKGNAME} minus everthing after the last '-'
PKGLATESTREPOSITORY?=	${PACKAGES}/Latest
.if !defined(PKGBASE)
PKGBASE!=	${ECHO} ${PKGNAME} | ${SED} -e 's/-[^-]*$$//'
.endif
PKGLATESTFILE?=		${PKGLATESTREPOSITORY}/${PKGBASE}${PKG_SUFX}

CONFIGURE_SCRIPT?=	configure
.if (${OPSYS} == "FreeBSD")
CONFIGURE_TARGET?=	${MACHINE_ARCH}--freebsd${OSREL}
.endif
CONFIGURE_LOG?=		config.log

.if defined(GNU_CONFIGURE)
CONFIGURE_ARGS+=	--prefix=${PREFIX} ${CONFIGURE_TARGET}
HAS_CONFIGURE=		yes
.endif

# Passed to most of script invocations
SCRIPTS_ENV+=	CURDIR=${MASTERDIR} DISTDIR=${DISTDIR} \
		  WRKDIR=${WRKDIR} WRKSRC=${WRKSRC} PATCHDIR=${PATCHDIR} \
		  SCRIPTDIR=${SCRIPTDIR} FILESDIR=${FILESDIR} \
		  PORTSDIR=${PORTSDIR} DEPENDS="${DEPENDS}" \
		  PREFIX=${PREFIX} LOCALBASE=${LOCALBASE} X11BASE=${X11BASE}

.if defined(BATCH)
SCRIPTS_ENV+=	BATCH=yes
.endif

MANPREFIX?=	${PREFIX}

.for sect in 1 2 3 4 5 6 7 8 9
MAN${sect}PREFIX?=	${MANPREFIX}
.endfor
MANLPREFIX?=	${MANPREFIX}
MANNPREFIX?=	${MANPREFIX}

MANLANG?=	""	# english only by default

.if !defined(NOMANCOMPRESS)
MANEXT=	.gz
.endif

.if (defined(MLINKS) || defined(_MLINKS_PREPEND)) && !defined(_MLINKS)
__pmlinks!=	${ECHO} '${MLINKS:S/	/ /}' | ${AWK} \
 '{ if (NF % 2 != 0) { print "broken"; exit; } \
	for (i=1; i<=NF; i++) { \
		if ($$i ~ /^-$$/ && i != 1 && i % 2 != 0) \
			{ $$i = $$(i-2); printf " " $$i " "; } \
		else if ($$i ~ /^[^ ]+\.[1-9ln][^. ]*$$/ || $$i ~ /^\//) \
			printf " " $$i " "; \
		else \
			{ print "broken"; exit; } \
	} \
  }' | ${SED} -e 's \([^/ ][^ ]*\.\(.\)[^. ]*\) $${MAN\2PREFIX}/man/$$$$$$$${__lang}/man\2/\1.gzg' -e 's/ //g' -e 's/MANlPREFIX/MANLPREFIX/g' -e 's/MANnPREFIX/MANNPREFIX/g'
.if ${__pmlinks:Mbroken} == "broken"
.BEGIN:
	@${ECHO} "${PKGNAME}: Unable to parse MLINKS."
	@${FALSE}
.endif
_MLINKS=	${_MLINKS_PREPEND}
.for lang in ${MANLANG}
.for ___pmlinks in ${__pmlinks}
.for __lang in ${lang}
_MLINKS+=	${___pmlinks:S// /g}
.endfor
.endfor
.endfor
.endif

.for lang in ${MANLANG}

.for sect in 1 2 3 4 5 6 7 8 9
.if defined(MAN${sect})
_MANPAGES+=	${MAN${sect}:S%^%${MAN${sect}PREFIX}/man/${lang}/man${sect}/%}
.endif
.endfor

.if defined(MANL)
_MANPAGES+=	${MANL:S%^%${MANLPREFIX}/man/${lang}/manl/%}
.endif

.if defined(MANN)
_MANPAGES+=	${MANN:S%^%${MANNPREFIX}/man/${lang}/mann/%}
.endif

.endfor

.if defined(_MLINKS) && make(generate-plist)
_TMLINKS!=	${ECHO} ${_MLINKS} | ${AWK} '{for (i=2; i<=NF; i+=2) print $$i}'
.else
_TMLINKS=
.endif

.if defined(_MANPAGES) && defined(NOMANCOMPRESS)
__MANPAGES:=	${_MANPAGES:S^${PREFIX}/^^:S/""//:S^//^/^g}
.elif defined(_MANPAGES)
__MANPAGES:=	${_MANPAGES:S^${PREFIX}/^^:S/""//:S^//^/^g:S/$/.gz/}
.endif

.if defined(_MANPAGES) && ${MANCOMPRESSED} == "yes"
_MANPAGES:=	${_MANPAGES:S/$/.gz/}
.endif

.MAIN: all

################################################################
# Many ways to disable a port.
#
# If we're in BATCH mode and the port is interactive, or we're
# in interactive mode and the port is non-interactive, skip all
# the important targets.  The reason we have two modes is that
# one might want to leave a build in BATCH mode running
# overnight, then come back in the morning and do _only_ the
# interactive ones that required your intervention.
#
# Don't attempt to build ports that require Motif if you don't
# have Motif.
#
# Ignore ports that can't be resold if building for a CDROM.
#
# Don't build a port if it's restricted and we don't want to get
# into that.
#
# Don't build a port on an ELF machine if it's broken for ELF.
#
# Don't build a port if it's broken, unless we're running a parallel
# build (in case it's fixed).
#
# Don't build a port if it's forbidden for whatever reason.
#
# Don't build a port if the system is too old.
################################################################

.if ${OSVERSION} >= 300000
# You need an upgrade kit or make world newer than this
BSDPORTMKVERSION=	19990501
.if exists(/var/db/port.mkversion)
VERSIONFILE=	/var/db/port.mkversion
.else
VERSIONFILE=	${PKG_DBDIR}/.mkversion
.endif
.if exists(${VERSIONFILE})
.if !defined(SYSTEMVERSION)
SYSTEMVERSION!=	cat ${VERSIONFILE}
.endif
.else
SYSTEMVERSION=	19990501
.endif
.if ${BSDPORTMKVERSION} > ${SYSTEMVERSION}
IGNORE=	": Your system is too old to use this bsd.port.mk.  You need a fresh make world or an upgrade kit.  Please go to http://www.FreeBSD.org/ports/ or a mirror site and follow the instructions"
.endif
.endif

.if defined(ONLY_FOR_ARCHS)
.for __ARCH in ${ONLY_FOR_ARCHS}
.if ${MACHINE_ARCH:M${__ARCH}} != ""
__ARCH_OK?=     1
.endif
.endfor
.else
__ARCH_OK?=     1
.endif

.if defined(NOT_FOR_ARCHS)
.for __NARCH in ${NOT_FOR_ARCHS}
.if ${MACHINE_ARCH:M${__NARCH}} != ""
.undef __ARCH_OK
.endif
.endfor
.endif

.if !defined(__ARCH_OK)
.if defined(ONLY_FOR_ARCHS)
IGNORE=		"is only for ${ONLY_FOR_ARCHS},"
.else # defined(NOT_FOR_ARCHS)
IGNORE=		"does not run on ${NOT_FOR_ARCHS},"
.endif
IGNORE+=	"and you are running ${ARCH}"
.endif

.if !defined(NO_IGNORE)
.if (defined(IS_INTERACTIVE) && defined(BATCH))
IGNORE=	"is an interactive port"
.elif (!defined(IS_INTERACTIVE) && defined(INTERACTIVE))
IGNORE=	"is not an interactive port"
.elif (defined(REQUIRES_MOTIF) && !defined(HAVE_MOTIF))
IGNORE=	"requires Motif.  LessTif is an LGPL implementation of the Motif API.  A port is available in ports/x11-toolkits/lesstif.  Please see /etc/make.conf"
.elif (defined(MOTIF_ONLY) && !defined(REQUIRES_MOTIF))
IGNORE=	"does not require Motif"
.elif (defined(NO_CDROM) && defined(FOR_CDROM))
IGNORE=	"may not be placed on a CDROM: ${NO_CDROM}"
.elif (defined(RESTRICTED) && defined(NO_RESTRICTED))
IGNORE=	"is restricted: ${RESTRICTED}"
.elif defined(NO_WRKDIR)
IGNORE=	"defines NO_WRKDIR, which is obsoleted.  If you are defining NO_WRKDIR and NO_EXTRACT, try changing it to NO_WRKSUBDIR=yes and EXTRACT_ONLY= \(the right side intentionally left empty\)"
.elif defined(NO_EXTRACT)
IGNORE=	"defines NO_EXTRACT, which is obsoleted.  Try changing it to EXTRACT_ONLY= \(the right side intentionally left empty\)"
.elif defined(NO_CONFIGURE)
IGNORE=	"defines NO_CONFIGURE, which is obsoleted"
.elif defined(NO_PATCH)
IGNORE=	"defines NO_PATCH, which is obsoleted"
.elif defined(BROKEN_ELF) && (${PORTOBJFORMAT} == "elf") && \
	  !defined(PARALLEL_PACKAGE_BUILD)
IGNORE=	"is broken for ELF: ${BROKEN_ELF}"
.elif defined(BROKEN) && !defined(PARALLEL_PACKAGE_BUILD)
# try building even if marked BROKEN
IGNORE=	"is marked as broken: ${BROKEN}"
.elif defined(FORBIDDEN)
IGNORE=	"is forbidden: ${FORBIDDEN}"
.endif

.if (defined(MANUAL_PACKAGE_BUILD) && defined(PACKAGE_BUILDING) && !defined(PARALLEL_PACKAGE_BUILD))
IGNORE=	"has to be built manually: ${MANUAL_PACKAGE_BUILD}"
clean:
	@${IGNORECMD}
.endif

.if defined(IGNORE)
.if defined(IGNORE_SILENT)
IGNORECMD=	${DO_NADA}
.else
IGNORECMD=	${ECHO_MSG} "===>  ${PKGNAME} ${IGNORE}."
.endif
fetch:
	@${IGNORECMD}
checksum:
	@${IGNORECMD}
extract:
	@${IGNORECMD}
patch:
	@${IGNORECMD}
configure:
	@${IGNORECMD}
all:
	@${IGNORECMD}
build:
	@${IGNORECMD}
install:
	@${IGNORECMD}
reinstall:
	@${IGNORECMD}
package:
	@${IGNORECMD}
.endif

.endif

.if defined(IGNORE) || defined(NO_PACKAGE)
ignorelist: package-name
.else
ignorelist:
	@${DO_NADA}
.endif

################################################################
# Clean directories for ftp or CDROM.
################################################################

.if defined(RESTRICTED)
clean-restricted:	delete-distfiles delete-package
clean-restricted-list: delete-distfiles-list delete-package-list
.else
clean-restricted:
clean-restricted-list:
.endif

.if defined(NO_CDROM)
clean-for-cdrom:	delete-distfiles delete-package
clean-for-cdrom-list:	delete-distfiles-list delete-package-list
.else
clean-for-cdrom:
clean-for-cdrom-list:
.endif

.if defined(ALL_HOOK)
all:
	@cd ${.CURDIR} && ${SETENV} CURDIR=${.CURDIR} DISTNAME=${DISTNAME} \
	  DISTDIR=${DISTDIR} WRKDIR=${WRKDIR} WRKSRC=${WRKSRC} \
	  PATCHDIR=${PATCHDIR} SCRIPTDIR=${SCRIPTDIR} \
	  FILESDIR=${FILESDIR} PORTSDIR=${PORTSDIR} PREFIX=${PREFIX} \
	  DEPENDS="${DEPENDS}" BUILD_DEPENDS="${BUILD_DEPENDS}" \
	  RUN_DEPENDS="${RUN_DEPENDS}" X11BASE=${X11BASE} \
	${ALL_HOOK}
.endif

.if !target(all)
all: build
.endif

.if !defined(DEPENDS_TARGET)
.if make(reinstall)
DEPENDS_TARGET=	reinstall
.else
DEPENDS_TARGET=	install
.endif
.if defined(DEPENDS_CLEAN)
DEPENDS_TARGET+=	clean
DEPENDS_ARGS+=	NOCLEANDEPENDS=yes
.endif
.else
DEPENDS_ARGS+=	FORCE_PKG_REGISTER=yes
.endif
.if defined(DEPENDS)
# pretty much guarantees overwrite of existing installation
.MAKEFLAGS:	FORCE_PKG_REGISTER=yes
.endif

################################################################
# The following are used to create easy dummy targets for
# disabling some bit of default target behavior you don't want.
# They still check to see if the target exists, and if so don't
# do anything, since you might want to set this globally for a
# group of ports in a Makefile.inc, but still be able to
# override from an individual Makefile.
################################################################

# Disable checksum
.if defined(NO_CHECKSUM) && !target(checksum)
checksum: fetch
	@${DO_NADA}
.endif

# Disable build
.if defined(NO_BUILD) && !target(build)
build: configure
	@${TOUCH} ${TOUCH_FLAGS} ${BUILD_COOKIE}
.endif

# Disable install
.if defined(NO_INSTALL) && !target(install)
install: build
	@${TOUCH} ${TOUCH_FLAGS} ${INSTALL_COOKIE}
.endif

# Disable package
.if defined(NO_PACKAGE) && !target(package)
package:
.if defined(IGNORE_SILENT)
	@${DO_NADA}
.else
	@${ECHO_MSG} "===>  ${PKGNAME} may not be packaged: ${NO_PACKAGE}."
.endif
.endif

# Disable describe
.if defined(NO_DESCRIBE) && !target(describe)
describe:
	@${DO_NADA}
.endif

################################################################
# More standard targets start here.
#
# These are the body of the build/install framework.  If you are
# not happy with the default actions, and you can't solve it by
# adding pre-* or post-* targets/scripts, override these.
################################################################

# Fetch

.if !target(do-fetch)
do-fetch:
	@${MKDIR} ${_DISTDIR}
	@(cd ${_DISTDIR}; \
	 for file in ${DISTFILES}; do \
		if [ ! -f $$file -a ! -f `${BASENAME} $$file` ]; then \
			if [ -h $$file -o -h `${BASENAME} $$file` ]; then \
				${ECHO_MSG} ">> ${_DISTDIR}/$$file is a broken symlink."; \
				${ECHO_MSG} ">> Perhaps a filesystem (most likely a CD) isn't mounted?"; \
				${ECHO_MSG} ">> Please correct this problem and try again."; \
				exit 1; \
			fi ; \
			${ECHO_MSG} ">> $$file doesn't seem to exist on this system."; \
			for site in ${MASTER_SITES}; do \
			    ${ECHO_MSG} ">> Attempting to fetch from $${site}."; \
				DIR=${DIST_SUBDIR}; \
				CKSIZE=`${GREP} "^SIZE ($${DIR:+$$DIR/}$$file)" ${MD5_FILE} | ${AWK} '{print $$4}'`; \
				case $${file} in \
				*/*)	${MKDIR} $${file%/*}; \
						args="-o $${file} $${site}$${file}";; \
				*)		args=$${site}$${file};; \
				esac; \
				if ${SETENV} ${FETCH_ENV} ${FETCH_CMD} ${FETCH_BEFORE_ARGS} $${args} ${FETCH_AFTER_ARGS}; then \
					continue 2; \
				fi \
			done; \
			${ECHO_MSG} ">> Couldn't fetch it - please try to retrieve this";\
			${ECHO_MSG} ">> port manually into ${_DISTDIR} and try again."; \
			exit 1; \
	    fi \
	 done)
.if defined(PATCHFILES)
	@(cd ${_DISTDIR}; \
	 for file in ${PATCHFILES}; do \
		if [ ! -f $$file -a ! -f `${BASENAME} $$file` ]; then \
			if [ -h $$file -o -h `${BASENAME} $$file` ]; then \
				${ECHO_MSG} ">> ${_DISTDIR}/$$file is a broken symlink."; \
				${ECHO_MSG} ">> Perhaps a filesystem (most likely a CD) isn't mounted?"; \
				${ECHO_MSG} ">> Please correct this problem and try again."; \
				exit 1; \
			fi ; \
			${ECHO_MSG} ">> $$file doesn't seem to exist on this system."; \
			for site in ${PATCH_SITES}; do \
			    ${ECHO_MSG} ">> Attempting to fetch from $${site}."; \
				DIR=${DIST_SUBDIR}; \
				CKSIZE=`${GREP} "^SIZE ($${DIR:+$$DIR/}$$file)" ${MD5_FILE} | ${AWK} '{print $$4}'`; \
				case $${file} in \
				*/*)	${MKDIR} $${file%/*}; \
						args="-o $${file} $${site}$${file}";; \
				*)		args=$${site}$${file};; \
				esac; \
				if ${SETENV} ${FETCH_ENV} ${FETCH_CMD} ${FETCH_BEFORE_ARGS} $${args} ${FETCH_AFTER_ARGS}; then \
					continue 2; \
				fi \
			done; \
			${ECHO_MSG} ">> Couldn't fetch it - please try to retrieve this";\
			${ECHO_MSG} ">> port manually into ${_DISTDIR} and try again."; \
			exit 1; \
	    fi \
	 done)
.endif
.endif

# Extract

.if !target(do-extract)
do-extract:
	@${RM} -rf ${WRKDIR}
	@${MKDIR} ${WRKDIR}
	@for file in ${EXTRACT_ONLY}; do \
		if ! (cd ${WRKDIR} && ${EXTRACT_CMD} ${EXTRACT_BEFORE_ARGS} ${_DISTDIR}/$$file ${EXTRACT_AFTER_ARGS});\
		then \
			exit 1; \
		fi \
	done
.if !defined(EXTRACT_PRESERVE_OWNERSHIP)
	@if [ `${ID}` = 0 ]; then \
		${CHMOD} -R ug-s ${WRKDIR}; \
		${CHOWN} -R 0:0 ${WRKDIR}; \
	fi
.endif
.endif

# Patch

.if !target(do-patch)
do-patch:
.if defined(PATCHFILES)
	@${ECHO_MSG} "===>  Applying distribution patches for ${PKGNAME}"
	@(cd ${_DISTDIR}; \
	  for i in ${PATCHFILES}; do \
		if [ ${PATCH_DEBUG_TMP} = yes ]; then \
			${ECHO_MSG} "===>   Applying distribution patch $$i" ; \
		fi; \
		case $$i in \
			*.Z|*.gz) \
				${GZCAT} $$i | ${PATCH} ${PATCH_DIST_ARGS}; \
				;; \
			*) \
				${PATCH} ${PATCH_DIST_ARGS} < $$i; \
				;; \
		esac; \
	  done)
.endif
.if defined(EXTRA_PATCHES)
	@for i in ${EXTRA_PATCHES}; do \
		${ECHO_MSG} "===>  Applying extra patch $$i"; \
		${PATCH} ${PATCH_ARGS} < $$i; \
	done
.endif
	@if [ -d ${PATCHDIR} ]; then \
		if [ "`echo ${PATCHDIR}/patch-*`" = "${PATCHDIR}/patch-*" ]; then \
			${ECHO_MSG} "===>   Ignoring empty patch directory"; \
			if [ -d ${PATCHDIR}/CVS ]; then \
				${ECHO_MSG} "===>   Perhaps you forgot the -P flag to cvs co or update?"; \
			fi; \
		else \
			${ECHO_MSG} "===>  Applying ${OPSYS} patches for ${PKGNAME}" ; \
			for i in ${PATCHDIR}/patch-*; do \
				case $$i in \
					*.orig|*.rej|*~) \
						${ECHO_MSG} "===>   Ignoring patchfile $$i" ; \
						;; \
					*) \
						if [ ${PATCH_DEBUG_TMP} = yes ]; then \
							${ECHO_MSG} "===>   Applying ${OPSYS} patch $$i" ; \
						fi; \
						${PATCH} ${PATCH_ARGS} < $$i; \
						;; \
				esac; \
			done; \
		fi; \
	fi
.endif

# Configure

.if !target(do-configure)
do-configure:
.if defined(USE_AUTOCONF)
	@(cd ${WRKSRC} && ${AUTOCONF})
.endif
	@if [ -f ${SCRIPTDIR}/configure ]; then \
		cd ${.CURDIR} && ${SETENV} ${SCRIPTS_ENV} ${SH} \
		  ${SCRIPTDIR}/configure; \
	fi
.if defined(HAS_CONFIGURE)
	@(cd ${WRKSRC} && \
		if ! ${SETENV} CC="${CC}" CXX="${CXX}" \
	    CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
	    INSTALL="/usr/bin/install -c -o ${BINOWN} -g ${BINGRP}" \
	    INSTALL_DATA="${INSTALL_DATA}" \
	    INSTALL_PROGRAM="${INSTALL_PROGRAM}" \
	    INSTALL_SCRIPT="${INSTALL_SCRIPT}" \
	    ${CONFIGURE_ENV} ./${CONFIGURE_SCRIPT} ${CONFIGURE_ARGS}; then \
			${ECHO} "===>  Script \"${CONFIGURE_SCRIPT}\" failed: here are the contents of \"${CONFIGURE_LOG}\""; \
			${CAT} ${CONFIGURE_LOG}; \
			${ECHO} "(end of \"${CONFIGURE_LOG}\")"; \
			${FALSE}; \
		fi)
.endif
.if defined(USE_IMAKE)
	@(cd ${WRKSRC} && ${XMKMF})
.endif
.endif

# Build

.if !target(do-build)
do-build:
.if defined(USE_GMAKE)
	@(cd ${WRKSRC}; ${SETENV} ${MAKE_ENV} ${GMAKE} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} ${ALL_TARGET})
.else defined(USE_GMAKE)
	@(cd ${WRKSRC}; ${SETENV} ${MAKE_ENV} ${MAKE} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} ${ALL_TARGET})
.endif
.endif

# Install

.if !target(do-install)
do-install:
.if defined(USE_GMAKE)
	@(cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${GMAKE} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} ${INSTALL_TARGET})
.if defined(USE_IMAKE) && !defined(NO_INSTALL_MANPAGES)
	@(cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${GMAKE} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} install.man)
.endif
.else defined(USE_GMAKE)
	@(cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${MAKE} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} ${INSTALL_TARGET})
.if defined(USE_IMAKE) && !defined(NO_INSTALL_MANPAGES)
	@(cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${MAKE} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} install.man)
.endif
.endif
.endif

# Package

.if !target(do-package)
do-package: ${TMPPLIST}
	@${ECHO_MSG} "===>  Building package for ${PKGNAME}"
	@if [ -d ${PACKAGES} ]; then \
		if [ ! -d ${PKGREPOSITORY} ]; then \
			if ! ${MKDIR} ${PKGREPOSITORY}; then \
				${ECHO_MSG} ">> Can't create directory ${PKGREPOSITORY}."; \
				exit 1; \
			fi; \
		fi; \
	fi
	@__softMAKEFLAGS='${__softMAKEFLAGS:S/'/'\''/g}'; \
	if ${PKG_CMD} ${PKG_ARGS} ${PKGFILE}; then \
		if [ -d ${PACKAGES} ]; then \
			eval ${MAKE} $${__softMAKEFLAGS} package-links; \
		fi; \
	else \
		eval ${MAKE} $${__softMAKEFLAGS} delete-package; \
		exit 1; \
	fi
.endif

# Some support rules for do-package

.if !target(package-links)
package-links:
	@${MAKE} ${__softMAKEFLAGS} delete-package-links
	@for cat in ${CATEGORIES}; do \
		if [ ! -d ${PACKAGES}/$$cat ]; then \
			if ! ${MKDIR} ${PACKAGES}/$$cat; then \
				${ECHO_MSG} ">> Can't create directory ${PACKAGES}/$$cat."; \
				exit 1; \
			fi; \
		fi; \
		${LN} -sf `${ECHO} $$cat | ${SED} -e 'sa[^/]*a..ag'`/${PKGREPOSITORYSUBDIR}/${PKGNAME}${PKG_SUFX} ${PACKAGES}/$$cat; \
	done
.if !defined(NO_LATEST_LINK)
	@if [ ! -d ${PKGLATESTREPOSITORY} ]; then \
		if ! ${MKDIR} ${PKGLATESTREPOSITORY}; then \
			${ECHO_MSG} ">> Can't create directory ${PKGLATESTREPOSITORY}."; \
			exit 1; \
		fi; \
	fi
	@${LN} -s ../${PKGREPOSITORYSUBDIR}/${PKGNAME}${PKG_SUFX} ${PKGLATESTFILE}
.endif
.endif

.if !target(delete-package-links)
delete-package-links:
	@for cat in ${CATEGORIES}; do \
		${RM} -f ${PACKAGES}/$$cat/${PKGNAME}${PKG_SUFX}; \
	done
.if !defined(NO_LATEST_LINK)
	@${RM} -f ${PKGLATESTFILE}
.endif
.endif

.if !target(delete-package)
delete-package:
	@${MAKE} ${__softMAKEFLAGS} delete-package-links
	@${RM} -f ${PKGFILE}
.endif

.if !target(delete-package-links-list)
delete-package-links-list:
	@for cat in ${CATEGORIES}; do \
		${ECHO} ${RM} -f ${PACKAGES}/$$cat/${PKGNAME}${PKG_SUFX}; \
	done
.if !defined(NO_LATEST_LINK)
	@${ECHO} ${RM} -f ${PKGLATESTFILE}
.endif
.endif

.if !target(delete-package-list)
delete-package-list:
	@${MAKE} ${__softMAKEFLAGS} delete-package-links-list
	@${ECHO} "[ -f ${PKGFILE} ] && (${ECHO} deleting ${PKGFILE}; ${RM} -f ${PKGFILE})"
.endif

################################################################
# This is the "generic" port target, actually a macro used from the
# six main targets.  See below for more.
################################################################

_PORT_USE: .USE
.if make(real-fetch)
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} fetch-depends
.endif
.if make(real-extract)
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} checksum REAL_EXTRACT=yes
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} build-depends lib-depends misc-depends
.endif
.if make(real-install)
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} check-categories
.if !defined(NO_PKG_REGISTER) && !defined(FORCE_PKG_REGISTER)
	@if [ -d ${PKG_DBDIR}/${PKGNAME} ]; then \
		${ECHO} "===>  ${PKGNAME} is already installed - perhaps an older version?"; \
		${ECHO} "      If so, you may wish to \`\`make deinstall'' and install"; \
		${ECHO} "      this port again by \`\`make reinstall'' to upgrade it properly."; \
		${ECHO} "      If you really wish to overwrite the old port of ${PKGNAME}"; \
		${ECHO} "      without deleting it first, set the variable \"FORCE_PKG_REGISTER\""; \
		${ECHO} "      in your environment or the \"make install\" command line."; \
		exit 1; \
	fi
.endif
	@if [ `${SH} -c umask` != 0022 ]; then \
		${ECHO_MSG} "===>  Warning: your umask is \"`${SH} -c umask`"\".; \
		${ECHO_MSG} "      If this is not desired, set it to an appropriate value"; \
		${ECHO_MSG} "      and install this port again by \`\`make reinstall''."; \
	fi
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} run-depends lib-depends
.endif
.if make(real-install)
	@${MKDIR} ${PREFIX}
	@if [ `${ID}` != 0 ]; then \
		if [ -w ${PREFIX}/ ]; then \
			${ECHO_MSG} "Warning: not superuser, you may get some errors during installation."; \
		else \
			${ECHO_MSG} "Error: ${PREFIX}/ not writable."; \
			${FALSE}; \
		fi; \
	fi
.if !defined(NO_MTREE)
	@if [ `${ID}` = 0 ]; then \
		if [ ! -f ${MTREE_FILE} ]; then \
			${ECHO} "Error: mtree file \"${MTREE_FILE}\" is missing."; \
			${ECHO} "Copy it from a suitable location (e.g., /usr/src/etc/mtree) and try again."; \
			exit 1; \
		else \
			${MTREE_CMD} ${MTREE_ARGS} ${PREFIX}/ >/dev/null; \
		fi; \
	else \
		${ECHO_MSG} "Warning: not superuser, can't run mtree."; \
		${ECHO_MSG} "You may want to become root and try again to ensure correct permissions."; \
	fi
.endif
	@if [ -d ${PREFIX}/info -a ! -f ${PREFIX}/info/dir -a -f /usr/share/info/dir ]; then \
	  ${SED} -ne '1,/Menu:/p' /usr/share/info/dir > ${PREFIX}/info/dir; \
	 fi
.endif
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} ${.TARGET:S/^real-/pre-/}
	@if [ -f ${SCRIPTDIR}/${.TARGET:S/^real-/pre-/} ]; then \
		cd ${.CURDIR} && ${SETENV} ${SCRIPTS_ENV} ${SH} \
			${SCRIPTDIR}/${.TARGET:S/^real-/pre-/}; \
	fi
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} ${.TARGET:S/^real-/do-/}
# put here so ports can change the contents of ${TMPPLIST} if necessary
.if make(real-install)
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} generate-plist
.endif
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} ${.TARGET:S/^real-/post-/}
	@if [ -f ${SCRIPTDIR}/${.TARGET:S/^real-/post-/} ]; then \
		cd ${.CURDIR} && ${SETENV} ${SCRIPTS_ENV} ${SH} \
			${SCRIPTDIR}/${.TARGET:S/^real-/post-/}; \
	fi
.if make(real-patch) && defined(USE_LIBTOOL)
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} patch-libtool
.endif
.if make(real-install) && (defined(_MANPAGES) || defined(_MLINKS))
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} compress-man
.endif
.if make(real-install) && !defined(NO_PKG_REGISTER)
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} fake-pkg
.endif
.if !make(real-fetch) \
	&& (!make(real-patch) || !defined(PATCH_CHECK_ONLY)) \
	&& (!make(real-package) || !defined(PACKAGE_NOINSTALL))
	@${TOUCH} ${TOUCH_FLAGS} ${WRKDIR}/.${.TARGET:S/^real-//}_done
.endif

################################################################
# Skeleton targets start here
# 
# You shouldn't have to change these.  Either add the pre-* or
# post-* targets/scripts or redefine the do-* targets.  These
# targets don't do anything other than checking for cookies and
# call the necessary targets/scripts.
################################################################

.if !target(fetch)
fetch:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} real-fetch
.endif

.if !target(extract)
extract: ${EXTRACT_COOKIE}
.endif

.if !target(patch)
patch: ${PATCH_COOKIE}
.endif

.if !target(configure)
configure: ${CONFIGURE_COOKIE}
.endif

.if !target(build)
build: ${BUILD_COOKIE}
.endif

.if !target(install)
install: ${INSTALL_COOKIE}
.endif

.if !target(package)
package: ${PACKAGE_COOKIE}
.endif

${EXTRACT_COOKIE}:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} fetch
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} real-extract
${PATCH_COOKIE}:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} extract
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} real-patch
${CONFIGURE_COOKIE}:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} patch
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} real-configure
${BUILD_COOKIE}:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} configure
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} real-build
${INSTALL_COOKIE}:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} build
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} real-install
${PACKAGE_COOKIE}:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} install
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} real-package

# And call the macros

real-fetch: _PORT_USE
real-extract: _PORT_USE
	@${ECHO_MSG} "===>  Extracting for ${PKGNAME}"
real-patch: _PORT_USE
	@${ECHO_MSG} "===>  Patching for ${PKGNAME}"
real-configure: _PORT_USE
	@${ECHO_MSG} "===>  Configuring for ${PKGNAME}"
real-build: _PORT_USE
	@${ECHO_MSG} "===>  Building for ${PKGNAME}"
real-install: _PORT_USE
	@${ECHO_MSG} "===>  Installing for ${PKGNAME}"
real-package: _PORT_USE

# Empty pre-* and post-* targets, note we can't use .if !target()
# in the _PORT_USE macro

.for name in fetch extract patch configure build install package

.if !target(pre-${name})
pre-${name}:
	@${DO_NADA}
.endif

.if !target(post-${name})
post-${name}:
	@${DO_NADA}
.endif

.endfor

# Patch-libtool
#
# Special target to automatically make libtool using ports use the
# libtool port.  See above for default values of LIBTOOLFILES.
#
# This target works by first checking the version of the installed
# libtool shell script, which is not actually used.  Rather it's path
# is determined, and used to find the path to ltconfig and ltmain.sh
# (which is ../share/libtool/).  Then the configure script is copied
# and the default paths for ltconfig and ltmain.sh (normally ./) is
# replaced.  The port's configure script therefore uses the files
# installed by the libtool port in place of it's own.
#
# Also passed to ltconfig are ${LIBTOOLFLAGS}, which can be used to
# customise the behaviour of the port.  Besides the normal flags the
# freebsd port of libtool supports three special flags:
#  --disable-ltlibs		Don't install the .la files. (on by default)
#  --release-ignore		Ignore any -release flags. (off by default)
#  --release-suffix		Add the -release to all libraries, not just
#						the shared library. (off by default)
#

.if (${OPSYS} == "FreeBSD")
.if !target(patch-libtool)
patch-libtool:
	@(if ${LIBTOOL} --version | grep -vq "1\.3\.3-freebsd-ports"; then \
		(${ECHO} "Your libtool installation is out of date. Please remove"; \
		 ${ECHO} "and reinstall ${PORTSDIR}/devel/libtool."; \
		 exit 1); \
	  fi; \
	 LIBTOOLDIR=`which ${LIBTOOL} | sed -e 's^/bin/libtool^/share/libtool^'` || ${LOCALBASE}/share/libtool; \
	 cd ${WRKSRC}; \
	 for file in ${LIBTOOLFILES}; do \
		${CP} $$file $$file.tmp; \
		${SED} -e "s^\$$ac_aux_dir/ltconfig^$${LIBTOOLDIR}/ltconfig^g" \
			$$file.tmp | \
		${SED} -e "s^\$$ac_aux_dir/ltmain.sh^${LIBTOOLFLAGS} $${LIBTOOLDIR}/ltmain.sh^g" \
			> $$file; \
	 done);
.endif
.else
.if !target(patch-libtool)
patch-libtool:
.endif
.endif
# Checkpatch
#
# Special target to verify patches

.if !target(checkpatch)
checkpatch:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} PATCH_CHECK_ONLY=yes patch
.endif

# Reinstall
#
# Special target to re-run install

.if !target(reinstall)
reinstall:
	@${RM} -f ${INSTALL_COOKIE} ${PACKAGE_COOKIE}
	@DEPENDS_TARGET="${DEPENDS_TARGET}" ${MAKE} install
.endif

# Deinstall
#
# Special target to remove installation

.if !target(deinstall)
deinstall:
	@${ECHO_MSG} "===>  Deinstalling for ${PKGNAME}"
	@${PKG_DELETE} -f ${PKGNAME}
	@${RM} -f ${INSTALL_COOKIE} ${PACKAGE_COOKIE}
.endif

################################################################
# Some more targets supplied for users' convenience
################################################################

# Cleaning up

.if !target(pre-clean)
pre-clean:
	@${DO_NADA}
.endif

.if !target(clean)
clean: pre-clean
.if !defined(NOCLEANDEPENDS)
	@${MAKE} ${__softMAKEFLAGS} clean-depends
.endif
	@${ECHO_MSG} "===>  Cleaning for ${PKGNAME}"
	@if [ -d ${WRKDIR} ]; then \
		if [ -w ${WRKDIR} ]; then \
			${RM} -rf ${WRKDIR}; \
		else \
			${ECHO_MSG} "===>   ${WRKDIR} not writable, skipping"; \
		fi; \
	fi
.endif

.if !target(pre-distclean)
pre-distclean:
	@${DO_NADA}
.endif

.if !target(distclean)
distclean: pre-distclean clean delete-distfiles
.endif

.if !target(delete-distfiles)
delete-distfiles:
	@${ECHO_MSG} "===>  Deleting distfiles for ${PKGNAME}"
	@(if [ "X${DISTFILES}${PATCHFILES}" != "X" -a -d ${_DISTDIR} ]; then \
		cd ${_DISTDIR}; \
		for file in ${DISTFILES} ${PATCHFILES}; do \
			${RM} -f $${file}; \
			dir=$${file%/*}; \
			if [ "$${dir}" != "$${file}" ]; then \
				${RMDIR} -p $${dir} >/dev/null 2>&1 || :; \
			fi; \
		done; \
	fi)
.if defined(DIST_SUBDIR)
	-@${RMDIR} ${_DISTDIR}  
.endif
.endif

.if !target(delete-distfiles-list)
delete-distfiles-list:
	@${ECHO} "# ${PKGNAME}"
	@if [ "X${DISTFILES}${PATCHFILES}" != "X" ]; then \
		for file in ${DISTFILES} ${PATCHFILES}; do \
			${ECHO} "[ -f ${_DISTDIR}/$$file ] && (${ECHO} deleting ${_DISTDIR}/$$file; ${RM} -f ${_DISTDIR}/$$file)"; \
			dir=$${file%/*}; \
			if [ "$${dir}" != "$${file}" ]; then \
				${ECHO} "(cd ${_DISTDIR} && ${RMDIR} -p $${dir} 2>/dev/null)"; \
			fi; \
		done; \
	fi
.if defined(DIST_SUBDIR)
	@${ECHO} "${RMDIR} ${_DISTDIR} 2>/dev/null"
.endif
.endif

# Prints out a list of files to fetch (useful to do a batch fetch)

.if !target(fetch-list)
fetch-list:
	@${MKDIR} ${_DISTDIR}
	@(cd ${_DISTDIR}; \
	 for file in ${DISTFILES}; do \
		if [ ! -f $$file -a ! -f `${BASENAME} $$file` ]; then \
			for site in ${MASTER_SITES}; do \
				DIR=${DIST_SUBDIR}; \
				CKSIZE=`${GREP} "^SIZE ($${DIR:+$$DIR/}$$file)" ${MD5_FILE} | ${AWK} '{print $$4}'`; \
				case $${file} in \
				*/*)	args="-o $${file} $${site}$${file}";; \
				*)		args=$${site}$${file};; \
				esac; \
				${ECHO} -n ${SETENV} ${FETCH_ENV} ${FETCH_CMD} ${FETCH_BEFORE_ARGS} $${args} "${FETCH_AFTER_ARGS}" '||' ; \
					break; \
			done; \
			${ECHO} "echo $${file} not fetched" ; \
		fi \
	done)
.if defined(PATCHFILES)
	@(cd ${_DISTDIR}; \
	 for file in ${PATCHFILES}; do \
		if [ ! -f $$file -a ! -f `${BASENAME} $$file` ]; then \
			for site in ${PATCH_SITES}; do \
				DIR=${DIST_SUBDIR}; \
				CKSIZE=`${GREP} "^SIZE ($${DIR:+$$DIR/}$$file)" ${MD5_FILE} | ${AWK} '{print $$4}'`; \
				case $${file} in \
				*/*)	args="-o $${file} $${site}$${file}";; \
				*)		args=$${site}$${file};; \
				esac; \
				${ECHO} -n ${SETENV} ${FETCH_ENV} ${FETCH_CMD} ${FETCH_BEFORE_ARGS} $${args} "${FETCH_AFTER_ARGS}" '||' ; \
					break; \
			done; \
			${ECHO} "echo $${file} not fetched" ; \
		fi \
	 done)
.endif
.endif

# Checksumming utilities

.if !target(makesum)
makesum: fetch
	@${MKDIR} ${FILESDIR}
	@if [ -f ${MD5_FILE} ]; then ${RM} -f ${MD5_FILE}; fi
	@(cd ${DISTDIR}; \
	 for file in ${_CKSUMFILES}; do \
		${MD5} $$file >> ${MD5_FILE}; \
	 done)
	@for file in ${_IGNOREFILES}; do \
		${ECHO} "MD5 ($$file) = IGNORE" >> ${MD5_FILE}; \
	done
.endif
# this line goes after the ${MD5} above
#		echo "SIZE ($$file) = "`wc -c < $$file` >> ${MD5_FILE}; \


.if !target(checksum)
checksum:
.if !defined(REAL_EXTRACT)
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} fetch
.endif
	@if [ ! -f ${MD5_FILE} ]; then \
		${ECHO_MSG} ">> No MD5 checksum file."; \
	else \
		(cd ${DISTDIR}; OK="true"; \
		  for file in ${_CKSUMFILES}; do \
			CKSUM=`${MD5} < $$file`; \
			CKSUM2=`${GREP} "^MD5 ($$file)" ${MD5_FILE} | ${AWK} '{print $$4}'`; \
			if [ "$$CKSUM2" = "" ]; then \
				${ECHO_MSG} ">> No checksum recorded for $$file."; \
				OK="false"; \
			elif [ "$$CKSUM2" = "IGNORE" ]; then \
				${ECHO_MSG} ">> Checksum for $$file is set to IGNORE in md5 file even though"; \
				${ECHO_MSG} "   the file is not in the "'$$'"{IGNOREFILES} list."; \
				OK="false"; \
			elif ${EXPR} "$$CKSUM2" : ".*$$CKSUM" > /dev/null; then \
				${ECHO_MSG} ">> Checksum OK for $$file."; \
			else \
				${ECHO_MSG} ">> Checksum mismatch for $$file."; \
				OK="false"; \
			fi; \
		  done; \
		  for file in ${_IGNOREFILES}; do \
			CKSUM2=`${GREP} "($$file)" ${MD5_FILE} | ${AWK} '{print $$4}'`; \
			if [ "$$CKSUM2" = "" ]; then \
				${ECHO_MSG} ">> No checksum recorded for $$file, file is in "'$$'"{IGNOREFILES} list."; \
				OK="false"; \
			elif [ "$$CKSUM2" != "IGNORE" ]; then \
				${ECHO_MSG} ">> Checksum for $$file is not set to IGNORE in md5 file even though"; \
				${ECHO_MSG} "   the file is in the "'$$'"{IGNOREFILES} list."; \
				OK="false"; \
			fi; \
		  done; \
		  if [ "$$OK" != "true" ]; then \
			${ECHO_MSG} "Make sure the Makefile and md5 file (${MD5_FILE})"; \
			${ECHO_MSG} "are up to date.  If you want to override this check, type"; \
			${ECHO_MSG} "\"make NO_CHECKSUM=yes [other args]\"."; \
			exit 1; \
		  fi) ; \
	fi
.endif

################################################################
# The special package-building targets
# You probably won't need to touch these
################################################################

# Nobody should want to override this unless PKGNAME is simply bogus.

.if !target(package-name)
package-name:
	@${ECHO} ${PKGNAME}
.endif

# Build a package but don't check the package cookie

.if !target(repackage)
repackage: pre-repackage package

pre-repackage:
	@${RM} -f ${PACKAGE_COOKIE}
.endif

# Build a package but don't check the cookie for installation, also don't
# install package cookie

.if !target(package-noinstall)
package-noinstall:
	@${MKDIR} ${WRKDIR}
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} PACKAGE_NOINSTALL=yes real-package
	@${RM} -f ${TMPPLIST}
	-@${RMDIR} ${WRKDIR}
.endif

################################################################
# Dependency checking
################################################################

.if !target(depends)
depends: lib-depends misc-depends
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} fetch-depends
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} build-depends
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} run-depends

.if make(fetch-depends)
DEPENDS_TMP+=	${FETCH_DEPENDS}
.endif

.if make(build-depends)
DEPENDS_TMP+=	${BUILD_DEPENDS}
.endif

.if make(run-depends)
DEPENDS_TMP+=	${RUN_DEPENDS}
.endif

.if defined(ALWAYS_BUILD_DEPENDS)
_DEPEND_ALWAYS=	1
.else
_DEPEND_ALWAYS=	0
.endif

_DEPENDS_USE:	.USE
.if defined(DEPENDS_TMP)
.if !defined(NO_DEPENDS)
	@for i in ${DEPENDS_TMP}; do \
		prog=`${ECHO} $$i | ${SED} -e 's/:.*//'`; \
		dir=`${ECHO} $$i | ${SED} -e 's/[^:]*://'`; \
		if ${EXPR} "$$dir" : '.*:' > /dev/null; then \
			target=`${ECHO} $$dir | ${SED} -e 's/.*://'`; \
			dir=`${ECHO} $$dir | ${SED} -e 's/:.*//'`; \
		else \
			target="${DEPENDS_TARGET}"; \
			depends_args="${DEPENDS_ARGS}"; \
		fi; \
		if ${EXPR} "$$prog" : \\/ >/dev/null; then \
			if [ -e "$$prog" ]; then \
				${ECHO_MSG} "===>   ${PKGNAME} depends on file: $$prog - found"; \
				if [ ${_DEPEND_ALWAYS} = 1 ]; then \
					${ECHO_MSG} "       (but building it anyway)"; \
					notfound=1; \
				else \
					notfound=0; \
				fi; \
			else \
				${ECHO_MSG} "===>   ${PKGNAME} depends on file: $$prog - not found"; \
				notfound=1; \
			fi; \
		else \
			if ${WHICH} "$$prog" > /dev/null 2>&1 ; then \
				${ECHO_MSG} "===>   ${PKGNAME} depends on executable: $$prog - found"; \
				if [ ${_DEPEND_ALWAYS} = 1 ]; then \
					${ECHO_MSG} "       (but building it anyway)"; \
					notfound=1; \
				else \
					notfound=0; \
				fi; \
			else \
				${ECHO_MSG} "===>   ${PKGNAME} depends on executable: $$prog - not found"; \
				notfound=1; \
			fi; \
		fi; \
		if [ $$notfound != 0 ]; then \
			${ECHO_MSG} "===>    Verifying $$target for $$prog in $$dir"; \
			if [ ! -d "$$dir" ]; then \
				${ECHO_MSG} "     >> No directory for $$prog.  Skipping.."; \
			else \
				(cd $$dir; ${MAKE} $$target $$depends_args) ; \
				${ECHO_MSG} "===>   Returning to build of ${PKGNAME}"; \
			fi; \
		fi; \
	done
.endif
.else
	@${DO_NADA}
.endif

fetch-depends:	_DEPENDS_USE
build-depends:	_DEPENDS_USE
run-depends:	_DEPENDS_USE

lib-depends:
.if defined(LIB_DEPENDS)
.if !defined(NO_DEPENDS)
	@for i in ${LIB_DEPENDS}; do \
		lib=`${ECHO} $$i | ${SED} -e 's/:.*//'`; \
		dir=`${ECHO} $$i | ${SED} -e 's/[^:]*://'`; \
		if ${EXPR} "$$dir" : '.*:' > /dev/null; then \
			target=`${ECHO} $$dir | ${SED} -e 's/.*://'`; \
			dir=`${ECHO} $$dir | ${SED} -e 's/:.*//'`; \
		else \
			target="${DEPENDS_TARGET}"; \
			depends_args="${DEPENDS_ARGS}"; \
		fi; \
		if ${LDCONFIG} -r | ${GREP} -qwF -e "-l$$lib"; then \
			${ECHO_MSG} "===>   ${PKGNAME} depends on shared library: $$lib - found"; \
			if [ ${_DEPEND_ALWAYS} = 1 ]; then \
				${ECHO_MSG} "       (but building it anyway)"; \
				notfound=1; \
			else \
				notfound=0; \
			fi; \
		else \
			${ECHO_MSG} "===>   ${PKGNAME} depends on shared library: $$lib - not found"; \
			notfound=1; \
		fi; \
		if [ $$notfound != 0 ]; then \
			${ECHO_MSG} "===>    Verifying $$target for $$lib in $$dir"; \
			if [ ! -d "$$dir" ]; then \
				${ECHO_MSG} "     >> No directory for $$lib.  Skipping.."; \
			else \
				(cd $$dir; ${MAKE} $$target $$depends_args) ; \
				${ECHO_MSG} "===>   Returning to build of ${PKGNAME}"; \
				if ${LDCONFIG} -r | ${GREP} -qwF -e "-l$$lib"; then \
					${TRUE}; \
				else \
					${ECHO_MSG} "Error: shared library \"$$lib\" does not exist"; \
					${FALSE}; \
				fi; \
			fi; \
		fi; \
	done
.endif
.else
	@${DO_NADA}
.endif

misc-depends:
.if defined(DEPENDS)
.if !defined(NO_DEPENDS)
	@for dir in ${DEPENDS}; do \
		if ${EXPR} "$$dir" : '.*:' > /dev/null; then \
			target=`${ECHO} $$dir | ${SED} -e 's/.*://'`; \
			dir=`${ECHO} $$dir | ${SED} -e 's/:.*//'`; \
		else \
			target="${DEPENDS_TARGET}"; \
			depends_args="${DEPENDS_ARGS}"; \
		fi; \
		${ECHO_MSG} "===>   ${PKGNAME} depends on: $$dir"; \
		${ECHO_MSG} "===>    Verifying $$target for $$dir"; \
		if [ ! -d $$dir ]; then \
			${ECHO_MSG} "     >> No directory for $$dir.  Skipping.."; \
		else \
			(cd $$dir; ${MAKE} $$target $$depends_args) ; \
		fi \
	done
	@${ECHO_MSG} "===>   Returning to build of ${PKGNAME}"
.endif
.else
	@${DO_NADA}
.endif

.endif

.if !target(clean-depends)
clean-depends:
.if defined(FETCH_DEPENDS) || defined(BUILD_DEPENDS) || defined(LIB_DEPENDS) \
	|| defined(RUN_DEPENDS)
	@for dir in `${ECHO} "${FETCH_DEPENDS} ${BUILD_DEPENDS} ${LIB_DEPENDS} ${RUN_DEPENDS}" | ${TR} '\040' '\012' | ${SED} -e 's/^[^:]*://' -e 's/:.*//' | sort -u`; do \
		if [ -d $$dir ] ; then \
			(cd $$dir; ${MAKE} NOCLEANDEPENDS=yes clean clean-depends); \
		fi \
	done
.endif
.if defined(DEPENDS)
	@for dir in `${ECHO} "${DEPENDS}" | ${TR} '\040' '\012' | ${SED} -e 's/:.*//' | sort -u`; do \
		if [ -d $$dir ] ; then \
			(cd $$dir; ${MAKE} NOCLEANDEPENDS=yes clean clean-depends); \
		fi \
	done
.endif
.endif

# Dependency lists: build and runtime.  Print out directory names.

build-depends-list:
	@${BUILD-DEPENDS-LIST}

BUILD-DEPENDS-LIST= \
	for dir in $$(${ECHO} "${FETCH_DEPENDS} ${BUILD_DEPENDS} ${LIB_DEPENDS}" | ${TR} '\040' '\012' | ${SED} -e 's/^[^:]*://' -e 's/:.*//' | sort -u) $$(${ECHO} ${DEPENDS} | ${TR} '\040' '\012' | ${SED} -e 's/:.*//' | sort -u); do \
		if [ -d $$dir ]; then \
			${ECHO} $$dir; \
		else \
			${ECHO_MSG} "${PKGNAME}: \"$$dir\" non-existent -- dependency list incomplete" >&2; \
		fi; \
	done | sort -u

run-depends-list:
	@${RUN-DEPENDS-LIST}

RUN-DEPENDS-LIST= \
	for dir in $$(${ECHO} "${LIB_DEPENDS} ${RUN_DEPENDS}" | ${TR} '\040' '\012' | ${SED} -e 's/^[^:]*://' -e 's/:.*//' | sort -u) $$(${ECHO} ${DEPENDS} | ${TR} '\040' '\012' | ${SED} -e 's/:.*//' | sort -u); do \
		if [ -d $$dir ]; then \
			${ECHO} $$dir; \
		else \
			${ECHO_MSG} "${PKGNAME}: \"$$dir\" non-existent -- dependency list incomplete" >&2; \
		fi; \
	done | sort -u

# This one does not print out directory names -- it could take a long time.
package-depends:
	@for dir in `${ECHO} "${LIB_DEPENDS} ${RUN_DEPENDS}" | ${TR} '\040' '\012' | ${SED} -e 's/^[^:]*://' -e 's/:.*//' | sort -u` `${ECHO} ${DEPENDS} | ${TR} '\040' '\012' | ${SED} -e 's/:.*//' | sort -u`; do \
		if [ -d $$dir ]; then \
			(cd $$dir ; ${MAKE} package-name package-depends); \
		else \
			${ECHO_MSG} "${PKGNAME}: \"$$dir\" non-existent -- dependency list incomplete" >&2; \
		fi; \
	done

################################################################
# Everything after here are internal targets and really
# shouldn't be touched by anybody but the release engineers.
################################################################

# This target generates an index entry suitable for aggregation into
# a large index.  Format is:
#
# distribution-name|port-path|installation-prefix|comment| \
#  description-file|maintainer|categories|build deps|run deps|www site

.if !target(describe)
describe:
	@${ECHO} `perl -e ' \
		print "${PKGNAME}|${.CURDIR}|${PREFIX}|"; \
		if (open (COMMENT, "${COMMENT}")) { \
			$$_ = <COMMENT>; \
			chomp; \
			print; \
		} else { \
			print "** No Description"; \
		} \
		if ( -f "${DESCR}" ) { \
			print "|${DESCR}"; \
		} else { \
			print "|/dev/null"; \
		} \
		print q#|${MAINTAINER}|${CATEGORIES}|#; \
		for (split /\s+/, "${FETCH_DEPENDS} ${BUILD_DEPENDS} ${LIB_DEPENDS}") { \
			next if /^$$/; \
			s/^[^:]*\://; \
			s/\:.*//; \
			if ( ! -d $$_ ) { \
				print STDERR "${PKGNAME}: \"$$_\" non-existent -- dependency list incomplete"; \
			} else { \
				push @bdirs, $$_; \
			} \
		} \
		for (split /\s+/, "${LIB_DEPENDS} ${RUN_DEPENDS}") { \
			next if /^$$/; \
			s/^[^:]*\://; \
			s/\:.*//; \
			if ( ! -d $$_ ) { \
				print STDERR "${PKGNAME}: \"$$_\" non-existent -- dependency list incomplete"; \
			} else { \
				push @rdirs, $$_; \
			} \
		} \
		for (split /\s+/, "${DEPENDS}") { \
			next if /^$$/; \
			s/\:.*//; \
			if ( ! -d $$_ ) { \
				print STDERR "${PKGNAME}: \"$$_\" non-existent -- dependency list incomplete"; \
			} else { \
				push @mdirs, $$_; \
			} \
		} \
		for (sort (@bdirs, @mdirs)) { \
			if ($$_ ne $$l) { \
				$$a .= $$_ . " "; \
				$$l = $$_; \
			} \
		} \
		chop $$a; \
		print "$$a|"; \
		for (sort (@rdirs, @mdirs)) { \
			if ($$_ ne $$m) { \
				$$b .= $$_ . " "; \
				$$m = $$_; \
			} \
		} \
		chop $$b; \
		print "$$b|"; \
		if (open (DESCR, "${DESCR}")) { \
			until (/^WWW\:\s/ or eof DESCR) { \
				$$_ = <DESCR>; \
			} \
			if (/^WWW\:\s/) { \
				chomp; \
				split /\s+/; \
				print $$_[1]; \
			} \
		} \
		print "\n";'`
.endif

www-site:
.if exists(${DESCR})
	@${GREP} '^WWW:[ 	]' ${DESCR} | ${AWK} '{print $$2}' | head -1
.else
	@${ECHO}
.endif

.if !target(readmes)
readmes:	readme
.endif

.if !target(readme)
readme:
	@rm -f README.html
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} README.html
.endif

README.html:
	@${ECHO_MSG} "===>   Creating README.html for ${PKGNAME}"
	@${CAT} ${TEMPLATES}/README.port | \
		${SED} -e 's%%PORT%%'`${ECHO} ${.CURDIR} | ${SED} -e 's.*/\([^/]*/[^/]*\)$$\1'`'g' \
			-e 's%%PKG%%${PKGNAME}g' \
			-e '/%%COMMENT%%/r${PKGDIR}/COMMENT' \
			-e '/%%COMMENT%%/d' \
			-e 's%%BUILD_DEPENDS%%'"`${MAKE} ${__softMAKEFLAGS} pretty-print-build-depends-list`"'' \
			-e 's%%RUN_DEPENDS%%'"`${MAKE} ${__softMAKEFLAGS} pretty-print-run-depends-list`"'' \
			-e 's%%TOP%%'"`${ECHO} ${CATEGORIES} | ${SED} -e 'sa .*aa' -e 'sa[^/]*a..ag'`"'/..' \
		>> $@

# The following two targets require an up-to-date INDEX in ${PORTSDIR}

.if !target(pretty-print-build-depends-list)
pretty-print-build-depends-list:
.if defined(FETCH_DEPENDS) || defined(BUILD_DEPENDS) || \
	defined(LIB_DEPENDS) || defined(DEPENDS)
	@${ECHO} -n 'This port requires package(s) "'
	@${ECHO} -n `${GREP} '^${PKGNAME}|' ${PORTSDIR}/INDEX | awk -F\| '{print $$8;}'`
	@${ECHO} '" to build.'
.endif
.endif

.if !target(pretty-print-run-depends-list)
pretty-print-run-depends-list:
.if defined(RUN_DEPENDS) || defined(LIB_DEPENDS) || defined(DEPENDS)
	@${ECHO} -n 'This port requires package(s) "'
	@${ECHO} -n `${GREP} '^${PKGNAME}|' ${PORTSDIR}/INDEX | awk -F\| '{print $$9;}'`
	@${ECHO} '" to run.'
.endif
.endif

# Generate packing list.  Also tests to make sure all required package
# files exist.

.if !target(generate-plist)
generate-plist:
	@${ECHO_MSG} "===>   Generating temporary packing list"
	@${MKDIR} `dirname ${TMPPLIST}`
	@if [ ! -f ${PLIST} -o ! -f ${COMMENT} -o ! -f ${DESCR} ]; then ${ECHO} "** Missing package files for ${PKGNAME}."; exit 1; fi
	@>${TMPPLIST}
	@for man in ${__MANPAGES}; do \
		${ECHO} $${man} >> ${TMPPLIST}; \
	done
.for _PREFIX in ${PREFIX}
.if ${_TMLINKS:M${_PREFIX}*}x != x
	@for i in ${_TMLINKS:M${_PREFIX}*:S,^${_PREFIX}/,,}; do \
		${ECHO} "$$i" >> ${TMPPLIST}; \
	done
.endif
.if ${_TMLINKS:N${_PREFIX}*}x != x
	@${ECHO} @cwd / >> ${TMPPLIST}
	@for i in ${_TMLINKS:N${_PREFIX}*:S,^/,,}; do \
		${ECHO} "$$i" >> ${TMPPLIST}; \
	done
	@${ECHO} '@cwd ${PREFIX}' >> ${TMPPLIST}
.endif
.endfor
	@${SED} ${PLIST_SUB:S/$/!g/:S/^/ -e s!%%/:S/=/%%!/} ${PLIST} | \
	 ${SED} -e "/\@exec install-info.*$$/h" \
		-e "s^^\@exec [ -f %D/info/dir -o ! -f /usr/share/info/dir ] || sed -ne '1,/Menu:/p' /usr/share/info/dir > %D/info/dir^g" \
		-e "t fix" -e "b" -e ":fix" -e "G" >> ${TMPPLIST}
.if !defined(NO_FILTER_SHLIBS)
.if (${PORTOBJFORMAT} == "aout")
	@${SED} -e 's,\(/lib.*\.so\.[0-9]*\)$$,\1.0,' ${TMPPLIST} > ${TMPPLIST}.tmp
.else
	@${SED} -e 's,\(/lib.*\.so\.[0-9]*\)\.[0-9]*$$,\1,' ${TMPPLIST} > ${TMPPLIST}.tmp
.endif
	@${MV} -f ${TMPPLIST}.tmp ${TMPPLIST}
.endif
.endif

${TMPPLIST}:
	@cd ${.CURDIR} && ${MAKE} ${__softMAKEFLAGS} generate-plist

# Compress (or uncompress) and symlink manpages.
.if !target(compress-man)
compress-man:
.if ${MANCOMPRESSED} == yes && defined(NOMANCOMPRESS)
	@${ECHO_MSG} "===>   Uncompressing manual pages for ${PKGNAME}"
	@_manpages='${_MANPAGES:S/'/'\''/g}' && [ "$${_manpages}" != "" ] && ( eval ${GUNZIP_CMD} $${_manpages} ) || ${TRUE}
.elif ${MANCOMPRESSED} == no && !defined(NOMANCOMPRESS)
	@${ECHO_MSG} "===>   Compressing manual pages for ${PKGNAME}"
	@_manpages='${_MANPAGES:S/'/'\''/g}' && [ "$${_manpages}" != "" ] && ( eval ${GZIP_CMD} $${_manpages} ) || ${TRUE}
.endif
.if defined(_MLINKS)
	@set ${_MLINKS:S,"",,g:S,//,/,g}; \
	while :; do \
		[ $$# -eq 0 ] && break || ${TRUE}; \
		${RM} -f $${2%.gz}; ${RM} -f $$2.gz; \
		${LN} -fs `${ECHO} $$1 $$2 | ${AWK} '{ \
					z=split($$1, a, /\//); x=split($$2, b, /\//); \
					while (a[i] == b[i]) i++; \
					for (q=i; q<x; q++) printf "../"; \
					for (; i<z; i++) printf a[i] "/"; printf a[z]; }'` $$2; \
		shift; shift; \
	done
.endif
.endif

# Fake installation of package so that user can pkg_delete it later.
# Also, make sure that an installed port is recognized correctly in
# accordance to the @pkgdep directive in the packing lists

.if !target(fake-pkg)
fake-pkg:
	@if [ ! -d ${PKG_DBDIR} ]; then ${RM} -f ${PKG_DBDIR}; ${MKDIR} ${PKG_DBDIR}; fi
	@${RM} -f /tmp/${PKGNAME}-required-by
.if defined(FORCE_PKG_REGISTER)
	@if [ -e ${PKG_DBDIR}/${PKGNAME}/+REQUIRED_BY ]; then \
		${CP} ${PKG_DBDIR}/${PKGNAME}/+REQUIRED_BY /tmp/${PKGNAME}-required-by; \
	fi
	@${RM} -rf ${PKG_DBDIR}/${PKGNAME}
.endif
	@if [ ! -d ${PKG_DBDIR}/${PKGNAME} ]; then \
		${ECHO_MSG} "===>   Registering installation for ${PKGNAME}"; \
		${MKDIR} ${PKG_DBDIR}/${PKGNAME}; \
		${PKG_CMD} ${PKG_ARGS} -O ${PKGFILE} > ${PKG_DBDIR}/${PKGNAME}/+CONTENTS; \
		${CP} ${DESCR} ${PKG_DBDIR}/${PKGNAME}/+DESC; \
		${CP} ${COMMENT} ${PKG_DBDIR}/${PKGNAME}/+COMMENT; \
		if [ -f ${PKGINSTALL} ]; then \
			${CP} ${PKGINSTALL} ${PKG_DBDIR}/${PKGNAME}/+INSTALL; \
		fi; \
		if [ -f ${PKGDEINSTALL} ]; then \
			${CP} ${PKGDEINSTALL} ${PKG_DBDIR}/${PKGNAME}/+DEINSTALL; \
		fi; \
		if [ -f ${PKGREQ} ]; then \
			${CP} ${PKGREQ} ${PKG_DBDIR}/${PKGNAME}/+REQUIRE; \
		fi; \
		if [ -f ${PKGMESSAGE} ]; then \
			${CP} ${PKGMESSAGE} ${PKG_DBDIR}/${PKGNAME}/+DISPLAY; \
		fi; \
		for dep in `${MAKE} ${__softMAKEFLAGS} package-depends ECHO_MSG=/usr/bin/true | sort -u`; do \
			if [ -d ${PKG_DBDIR}/$$dep ]; then \
				if ! ${GREP} ^${PKGNAME}$$ ${PKG_DBDIR}/$$dep/+REQUIRED_BY \
					>/dev/null 2>&1; then \
					${ECHO} ${PKGNAME} >> ${PKG_DBDIR}/$$dep/+REQUIRED_BY; \
				fi; \
			fi; \
		done; \
	fi
	@if [ -e /tmp/${PKGNAME}-required-by ]; then \
		${CAT} /tmp/${PKGNAME}-required-by >> ${PKG_DBDIR}/${PKGNAME}/+REQUIRED_BY; \
		${RM} -f /tmp/${PKGNAME}-required-by; \
	fi
.endif

# Depend is generally meaningless for arbitrary ports, but if someone wants
# one they can override this.  This is just to catch people who've gotten into
# the habit of typing `make depend all install' as a matter of course.
#
.if !target(depend)
depend:
.endif

# Same goes for tags
.if !target(tags)
tags:
.endif

.if !defined(NOPRECIOUSMAKEVARS)
.for softvar in CKSUMFILES _MLINKS PKGBASE
.if defined(${softvar})
__softMAKEFLAGS+=      '${softvar}+=${${softvar}:S/'/'\''/g}'
.endif
.endfor
# These won't change, so we can pass them through the environment
.MAKEFLAGS: \
	ARCH="${ARCH:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	OPSYS="${OPSYS:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	OSREL="${OSREL:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	OSVERSION="${OSVERSION:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	PORTOBJFORMAT="${PORTOBJFORMAT:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	SYSTEMVERSION="${SYSTEMVERSION:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}"
.endif

.endif
# End of post-makefile section.