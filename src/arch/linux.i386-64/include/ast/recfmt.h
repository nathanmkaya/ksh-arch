
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
 * record format interface
 */

#ifndef _RECFMT_H
#if !defined(__PROTO__)
#include <prototyped.h>
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif

#define _RECFMT_H		1

#include <ast.h>

typedef uint32_t Recfmt_t;

#define REC_delimited		0
#define REC_fixed		1
#define REC_variable		2
#define REC_method		14
#define REC_none		15

#define REC_M_path		0
#define REC_M_data		1

#define RECTYPE(f)		(((f)>>28)&((1<<4)-1))

#define REC_D_TYPE(d)		((REC_delimited<<28)|((d)&((1<<8)-1)))
#define REC_D_DELIMITER(f)	((f)&((1<<8)-1))

#define REC_F_TYPE(s)		((REC_fixed<<28)|((s)&((1<<28)-1)))
#define REC_F_SIZE(f)		((f)&((1<<28)-1))

#define REC_U_TYPE(t,a)		(((t)<<28)|((a)&((1<<28)-1)))
#define REC_U_ATTRIBUTES(f)	((f)&~((1<<28)-1))

#define REC_V_TYPE(h,o,z,l,i)	((REC_variable<<28)|((h)<<23)|((o)<<19)|(((z)-1)<<18)|((l)<<17)|((i)<<16))
#define REC_V_RECORD(f,s)	(((f)&(((1<<16)-1)<<16))|(s))
#define REC_V_HEADER(f)		(((f)>>23)&((1<<5)-1))
#define REC_V_OFFSET(f)		(((f)>>19)&((1<<4)-1))
#define REC_V_LENGTH(f)		((((f)>>18)&1)+1)
#define REC_V_LITTLE(f)		(((f)>>17)&1)
#define REC_V_INCLUSIVE(f)	(((f)>>16)&1)
#define REC_V_SIZE(f)		((f)&((1<<16)-1))
#define REC_V_ATTRIBUTES(f)	((f)&~((1<<16)-1))

#define REC_M_TYPE(i)		((REC_method<<28)|(i))
#define REC_M_INDEX(f)		((f)&((1<<28)-1))

#define REC_N_TYPE()		0xffffffff

#if _BLD_ast && defined(__EXPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__		__EXPORT__
#endif

extern __MANGLE__ char*		fmtrec __PROTO__((Recfmt_t, int));
extern __MANGLE__ Recfmt_t		recfmt __PROTO__((const __V_*, size_t, off_t));
extern __MANGLE__ Recfmt_t		recstr __PROTO__((const char*, char**));
extern __MANGLE__ ssize_t		reclen __PROTO__((Recfmt_t, const __V_*, size_t));

#undef __MANGLE__
#define __MANGLE__ __LINKAGE__

#endif