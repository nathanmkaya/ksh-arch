/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1985-2015 AT&T Intellectual Property          *
*                      and is licensed under the                       *
*                 Eclipse Public License, Version 1.0                  *
*                    by AT&T Intellectual Property                     *
*                                                                      *
*                A copy of the License is available at                 *
*          http://www.eclipse.org/org/documents/epl-v10.html           *
*         (with md5 checksum b35adb5213ca9657e911e9befb180842)         *
*                                                                      *
*              Information and Software Systems Research               *
*                            AT&T Research                             *
*                           Florham Park NJ                            *
*                                                                      *
*               Glenn Fowler <glenn.s.fowler@gmail.com>                *
*                    David Korn <dgkorn@gmail.com>                     *
*                     Phong Vo <phongvo@gmail.com>                     *
*                                                                      *
***********************************************************************/
/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libast/features/ndbm by iffe version 2013-11-14 : : */
#ifndef _def_ndbm_ast
#define _def_ndbm_ast	1
#define _sys_types	1	/* #include <sys/types.h> ok */
#define _LIB_db	1	/* -ldb is a library */
/* sleepycat ndbm compatibility */
#ifndef DB_DBM_HSEARCH
#define DB_DBM_HSEARCH	1
#include <db.h>
#endif
#define _use_ndbm	1

#endif
