# $FreeBSD: src/share/mk/bsd.kmod.mk,v 1.75.2.3 2001/05/18 19:42:32 jlemon Exp $

# Search for kernel source tree in standard places.
.for _dir in ${.CURDIR}/../.. ${.CURDIR}/../../.. ${.CURDIR}/../../../.. /sys /usr/src/sys
.if !defined(SYSDIR) && exists(${_dir}/conf/kmod.mk)
SYSDIR=	${_dir}
.endif
.endfor
.if !defined(SYSDIR) || !exists(${SYSDIR}/kern) || !exists(${SYSDIR}/conf/)
.error "can't find kernel source tree"
.endif

.include "${SYSDIR}/conf/kmod.mk"
