make (AT&T Research) 5.7 2013-08-11   ÕHo                                                                           ©        (IFFE)   ( ®È³w¡æ¢¡F()cmd/coshell ®È³w©        (YACC)  ©        
(M4FLAGS)          .STATE  ©        (MSGCCFLAGS)  À       cmd  À       lib   ( ®È³xÄ§Ím()cmd/dsslib ®È³x (  ®È³uàà¸Zàà¸Z().PROBE.INITlocal I J K
if "$(.COMMAND.CC:N=$(CC))"
	if ! "$(PATH:/:/ /G:X=$(CC):P=X)"
		for I $(.COMMAND.CC:N!=$(CC))
			if "$(PATH:/:/ /G:X=$(I):P=X)"
				CC := $(I)
				break
			end
		end
	end
end
$(.PROBE.SPECIAL.) : -FUNCTIONAL
if "$(-base)" || ! "$(CC)" || "$(-cctype)" == "[-0]"
	set cctype:=0
	.CC.PROBE. =
else
	if ! "$(-cctype)"
		set cctype:="$(CC:N!=*=*)"
		if ! "$(-cctype)"
			set cctype:=cc
		end
	end
	I := $(-cctype:O=1:P=C) $(-cctype:O>1)
	set cctype:="$(I)"
	if ! ( .CC.PROBE. = "$(CC.PROBE)" )
		.CC.PROBE. := $(-cctype|"cc":@P=P=C)
	end
	.CC.PROBE. : .VIRTUAL $(.CC.PROBE.)
	$(.CC.PROBE.) : .SPECIAL .ACCEPT .DONTCARE
	(AR) (AS) (CPP) (CC) (LD) : .CC.PROBE.
	if .CC.PROBE.
		include "$(.CC.PROBE.)"
		if ! "$(CC.HOSTTYPE)"
			CC.HOSTTYPE := $(_hosttype_)
		end
	else
		if "$(-cctype)"
			error 1 $(-cctype): C probe failed -- default assumed
		end
		if ! CC.STDINCLUDE
			CC.STDINCLUDE = /usr/include
		end
		if ! CC.MAKE.OPTIONS
			CC.MAKE.OPTIONS = nativepp=-1
		end
	end
end
if CC.MAKE.OPTIONS
	set $(CC.MAKE.OPTIONS)
end
$(CC.LD.DYNAMIC) $(CC.LD.STATIC) : .MULTIPLE .ARCHIVE .IGNORE .DO.NOTHING
if ! CC.SUFFIX.ARCHIVE
	CC.SUFFIX.ARCHIVE = .a
end
.ATTRIBUTE.%$(CC.SUFFIX.ARCHIVE) : .ARCHIVE
if CC.SUFFIX.STATIC
	.ATTRIBUTE.%$(CC.SUFFIX.STATIC) : .ARCHIVE
end
if CC.SUFFIX.DYNAMIC && CC.SUFFIX.SHARED
	.ATTRIBUTE.%$(CC.SUFFIX.SHARED) : .ARCHIVE .SCAN.IGNORE
	.SOURCE.%$(CC.SUFFIX.SHARED) : .FORCE $$(*.SOURCE.%.ARCHIVE)
end
if ! CC.SUFFIX.OBJECT
	CC.SUFFIX.OBJECT = .o
end
if ! CC.STDLIB.BASE
	CC.STDLIB.BASE := $(CC.STDLIB:N=?(/usr)/lib?(64):B) lib
	CC.STDLIB.BASE := $(CC.STDLIB.BASE:U)
end
if CCSPECIALIZE
	CC.OPTIMIZE := $(CCSPECIALIZE)
end
.ATTRIBUTE.%$(CC.SUFFIX.OBJECT) : .OBJECT
if CC.SHARED.REGISTRY
	CC.SHARED += $$(.CC.SHARED.REGISTRY.)
end
if CC.SHARED.NAME
	CC.SHARED += $$(.CC.SHARED.NAME.)
end
if "$(-mam:N=static*,port*)"
	.NO.LIB.TYPE = 1
end
if ! .NO.LIB.TYPE && "$(-lib-type)"
	I :=
	J :=
	if "$(-instrument)"
		I := $(-instrument:B:/\(...\).*/-\1/)
	end
	if "$(-threads)"
		J := t$(J)
	end
	if "$(-debug-symbols)" || "$(CCFLAGS:N=$(CC.DEBUG))" && ! "$(CCFLAGS:N=-O*|$(CC.OPTIMIZE))"
		J := $(J)g
	end
	if ! "$(J)"
		if K = "$(CCFLAGS:N=-p|-pg)"
			J := $(K:O=1:/-//)
		elif K = "$(LDFLAGS:N=-O[1-9])"
			J := $(K:O=1:/-//)
		end
	end
	if J
		J := -$(J)
	end

	



	for K $(...:T=XQSV:N=\(*FLAGS\):/[()]//G)
		if "$($(K)_DEFAULT:V)"
			$(K) := $$($(K)_DEFAULT) $($(K):V)
		end
	end
	CC.LIB.TYPE := $(I)$(J)
end
.REQUIRE.$(CC.PREFIX.ARCHIVE)%$(CC.SUFFIX.ARCHIVE) : .FUNCTION
	if "$(%:N=-l*)"
		return $(.REQUIRE.-l% $(%))
	elif "$(%:N=+l*)"
		return $(.REQUIRE.+l% $(%))
	elif ! "$(%:A=.TARGET)" && CC.PREFIX.ARCHIVE && "$(%:B:S:N=$(CC.PREFIX.ARCHIVE)*.$(CC.SUFFIX.ARCHIVE))"
		return $(.REQUIRE.-l% -l$(%:B:S:/^$(CC.PREFIX.ARCHIVE)//:/$(CC.SUFFIX.ARCHIVE)$//:/$(CC.LIB.TYPE)$//))
	end









if "$(_MAKE_PROBE_WORKAROUND_)"
	local I
	for I $(_MAKE_PROBE_WORKAROUND_)
		eval
		$(I)
		end
	end
end
include - + pkg-default.mk®È³u ( ®È³wóÈJõ¸#()lib/libcs ®È³wÀ       lib/libcmd  ¨       (ERROR_CATALOG)  ©        (LDSHARED)   (   ®È³x¤Ì¤Ì().CC.LD.RUNPATH.[if "$(LDRUNPATH)" && CC.LD.RUNPATH && "$(CC.DIALECT:N=DYNAMIC)" && ( "$(CCLDFLAGS:V:N=$(CC.DYNAMIC)|$\(CC.DYNAMIC\))" || ! "$(CCLDFLAGS:V:N=$(CC.STATIC)|$\(CC.STATIC\))" )
	local T
	T := $(LDRUNPATH:N!=.) $(*.SOURCE.%.ARCHIVE:I=$$(**:N=-l*:P=D):N!=.:$(.CC.NOSTDLIB.):P=A:N!=$(LIBDIR))
	if T = "$(T:@/ /:/G)"
		return $(CC.LD.RUNPATH)$(T)
	end
end®È³x (   ®È³x£òÍ£òÍ().PACKAGE.LIBRARY.Elocal P R
if ! ( P = "$(<:T=M:A=.COMMAND:O=1)" )
	P := $(<:T=M:B:S:N=$(CC.PREFIX.ARCHIVE)*$(CC.SUFFIX.ARCHIVE)|$(CC.PREFIX.SHARED)*$(CC.SUFFIX.SHARED)*:O=1)
end
if P
	if R = "$(.PACKAGE.$(%).library.$(P))"
		return $(R)
	end
	if R = "$(.PACKAGE.$(%).library.weak.$(P))"
		return $(R)
	end
end
return $(.PACKAGE.$(%).library)®È³xÀ       cmd/paxlib   ( 
®È³wÊºÔKËÜËQ()lib/libdll ®È³w       .ATTRIBUTE          ().FLAGSINIT  À        .ALL  ©        (LEX)  À       
cmd/ksh93  À        .CC.PROBE.   (   ®È³ußò×*ßò×*().OPTION.COMPATIBILITYlocal N O
if .MAKEVERSION. < 20150101
	O =
	N =
	if ! "$(-?clobber)" && "$("clobber":T=QV)"
		O += clobber=$(clobber)
		if clobber == "1"
			N += --clobber
		elif clobber == "0"
			N += --noclobber
		else
			N += --clobber=$(clobber)
		end
	end
	if ! "$(-?compare)" && "$("compare":T=QV)"
		O += compare=$(compare)
		if compare
			N += --compare
		else
			N += --nocompare
		end
	end
	if ! "$(-?debug-symbols)" && "$("debug":T=QV)"
		O += debug=$(debug)
		if debug
			N += --debug-symbols
		else
			N += --nodebug-symbols
		end
	end
	if ! "$(-?instrument)" && "$("instrument":T=QV)"
		O += instrument=$(instrument)
		if instrument != ""
			N += --instrument=$(instrument)
		else
			N += --noinstrument
		end
	end
	if ! "$(-?link)" && "$("link":T=QV)"
		O += link=$(link)
		if link == "1"
			N += --link
		elif link == "0"
			N += --nolink
		else
			N += --link=$(link)
		end
	end
	if ! "$(-?prefix-include)" && "$("prefixinclude":T=QV)"
		O += prefixinclude=$(prefixinclude)
		if prefixinclude
			N += --prefix-include
		else
			N += --noprefix-include
		end
	end
	if ! "$(-?static-link)" && "$("static":T=QV)"
		O += static=$(static)
		if static
			N += --static-link
		else
			N += --nostatic-link
		end
	end
	if N
		set $(N)
		if .MAKEVERSION. >= 20050701
			error 1 $(O): obsolete: use $(N)
		end
	end
end®È³u (   ®È³xíÿríÿr().RECURSE.FLUSHunbind $(<<)®È³x (   ®È³x¯@¯@().RECURSE.ARGS."local A L V
L = .TARGET
for A $(.ORIGINAL.ARGS.)
	if ! "$(A:A=.TARGET)" && ( T = "$(A:/.*/.&/U:A=$(L))" )
		A := $(T)
	else
		L = .ONOBJECT
	end
	if "$(A:A!=.ACTIVE:N!=.RECURSE)" || "$(A:A=.ONOBJECT)"
		V += $(A)
	end
end
if V && "$(~.ARGS:A=.ONOBJECT)"
	V := .RECURSE $(V)
end
return $(V)®È³x (  ®È³¨ÝåH¨ÝåH().BELIEVEClocal A O
set ignorelock keepgoing touch
make .INSTALL
set notouch
for A $(...:A=.TARGET:A=.ARCHIVE.o)
	O += $(*$(A):N=*$(CC.SUFFIX.OBJECT):T=F)
end
if "$(O)"
	make { $(RM) $(RMFLAGS) $(O) }
end®È³À        	.RECURSE   ( ®È³uù£´@úf()cmd/INIT ®È³ué       (CC)  ©        (YACCFLAGS)       ®È³¨¨¿l ().RECURSE.DIRkset -
if	$(*.VIEW:O=2:N=...:+2d) test -d $(<) $(-virtual:+|| $(MKDIR) $(<))
then	$(-silent:~echo $$(-recurse-enter) $$(.RWD.:+$$$(<:N!=/*:+$$$$(.RWD.)/))$$(<)$$(":") >&2)
	cd $(<)
	$(MAKE) $(-) --errorid=$(<:Q) $(=:V:N!=MAKEPATH=*|VPATH=*) .RWD.=$(.RWD.:C%$%/%)$(<) $(.RECURSE.OPTIONS.) $(.ORIGINAL.ARGS.)
	$(-recurse-leave:+$$(-silent:~echo $$$(-recurse-leave) $$$(.RWD.:+$$$$(<:N!=/*:+$$$$$(.RWD.)/))$$$(<)$$$(":") >&2))
else	echo $(<): warning: cannot recurse on virtual directory >&2
fi À        .RECURSE.DIR  À       cmd/msggen  é       (LD)  À        .NORECURSE.DIR  ©        (PROTO)  ©        (SHELLMAGIC)   ( ®È³w¥|¦ï()lib/libcmd ®È³w©        
(ASFLAGS)   ( ®È³x÷èÓjø³.()cmd/paxlib ®È³xÀ       lib/libast  ©        (COATTRIBUTES)        .SCAN   (  ®È³ªÇèYªÇèY()-®È³é       (AR)  ©        (F77)  ©        
(LDFLAGS)   (  ®È³uá¾Uá¾U().MAKEINITÝUlocal A T1 T2 T3 T4 T5 T6 TI







.SOURCE.mk : .CLEAR . $(*.SOURCE.mk:N!=$(*.SOURCE.mk.INTERNAL:/ /|/G)) $(*.SOURCE.mk.INTERNAL)
.MAKE : .PROBE.INIT
if "$(-instrument)"
	if ! ( instrument.root = "$(-instrument:O=1:D:N!=.:T=F)" )
		T1 = $(PATH):$(OPTDIRS)
		instrument.root := $(T1:/:/ /G:N!=.:X=$(-instrument:O=1:B)/.:P=X:D)
		if ! instrument.root
			instrument.root = $(.INSTRUMENT.notfound)
		end
	end
	T2 := $(-instrument:O=1:B)
	T1 := $(INSTRUMENT_$(T2))
	if ! T1 || ! "$(T1:N!=*=*)"
		T5 =
		T6 =
		for T3 $(T1:N=*=*:/command=/TI=/:/root=/T5=/:/bin=/T6=/)
			eval
			$(T3)
			end
		end
		if ! TI
			TI = CC
			CCFLAGS := $(CCFLAGS:N!=-g|-O*|-p*|$(CC.DEBUG)|$(CC.OPTIMIZE)) $(CC.DEBUG)
		end
		T1 := $(TI) = $($(TI):N=*=*)
		if ! T5
			T2 := $(T2:F=%(upper)s)
			T5 = $(T2)HOME
			for T3  $(T2) $(T2)HOME $(T2)_HOME $(T2)ROOT $(T2)_ROOT
				if "$($(T3):T=F)"
					T5 := $(T3)
					break
				end
			end
		end
		if "$($(T5))"
			T5 := $($(T5))
		else
			T1 += $(T5)=$(instrument.root)
			T5 := $(instrument.root)
		end
		if ! "$(PATH:/:/ /G:X=$(-instrument):P=X)"
			if T6
				T5 := $(T5)/$(T6)
			end
			T1 += PATH=$(PATH):$(T5)
		end
		T1 += $(-instrument) $($(TI):N!=*=*)
	end
	if T1
		CC.READONLY =
		set expandview
		eval
		$(T1:V)
		end
	end
end
if "$(-mam:N=(regress|static)*)"
	set nativepp:=-1
end
if "$(-debug-symbols)" && ! "$(CCFLAGS:N=$(CC.DEBUG))"
	CCFLAGS := $(CCFLAGS:V:N!=-O*|$(CC.OPTIMIZE)|$\(CC.OPTIMIZE\)) $(CC.DEBUG)
end
if "$(-profile)" && ! "$(CCFLAGS:N=$(CC.PROFILE))"
	CCFLAGS += $(CC.PROFILE)
end
if ! CC.LIB.THREADS
	CC.LIB.THREADS = -lpthreads
end
$(CC.LIB.THREADS) : .DONTCARE
if A = "$(-ancestor)"
	if "$(-mam:N=(regress|static)*)"
		T1 = ..
		let T2 = 1
		while T2 < A
			let T2 = T2 + 1
			T1 := ../$(T1)
		end
		.MAM.INSTALLROOT := $(T1)
		print -um setv INSTALLROOT $(T1)
		T4 =
		for T3 $(.ANCESTOR.LIST)
			if T4
				$(T4) : $(T1)/$(T3)
				T4 =
			else
				T4 := $(T3)
			end
		end
	end
	T1 = ..
	let T2 = 0
	while T2 < A
		let T2 = T2 + 1
		T4 =
		for T3 $(.ANCESTOR.LIST)
			if T4
				$(T4) : $(T1)/$(T3)
				T4 =
			else
				T4 := $(T3)
			end
		end
		T1 := ../$(T1)
	end
elif "$(-mam:N=(regress|static)*)"
	.MAM.INSTALLROOT := $(INSTALLROOT:N=..*(/*):?$(INSTALLROOT)?$HOME?)
	print -um setv INSTALLROOT $(.MAM.INSTALLROOT)
end
for T3 $(.ANCESTOR.LIST)
	if T4
		$(T4) : $($(T3:F=%(upper)s)DIR)
		T4 =
	else
		T4 := $(T3)
	end
end
.SOURCE.h : $(INSTALLROOT)/include
if "$(-mam:N=dynamic*)"
	.MAM.INSTALLROOT := $(INSTALLROOT:N=$(HOME):?$HOME?$(INSTALLROOT)?)
	print -um setv INSTALLROOT $(.MAM.INSTALLROOT)
	.MAM.PACKAGEROOT := $(PACKAGEROOT:N=$(HOME):?$HOME?$(PACKAGEROOT)?)
	print -um setv PACKAGEROOT $(.MAM.PACKAGEROOT)
end
.MAMEDIT. =
if "$(INSTALLROOT:N=..*(/*))"
	.MAMROOT. := $(INSTALLROOT)
elif "$(PWD)/" == "$(INSTALLROOT)/*"
	.MAMROOT. := $(".":P=R=$(INSTALLROOT))
elif "$(PWD)/" == "$(PACKAGEROOT)/*"
	.MAMROOT. := $(".":P=R=$(PACKAGEROOT))
else
	.MAMROOT. := $(PWD:C@.*/src/@/src/@:C@/[^/]*@/..@G:C@/@@)
end
.SOURCE.h : $(*.SOURCE.c:N!=.) $(*.SOURCE:N!=.)
.SOURCE .SOURCE.a .SOURCE.c .SOURCE.h : .INSERT .
if CC.PREROOT && "$(CC.PREROOT:P!=I=/)"
	T1 := $(CC.PREROOT) /
	CC.STDINCLUDE := $(T1:X=$$(CC.STDINCLUDE:C@^/@@))
	CC.STDLIB := $(T1:X=$$(CC.STDLIB:C@^/@@))
end
if T1 = "$(.PACKAGE.build:A!=.TARGET)"
	local B D H I L N P Q S T V W X Z K=0 K.0=0 KP IP LP
	LDLIBRARIES += $$(.PACKAGE.LIBRARIES. $(T1))
	T2 =
	for P $(T1)
		if P == "{"
			if ! "$(-mam:N=static*)"
				if K
					KP := $(K.$(K))
				else
					KP = 0
				end
				let K = K + 1
				local K.$(K)=$(KP)
				local L.$(K)
			end
			continue
		elif P == "}"
			if ! "$(-mam:N=static*)" && K
				if ! $(K.$(K))
					error 3 at least one of the packages { $(L.$(K)) } must exist
				end
				let K = K - 1
			end
			continue
		elif $(K.$(K)) > 0
			continue
		end
		if K
			L.$(K) += $(P)
		end
		P := $(.PACKAGE.INIT. $(P))
		I := $(PACKAGE_$(P)_INCLUDE)
		L := $(PACKAGE_$(P)_LIB)
		if "$(.PACKAGE.$(P).found)" == "1"
			if K
				K.$(K) := 1
			end
		elif ! K && ! "$(.PACKAGE.$(P).dontcare)"
			if ! "$(PKGDIRS:X=package/$(P).lic package/$(P).pkg:T=F)" && ! "$(.PACKAGE.$(P).library)"
				error 3 $(P): package not found
			end
			.PACKAGE.$(P).dontcare := 1
		end
		T2 += $(P)
		T4 =
		if "$(-mam:N=static*)"
			if "$(INCLUDEDIR:D:N=$(INSTALLROOT))" || "$(INCLUDEDIR:D:D:N=$(INSTALLROOT))"
				T4 += P
			end
			if I && ( "$(I:D)" == "$(L:D)" || "$(I:D:D)" == "$(L:D)" )
				if "$(I:D)" == "$(L:D)"
					H := $(I:D)
				else
					H := $(I:D:D)
				end
				T := $(I:C,^$(H)/,,)
				print -um setv PACKAGE_$(P) $(T4:N=P:?${INSTALLROOT}?$(H)?)
				print -um setv PACKAGE_$(P)_INCLUDE ${PACKAGE_$(P)}/$(T)
				print -um setv PACKAGE_$(P)_LIB ${PACKAGE_$(P)}/$(L:B:S)
				T4 += I L
			end
		end
		if I
			if ! "$(CC.STDINCLUDE:N=$(I))"
				.SOURCE.h : $(I)
				if "$(I:B)" == "$(P)" && ! "$(CC.STDINCLUDE:N=$(I:D))"
					.SOURCE.h : $(I:D)
				end
			elif "$(-mam:N=static*)"
				.SOURCE.h : $(I)
				CC.STDINCLUDE := $(CC.STDINCLUDE:N!=$(I))
				if "$(I:B)" == "$(P)"
					.SOURCE.h : $(I:D)
					CC.STDINCLUDE := $(CC.STDINCLUDE:N!=$(I:D))
				end
			end
			if "$(-mam:N=(regress|static)*)"
				.MAMPACKAGE. += PACKAGE_$(P)_INCLUDE
				if ! "$(T4:N=I)"
					print -um setv PACKAGE_$(P)_INCLUDE $(T4:N=P:?${INSTALLROOT}/$(INSTALLROOT:P=R=$(I))?$(I)?)
				end
			end
		end
		if L && L != "/lib|/usr/lib"
			if ! "$(CC.STDLIB:N=$(L))"
				.SOURCE.a : $(L)
			elif "$(-mam:N=static*)"
				.SOURCE.a : $(L)
				CC.STDLIB := $(CC.STDLIB:N!=$(L))
			end
			if "$(-mam:N=(regress|static)*)"
				.MAMPACKAGE. += PACKAGE_$(P)_LIB
				if ! "$(T4:N=L)"
					print -um setv PACKAGE_$(P)_LIB $(T4:N=P:?${INSTALLROOT}/$(INSTALLROOT:P=R=$(L))?$(L)?)
				end
			end
		end
	end
	T3 := $(*.SOURCE.h)
	.SOURCE.h : $(CC.STDINCLUDE) $(LCLDIRS:/:/ /G:C,$,/include,)
	T4 := $(*.SOURCE.a)
	.SOURCE.a : $(CC.STDLIB)
	if T2
		T2 += .
		T1 := $(*.SOURCE.h:C,.*,$$(T2:C%.*%&/\&%),)
		.SOURCE.h : .CLEAR . $(T1:P=C)
		T1 := $(*.SOURCE.a:C,.*,$$(T2:C%.*%&/\&%),)
		.SOURCE.a : .CLEAR . $(T1:P=C)
	end
else
	T3 := $(*.SOURCE.h)
	.SOURCE.h : $(CC.STDINCLUDE)
	T4 := $(*.SOURCE.a)
	.SOURCE.a : $(CC.STDLIB)
end
if "$(-mam:N=(regress|static)*)"
	.CC.NOSTDINCLUDE. := $(CC.STDINCLUDE:V:N!=*[()]*|$(T3:@C@ @|@G):C@ @|@G:C@^@N!=@)
	.CC.NOSTDLIB. := $(CC.STDLIB:V:N!=*[()]*|$(T4:@C@ @|@G):C@ @|@G:C@^@N!=@)
else
	.CC.NOSTDINCLUDE. := $(CC.STDINCLUDE:N!=$(T3:@C@ @|@G):C@ @|@G:C@^@N!=@)
	.CC.NOSTDLIB. := $(CC.STDLIB:N!=$(T4:@C@ @|@G):C@ @|@G:C@^@N!=@)
end
T3 = $(PACKAGE_PATH:/:/ /G) $(.PACKAGE.DIRS.) $(.PACKAGE.GLOBAL.)
T3 := $(T3:X=lib:N!=$(.PACKAGE.stdlib:/ /|/G):T=F)
.SOURCE.a : $(T3)

T3 =
if ! "$(CC.DIALECT:N=ANSI)"
	stdarg.h : .SPECIAL .NULL .TERMINAL .DONTCARE .IGNORE
end
if "$(CC.REPOSITORY)"
	.PTR.PREREQS = $(!) $(!.PTR.CHECK)
	if ! "$(*.SOURCE.ptr)"
		.SOURCE.ptr : $(CC.REPOSITORY)
	end
	T3 += $$(.PTR.OPTIONS.)
end
if ! "$(CC.INCLUDE.LOCAL)" && "$(CC.DIALECT:N=-I-)"
	CC.INCLUDE.LOCAL = -I-
end
if "$(-separate-include)"
	CC.SEPARATEINCLUDE := $(CC.INCLUDE.LOCAL)
end
if ! "$(-nativepp)"
	if ! "$(-separate-include)" && "$(-?separate-include)"
		set nativepp:=-1
		if ! "$(-?prefix-include)"
			set prefix-include:=0
		end
	elif "$(CC.SEPARATEINCLUDE)" && !CC.ALTPP.FLAGS && !CC.ALTPP.ENV
		set nativepp:=1
	end
end
if ! "$(-nativepp)"
	if CC.CC && ! ( T4 = "$(CC.PROBEPP)" )
		T4 := $(-cctype:@P=P=C,pp)
	end
	if ! "$(CC.DIALECT:N=LIBPP)" || CPP != "$\(MAKEPP\)"
		if ! "$(-?prefix-include)" && CPP != "$\(MAKEPP\)"
			set prefix-include:=1
		end
		(CC) : (CPP)
		if CC.ALTPP.FLAGS || CC.ALTPP.ENV
			T5 := $(CC.ALTPP.FLAGS)
			T3 += $(T5:V)
			if CC.ALTPP.ENV
				.BIND : (CC)
				CC := $$(CC.ALTPP.ENV) $(CC:V)
			end
		else
			.BIND : (CC)
			if "$(CCLD:V)" == "$$(CC)"
				CCLD := $(CC:V)
			end
			CC := $(CC:N=*=*) $$(PPCC) $$(PPCCFLAGS) $$(CC.DIALECT:/^/-o /) $$(CPP) $(TI:@N=CC:?$(-instrument)?$(-cctype)?)
		end
		if T4
			T5 := -I-D$(T4)
			T3 += $(T5:V)
		end
	end
elif ! "$(-?prefix-include)" && ! "$(CC.SEPARATEINCLUDE)"
	set prefix-include:=1
end
if ! "$(-?prefix-include)" && "$(CCFLAGS:N=$(CC.INCLUDE.LOCAL)|-I-)"
	set prefix-include:=1
end
if "$(-prefix-include)" || ! "$(-separate-include)" || "$(-nativepp)" && ! "$(CC.SEPARATEINCLUDE)"
	T3 += $$(*:A=.SCAN.c:@?$$$(*.SOURCE.%.LCL.INCLUDE:I=$$$$(!$$$$(*):A=.LCL.INCLUDE|.STD.INCLUDE:P=D:U):$(.CC.NOSTDINCLUDE.):/^/-I/)??) $$(&:T=D)
	if "$(-nativepp)" == "[1-9]*"
		error 1 local include files may be ignored by the native C preprocessor
	end
else
	if ! "$(-?prefix-include)"
		set prefix-include:=0
	end
	T3 += $$(*:A=.SCAN.c:@?$$$(*.SOURCE.%.LCL.INCLUDE:I=$$$$(!$$$$(*):A=.LCL.INCLUDE:P=D):$(.CC.NOSTDINCLUDE.):/^/-I/) $$(.PREFIX.SOURCE. $$(*):/^/-I/) $(CC.INCLUDE.LOCAL:--I-) $$$(!$$$(*):A=.STD.INCLUDE:A=.LCL.INCLUDE:@+-I.) $$$(*.SOURCE.%.STD.INCLUDE:I=$$$$(!$$$$(*):A=.STD.INCLUDE:P=D):$(.CC.NOSTDINCLUDE.):/^/-I/)??) $$(&:T=D)
end
if "$(CC.DIALECT:N=TOUCHO)"
	.TOUCHO : .MAKE .VIRTUAL .FORCE .REPEAT .AFTER .FOREGROUND
		.REBIND : $(*$(<<):N=*$(CC.SUFFIX.OBJECT))
	.APPEND.%.COMMAND : .TOUCHO
end
if "$(CCFLAGS:N=-g|$(CC.DEBUG))"
	_BLD_DEBUG == 1
end
if "$(-instrument)"
	_BLD_INSTRUMENT == 1
end
if "$(-static-link)"
	_BLD_STATIC_LINK == 1
end
if "$(-shared)" && ! "$(CCFLAGS:VP:N=$\(CC.DLL\))"
	T4 = $(CC.DLL)
else
	T4 =
end
if T3
	T4 += $$(-target-context:?$$$(!$$$(*):A=.PFX.INCLUDE:@Y%$$$(<:P=U:D:T=*:P=L=*:/^/-I/) %%)??)$$(-target-prefix:?$$$(<:O=1:N=$$$(*:O=1:B:S=$$$(CC.SUFFIX.OBJECT)):Y%%-o $$$$(<) %)??)$(T3:V)
end
if T3 || T4
	CCFLAGS &= $(T4:V)
end
T3 =
T4 =
if "$(CC.REPOSITORY)"
	T3 += $(T5:V) $$(CCFLAGS:N=-[D]*) $$(.PTR.PREREQS:A=.SCAN.c:@?$$$(*.SOURCE.%.LCL.INCLUDE:I=$$$$(.PTR.PREREQS:A=.LCL.INCLUDE:P=D):/^/-I/) $(CC.SEPARATEINCLUDE) $$$(*.SOURCE.%.LCL.INCLUDE:I=$$$$(.PTR.PREREQS:A=.LCL.INCLUDE|.STD.INCLUDE:P=D):$(.CC.NOSTDINCLUDE.):/^/-I/)??) $$(&.PTR.CHECK:T=D)
	.APPEND.%.COMMAND : .PTR.CHECK .PTR.UPDATE
	T3 := $$(@:V:N=*$\(CC*(LD)\)*:@?$(T3:V)??)
end
if "$(CC.ARFLAGS)"
	.ARCHIVE.o : .CLEAR .USE .ARPREVIOUS (CC) (AR)
		$(.ARPREVIOUS.$(<:B:S):@?$(IGNORE) $$(AR) $$(ARHYPHEN)d $$(<) $$(.ARPREVIOUS.$$(<:B:S))$$("\n")??)$(CC) $(CC.ARFLAGS) $(CCLDFLAGS) -o $(<) $(*)
	.SHARED.o : .CLEAR .USE (LDSHARED)
		$(LDSHARED) $(CC.SHARED) $(CCLDFLAGS) -o $(<) $(*$(**):N!=*$(CC.SUFFIX.ARCHIVE))
	.ATTRIBUTE.%.a : -ARCHIVE
end
IFFEFLAGS += -c '$$(IFFECC) $$(IFFECCFLAGS) $$(IFFELDFLAGS)' $$(-mam:N=(regress|static)*:??-S '$$(CC.STATIC)')
if "$(-cross)" || "$(CC.EXECTYPE)" && "$(CC.HOSTTYPE)" != "$(CC.EXECTYPE)"
	set cross
	IFFEFLAGS += -x $(CC.HOSTTYPE)
end
.BIND : (IFFEFLAGS)
IFFEFLAGS += $$(.IFFE.REF.)
if ! IFFE_huh

	(IFFEFLAGS) : .PARAMETER
end
if "$(-mam:N=(regress|static)*)"
	LDFLAGS &= $(T3:V)
else
	if "$(CC.LD.ORIGIN:V)"
		T4 += $$(CC.LD.ORIGIN)
	end
	if "$(CC.LD.RUNPATH:V)"
		T4 += $$(.CC.LD.RUNPATH.)
	end
	LDFLAGS &= $$(*.SOURCE.%.ARCHIVE:I=$$$(*:N=-l*:P=D):$(.CC.NOSTDLIB.):P=A:/^/-L/) $(T3:V)
end
CCLDFLAGS &= $$(CCFLAGS:N!=-[DIU]*:@C@$$(CC.ALTPP.FLAGS)@@) $$(LDFLAGS) $(T4:V)
if "$(CC.LD.STRIP:V)"
	if "$(-strip-symbols)" || "$(PACKAGE_OPTIONS:N=optimize-space)"
		.PACKAGE.strip = $(CC.LD.STRIP)
	end
	CCLDFLAGS += $$(.PACKAGE.strip)
end
M4FLAGS &= $$(*.SOURCE.%.M4.INCLUDE:I=$$$(!$$$(*):P=D):/^/-I/) $$(&:T=D)
make .FLAGSINIT





if ERROR_CATALOG == ""
	ERROR_CATALOG == "$(CATALOG)"
end
if USAGE_LICENSE == ""
	USAGE_LICENSE == "$(LICENSEINFO:P=W=$(LICENSE),type=usage)$(CATALOG:N!=$(ID):Y%[--catalog?$(CATALOG)]%%)"
end





for T3 .ARGS .MAIN
	T2 := $(~$(T3):V)
	eval
	.ORIGINAL$(T3). = $(T2:V)
	end
	$(T3) : .CLEAR .VIRTUAL
	T4 = 0
	for T1 $(T2)
		if ! T4 && "$(T1:A!=.IMMEDIATE|.TARGET)"
			T2 := $(".$(T1:F=%(upper)s)":A=.IMMEDIATE|.TARGET:A!=.ATTRIBUTE)
			if T2
				T1 := $(T2)
			else
				T4 = 1
			end
		end
		$(T3) : $(T1:V)
	end
end






if "$(~.MAIN:V)" == ".RECURSE" && "$(~.ALL:V)" == ".RECURSE" && ! "$(~.ARGS:V:N=.RECURSE|.NORECURSE)" && ! "$(~.ARGS:V:O=1:A=.IMMEDIATE)"
	.ARGS : .INSERT .RECURSE
end





T1 := $(-recurse:/:/ /G:N=[0-9]*:O=N)
if T1 > 0
	T2 =
	while T1 > 0
		let T1 = T1 - 1
		T2 += .SEMAPHORE
	end
	.RECURSE.SEMAPHORE : $(T2)
end
.INITIALIZED. = 1®È³u ( ®È³x¶ïË()cmd ®È³xÀ       lib/libcoshell   ( ®È³xïï¯jñ¾¥()lib ®È³x©        (PROTOFLAGS)   (   ®È³x£ðã8£ðã8().LIB.TYPE.olocal P T
if "$(%)" == "*/*"
	if CC.PREFIX.DYNAMIC || CC.SUFFIX.DYNAMIC
		T := $(%:D)/$(CC.PREFIX.DYNAMIC)$(%:B)$(CC.SUFFIX.DYNAMIC)
	else
		T := $(%:D)/$(CC.PREFIX.SHARED)$(%:B)$(CC.SUFFIX.SHARED)
	end
	if T = "$(*.SOURCE.%.ARCHIVE:X=$(T):T=F:O=1)"
		return $(T)
	end
end
if ! .NO.LIB.TYPE
	if "$(-lib-type)" && "$(.PACKAGE.$(%).type)" != "-"
		for P $(.PACKAGE.$(%).type) $(CC.LIB.TYPE)

			T := $(CC.PREFIX.ARCHIVE)$(%)$(P)$(CC.SUFFIX.ARCHIVE)
			if ! "$(T:A=.TARGET)" && ! "$(T:T=F)"
				T := $(CC.PREFIX.ARCHIVE)$(%)(P:/-/_/)$(CC.SUFFIX.ARCHIVE)
				if ! "$(T:A=.TARGET)" && ! "$(T:T=F)"
					T := lib$(P:/-//)/$(CC.PREFIX.ARCHIVE)$(%)$(CC.SUFFIX.ARCHIVE)
				end
			end
			if "$(T:A=.TARGET)" || "$(T:T=F)"
				return $(T)
			end
		end
	end
end®È³xÀ        .OPTION.COMPATIBILITY   (   ®È³wæýªæýª().RECURSE.OPTIONS.local L O R
O = ..
R = --include=..
for L $(.RWD.:C,/, ,G)
	O := $(O)/..
	R += --include=$(O)
end
R := RECURSEROOT=$(O)
return $(R)®È³wÀ        .RECURSE.SEMAPHORE  À       lib/libsum   (  ®È³wËãèVËãèV().RECURSE®È³w ( 2®È³xìØ»î"()cmd/msggen ®È³x       lib/pthreads  ©        (COBOL)   (   ®È³x£þ¨m£þ¨m().PREFIX.SOURCE."if ! "$(-prefix-include)" && ! "$(-target-context)"
	local P S
	P := $(!$(%):A=.PFX.INCLUDE)
	if S = "$(P:P=U:D:U:N!=.)"
		return $(P:P=D:X=$(S):T>FD:U)
	end
end®È³x ( 5®È³xôÑßôý¦Q()cmd/vcodexlib ®È³x¨       (USAGE_LICENSE)         -lm  À       
lib/libcs         libm.so   ( 7®È³wæ¯gæøÍ7()cmd/ksh93 ®È³w       	libdl.so  ©        (MSGCC)  ©        
(ARFLAGS)  ©        (CCLDFLAGS)  ©        (LEXFLAGS)   ( :®È³vººê{»â½x()lib/libast ®È³v©        
(CCFLAGS)  é    =   (AS)  ©        (CIAFLAGS)  À       cmd/coshell  ©        (PERLMAGIC)  ©        (F77FLAGS)  ©        (CIADBFLAGS)       ®È³²ñ{ ().NORECURSE.DIRXset -
if	$(*.VIEW:O=2:N=...:+2d) test -d $(<) $(-virtual:+|| $(MKDIR) $(<))
then	$(-silent:~echo $(-recurse-enter) $(.RWD.:+$(<:N!=/*:+$(.RWD.)/))$(<)$$(":") >&2)
	cd $(<)
	$(MAKE) $(-) --norecurse --errorid=$(<:Q) $(=:V:N!=MAKEPATH=*|VPATH=*) .RWD.=$(.RWD.:C%$%/%)$(<) $(.RECURSE.ARGS.:N!=.RECURSE)
	$(-recurse-leave:+$(-silent:~echo $(-recurse-leave) $(.RWD.:+$(<:N!=/*:+$$(.RWD.)/))$(<)$$$(":") >&2))
else	echo $(<): warning: cannot recurse on virtual directory >&2
fi À       cmd/vcodexlib  ©        (LDLIBRARIES)  ©        (COBOLDIALECT)   (   ®È³ußâÃißâÃi().MAKERULES.LOAD ®È³uÄ       .RECURSE.FLUSH  À       cmd/dsslib         -      >  ËãèV().ALL ®È³w (   ®È³ußâµHßâµH().PROBE.LOAD-.PROBE.SPECIAL. = CC.HOSTTYPE CC.LD.DYNAMIC CC.LD.STATIC CC.STDLIB.BASE
$(.PROBE.SPECIAL.) : .FUNCTION
	$(.PROBE.SPECIAL.) : -FUNCTIONAL
	make .PROBE.INIT
	return "$($(<))"®È³u   ?  S().INSTALL ®È³x       -ldl   ( @®È³v×ØÖ()lib/libsum ®È³v©        (COBOLFLAGS)   ( C®È³xÛjÈg()cmd/codexlib ®È³x©     ®È³ã£8 (IFFEFLAGS) I-v -c 'cc -O2   -Wl,-O1,--sort-common,--as-needed,-z,relro' -S '-static'      ï*().CC- ®È³x©        (CIA)  À       cmd/codexlib  À       lib/libdll  ©        (CCLD)   (   ®È³uå×½ å×½ ().RECURSE.INIT.olocal D N P
if ! "$(-recurse)"
	return
end
if ( D = "$(%)" )
	.X. : .CLEAR
	for N $(D)
		if N == "-"
			.X. : $(N)
		elif "$(N:T=F=D)"
			.X. : $(N)
		else
			P := $(".":L=$(N):T=F=D)
			if P
				.X. : $(P)
			else
				.X. : $(N)
			end
		end
	end
	D := $(~.X.)
else
	D = .
end
if "$(-recurse)" == "*prereqs*"
	print $(D:W=P=$(.RECURSE.ARGS.:A!=.ONOBJECT:N!=.RECURSE))
	exit 0
end
if D == "."
	D := $(D:W=R=$(.RECURSE.ARGS.:A!=.ONOBJECT:N!=.RECURSE))
end
if "$(-recurse)" == "*only*"
	D := $(D:N=?(*/)($(.RECURSE.ARGS.:/ /|/G)))
end
if "$(-recurse)" == "*list*"
	print $(D:/ /$("\n")/G)
	exit 0
end
$(D) : .OBJECT
P := recurse .RECURSE $(D:B:S:N!=$(...:A=.ONOBJECT:N=.*:/.\(.*\)/\1/L:N!=*.*:/ /|/G)) $(<<) $(...:A>*.RECURSE.INIT.*)
P := $(P:U:/ /|/G)
.ORIGINAL.ARGS. := $(.ORIGINAL.ARGS.:N!=$(P))
.ARGS : .CLEAR $(~.ARGS:N!=$(P))
P := $(D:N!=-|.|.CC-*|cc-*)
if P == "* + *"
	$(P:@/ + .*//:T!=FR) : .TERMINAL .RECURSE.DIR
	$(P:@/.* + //:T!=FR) : .TERMINAL .NORECURSE.DIR
else
	$(P:T!=FR) : .TERMINAL .RECURSE.DIR
end
$(P:T=FR) : .TERMINAL .RECURSE.FILE
.SELECT.EDIT. := $(.SELECT.EDIT.):N!=($(P:T=F:P=L=*:/ /|/G))?(/*)
return $(D:N!=+)®È³u (   ®È³xõõ().BIND.%.PFX.INCLUDE@if "$(%:A=.DONTCARE)"
	$(%:B:S) : .DONTCARE
end
return $(%:B:S)®È³x©        (M4)  À       	cmd/INIT  é    E   (CPP)   ( F®È³wÎ½0Ï¶î#()lib/libcoshell ®È³w (   ®È³x¤È÷b¤È÷b().BIND.-l%¨local A B D T V X
if "$(%)" != "[-+]l*"
	return $(%)
end
B := $(%:/[-+]l//)
if "$(-mam:N=static*,port*)" && ! .BIND.REAL.
	if "$(%)" != "-l+([a-zA-Z0-9_])"
		$(%) : .DONTCARE
		return + $(%)
	end
	.BIND.REAL. = 1
	A := $(.BIND.-l% $(%):T=F)
	.BIND.REAL. =
	V := ${mam_lib$(B)}
	if "$(%:A=.DONTCARE)" && "$(A:N=/*)"
		print -um bind -l$(B) dontcare
		return + $(V)
	elif T = "$(%:/-l\(.*\)/$(CC.PREFIX.ARCHIVE)\1$(CC.SUFFIX.ARCHIVE)/:A=.TARGET)"
		return $(T)
	else
		$(V) : .DONTCARE
		return $(V:T=F)
	end
end
if ( T = "$(.LIB.TYPE. $(B))" )
	return $(T)
end
if ( "$(-static-link)" || "$(.PACKAGE.LIBRARY. $(B))" == "+l" ) && "$(<<)" != ".BIND.+l%"
	V := $(CC.PREFIX.ARCHIVE)$(B)$(CC.SUFFIX.ARCHIVE)
	if ( T = "$(V:A=.TARGET)" )
		return $(T)
	end
	if ( T = "$(V:T=F)" )
		if "$(T:D)" != "$(CC.STDLIB:/ /|/G)" && "$(T:D)" != "/usr/($(.PACKAGE.:/ /|/G))"
			$(T) : -IGNORE
			return $(T)
		end
	end
end
if "$(CC.DIALECT:N=DYNAMIC)" && ( "$(CCLDFLAGS:N=$(CC.DYNAMIC))" || ! "$(CCLDFLAGS:N=$(CC.STATIC))" )
	if ( CC.SUFFIX.DYNAMIC || ! "$(-local-static)" ) && CC.SUFFIX.SHARED && ! "$(.PLUGIN.$(B))"
		if CC.SUFFIX.DYNAMIC
			T := $(*$(B):N=*$(CC.SUFFIX.DYNAMIC))
			if "$(CC.PREFIX.DYNAMIC)" != "$(CC.PREFIX.SHARED)"
				if CC.PREFIX.DYNAMIC
					T := $(T:D:B=$(T:B:/$(CC.PREFIX.DYNAMIC)/$(CC.PREFIX.SHARED)/):S=$(CC.SUFFIX.SHARED))
				else
					T := $(T:D:B=$(T:B:/^/$(CC.PREFIX.SHARED)/):S=$(CC.SUFFIX.SHARED))
				end
			else
				T := $(T:D:B:S=$(CC.SUFFIX.SHARED))
			end
		else
			T := $(*$(B):N=*$(CC.SUFFIX.SHARED)*(.+([0-9])))
		end
		if "$(T:A=.TARGET)"
			if ( X = "$(*.INSTALL:N=*/$(T))" )
				make $(X)
				return - $(X)
			end
			return $(T)
		end
		if ( T = "$(*$(B):N=-l$(B):/-l//)" )
			T := $(T)$($(B).VERSION:/[^0-9]//G)
			if ( T = "$(T:B:S=$(CC.SUFFIX.SHARED):A=.TARGET)" )
				if ( X = "$(*.INSTALL:N=*/$(T))" )
					make $(X)
					return - $(X)
				end
				return $(T)
			end
		end
	end
	if ( T = "$(%:/-l\(.*\)/$(CC.PREFIX.ARCHIVE)\1$(CC.SUFFIX.ARCHIVE)/:A=.TARGET)" )
		if "$(PACKAGE_OPTIONS:N=optimize-space)" && "$(CC.SUFFIX.SHARED)"
			if ( V = "$(*$(B):N=*$(CC.SUFFIX.SHARED)*:A=.TARGET)" )
				A := $(V:/\(.*$(CC.SUFFIX.SHARED)\).*/\1/)
				if "$(A)" != "$(V)"
					$(A) : $(V)
						$(LN) -f $(*) $(<)
					V := $(A)
				end
				.MAKE : $(V)
				$(%) : .NULL
				return $(%)
			end
		end
		return $(T)
	else
		local H I J L P Q S Z
		L := $(%)
		V :=
		if P = "$(PACKAGE_$(B)_VERSION)"
			P := ?([-.])$(P)
		end
		if T = "$(PACKAGE_$(B)_LIB)"
			if ! "$(.PACKAGE.stdlib:N=$(T))"
				.SOURCE.a : $(T)
			end
		end
		for J $(CC.PREFIX.SHARED) ''
			for I $(P) ''
				if "$(CC.SUFFIX.DYNAMIC)"
					if T = "$(*.SOURCE.%.ARCHIVE:L>$(CC.PREFIX.ARCHIVE)$(B)$(I)$(CC.SUFFIX.ARCHIVE)|$(J)$(B)$(I)$(CC.SUFFIX.SHARED))"
						if "$(CC.SUFFIX.SHARED)"
							if T != "*$(CC.SUFFIX.SHARED)" && T == "*$(CC.SUFFIX.ARCHIVE)"
								if S = "$(T:D:B=$(J)$(T:B:/$(CC.PREFIX.ARCHIVE)//):S=$(CC.SUFFIX.SHARED):T=F)"
									T := $(S)
								end
							end
						end
						T := $(T:T=F)
						Q = .ARCHIVE
						if ! "$(-force-shared)" && ! "$(-static-link)" && ! "$(CC.SUFFIX.DYNAMIC)" && "$(CC.SUFFIX.SHARED)" && T == "*$(CC.SUFFIX.SHARED)"
							Q += .IGNORE
						end
						$(%) $(T) : $(Q)
						return $(T)
					end
				elif "$(J)" || ! "$(CC.PREFIX.SHARED)"
					if ! S
						if "$(CC.SUFFIX.STATIC)"
							S = |$(CC.SUFFIX.STATIC)
						end
						if "$(CC.SUFFIX.SHARED)"
							S := $(S:V)|$(CC.SUFFIX.SHARED)
							if "$(CC.SUFFIX.SHARED)" != "$(CC.SUFFIX.OBJECT)"
								H = -
								if "$(CC.DIALECT:N=VERSION)"
									Z = 1
								end
							end
						end
					end
					while 1
						T := $(*.SOURCE.%.ARCHIVE:L!>$(L:/-l\(.*\)/$(CC.PREFIX.ARCHIVE)\1/)$(I)@($(V)$(CC.SUFFIX.ARCHIVE)$(S)))
						if ! T && Z
							T := $(*.SOURCE.%.ARCHIVE:L!>$(L:/-l\(.*\)/$(CC.PREFIX.ARCHIVE)\1/)$(I)@($(V)$(CC.SUFFIX.ARCHIVE)$(S)$(V)*))
						end
						if T
							if ! "$(CC.SUFFIX.SHARED)" || T != "*$(CC.SUFFIX.SHARED)"
								if T == "*$(CC.SUFFIX.ARCHIVE)"
									if "$(CC.STDLIB:N=$(T:D))"
										return - $(T:T=F)
									end
									return $(H) $(T:B:S)
								end
								if "$(CC.SUFFIX.STATIC)" && T == "*$(CC.SUFFIX.STATIC)"
									H = -
								end
							end
							T := $(T:B:S)
							Q = .ARCHIVE
							if ! "$(-force-shared)" && ! "$(-static-link)" && ! "$(CC.SUFFIX.DYNAMIC)" && "$(CC.SUFFIX.SHARED)" && T == "*$(CC.SUFFIX.SHARED)"
								Q += .IGNORE
							end
							$(%) $(T) : $(Q)
							return $(H) $(T:T=F)
						end
						if ! "$(L:N=*+(.+([0-9])))"
							break
						end
						T := $(L:/\.[0-9]*$//)
						V := $(L:/$(T)//)$(V)
						L := $(T)
					end
				end
			end
		end
	end
else
	T := $(CC.PREFIX.ARCHIVE)$(B)$(CC.SUFFIX.ARCHIVE)
	if "$(%:A=.DONTCARE)"
		$(T) : .DONTCARE
	end
	return $(T)
end
if ! "$(.BOUND.$(B))"
	.BOUND.$(B) := 1
	if T = "$(CC.REQUIRE.$(B))"
		$(%) : .DONTCARE
		return $(T)
	elif T = "$(B:B:S=.req:T=F)"
		$(%) : .DONTCARE
		return $(T:T=I)
	else
		T := lib/$(B)
		$(T) : .ARCHIVE
		if ! "$(T:T=F)"
			T := $(MAKELIB:D)/$(T)
		end
		if "$(T:T=F)"
			T := $(T:T=I)
			if ! "$(T:N=[-+]l$(B))"
				$(%) : .DONTCARE
			end
			return $(T)
		end
	end
end®È³x"Y: %: 8 "Y: "Y: "Y:   "Y: %:  8 %: %: l[+[;[4D[Pg[#UZf "Y: %: "Y: "Y:    "Y: %:  "Y:  