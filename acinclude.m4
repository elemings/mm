# ===========================================================================
#     https://www.gnu.org/software/autoconf-archive/ax_check_define.html
# ===========================================================================
#
# SYNOPSIS
#
#   AC_CHECK_DEFINE([symbol], [ACTION-IF-FOUND], [ACTION-IF-NOT])
#   AX_CHECK_DEFINE([includes],[symbol], [ACTION-IF-FOUND], [ACTION-IF-NOT])
#
# DESCRIPTION
#
#   Complements AC_CHECK_FUNC but it does not check for a function but for a
#   define to exist. Consider a usage like:
#
#    AC_CHECK_DEFINE(__STRICT_ANSI__, CFLAGS="$CFLAGS -D_XOPEN_SOURCE=500")
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 11

AU_ALIAS([AC_CHECK_DEFINED], [AC_CHECK_DEFINE])
AC_DEFUN([AC_CHECK_DEFINE],[
AS_VAR_PUSHDEF([ac_var],[ac_cv_defined_$1])dnl
AC_CACHE_CHECK([for $1 defined], ac_var,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]], [[
  #ifdef $1
  int ok;
  (void)ok;
  #else
  choke me
  #endif
]])],[AS_VAR_SET(ac_var, yes)],[AS_VAR_SET(ac_var, no)]))
AS_IF([test AS_VAR_GET(ac_var) != "no"], [$2], [$3])dnl
AS_VAR_POPDEF([ac_var])dnl
])

AU_ALIAS([AX_CHECK_DEFINED], [AX_CHECK_DEFINE])
AC_DEFUN([AX_CHECK_DEFINE],[
AS_VAR_PUSHDEF([ac_var],[ac_cv_defined_$2_$1])dnl
AC_CACHE_CHECK([for $2 defined in $1], ac_var,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <$1>]], [[
  #ifdef $2
  int ok;
  (void)ok;
  #else
  choke me
  #endif
]])],[AS_VAR_SET(ac_var, yes)],[AS_VAR_SET(ac_var, no)]))
AS_IF([test AS_VAR_GET(ac_var) != "no"], [$3], [$4])dnl
AS_VAR_POPDEF([ac_var])dnl
])

AC_DEFUN([AX_CHECK_FUNC],
[AS_VAR_PUSHDEF([ac_var], [ac_cv_func_$2])dnl
AC_CACHE_CHECK([for $2], ac_var,
dnl AC_LANG_FUNC_LINK_TRY
[AC_LINK_IFELSE([AC_LANG_PROGRAM([$1
                #undef $2
                char $2 ();],[
                char (*f) () = $2;
                return f != $2; ])],
                [AS_VAR_SET(ac_var, yes)],
                [AS_VAR_SET(ac_var, no)])])
AS_IF([test AS_VAR_GET(ac_var) = yes], [$3], [$4])dnl
AS_VAR_POPDEF([ac_var])dnl
])# AC_CHECK_FUNC

# ===========================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_check_enable_debug.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_CHECK_ENABLE_DEBUG([enable by default=yes/info/profile/no], [ENABLE DEBUG VARIABLES ...], [DISABLE DEBUG VARIABLES NDEBUG ...], [IS-RELEASE])
#
# DESCRIPTION
#
#   Check for the presence of an --enable-debug option to configure, with
#   the specified default value used when the option is not present.  Return
#   the value in the variable $ax_enable_debug.
#
#   Specifying 'yes' adds '-g -O0' to the compilation flags for all
#   languages. Specifying 'info' adds '-g' to the compilation flags.
#   Specifying 'profile' adds '-g -pg' to the compilation flags and '-pg' to
#   the linking flags. Otherwise, nothing is added.
#
#   Define the variables listed in the second argument if debug is enabled,
#   defaulting to no variables.  Defines the variables listed in the third
#   argument if debug is disabled, defaulting to NDEBUG.  All lists of
#   variables should be space-separated.
#
#   If debug is not enabled, ensure AC_PROG_* will not add debugging flags.
#   Should be invoked prior to any AC_PROG_* compiler checks.
#
#   IS-RELEASE can be used to change the default to 'no' when making a
#   release.  Set IS-RELEASE to 'yes' or 'no' as appropriate. By default, it
#   uses the value of $ax_is_release, so if you are using the AX_IS_RELEASE
#   macro, there is no need to pass this parameter.
#
#     AX_IS_RELEASE([git-directory])
#     AX_CHECK_ENABLE_DEBUG()
#
# LICENSE
#
#   Copyright (c) 2011 Rhys Ulerich <rhys.ulerich@gmail.com>
#   Copyright (c) 2014, 2015 Philip Withnall <philip@tecnocode.co.uk>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.

