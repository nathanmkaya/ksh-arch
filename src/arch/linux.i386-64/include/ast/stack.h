
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
 * homogenous stack routine definitions
 */

#ifndef _STACK_H
#if !defined(__PROTO__)
#include <prototyped.h>
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif

#define _STACK_H

typedef struct stacktable* STACK;	/* stack pointer		*/
typedef struct stackposition STACKPOS;	/* stack position		*/

struct stackblock			/* stack block cell		*/
{
	__V_**		  stack;	/* actual stack			*/
	struct stackblock* prev;	/* previous block in list	*/
	struct stackblock* next;	/* next block in list		*/
};

struct stackposition			/* stack position		*/
{
	struct stackblock* block;	/* current block pointer	*/
	int		index;		/* index within current block	*/
};

struct stacktable			/* stack information		*/
{
	struct stackblock* blocks;	/* stack table blocks		*/
	__V_*		error;		/* error return value		*/
	int		size;		/* size of each block		*/
	STACKPOS	position;	/* current stack position	*/
};

/*
 * map old names to new
 */

#define mkstack		stackalloc
#define rmstack		stackfree
#define clrstack	stackclear
#define getstack	stackget
#define pushstack	stackpush
#define popstack	stackpop
#define posstack	stacktell

#if _BLD_ast && defined(__EXPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__		__EXPORT__
#endif

extern __MANGLE__ STACK		stackalloc __PROTO__((int, __V_*));
extern __MANGLE__ void		stackfree __PROTO__((STACK));
extern __MANGLE__ void		stackclear __PROTO__((STACK));
extern __MANGLE__ __V_*		stackget __PROTO__((STACK));
extern __MANGLE__ int		stackpush __PROTO__((STACK, __V_*));
extern __MANGLE__ int		stackpop __PROTO__((STACK));
extern __MANGLE__ void		stacktell __PROTO__((STACK, int, STACKPOS*));

#undef __MANGLE__
#define __MANGLE__ __LINKAGE__

#endif
