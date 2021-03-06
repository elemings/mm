## ====================================================================
## Copyright (c) 1999-2006 Ralf S. Engelschall <rse@engelschall.com>
## Copyright (c) 1999-2006 The OSSP Project <http://www.ossp.org/>
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
##
## 1. Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in
##    the documentation and/or other materials provided with the
##    distribution.
##
## 3. All advertising materials mentioning features or use of this
##    software must display the following acknowledgment:
##    "This product includes software developed by
##     Ralf S. Engelschall <rse@engelschall.com>."
##
## 4. Redistributions of any form whatsoever must retain the following
##    acknowledgment:
##    "This product includes software developed by
##     Ralf S. Engelschall <rse@engelschall.com>."
##
## THIS SOFTWARE IS PROVIDED BY RALF S. ENGELSCHALL ``AS IS'' AND ANY
## EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
## PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL RALF S. ENGELSCHALL OR
## ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
## NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
## LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
## HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
## OF THE POSSIBILITY OF SUCH DAMAGE.
## ====================================================================

ACLOCAL_AMFLAGS = -I m4

SHTOOL = @SHTOOL@

include_HEADERS = mm.h

lib_LTLIBRARIES = libmm.la

libmm_la_SOURCES = \
	mm_alloc.c \
	mm_core.c \
	mm_global.c \
	mm_lib.c \
	mm_vers.c
libmm_la_LDFLAGS = \
	-version-info `$(SHTOOL) version -l c -d libtool $(srcdir)/mm_vers.c`

mm_lib.lo: $(srcdir)/mm_vers.c
$(srcdir)/mm_vers.c: $(srcdir)/configure.ac
	-chmod u+w $@ 2>/dev/null
	cd $(srcdir) && \
	$(SHTOOL) version -l c -n "OSSP mm" -s $(PACKAGE_VERSION) -p mm_ `basename $@`

TESTS = mm_test
check_PROGRAMS = mm_test
mm_test_LDADD = libmm.la

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = mm.pc

EXTRA_DIST = \
	LICENSE \
	PORTING \
	autogen.sh \
	$(SHTOOL) \
	mm.pod

mm.3: $(srcdir)/mm.pod
	V1=`$(SHTOOL) version -l c -d short $(srcdir)/mm_vers.c`; \
	V2=`$(SHTOOL) version -l c -d long $(srcdir)/mm_vers.c`; \
	D=`$(SHTOOL) version -l c -d long $(srcdir)/mm_vers.c | sed -e 's;.*(;;' -e 's;).*;;'`; \
	pod2man --section=3 --center="Shared Memory Library" --release="$$D" --date="MM $$V1" $^ |\
	perl -p -e 's;^(\\\&\s+.+?)([Mm][Mm]_[a-zA-Z0-9_]+)(\(.+?)$$;$$1\\fB$$2\\fR$$3;' |\
	sed -e "s;MM_VERSION_STR;$$V2;" > $@

man_MANS = mm.3

DISTCLEANFILES = mm.3

# The default behavior generated by automake for this target is to
# simply display a warning.  Override this target to actually check
# for the required tools and exit if they are not present before
# cleaning the files.

MAINTAINERCLEANFILES = \
	$(aux_srcdir) \
	$(srcdir)/Makefile.in \
	$(srcdir)/aclocal.m4 \
	$(srcdir)/config.h.in \
	$(srcdir)/configure \
	$(srcdir)/m4 \
	$(srcdir)/mm_vers.c

maintainer-clean-generic:
	@if libtoolize --version </dev/null >/dev/null 2>&1 && \
	    $(AUTOMAKE) --version </dev/null >/dev/null 2>&1 && \
	    $(AUTOCONF) --version </dev/null >/dev/null 2>&1; then \
	  true; \
	else \
	  echo "This command is intended for maintainers to use"; \
	  echo "it deletes files that may require special tools to rebuild."; \
	  exit 1; \
	fi

maintainer-clean-local:
	-$(RM) -r $(MAINTAINERCLEANFILES)