##serial 9

AC_DEFUN([AX_CHECK_ENABLE_DEBUG],[
    AC_BEFORE([$0],[AC_PROG_CC])dnl
    AC_BEFORE([$0],[AC_PROG_CXX])dnl
    AC_BEFORE([$0],[AC_PROG_F77])dnl
    AC_BEFORE([$0],[AC_PROG_FC])dnl

    AC_MSG_CHECKING(whether to enable debugging)

    ax_enable_debug_default=m4_tolower(m4_normalize(ifelse([$1],,[no],[$1])))
    ax_enable_debug_is_release=m4_tolower(m4_normalize(ifelse([$4],,
                                                              [$ax_is_release],
                                                              [$4])))

    # If this is a release, override the default.
    AS_IF([test "$ax_enable_debug_is_release" = "yes"],
      [ax_enable_debug_default="no"])

    m4_define(ax_enable_debug_vars,[m4_normalize(ifelse([$2],,,[$2]))])
    m4_define(ax_disable_debug_vars,[m4_normalize(ifelse([$3],,[NDEBUG],[$3]))])

    AC_ARG_ENABLE(debug,
        [AS_HELP_STRING([--enable-debug=]@<:@yes/info/profile/no@:>@,[compile with debugging])],
        [],enable_debug=$ax_enable_debug_default)

    # empty mean debug yes
    AS_IF([test "x$enable_debug" = "x"],
      [enable_debug="yes"])

    # case of debug
    AS_CASE([$enable_debug],
      [yes],[
        AC_MSG_RESULT(yes)
        CFLAGS="${CFLAGS} -g -O0"
        CXXFLAGS="${CXXFLAGS} -g -O0"
        FFLAGS="${FFLAGS} -g -O0"
        FCFLAGS="${FCFLAGS} -g -O0"
        OBJCFLAGS="${OBJCFLAGS} -g -O0"
      ],
      [info],[
        AC_MSG_RESULT(info)
        CFLAGS="${CFLAGS} -g"
        CXXFLAGS="${CXXFLAGS} -g"
        FFLAGS="${FFLAGS} -g"
        FCFLAGS="${FCFLAGS} -g"
        OBJCFLAGS="${OBJCFLAGS} -g"
      ],
      [profile],[
        AC_MSG_RESULT(profile)
        CFLAGS="${CFLAGS} -g -pg"
        CXXFLAGS="${CXXFLAGS} -g -pg"
        FFLAGS="${FFLAGS} -g -pg"
        FCFLAGS="${FCFLAGS} -g -pg"
        OBJCFLAGS="${OBJCFLAGS} -g -pg"
        LDFLAGS="${LDFLAGS} -pg"
      ],
      [
        AC_MSG_RESULT(no)
        dnl Ensure AC_PROG_CC/CXX/F77/FC/OBJC will not enable debug flags
        dnl by setting any unset environment flag variables
        AS_IF([test "x${CFLAGS+set}" != "xset"],
          [CFLAGS=""])
        AS_IF([test "x${CXXFLAGS+set}" != "xset"],
          [CXXFLAGS=""])
        AS_IF([test "x${FFLAGS+set}" != "xset"],
          [FFLAGS=""])
        AS_IF([test "x${FCFLAGS+set}" != "xset"],
          [FCFLAGS=""])
        AS_IF([test "x${OBJCFLAGS+set}" != "xset"],
          [OBJCFLAGS=""])
      ])

    dnl Define various variables if debugging is disabled.
    dnl assert.h is a NOP if NDEBUG is defined, so define it by default.
    AS_IF([test "x$enable_debug" = "xyes"],
      [m4_map_args_w(ax_enable_debug_vars, [AC_DEFINE(], [,[1],[Define if debugging is enabled])])],
      [m4_map_args_w(ax_disable_debug_vars, [AC_DEFINE(], [,[1],[Define if debugging is disabled])])])
    ax_enable_debug=$enable_debug
])

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

