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
/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libast/features/api by iffe version 2013-11-14 : : */
#define _sys_types	1	/* #include <sys/types.h> ok */
#define _AST_VERSION AST_VERSION /* pre-20100601 compatibility */

#define AST_VERSION	20131127
#define ASTAPI(rel)	( _BLD_ast || !_API_ast || _API_ast >= rel )

#ifndef _AST_API_IMPLEMENT
#define _AST_API_IMPLEMENT	1


#if !defined(_API_ast) && defined(_API_DEFAULT)
#define _API_ast	_API_DEFAULT
#endif

#if ASTAPI(20120411)
#undef	cmdopen
#define cmdopen	cmdopen_20120411
#elif _API_ast >= 20110505
#undef	cmdopen
#define cmdopen	cmdopen_20110505
#endif

#if ASTAPI(20130509)
#undef	memfatal
#define memfatal	memfatal_20130509
#endif

#if ASTAPI(20100601)
#undef	pathaccess
#define pathaccess	pathaccess_20100601
#endif

#if ASTAPI(20100601)
#undef	pathcanon
#define pathcanon	pathcanon_20100601
#endif

#if ASTAPI(20100601)
#undef	pathcat
#define pathcat	pathcat_20100601
#endif

#if ASTAPI(20100601)
#undef	pathkey
#define pathkey	pathkey_20100601
#endif

#if ASTAPI(20100601)
#undef	pathpath
#define pathpath	pathpath_20100601
#endif

#if ASTAPI(20100601)
#undef	pathprobe
#define pathprobe	pathprobe_20100601
#endif

#if ASTAPI(20100601)
#undef	pathrepl
#define pathrepl	pathrepl_20100601
#endif

#if ASTAPI(20120528)
#undef	regexec
#define regexec	regexec_20120528
#endif

#if ASTAPI(20120528)
#undef	regnexec
#define regnexec	regnexec_20120528
#endif

#if ASTAPI(20120528)
#undef	regrexec
#define regrexec	regrexec_20120528
#endif

#if ASTAPI(20120528)
#undef	regsubexec
#define regsubexec	regsubexec_20120528
#endif

#if ASTAPI(20000308)
#undef	sfkeyprintf
#define sfkeyprintf	sfkeyprintf_20000308
#endif

#if ASTAPI(20120528)
#undef	strgrpmatch
#define strgrpmatch	strgrpmatch_20120528
#endif

#define _API_ast_MAP	"cmdopen_20120411 cmdopen_20110505 memfatal_20130509 pathaccess_20100601 pathcanon_20100601 pathcat_20100601 pathkey_20100601 pathpath_20100601 pathprobe_20100601 pathrepl_20100601 regexec_20120528 regnexec_20120528 regrexec_20120528 regsubexec_20120528 sfkeyprintf_20000308 strgrpmatch_20120528"

#endif

