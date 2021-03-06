/*-
 * Copyright (c) 2002 Juli Mallett.
 * Copyright (c) 1988, 1989, 1990, 1993
 *	The Regents of the University of California.  All rights reserved.
 * Copyright (c) 1989 by Berkeley Softworks
 * All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Adam de Boor.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $FreeBSD: src/usr.bin/make/var.h,v 1.1 2002/10/28 23:33:57 jmallett Exp $
 */

typedef struct Var {
    char          *name;	/* the variable's name */
    Buffer	  val;	    	/* its value */
    int	    	  flags;    	/* miscellaneous status flags */
#define	VAR_IN_USE	1   	    /* Variable's value currently being used.
				     * Used to avoid recursion */
#define	VAR_FROM_ENV	2   	    /* Variable comes from the environment */
#define	VAR_JUNK  	4   	    /* Variable is a junk variable that
				     * should be destroyed when done with
				     * it. Used by Var_Parse for undefined,
				     * modified variables */
} Var;

/* Var*Pattern flags */
#define	VAR_SUB_GLOBAL	0x01	/* Apply substitution globally */
#define	VAR_SUB_ONE	0x02	/* Apply substitution to one word */
#define	VAR_SUB_MATCHED	0x04	/* There was a match */
#define	VAR_MATCH_START	0x08	/* Match at start of word */
#define	VAR_MATCH_END	0x10	/* Match at end of word */
#define	VAR_NOSUBST	0x20	/* don't expand vars in VarGetPattern */

typedef struct {
    char    	  *lhs;	    /* String to match */
    int	    	  leftLen;  /* Length of string */
    char    	  *rhs;	    /* Replacement string (w/ &'s removed) */
    int	    	  rightLen; /* Length of replacement */
    int	    	  flags;
} VarPattern;

typedef struct { 
    regex_t	   re; 
    int		   nsub;
    regmatch_t	  *matches;
    char	  *replace;
    int		   flags;
} VarREPattern;

/*
 * var.c
 */
void VarREError(int, regex_t *, const char *);

/*
 * var_modify.c
 */
Boolean VarHead(const char *, Boolean, Buffer, void *);
Boolean VarTail(const char *, Boolean, Buffer, void *);
Boolean VarSuffix(const char *, Boolean, Buffer, void *);
Boolean VarRoot(const char *, Boolean, Buffer, void *);
Boolean VarMatch(const char *, Boolean, Buffer, void *);
#ifdef SYSVVARSUB
Boolean VarSYSVMatch(const char *, Boolean, Buffer, void *);
#endif
Boolean VarNoMatch(const char *, Boolean, Buffer, void *);
Boolean VarRESubstitute(const char *, Boolean, Buffer, void *);
Boolean VarSubstitute(const char *, Boolean, Buffer, void *);