define(AC_CONFIGURE_PART,[dnl
AC_MSG_RESULT()
AC_MSG_RESULT(${T_MD}$1:${T_ME})
])dnl

undefine([AC_CHECK_DEFINE])
define([AC_CHECK_DEFINE],[dnl
  AX_CHECK_DEFINE([$2], [$1],
    [AC_DEFINE(HAVE_$1, 1, [define to 1 if you have the $1 define])])
])dnl

define(AC_IFALLYES,[dnl
ac_rc=yes
for ac_spec in $1; do
    ac_type=`echo "$ac_spec" | sed -e 's/:.*$//'`
    ac_item=`echo "$ac_spec" | sed -e 's/^.*://'`
    case $ac_type in
        header )
            ac_item=`echo "$ac_item" | sed 'y%./+-%__p_%'`
            ac_var="ac_cv_header_$ac_item"
            ;;
        file )
            ac_item=`echo "$ac_item" | sed 'y%./+-%__p_%'`
            ac_var="ac_cv_file_$ac_item"
            ;;
        func )   ac_var="ac_cv_func_$ac_item"   ;;
        define ) ac_var="ac_cv_define_$ac_item" ;;
        custom ) ac_var="$ac_item" ;;
    esac
    eval "ac_val=\$$ac_var"
    if test ".$ac_val" != .yes; then
        ac_rc=no
        break
    fi
done
if test ".$ac_rc" = .yes; then
    :
    $2
else
    :
    $3
fi
])dnl

define(AC_BEGIN_DECISION,[dnl
ac_decision_item='$1'
ac_decision_msg='FAILED'
ac_decision=''
])dnl
define(AC_DECIDE,[dnl
ac_decision='$1'
ac_decision_msg='$2'
ac_decision_$1=yes
ac_decision_$1_msg='$2'
])dnl
define(AC_DECISION_OVERRIDE,[dnl
    ac_decision=''
    for ac_item in $1; do
         eval "ac_decision_this=\$ac_decision_${ac_item}"
         if test ".$ac_decision_this" = .yes; then
             ac_decision=$ac_item
             eval "ac_decision_msg=\$ac_decision_${ac_item}_msg"
         fi
    done
])dnl
define(AC_DECISION_FORCE,[dnl
ac_decision="$1"
eval "ac_decision_msg=\"\$ac_decision_${ac_decision}_msg\""
])dnl
define(AC_END_DECISION,[dnl
if test ".$ac_decision" = .; then
    echo "[$]0:Error: decision on $ac_decision_item failed" 1>&2
    exit 1
else
    if test ".$ac_decision_msg" = .; then
        ac_decision_msg="$ac_decision"
    fi
    AC_MSG_RESULT([decision on $ac_decision_item... $ac_decision_msg])
fi
])dnl

