
/* : : generated by proto : : */
/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1985-2011 AT&T Intellectual Property          *
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
                  
/*
 * Glenn Fowler
 * AT&T Research
 *
 * integral representation conversion support definitions
 * supports sizeof(integral_type)<=sizeof(intmax_t)
 */

#ifndef _SWAP_H
#if !defined(__PROTO__)
#include <prototyped.h>
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif

#define _SWAP_H

#include <ast_common.h>

#define int_swap	_ast_intswap

#define SWAP_MAX	8

#define SWAPOP(n)	(((n)&int_swap)^(n))

#if _BLD_ast && defined(__EXPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__		__EXPORT__
#endif

extern __MANGLE__ __V_*		swapmem __PROTO__((int, const __V_*, __V_*, size_t));
extern __MANGLE__ intmax_t		swapget __PROTO__((int, const __V_*, int));
extern __MANGLE__ __V_*		swapput __PROTO__((int, __V_*, int, intmax_t));
extern __MANGLE__ int		swapop __PROTO__((const __V_*, const __V_*, int));

#undef __MANGLE__
#define __MANGLE__ __LINKAGE__

#endif