define(AC_CHECK_MAXSEGSIZE,[dnl
AC_MSG_CHECKING(for shared memory maximum segment size)
AC_CACHE_VAL(ac_cv_maxsegsize,[
OCFLAGS="$CFLAGS"
case "$1" in
    MM_SHMT_MM*    ) CFLAGS="-DTEST_MMAP   $CFLAGS" ;;
    MM_SHMT_IPCSHM ) CFLAGS="-DTEST_SHMGET $CFLAGS" ;;
esac
cross_compile=no
AC_TRY_RUN(
changequote(<<, >>)dnl
<<
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>
#ifdef TEST_MMAP
#include <sys/mman.h>
#endif
#ifdef TEST_SHMGET
#ifdef MM_OS_SUNOS
#define KERNEL 1
#endif
#ifdef MM_OS_BS2000
#define _KMEMUSER
#endif
#include <sys/ipc.h>
#include <sys/shm.h>
#ifdef MM_OS_SUNOS
#undef KERNEL
#endif
#ifdef MM_OS_BS2000
#undef _KMEMUSER
#endif
#if !defined(SHM_R)
#define SHM_R 0400
#endif
#if !defined(SHM_W)
#define SHM_W 0200
#endif
#endif
#if !defined(MAP_FAILED)
#define MAP_FAILED ((void *)(-1))
#endif
#ifdef MM_OS_BEOS
#include <kernel/OS.h>
#endif

int testit(int size)
{
    int fd;
    void *segment;
#ifdef TEST_MMAP
    char file[] = "./ac_test.tmp";
    unlink(file);
    if ((fd = open(file, O_RDWR|O_CREAT, S_IRUSR|S_IWUSR)) == -1)
        return 0;
    if (ftruncate(fd, size) == -1)
        return 0;
    if ((segment = (void *)mmap(NULL, size, PROT_READ|PROT_WRITE,
                                MAP_SHARED, fd, 0)) == (void *)MAP_FAILED) {
        close(fd);
        return 0;
    }
    munmap((caddr_t)segment, size);
    close(fd);
    unlink(file);
#endif
#ifdef TEST_SHMGET
    if ((fd = shmget(IPC_PRIVATE, size, SHM_R|SHM_W|IPC_CREAT)) == -1)
        return 0;
    if ((segment = (void *)shmat(fd, NULL, 0)) == ((void *)-1)) {
        shmctl(fd, IPC_RMID, NULL);
        return 0;
    }
    shmdt(segment);
    shmctl(fd, IPC_RMID, NULL);
#endif
#ifdef TEST_BEOS
    area_id id;
    id = create_area("mm_test", (void*)&segment, B_ANY_ADDRESS, size,
                     B_LAZY_LOCK, B_READ_AREA|B_WRITE_AREA);
    if (id < 0)
        return 0;
    delete_area(id);
#endif
    return 1;
}

#define ABS(n) ((n) >= 0 ? (n) : (-(n)))

int main(int argc, char *argv[])
{
    int t, m, b;
    int d;
    int rc;
    FILE *f;

    /*
     * Find maximum possible allocation size by performing a
     * binary search starting with a search space between 0 and
     * 64MB of memory.
     */
    t = 1024*1024*64 /* = 67108864 */;
    if (testit(t))
        m = t;
    else {
        m = 1024*1024*32;
        b = 0;
        for (;;) {
            /* fprintf(stderr, "t=%d, m=%d, b=%d\n", t, m, b); */
            rc = testit(m);
            if (rc) {
                d = ((t-m)/2);
                b = m;
            }
            else {
                d = -((m-b)/2);
                t = m;
            }
            if (ABS(d) < 1024*1) {
                if (!rc)
                    m = b;
                break;
            }
            if (m < 1024*8)
                break;
            m += d;
        }
        if (m < 1024*8)
            m = 0;
    }
    if ((f = fopen("conftestval", "w")) == NULL)
        exit(1);
    fprintf(f, "%d\n", m);
    fclose(f);
    exit(0);
}
>>
changequote([, ])dnl
,[ac_cv_maxsegsize="`cat conftestval`"
],
ac_cv_maxsegsize=0
,
ac_cv_maxsegsize=0
)
CFLAGS="$OCFLAGS"
])
msg="$ac_cv_maxsegsize"
if test $msg -eq 67108864; then
    msg="64MB (soft limit)"
elif test $msg -gt 1048576; then
    msg="`expr $msg / 1024`"
    msg="`expr $msg / 1024`"
    msg="${msg}MB"
elif test $msg -gt 1024; then
    msg="`expr $msg / 1024`"
    msg="${msg}KB"
else
    ac_cv_maxsegsize=0
    msg=unknown
fi
MM_SHM_MAXSEGSIZE=$ac_cv_maxsegsize
test ".$msg" = .unknown && AC_MSG_ERROR([Unable to determine maximum shared memory segment size])
AC_MSG_RESULT([$msg])
AC_DEFINE_UNQUOTED(MM_SHM_MAXSEGSIZE, $MM_SHM_MAXSEGSIZE, [maximum segment size])
])

