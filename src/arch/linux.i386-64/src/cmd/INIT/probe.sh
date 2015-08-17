:
### this script contains archaic constructs that work with all sh variants ###
# Glenn Fowler
# AT&T Research
#
# @(#)C probe (AT&T Research) 2013-05-21
#
# probe [ -d ] c-compiler-path [ attributes ]
#
# common C probe preamble for the tool specific probes
#
# NOTE: some cc -E's do syntax analysis!

#
# probe_* are first eval'd and then attempted from left to right
#

probe_binding="-dy -dn -Bdynamic -Bstatic '-Wl,-ashared -Wl,+s' -Wl,-aarchive -call_shared -non_shared -dynamic -static -bshared -bstatic '' -static"
probe_env="CC_OPTIONS CCOPTS LD_OPTIONS LDOPTS LIBPATH LPATH"
probe_include="stdio.h iostream.h complex.h ctype.h plot.h stdarg.h varargs.h ranlib.h hash.h sys/types.h stab.h cmath cstdio iostream string"
probe_longlong="long 'long long'"
probe_longlong_t="__int64_t _int64_t __int64 _int64 int64"
probe_l="l yyreject m sin mopt sin"
probe_lxx="C exit ++ exit g++ exit"
probe_ppprefix="a n"
probe_size="size"
probe_src="cxx C cc c"
probe_sa=".sa"
probe_sd=".dll .lib .dll .x"
probe_sdb=".pdb"
probe_so=".dylib .so .sl"
probe_symprefix="_"
probe_verbose="'-v -v' '-# -#' '-d -d' -dryrun '-V -V'"
probe_version="--version -V -version -v"

#
# the following are set by the preamble for the tool specific probe
#

cc=cc
debug=
dir=.
dll=.dll
dynamic=
exe=exe
executable="test -x"
hosted=
ifs=${IFS-'
	 '}
obj=o
ppenv=
ppopt=
predef=
prepred=
sa=
sd=
sdb=
so=
sov=
static=
stdlib=
stdpp=
suffix_command=
if	test "" != "$TMPDIR" -a -d "$TMPDIR"
then	tmpdir=$TMPDIR
else	tmpdir=/tmp
fi
tmpdir=$tmpdir/probe$$
undef="define defined elif else endif error if ifdef ifndef include line pragma undef __STDC__ __STDPP__ __ARGC__ __BASE__ __BASE_FILE__ __DATE__ __FILE__ __FUNCTION__ __INCLUDE_LEVEL__ __LINE__ __PATH__ __TIME__ __TIMESTAMP__ __VERSION__"
version_flags=
version_stamp=
version_string=

#
# constrain the environment
#

DISPLAY=
LC_ALL=C
export DISPLAY LC_ALL

#
# now the common probes
#

while	:
do	case $1 in
	-d)	debug=1 ;;
	-*)	set ''; break ;;
	*)	break ;;
	esac
	shift
done

cc=$1
case $cc in
[\\/]*|[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:\\*)
	;;
*)	echo "Usage: $0 [ -d ] c-compiler-path [ attributes ]" >&2
	exit 1
	;;
esac
ATTRIBUTES=
eval $2
_probe_PATH=$PATH
PATH=/usr/bin:/bin:$PATH

case $0 in
*[\\/]*)	dir=`echo $0 | sed -e 's,[\\/][\\/]*[^\\/]*\$,,'` ;;
esac

$executable . 2>/dev/null || executable='test -r'

case $SHELL in
[\\/]*|[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:\\*)
	sh=$SHELL
	;;
*)	sh=/bin/sh
	;;
esac

trap 'code=$?; cd ..; rm -rf $tmpdir; exit $code' 0 1 2 3
mkdir $tmpdir
cd $tmpdir

exec 3>&1 4>&2 </dev/null
case $debug in
"")	exec >/dev/null 2>&1
	(ulimit -c 0) >/dev/null 2>&1 && ulimit -c 0
	;;
*)	PS4='+$LINENO+ '
	set -x
	;;
esac

if	(xxx=xxx; unset xxx)
then	UNSET=1
else	UNSET=
fi
eval set x $probe_env
while	:
do	shift
	case $# in
	0)	break ;;
	esac
	eval x='$'$1
	case $x in
	'')	continue ;;
	esac
	case $1 in
	*PATH)	_probe_export="$_probe_export $1='$x'" ;;
	esac
	case $UNSET in
	'')	eval $1=
		export $1
		;;
	*)	unset $1
		;;
	esac
done

if	test -f "$dir/probe.ini"
then	. "$dir/probe.ini"
	IFS=$ifs
fi

mkdir suffix
cd suffix
for src in $probe_src
do	echo "int main(){return 0;}" > ../test.$src
	rm -f test*
	if	$cc -c ../test.$src
	then	set test.*
		if	test -f "$1"
		then	o="$*"
			mv $* ..
			for i in $o
			do	if	$cc -o test.exe ../$i
				then	obj=`echo "$i" | sed -e 's,test.,,'`
					$executable test.exe || executable="test -r"
					set test*
					rm *
					if	$cc -o test ../$i
					then	rm $*
						set test.*
						if	$executable "$1"
						then	exe=`echo "$1" | sed -e 's,test.,,'`
							suffix_command=.$exe
						fi
					fi
					break 2
				fi
			done
		fi
	fi
done
cd ..

case $src in
c)	;;
*)	echo '// (
int
main()
{
	class { public: int i; } j;
	j.i = 0;
	int k = j.i + 1;
	return k;
}' > dialect.$src
	if	$cc -c dialect.$src && $cc -o dialect.$exe dialect.$obj && $executable dialect.$exe
	then	mv dialect.$src dialect.c
		rm -f dialect.$obj dialect.$exe
		if	$cc -c dialect.c && $cc -o dialect.$exe dialect.$obj && $executable dialect.$exe
		then	src=c
		else	set x $cc
			while	:
			do	shift
				case $# in
				0)	break ;;
				esac
				case $1 in
				*=*)	continue ;;
				esac
				case `echo $1 | sed -e 's,.*/,,'` in
				*CC*|*++*|*[xX][xX]*|*[pP][lL][uU][sS]*) ;;
				*)	src=c ;;
				esac
				break
			done
		fi
	else	src=c
	fi
	;;
esac

set x x '(' 1 'int x;' 0
while	:
do	shift
	shift
	case $# in
	[01])	break ;;
	esac
	rm -f test.$obj
	echo "$1" > test.$src
	$cc -c test.$src
	r=$?
	case $r in
	0)	test -f test.$obj || r=1 ;;
	*)	r=1 ;;
	esac
	case $2:$r in
	0:0)	;;
	0:1)	echo "$cc: not a C compiler: failed to compile \`\`$1''" >&4
		exit 1
		;;
	1:0)	echo "$cc: not a C compiler: successfully compiled \`\`$1''" >&4
		exit 1
		;;
	esac
done

hosttype=`package CC="$cc" || $SHELL -c "package CC='$cc'"`
case $hosttype in
*[Uu][Ss][Aa][Gg][Ee]:*)
	hosttype=`PATH=$_probe_PATH; export PATH; package CC="$cc" || $SHELL -c "package CC='$cc'"`
	;;
esac

echo '#include <stdio.h>
int main(){printf("hello");return 0;}' > dynamic.$src
echo 'extern int sfclose() { return 0; }' > fun.$src
if	$cc -c dynamic.$src && $cc -c fun.$src
then	eval set x $probe_so
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		for i in foo junk
		do	rm -f dynamic.$exe
			if	$cc -L. -o dynamic.$exe dynamic.$obj -l$i
			then	: "there's really a -l$i"?
			else	rm -f dynamic.$exe
				cat fun.$obj > lib$i$1
				$cc -L. -o dynamic.$exe dynamic.$obj -l$i && $executable dynamic.$exe
				x=$?
				rm lib$i$1
				case $x in
				0)	so=$1
					rm -f dynamic.$exe > lib$i$1.1
					$cc -L. -o dynamic.$exe dynamic.$obj -l$i && $executable dynamic.$exe
					x=$?
					rm lib$i$1.1
					case $x in
					0)	sov=1 ;;
					esac
					break 2
					;;
				*)	break
					;;
				esac
			fi
		done
		k=
		for i in "" .1 .2 .3 .4 .5 .6 .7 .8 .9
		do	rm -f dynamic.$exe > libc$1$i
			$cc -L. -o dynamic.$exe dynamic.$obj && $executable dynamic.$exe
			x=$?
			(cd ..; rm $tmpdir/libc$1$i)
			case $x in
			0)	;;
			*)	k=X$k
				case $k in
				XXX)	break ;;
				esac
				;;
			esac
		done
		case $k in
		XXX)	so=$1
			sov=1
			break
			;;
		?*)	so=$1
			break
			;;
		esac
	done
	rm -f dynamic.$exe
	if	$cc -o dynamic.$exe dynamic.$obj 2>e && $executable dynamic.$exe
	then	e=`wc -l e`
		maybe=
		eval set x x $probe_binding
		while	:
		do	shift
			shift
			case $# in
			0)	break ;;
			esac
			rm -f dynamic.$exe
			$cc -o dynamic.$exe $1 dynamic.$obj 2>e && $executable dynamic.$exe || continue
			case $1 in
			?*)	case $maybe in
				"")	maybe=$1 ;;
				*)	maybe=-- ;;
				esac
				;;
			esac
			case `wc -l e` in
			$e)	;;
			*)	continue ;;
			esac
			d=`ls -s dynamic.$exe`
			rm -f dynamic.$exe
			$cc -o dynamic.$exe $2 dynamic.$obj 2>e && $executable dynamic.$exe || continue
			case `wc -l e` in
			$e)	;;
			*)	continue ;;
			esac
			case `ls -s dynamic.$exe` in
			$d)	;;
			*)	dynamic=$1
				static=$2
				maybe=
				break
				;;
			esac
		done
		case $maybe in
		""|--)	;;
		*)	rm -f dynamic.$exe
			if	$cc -o dynamic.$exe $maybe dynamic.$obj 2>e && $executable dynamic.$exe
			then	e=`wc -l e`
				if	$cc -o dynamic.$exe $maybe-bogus-bogus-bogus dynamic.$obj 2>e && $executable dynamic.$exe
				then	case `wc -l e` in
					$e)	;;
					*)	dynamic=$maybe ;;
					esac
				else	dynamic=$maybe
				fi
			fi
			;;
		esac
	fi
fi

eval set x $probe_version
shift
for o in "$@"
do	if	$cc $o > version.out 2>&1
	then	version_string=`sed -e '/ is /d' -e 's/;/ /g' version.out | sed -e 1q`
		case $version_string in
		''|*[Ee][Rr][Rr][Oo][Rr]*|*[Ff][Aa][Tt][Aa][Ll]*|*[Ww][Aa][Rr][Nn][Ii][Nn][Gg]*|*[Oo][Pp][Tt][Ii][Oo][Nn]*)
			;;
		*)	version_flags=$o
			version_stamp=";VERSION;$o;$version_string;PATH;$cc"
			break
			;;
		esac
	fi
done
case $version_stamp in
'')	eval set x $probe_version
	shift
	echo 'int main() { return 0; }' > version.i
	for o in "$@"
	do	if	$cc -c $o version.i > version.out 2>&1
		then	version_string=`sed -e '/ is /d' -e 's/;/ /g' version.out | sed -e 1q`
			case $version_string in
			''|*[Ee][Rr][Rr][Oo][Rr]*|*[Ff][Aa][Tt][Aa][Ll]*|*[Ww][Aa][Rr][Nn][Ii][Nn][Gg]*|*[Oo][Pp][Tt][Ii][Oo][Nn]*)
				;;
			*)	version_flags=$o
				break
				;;
			esac
		fi
	done
	;;
esac

echo 'int main(){return 0;}' > hosted.$src
$cc -o hosted.$exe hosted.$src && ./hosted.$exe && hosted=1

echo '#!'$sh'
echo "" $@' > cpp
chmod +x cpp
case `./cpp -Dprobe` in
*-Dprobe*)
	;;
*)	cp /bin/echo cpp
	chmod u+w cpp
	;;
esac
for prefix in $probe_ppprefix `echo $cc | sed -e '/cc\$/!d' -e 's,cc\$,,' -e 's,.*/,,'`
do	cp cpp ${prefix}cpp
done

echo "" > flags.$src
echo '#pragma pp:version' > libpp.$src

# this works around a `...` hang in ksh-2013-05-20 -- to be solved another day #
eval 'shell=$(echo modern)' >/dev/null 2>&1
case $shell in
modern)	if	test $(realcppC=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppenv='realcppC=${ppcmd}'
	elif	test $(cppC=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppenv='cppC=${ppcmd}'
	elif	test $(_CPPNAME=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppenv='_CPPNAME=${ppcmd}'
	elif	test $(_CPP=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppenv='_CPP=${ppcmd}'
	elif	test $($cc -Dprobe -E -%p+. flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1 && test `$cc -Dprobe -E -%p+. flags.$src | wc -l` -eq 1
	then	ppopt='-%p+${ppdir}'
	elif	test $($cc -Dprobe -E -Yp,. flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-Yp,${ppdir}'
	elif	test $($cc -Dprobe -E -Qpath $tmpdir flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-Qpath ${ppdir}'
	elif	test $($cc -Dprobe -E -tp -B./ flags.$src 2>err.out | tee cpp.out | grep -c '[-]Dprobe') -eq 1 -a ! -s err.out
	then	ppopt='-tp -B${ppdir}/'
	elif	test $($cc -Dprobe -E -B./ flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-B${ppdir}/'
	elif	test $($cc -Dprobe -E -tp -h./ -B flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-tp -h${ppdir}/ -B'
	elif	test $($cc -Dprobe -E -t p,./cpp flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-t p,${ppcmd}'
	else	{
			eval set x $probe_verbose
			shift
			for o in "$@"
			do	$cc -E $o flags.$src
			done
		} 2>&1 | sed -e "s/['\"]//g" > cpp.out
	fi
	;;
*)	if	test `realcppC=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppenv='realcppC=${ppcmd}'
	elif	test `cppC=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppenv='cppC=${ppcmd}'
	elif	test `_CPPNAME=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppenv='_CPPNAME=${ppcmd}'
	elif	test `_CPP=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppenv='_CPP=${ppcmd}'
	elif	test `$cc -Dprobe -E -%p+. flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1 && test `$cc -Dprobe -E -%p+. flags.$src | wc -l` -eq 1
	then	ppopt='-%p+${ppdir}'
	elif	test `$cc -Dprobe -E -Yp,. flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-Yp,${ppdir}'
	elif	test `$cc -Dprobe -E -Qpath $tmpdir flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-Qpath ${ppdir}'
	elif	test `$cc -Dprobe -E -tp -B./ flags.$src 2>err.out | tee cpp.out | grep -c '[-]Dprobe'` -eq 1 -a ! -s err.out
	then	ppopt='-tp -B${ppdir}/'
	elif	test `$cc -Dprobe -E -B./ flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-B${ppdir}/'
	elif	test `$cc -Dprobe -E -tp -h./ -B flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-tp -h${ppdir}/ -B'
	elif	test `$cc -Dprobe -E -t p,./cpp flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-t p,${ppcmd}'
	else	{
			eval set x $probe_verbose
			shift
			for o in "$@"
			do	$cc -E $o flags.$src
			done
		} 2>&1 | sed -e "s/['\"]//g" > cpp.out
	fi
	;;
esac

set x `sed -e 's,[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:\\\\,/,g' -e 's,\\\\,/,g' cpp.out`
def=
definclude="-I+C -I-H"
stdinclude=$definclude
case $hosted in
"")	usrinclude= ;;
esac
cmdinclude=
while	:
do	case $# in
	0|1)	break ;;
	esac
	shift
	case $1 in
	-A)	case $2 in
		*\(*\))	shift
			prepred="$prepred `echo $1 | sed 's/\(.*\)(\(.*\))/\1 \2/'`"
			;;
		esac
		;;
	-A\(*\))
		prepred="$prepred `echo $1 | sed 's/-A\(.*\)(\(.*\))/\1 \2/'`"
		;;
	-[DI][-+][ABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
		stdpp=1
		case $1 in
		-I?[CH])	case $def in
				?*)	definclude="$definclude $1" ;;
				*)	stdinclude="$stdinclude $1" ;;
				esac
				;;
		-I-S*|-YI,*)	usrinclude="`echo $1 | sed 's/....//'`" ;;
		-Y?,*)		;;
		-Y*)		usrinclude="`echo $1 | sed 's/..//'`" ;;
		esac
		;;
	-D)	shift
		case $1 in
		[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_]*=*)
			predef="$predef
`echo $1 | sed -e 's/=.*//'`"
			;;
		[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_]*)
			predef="$predef
$1"
			;;
		esac
		;;
	-Dprobe);;
	-D*)	case $1 in
		-D[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_]*=*)
			predef="$predef
`echo $1 | sed -e 's/^-D//' -e 's/=.*//'`"
			;;
		-D[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_]*)
			predef="$predef
`echo $1 | sed -e 's/^-D//'`"
			;;
		esac
		;;
	-I)	shift
		case $1 in
		/*)	case $def in
			?*)	definclude="$definclude $1" ;;
			*)	stdinclude="$stdinclude $1" ;;
			esac
			cmdinclude="$cmdinclude $1"
			;;
		esac
		;;
	-I/*)	f=`echo X$1 | sed 's/X-I//'`
		case $def in
		?*)	definclude="$definclude $f" ;;
		*)	stdinclude="$stdinclude $f" ;;
		esac
		cmdinclude="$cmdinclude $f"
		;;
	-U)	shift
		undef="$undef $1"
		;;
	-U*)	undef="$undef `echo $1 | sed 's/^-U//'`"
		;;
	flags.$src)def=
		;;
	esac
done
stdinclude="$stdinclude $definclude"
case " $stdinclude " in
*\ $usrinclude\ *)
	case $usrinclude in
	/usr/include)
		usrinclude=
		;;
	*)	case " $stdinclude " in
		*\ /usr/include\ *)
			usrinclude=
			;;
		*)	usrinclude=/usr/include
			;;
		esac
		;;
	esac
	;;
esac

tstinclude=`$cc -v -E flags.$src 2>&1 | sed -e '1,/[iI][nN][cC][lL][uU][dD][eE][ 	]*<[.][.][.]>/d' -e '/^[eE][nN][dD] [oO][fF] [sS][eE][aA][rR][cC][hH]/,\$d'`
j=$tstinclude
case $j in
*/*)	;;
*)	j=$cmdinclude ;;
esac
tstinclude=
good=
nogood=
c_hdr="stdio.h ctype.h"
C_hdr="libc.h"
for i in $j
do	if	test -d "$i"
	then	tstinclude="$tstinclude $i"
		h=
		for f in $c_hdr
		do	if	test -f "$i/$f"
			then	case $i in
				*/CC)	nogood=1 ;;
				*)	good=1 ;;
				esac
			else	h="$h $f"
			fi
		done
		c_hdr=$h
		h=
		for f in $C_hdr
		do	if	test -f "$i/$f"
			then	case $i in
				*/CC)	nogood=1 ;;
				*)	good=1 ;;
				esac
			else	h="$h $f"
			fi
		done
		C_hdr=$h
	fi
done
case $nogood in
1)	good=0 ;;
esac
case $good in
1)	case $c_hdr in
	?*)	bad=1
		usrinclude=/usr/include
		set '' $tstinclude /usr/include
		;;
	*)	set '' $tstinclude
		;;
	esac
	shift
	stdinclude=$*
	echo "#include <sys/types.h>" > include.$src
	$cc -E include.$src | sed -e '/# 1 "[\\/]/!d' -e 's,[^"]*",,' -e 's,[\\/][^\\/]*".*,,' -e 's,[\\/]sys,,' > include.out
	for f in `cat include.out`
	do	if	test -d "$f"
		then	g=`echo $f | sed -e 's,[\\/][\\/]*[^\\/]*$,,'`
			case /$g/ in
			*/tmp/*|*/probe[0123456789]*)
				;;
			*)	case " $stdinclude " in
				*\ $f\ *|*\ $g\ *)
					;;
				*)	stdinclude="$stdinclude $f"
					case $f in
					/usr/include)	usrinclude=$f ;;
					esac
					bad=1
					;;
				esac
				;;
			esac
		fi
	done
	;;
*)	case $ppopt$ppenv in
	?*)	echo '#!'$sh'
		echo $VIRTUAL_ROOT | sed "s/:.*//"' > cpp
		chmod +x cpp
		ppcmd=cpp
		ppdir=.
		eval x='`'$ppenv '$'cc -E $ppopt flags.$src'`'
		case $x in
		?*)	tstinclude=$x/usr/include
			;;
		esac
		cp /bin/echo cpp
		chmod u+w cpp
		;;
	esac

	eval set x $probe_include
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		echo "#include <$1>" > include.$src
		$cc -E include.$src
	done > include.out

	ccinclude=
	x=$stdinclude
	stdinclude=
	subinclude=
	for f in $x $tstinclude `sed -e 's,\\\\,/,g' -e 's,///*,/,g' -e 's,"[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:/,"/,g' -e '/^#[line 	]*[0123456789][0123456789]*[ 	][ 	]*"[\\/]/!d' -e 's/^#[line 	]*[0123456789][0123456789]*[ 	][ 	]*"\(.*\)[\\/].*".*/\1/' include.out | sort -u`
	do	case $f in
		-*)	;;
		*/)	f=`echo $f | sed -e 's,//*\$,,'` ;;
		*/.)	f=`echo $f | sed -e 's,//*.\$,,'` ;;
		esac
		case $f in
		-I*)	;;
		*/cc)	ccinclude=1
			;;
		*/sys)	continue
			;;
		*/include/*/*)
			;;
		*/include/*)
			subinclude="$subinclude $f"
			continue
			;;
		esac
		if	test -d "$f"
		then	case " $stdinclude " in
			*\ $f\ *)	;;
			*)	stdinclude="$stdinclude $f" ;;
			esac
		fi
	done
	rm include.out
	case $ccinclude in
	?*)	eval set x $probe_include
		while	:
		do	shift
			case $# in
			0)	break ;;
			esac
			echo "#include <cc/$1>" > include.$src
			if	$cc -E include.$src > /dev/null
			then	break
			fi
		done
		case $# in
		0)	;;
		*)	x=$stdinclude
			stdinclude=
			for f in $x
			do	case $f in
				*/cc)	;;
				*)	stdinclude="$stdinclude $f" ;;
				esac
			done
			;;
		esac
		;;
	esac
	case $subinclude in
	?*)	for i in $subinclude
		do	for j in $stdinclude
			do	case $i in
				$j/*/*)	;;
				$j/*)	both=
					eval set x $probe_include
					while	:
					do	shift
						case $# in
						0)	for k in $both
							do	echo "#include <$k>" > include.$src
								$cc -E include.$src > include.out
								I=`grep -c $i/$k < include.out`
								J=`grep -c $j/$k < include.out`
								case $I:$J in
								0:*)	;;
								*:0)	stdinclude="$i $stdinclude"
									break
									;;
								esac
							done
							continue 3
							;;
						esac
						if	test -f $i/$1
						then	if	test ! -f $j/$1
							then	break 2
							fi
							both="$both $1"
						fi
					done
					;;
				$j)	continue 2
				;;
				esac
			done
			stdinclude="$i $stdinclude"
		done
		;;
	esac

	{

	for i in $stdinclude
	do
		case $i in
		$usrinclude)	;;
		*)		echo $i $i ;;
		esac
	done

	eval set x $probe_include
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		echo "#include <$1>" > t.c
		p=
		for j in `$cc -E t.c | grep "$1" | sed -e 's,\\\\,/,g' -e 's,"[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:/,"/,g' -e '/^#[line 	]*1[ 	][ 	]*"[\\/]/!d' -e 's/^#[line 	]*1[ 	][ 	]*"\(.*\)[\\/].*".*/\1/'`
		do	j=`echo $j | sed -e 's,///*,/,g' -e 's,/$,,'`
			case $p in
			?*)	echo $p $j ;;
			esac
			p=$j
		done
	done

	case $usrinclude in
	?*)	echo $usrinclude $usrinclude ;;
	esac

	} | tsort > tmp.tmp
	tstinclude=`cat tmp.tmp`
	bad=
	for i in $stdinclude
	do	case "
$tstinclude
" in
		*"
$i
"*)			;;
		*)	bad=1
			break
			;;
		esac
	done
	;;
esac

case $bad in
"")	x=$stdinclude
	stdinclude=
	z=
	for i in $tstinclude
	do	case " $x " in
		*" $i "*)
			stdinclude="$stdinclude $i"
			z=$i
			;;
		esac
	done
	case $usrinclude in
	'')	usrinclude=$z ;;
	esac
	;;
esac
case $hosted in
"")	case $usrinclude in
	/usr/include)	usrinclude= ;;
	esac
	;;
esac

case $usrinclude in
?*)	case " $stdinclude " in
	*\ $usrinclude\ *)
		x=$stdinclude
		stdinclude=
		for f in $x
		do	case $f in
			$usrinclude)	;;
			*)		stdinclude="$stdinclude $f" ;;
			esac
		done
		;;
	esac
	;;
esac

# drop dups -- they creep in somehow

x=$stdinclude
stdinclude=
for f in $x
do	case " $stdinclude $usrinclude " in
	*" $f "*)	;;
	*)		stdinclude="$stdinclude $f" ;;
	esac
done
:
### this script contains archaic constructs that work with all sh variants ###
# Glenn Fowler
# AT&T Research
#
# @(#)make.probe (AT&T Research) 2013-05-17
#
# C probe for make
#
# NOTE: C.probe must be included or .'d here
#

cc_dll_def=-D_BLD_DLL

probe_ar_arflags="-Xany"
probe_arflags="-xar"
probe_ccs="strip size nm ld ar" # longest to shortest
probe_debug="-g"
probe_dll="'-G 0' -Wc,dll,exportall,longname,rent -Wc,exportall -dynamic $cc_dll_def"
probe_export_dynamic="-rdynamic -export-dynamic -Wl,-export-dynamic -Wl,-E -bexpall -force_flat_namespace"
probe_gcc_optimize="-O2"
probe_gcc_version="*[Gg][Cc][Cc]*"
probe_include_local="'-ignore-source-dir -iquote' -iquote -I-"
probe_ldlazy='-zlazyload -znolazyload -Wl,-zlazyload -Wl,-znolazyload'
probe_ldlib="LD_LIBRARY_PATH LIBPATH LPATH"
probe_ldmap="'-Wl,-M' '-Qoption ld -M' '-Wl,-m' '-m'"
probe_ldorigin="-Wl,-z,origin"
probe_ldrecord='-zrecord -zignore -Wl,-zrecord -Wl,-zignore'
probe_ldrunpath="-Wl,-R, -R -Wl,-rpath, -L"
probe_ldstrip="'-s -mr' -Wl,-s"
probe_lib="a lib"
probe_lib_append="/usr/lib/pa1.1"
probe_lib_all_undef="-all -notall -all -none -Bwhole-archive -Bno-whole-archive -whole-archive -no-whole-archive -Wl,-whole-archive -Wl,-no-whole-archive -all_load '' -Wl,-zallextract -Wl,-zdefaultextract +forceload +noforceload"
probe_lib_multiple="-Wl,-zmuldefs"
probe_libdir="shlib lib"
probe_nm_nmflags="-Xany"
probe_nmflags="'' -p -B"
probe_optimize="-O"
probe_pic="-Kpic -KPIC -fpic -fPIC -pic -PIC +z +Z"
probe_no_protect="'-fno-stack-protector -fno-stack-protector-all' -GS-"
probe_readonly="-R -Krodata -xMerge -Wa,-r"
probe_shared="'' -G -b -c -shared -Wl,dll"
probe_shared_name="-Wl,-soname= -h"
probe_shared_nostart="-nostartfiles"
probe_shared_registry='"-update_registry $probe_shared_registry_file"'
probe_shared_registry_file='registry.ld'
probe_shared_registry_path="\$(LIBDIR)/$probe_shared_registry_file"
probe_strict="'-ansi -pedantic' '-ansi -strict' -strict -ansi"
probe_stripflags="'-f -s' -f -s"
probe_unresolved="'-expect_unresolved \"*\"'"
probe_warn="-Wall -fullwarn -w3 '-A -A' +w1"

echo '#pragma pp:version' > libpp.$src
echo '#define dDflag on' > dDflag.$src
echo 'int main(){return 0;}' > doti.$src
echo 'int code(){return 0;} int main(){return code();}' > export.$src
echo '#include <stdio.h>' > imstd.$src
echo '#include "_i_.h"' > imusr.$src
echo 'int x;' > _i_.h
mkdir im
echo '(' > im/stdio.h
echo '#include "implc_x.h"
int main(){f(1);return 0;}' > implc.$src
echo 'template <class T> void f(T){}' > implc_x.$src
echo 'template <class T> void f(T);' > implc_x.h
echo 'extern int NotalL(){return(0);}' > notall.$src
echo '#include <stdio.h>
extern int i;
int i = 1;
extern int f(){return(!i);}
int main(){FILE* fp=stdin;return(f());}' > pic.$src
echo 'class x {int n;} m;' > plusplus.$src
echo 'int prefix(){return 0;}' > prefix.$src
echo 'template<class T> int gt(T a, T b);
template<class T> int gt(T a, T b) { return a > b; }
int main () { return gt(2,1); }' > ptr.$src
echo 'int main(){return 0;}' > require.$src
echo '#if mips && !sgi || __CYGWIN__
( /* some systems choke on this probe */
#else
#if test_const
#define CONST const
#else
#define CONST
#endif
CONST char x[]={1,2,3,4,5,6,7,8,9,0};
int main(){*(char*)x=0; return x[0];}
#endif' > readonly.$src
# NOTE:	sfclose() defined on uwin, not defined on all other systems
echo 'extern int sfclose(); extern int ShareD(){return(sfclose());}' > shared.$src
echo '#define g(a,b) a ## b
volatile int a;
const int g(x,y)=1;
extern int c(int);' > stdc.$src
echo 'extern int f(); int main() { return f(); }' > sovmain.$src
echo 'int f() { return 0; }' > sovlib.$src
echo '#include <stdio.h>
int i;
int main(){int j;j = i * 10;return j;}' > strip.$src
echo 'template <class T> void f(T){}
int main(){f(1);return 0;}' > toucho.$src
echo '#if defined(__STDC__) || defined(__cplusplus)
extern type call(int);
#endif
int main() {call(0);return(0);}' > tstlib.$src
echo 'int main(){return 0;}' > warn.$src
echo 'int f(){return 0;}' > warn1.$src
echo 'int f(){}' > warn2.$src
echo 'int f(){int i; return 0;}' > warn3.$src
echo 'int f(){int i; return i;}' > warn4.$src
echo 'int f(){return g();}' > warn5.$src
warn_enum="1 2 3 4 5"

chmod -w *.$src

ar_arflags=
arflags=
cc_dll=
cc_pic=
cc_PIC=
dDflag=
debug=
dialect=
dll_dir='$(LIBDIR)'
dll_libraries=
dll_variants=
doti=
exectype=
export_dynamic=
gnu=
implicitc=
include_local=
lddynamic=
ldlazy=
ldnolazy=
ldnorecord=
ldorigin=
ldrecord=
ldrunpath=
ldscript=
ldstatic=
ldstrip=
Lflag=
lib_dll=
lib_all=
lib_undef=
libpath=
libpp=
makeoptions=
nm_nmflags=
nmedit=
nmflags=
no_protect=
optimize=
plusplus=
prefix_archive=lib
prefix_dynamic=
prefix_shared=lib
ptrcopy=
ptrimplicit=
ptrmkdir=
readonly=
repository=
require=
runpath=
shared=
shared_name=
shared_registry=
shellmagic=
soversion=
stdc=
strict=
stripflags=
symprefix=
toucho=
warn=

set $probe_lib
lib=$1

d=
for f in $stdinclude $usrinclude
do	case $f in
	-I*)	;;
	*)	d="$d $f" ;;
	esac
done
stdinclude=$d

set x $cc
cc_dir=`echo $2 | sed -e 's,/*[^/]*$,,'`
for c in $probe_ccs
do	if	$executable $cc_dir/$c
	then	x=$cc_dir/$c
	else	x=$c
	fi
	eval $c='$x'
done
ld_dir=
rm -f doti.$obj
if	$cc -c doti.$src
then	eval set x $probe_verbose
	shift
	for o
	do	$cc $o doti.$obj
		$cc $o doti.$obj -lF0oB@r
	done 2>&1 | sed -e 's/^[+ 	]*//' -e 's/[ 	].*//' -e '/^\//!d' -e 's/:$//' -e '/ld[a-zA-Z0-9.]*$/!d' -e 's,///*,/,g' > t
	for i in `cat t`
	do	rm -f t.$obj
		if test -x $i && $i -r -o t.$obj doti.$obj && test -f t.$obj
		then	case $ld in
			ld)	ld=$i ;;
			esac
			ld_dir=`echo $i | sed 's,/[^/]*$,,'`
			break
		fi
	done
fi
IFS=:
set x $PATH
IFS=$ifs
path=$*
m=
for c in $probe_ccs
do	eval o='$'$c
	case $o in
	$c)	;;
	*)	continue ;;
	esac
	C='${c}'
	for x in $cc_dir $ld_dir
	do	cd $x
		for p in "${C}" "${C}[!a-zA-Z]*" "*[!a-zA-Z]${C}" "*[!a-zA-Z]${C}[!a-zA-Z]*"
		do	eval set x $p
			case $# in
			2)	if	$executable $2
				then	case $2 in
					*$c*$c*);;
					*)	m=$p
						break 3
						;;
					esac
				fi
				;;
			esac
		done
	done
done
cd $tmpdir
for c in $probe_ccs
do	eval o='$'$c
	case $o in
	$c)	;;
	*)	continue ;;
	esac
	for x in $cc_dir $ld_dir
	do	if	$executable $x/$c
		then	eval $c='$x/$c'
			continue 2
		fi
		case $m in
		?*)	eval set x $x/$m
			case $# in
			2)	if	$executable $2
				then	eval $c='$2'
					continue 2
				fi
				;;
			esac
			;;
		esac
	done
	for x in $path
	do	if	$executable $x/$c
		then	eval $c='$x/$c'
			break
		fi
	done
done
dld=$cc

rm -f dynamic.$exe
if	$cc -o dynamic.$exe dynamic.$obj && $executable dynamic.$exe
then	mkdir mylib
	echo > mylib/libc.$lib
	eval set x $probe_ldlib
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f dynamic.$exe
		if	eval $1=./mylib '$'cc -o dynamic.$exe dynamic.$obj
		then	:
		else	libpath=$1
			break
		fi
	done
fi
test `$cc -E libpp.$src | grep -c '^#pragma pp:version "libpp '` -eq 1 && libpp=1
$cc -E doti.$src > doti.i && $cc -c doti.i && test -s doti.$obj && doti=1
if	$cc -c imusr.$src
then	eval set x $probe_include_local
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		if	$cc -c $1 imusr.$src
		then	: "$1 should skip \"_i_.h\" in ."
		elif	$cc -c imstd.$src
		then	if	$cc -c -Iim imstd.$src
			then	: '-Idir should find <stdio.h> in dir'
			elif	$cc -c $1 -Iim imstd.$src
			then	: "$1 -Idir should find <stdio.h> in dir"
			elif	$cc -c -Iim $1 imstd.$src
			then	include_local=$1
				break
			else	: "-Idir $1 should skip <stdio.h> in dir"
			fi
		else	: should find stdio.h
		fi
	done
else	: 'should find "_i_.h" in .'
fi

if	$cc -c pic.$src 2>e
then	e=`wc -l e`
	s=`$size pic.$obj; wc pic.$obj`
	eval set x $probe_pic
	shift
	while	:
	do	case $# in
		0|1)	break ;;
		esac
		pic=$1
		shift
		PIC=$1
		shift
		rm -f pic.$obj
		$cc $pic -c pic.$src 2>e && test -f pic.$obj || continue
		$cc $pic -o pic.$exe pic.$obj && test -f pic.$exe || {
			rm -f pic.$exe
			$cc -o pic.$exe pic.$obj && test -f pic.$exe && continue
		}
		case `wc -l e` in
		$e)	;;
		*)	continue ;;
		esac
		case $pic in
		???*)	m=`echo " $pic" | sed -e 's/^ [-+]//g' -e 's/./-& /g' -e 's/[-+] //g'`
			rm -f pic.$obj pic1.$exe
			if	$cc $m -c pic.$src 2>e && test -f pic.$obj &&
				$cc -o pic1.$exe pic.$obj && test -f pic1.$exe
			then	case `wc -l e` in
				$e)	cc_pic=$m
					break
					;;
				esac
			fi
			cc_pic=$pic
			break
			;;
		*)	case `$size pic.$obj; wc pic.$obj` in
			$s)	;;
			*)	cc_pic=$pic
				break
				;;
			esac
			;;
		esac
	done
	# this works around gcc 2.95 sun4 -fpic a.out core dump after exit
	case $hosted:$cc_pic in
	1:?*)   if	./pic.$exe
		then	# this catches lynxos.ppc gcc that dumps -fpic and not -mshared
			echo 'static int* f() { static int v; return &v; }
int main() { f(); return 0; }' > picok.$src
			$cc $cc_pic -o picok.$exe picok.$src && ./picok.$exe || cc_pic=
		else	cc_pic=
		fi
		;;
	esac
	case $cc_pic in
	?*)	rm -f pic.$obj
		if	$cc $PIC -c pic.$src 2>e && test -f pic.$obj
		then	cc_PIC=$PIC
		else	cc_PIC=$cc_pic
		fi
		;;
	*)	eval set x $probe_dll
		while	:
		do	shift
			case $# in
			0)	break ;;
			esac
			rm -f pic.$obj pic.$exe
			$cc $1 -c pic.$src 2>e && test -f pic.$obj || continue
			$cc $1 -o pic.$exe pic.$obj && test -f pic.$exe || {
				rm -f pic.$exe
				$cc -o pic.$exe pic.$obj && test -f pic.$exe && continue
			}
			case $1 in
			-Wc,*exportall*)
				# get specific since sgi gets this far too
				rm -f pic.$exe pic.x
				$cc -Wl,dll -o pic.$exe pic.$obj || continue
				test -f pic.$exe || continue
				test -f pic.x || continue
				cc_dll="-D_SHARE_EXT_VARS $1"
				so=.x
				sd=.dll
				dld=$cc
				shared=-Wl,dll
				prefix_shared=
				probe_sd=
				probe_shared=
				#unused# lddynamic=-Bdynamic
				#unused# ldstatic=-Bstatic
				lib_dll=SYMBOL
				break
				;;
			esac
			case `wc -l e` in
			$e)	cc_dll=$1
				break
				;;
			esac
		done
		;;
	esac
fi

$cc -c plusplus.$src && plusplus=1
$cc -E -dD dDflag.$src > t
case `grep '#define[ 	][ 	]*dDflag[ 	][ 	]*on' t` in
?*)	dDflag=1 ;;
esac
case `grep '#define.*_GNUC_' t` in
?*)	gnu=1 ;;
esac
case $plusplus in
"")	$cc -c stdc.$src && stdc=1 ;;
*)	mkdir ptr
	cd ptr
	$cc -c ../ptr.$src &
	NFS_locks_are_botched=$!
	cd ..
	if	$cc -c require.$src && $cc require.$obj
	then	set x `$cc require.$obj 2>&1`
		d=
		while	:
		do	shift
			case $# in
			0)	break ;;
			esac
			case $1 in
			-l*)	d="$d $1" ;;
			esac
		done
		for f in ++
		do	if $cc require.$obj -l$f
			then	set x `$cc require.$obj -l$f 2>&1`
				r=
				while	:
				do	shift
					case $# in
					0)	break ;;
					esac
					case $1 in
					-l*)	case " $d $r " in
						*" "$1" "*)	;;
						*)		r="$r $1" ;;
						esac
					esac
				done
				case $r in
				?*)	require="$require $f"
					echo '' $r > req.$f
					;;
				esac
			fi
		done
	fi
	cd ptr
	for i in *
	do	if	test -d $i
		then	repository=$i
			break
		fi
	done
	cd ..
	kill -9 $NFS_locks_are_botched
	rm -rf ptr
	case $repository in
	*?)	mkdir ptr
		cd ptr
		i=PTR
		case $repository in
		$i)	i=$i$i ;;
		esac
		$cc -ptr$i -c ../ptr.$src &
		NFS_locks_are_botched=$!
		cd ..
		sleep 5
		if	test -d ptr/$i/$repository
		then	ptrimplicit=1
		fi
		kill -9 $NFS_locks_are_botched
		rm -rf ptr
		;;
	esac
	$cc -o implc implc.$src && $executable implc && implicitc=1
	if	$cc -c toucho.$src && test -f toucho.$obj
	then	o=`ls -l toucho.$obj`
		if	$cc -o toucho toucho.$obj && $executable toucho
		then	n=`ls -l touch.$obj`
			case $n in
			"$o")	;;
			*)	toucho=1 ;;
			esac
		fi
	fi
	;;
esac

if	$cc -c pic.$src
then	eval set x $probe_nm_nmflags
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		case `$nm $1 pic.$obj | grep -c '[ 	]T[ 	]'` in
		0)	;;
		*)	nm_nmflags=$1
			break
			;;
		esac
	done
	eval set x $probe_nmflags
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		case `$nm $nm_nmflags $1 pic.$obj | grep -c '[0123456789][ 	][ 	]*T[ 	][ 	]*[_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]'` in
		0)	;;
		*)	nmflags=$1
			break
			;;
		esac
	done
	case $# in
	0)	case `$nm $nm_nmflags -gh pic.$obj | grep -c '|\.*[TtDdBbC][EeAaSsOo][XxTtSsMm]'` in
		0)	;;
		*)	nmflags=-gh
			nmedit="-e '/\.*[TtDdBbC][EeAaSsOo][XxTtSsMm]/!d' -e 's/[| 	].*//'"
			;;
		esac
		;;
	*)	nmedit="-e '/[ 	]T[ 	][ 	]*[_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]/!d' -e 's/.*[ 	]T[ 	][ 	]*//'"
		;;
	esac
fi

if	$cc -c doti.$src
then	eval set x $probe_stripflags
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		if	$strip $1 doti.$obj
		then	stripflags=$1
			break
		fi
	done
fi

rm -f export.$obj export.exe
if	$cc -c export.$src
then	lm=
	if	$cc -o export.exe export.$obj -lm 2>e && lm=-lm ||
		$cc -o export.exe export.$obj 2>e
	then	z=`wc -c < export.exe; $size export.exe 2>/dev/null`
		eval set x $probe_export_dynamic
		while	:
		do	shift
			case $# in
			0)	break ;;
			esac
			rm -f export.exe
			if	$cc -o export.exe $1 export.$obj $lm 2>f && $executable export.exe
			then	y=`wc -c < export.exe; $size export.exe 2>/dev/null`
				case $y in
				$z)	;;
				*)	if	cmp -s e f
					then	export_dynamic=$1
						break
					fi
					;;
				esac
			fi
		done
	fi
fi
rm -f export.$obj export.exe

rm -f strip.exe
if	$cc -o strip.exe strip.$src
then	z=`wc -c < strip.exe`
	eval set x $probe_ldstrip
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f strip.exe
		if	$cc -o strip.exe $1 strip.$src
		then	case `wc -c < strip.exe` in
			$z)	;;
			*)	ldstrip=$1
				break
				;;
			esac
		fi
	done
fi

rm -f strip.exe strip.$obj
if	$cc -c strip.$src && $cc -o strip.exe strip.$obj 2>e
then	eval set x x $probe_ldlazy
	while	:
	do	shift
		shift
		case $# in
		0)	break ;;
		esac
		rm -f strip.$exe
		$cc -o strip.$exe $1 strip.$obj $2 2>f && test -f strip.$exe || continue
		cmp -s e f || continue
		ldlazy=$1
		ldnolazy=$2
		break
	done
	eval set x x $probe_ldrecord
	while	:
	do	shift
		shift
		case $# in
		0)	break ;;
		esac
		rm -f strip.$exe
		$cc -o strip.$exe $1 strip.$obj $2 2>f && test -f strip.$exe || continue
		cmp -s e f || continue
		ldrecord=$1
		ldnorecord=$2
		break
	done
fi

case $cc_dll:$cc_pic:$so:$dynamic:$static in
::::|$cc_dll_def::::)
	: last chance dynamic checks
	while	:
	do
		echo '__declspec(dllexport) int fun() { return 0; }' > exp.$src
		if	$cc -c $cc_dll_def exp.$src
		then	rm -f xxx.dll xxx.lib
			if	$cc -shared -Wl,--enable-auto-image-base -Wl,--out-implib=xxx.lib -o xxx.dll exp.$obj &&
				test -f xxx.lib -a -f xxx.dll
			then
				: cygwin
				cc_dll=$cc_dll_def
				dll_dir='$(BINDIR)'
				sd=.dll
				so=.dll.a
				ldscript=".def .exp .ign .res"
				lib_dll=option
				lib_all=-Wl,-whole-archive
				lib_undef=-Wl,-no-whole-archive
				dld=$cc
				shared='-shared -Wl,--enable-auto-image-base -Wl,--out-implib=$(<:N=*'$so')'
				prefix_dynamic=cyg
				prefix_shared=lib
				break
			fi
		fi
		break
	done
	;;
*)	if	$cc -c $cc_dll $cc_pic shared.$src && $cc -c $cc_dll $cc_pic notall.$src
	then	for xx in "$cc" "$ld"
		do	eval set x $probe_shared
			while	:
			do	shift
				case $# in
				0)	break ;;
				esac
				rm -f xxx$dll
				# UNDENT ...

	if	$xx $1 -o xxx$dll shared.$obj 2>e && test -r xxx$dll
	then	if	test -s e && egrep -i 'unknown|invalid|option' e > /dev/null
		then	continue
		fi
		case `PATH=/bin:/usr/bin:$PATH file xxx$dll` in
		*lib*|*obj*|*shared*)
			;;
		"")	$executable xxx$dll || continue
			;;
		*ELF*|*elf*)
			$executable xxx$dll || continue
			case `strings xxx$dll | sed -e 's,.*[ |],,' | sort -u | egrep -i '^([._](dynamic|dynstr|dynsym))$'` in
			[012])	continue ;;
			esac
			;;
		*archive*not*stripped*|*data*dynamic*not*stripped*)
			$executable xxx$dll || continue
			;;
		*)	continue
			;;
		esac
		dld=$xx
		shared=$1
		# does -nostartfiles make sense for C?
		case $plusplus in
		'')	z=`wc -c < xxx$dll`
			eval set x $probe_shared_nostart
			while	:
			do	shift
				case $# in
				0)	break ;;
				esac
				rm -f xxx$dll
				if	$dld $shared $1 -o xxx$dll shared.$obj 2>e && test -r xxx$dll
				then	case `wc -c < xxx$dll` in
					$z)	;;
					*)	if	test -s e
						then	case `cat e` in
							*[Ee][Rr][Rr][Oo][Rr]*|*[Ww][Aa][Rr][Nn][Ii][Nn][Gg]*|*[Oo][Pp][Tt][Ii][Oo][Nn]*)
								continue
								;;
							esac
						fi
						case $shared in
						'')	shared=$1 ;;
						*)	shared="$shared $1" ;;
						esac
						break
						;;
					esac
				fi
			done
			;;
		esac
		case $cc_dll in
		"")	cc_dll=$cc_dll_def ;;
		esac
		eval set x x $probe_sd
		while	:
		do	shift
			shift
			case $# in
			[01])	break ;;
			esac
			rm -f xxx xxx$1 xxx$2
			if	$dld $shared -o xxx shared.$obj 2>e
			then	if	test -f xxx$1 -a \( -f xxx$2 -o "$cc_dll" = "$cc_dll_def" \)
				then	sd=$1
					so=$2
					lddynamic=-Bdynamic
					ldstatic=-Bstatic
					break 2
				elif	test -f xxx -a -f xxx$2
				then	sd=$1
					so=$2
					break 2
				else	case $so in
					'')	so=$1 ;;
					esac
					break
				fi
			fi
		done
		rm -f libxxx.$lib
		$ar cr libxxx.$lib shared.$obj
		ranlib libxxx.$lib
		eval set x x $probe_lib_all_undef
		rm -f xxx$dll
		if	$dld $shared -o xxx$dll libxxx.$lib && test -r xxx$dll
		then	if	$nm $nm_nmflags $nmflags xxx$dll | grep ShareD
			then	lib_dll=OPTION
				set x x
			fi
		fi
		while	:
		do	shift
			shift
			case $# in
			0|1)	break ;;
			esac
			rm -f xxx$dll
			if	$dld $shared -o xxx$dll $1 libxxx.$lib $2 && test -r xxx$dll
			then	if	$nm $nm_nmflags $nmflags xxx$dll | grep ShareD
				then	lib_dll=option
					lib_all=$1
					lib_undef=$2
					break
				fi
			fi
			case $2 in
			?*)	if	$dld $shared -o xxx$dll $1 libxxx.$lib && test -r xxx$dll
				then	if	$nm $nm_nmflags $nmflags xxx$dll | grep ShareD
					then	lib_dll=option
						lib_all=$1
						break
					fi
				fi
				;;
			esac
		done
		case $lib_dll in
		OPTION)	lib_dll=option
			;;
		option)	case $lib_undef in
			"")	rm -f libyyy.$lib
				$ar cr libyyy.$lib notall.$obj
				ranlib libyyy.$lib
				$cc -c prefix.$src
				eval set x x $probe_lib_all_undef
				while	:
				do	shift
					shift
					case $# in
					0|1)	break ;;
					esac
					rm -f xxx$dll
					if	$dld $shared -o xxx$dll prefix.$obj $lib_all libxxx.$lib $2 libyyy.$lib && test -r xxx$dll
					then	rm -f t
						$nm $nm_nmflags $nmflags xxx$dll > t
						case `grep -c ShareD t`:`grep -c NotalL t` in
						0:*)	;;
						*:0)	lib_undef=$2
							break
							;;
						esac
					fi
				done
				;;
			esac
			case $lib_undef in
			"")	eval set x $probe_lib_multiple
				rm -f libyyy.$lib
				cp libxxx.$lib libyyy.$lib
				rm -f xxx$dll
				if	$dld $shared -o xxx$dll prefix.$obj $lib_all libxxx.$lib libyyy.$lib && test -r xxx$dll
				then	:
				else	while	:
					do	shift
						case $# in
						0)	break ;;
						esac
						rm -f xxx$dll
						if	$dld $shared -o xxx$dll prefix.$obj $lib_all $1 libxxx.$lib libyyy.$lib && test -r xxx$dll
						then	rm -f t
							$nm $nm_nmflags $nmflags xxx$dll > t
							case `grep -c ShareD t` in
							0)	;;
							*)	lib_all="$lib_all $1"
								break
								;;
							esac
						fi
					done
				fi
				lib_dll=symbol
				;;
			esac
			;;
		*)	lib_dll=symbol
			;;
		esac
		case `cat e` in
		?*)	eval set x $probe_unresolved
			while	:
			do	shift
				case $# in
				0)	break ;;
				esac
				rm -f xxx$dll
				if	eval '$dld $shared' $1 '-o xxx$dll shared.$obj 2>e && test -r xxx$dll'
				then	case `cat e` in
					"")	shared="$shared $1"; break ;;
					esac
				fi
			done
			;;
		esac
		r=
		eval set x $probe_shared_registry
		while	:
		do	shift
			r=x$r
			case $# in
			0)	break ;;
			esac
			rm -f xxx$dll
			if	eval \$dld \$shared -o xxx\$dll $1 shared.\$obj &&
				test -r xxx$dll -a -r $probe_shared_registry_file
			then	probe_shared_registry_file='$(CC.SHARED.REGISTRY.PATH)'
				eval set x $probe_shared_registry
				i=
				while	:
				do	shift
					i=x$i
					case $i in
					$r)	break ;;
					esac
				done
				shared_registry=$1
			fi
		done
		break 2
	fi

				# ... INDENT
			done
		done
	fi
	case $so in
	?*)	rm -f xxx*
		if	$dld $shared -g -o xxx shared.$obj 2>e
		then	set x $probe_sdb
			while	:
			do	shift
				case $1 in
				0)	break ;;
				esac
				if	test -f xxx$1
				then	sdb=$1
					break
				fi
			done
		fi
		if	$cc -c require.$src
		then	p='
/usr/proberun/lib:/local/runprobe/lib
'
			eval set x $probe_ldrunpath
			while	:
			do	shift
				case $# in
				0)	break ;;
				esac
				rm -f require.exe
				if	$cc -o require.exe $1"$p" require.$obj &&
					grep -c /proberun/ require.exe >/dev/null &&
					grep -c /runprobe/ require.exe > /dev/null
				then	ldrunpath=$1
					eval set x $probe_ldorigin
					while	:
					do	shift
						case $# in
						0)	break ;;
						esac
						rm -f origin.exe
						if	$cc -o origin.exe $1 $ldrunpath'$ORIGIN' require.$obj
						then	if	./origin.exe > /dev/null 2>&1
							then	ldorigin="$1 $ldrunpath"'\$ORIGIN/$(BINDIR:P=R=$(DLLDIR))'
							fi
							break
						fi
					done
					break
				fi
			done
		fi
		rm -f libxxx$so
		if	$cc -c sovmain.$src &&
			$cc -c $cc_dll $cc_pic sovlib.c &&
			$dld $shared -o libxxx$so sovlib.$obj &&
			$cc -o sovmain.$exe -L. sovmain.$obj -lxxx
		then	rm -f sovmain.$exe
			mv libxxx$so libxxx$so.5.6
			if	$cc -o sovmain.$exe -L. sovmain.$obj -lxxx
			then	soversion=1
			fi
		fi
		rm -f doti.$obj
		std64=/lib64
		lcl64=/usr/local/lib64
		if	test -d $std64 -a -d $lcl64 && $cc -c doti.$src
		then	for i in `cd $lcl64; ls *$so 2>/dev/null | sed 's/lib\([^.]*\).*/\1/'`
			do	if	$cc -o runpath.$exe doti.$obj -l$i >/dev/null 2>&1
				then	LD_LIBRARY_PATH= ./runpath.$exe >/dev/null 2>&1 && continue
					if	LD_LIBRARY_PATH=$lcl64 ./runpath.$exe >/dev/null 2>&1
					then	runpath=$lcl64
						break
					elif	LD_LIBRARY_PATH=$std64 ./runpath.$exe >/dev/null 2>&1
					then	runpath=$std64
						break
					elif	LD_LIBRARY_PATH=$lcl64:$std64 ./runpath.$exe >/dev/null 2>&1
					then	runpath=$lcl64:$std64
						break
					fi
				fi
			done
		fi
		;;
	esac
	;;
esac

rm -f shared.$obj
if	$cc -c shared.$src
then	eval set x $probe_ar_arflags
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f libxxx.$lib
		if	$ar $1 r libxxx.$lib shared.$obj && $ar $1 t libxxx.$lib 2>&1 | grep shared.$obj >/dev/null
		then	ar_arflags=$1
			break
		fi
	done
	eval set x $probe_arflags
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f libxxx.$lib
		if	$cc $1 -o libxxx.$lib shared.$obj && $ar t libxxx.$lib 2>&1 | grep shared.$obj >/dev/null
		then	arflags=$1
			break
		fi
	done
fi

case $shared in
-G)	case $cc_dll in
	"")	cc_dll=$cc_dll_def ;;
	esac
	;;
*)	case $lib_dll in
	symbol)	echo 'extern int f();
	int main() { f(); return 0; }' > main.$src
		echo '#include <stdio.h>
	int f() { printf("hello world"); return 0; }' > member.$src
		if	$cc -c main.$src && $cc -c member.$src
		then	echo f > lib.exp
			rm -f lib.$obj main.exe
			if	$ld -o lib.$obj -L: -bexport:lib.exp -berok -bmodtype:SRE -T512 -H512 -lm -lc member.$obj && $cc -o main.exe main.$obj lib.$obj
			then	dld=$ld
				shared='-T512 -H512 -L$(LIBDIR): -berok -bmodtype:SRE'
				lib_dll=export
				dll_libraries='-lm -lc'
				ldscript=.exp
				case $cc_dll in
				"")	cc_dll=$cc_dll_def ;;
				esac
				case $so in
				"")	so=.$obj ;;
				esac
			fi
		fi
		;;
	esac
	;;
esac
case $shared in
?*)	if	$cc -c $cc_dll $cc_pic shared.$src
	then	eval set x $probe_shared_name
		while	:
		do	shift
			case $# in
			0)	break ;;
			esac
			rm -f xxx$dll
			if	$dld $shared ${1}libfoo.1.2 -o xxx$dll shared.$obj 2>e && test -r xxx$dll
			then	shared_name=$1
				break
			fi
		done
	fi
	;;
esac
case " $cc_dll " in
*" $cc_dll_def "*)
	;;
"  ")	;;
*)	cc_dll="$cc_dll_def $cc_dll"
	;;
esac

case $hosttype in
win32.*|cygwin.*|os2.*)
	Lflag=1
	;;
*)	if	$cc -c doti.$src
	then	if	$cc -L. doti.$obj -lc >/dev/null
		then	case $cc_dll in
			'')	;;
			*)	Lflag=1 ;;
			esac
		fi
	fi
	;;
esac

case $lib_dll in
option)	case $hosttype in
	linux.*)	dll_libraries=-lc ;;
	esac
	;;
SYMBOL)	lib_dll=symbol
	;;
symbol)	echo "#include <stdio.h>
extern int fun()
{
	puts(\"fun\");
	return 0;
}" > dllib.$src
	echo "extern int fun();
int
main()
{
	return fun();
}" > dlmain.$src
	pwd=`pwd`
	while	:
	do
		if	$cc -c $cc_dll $cc_pic dlmain.$src &&
			$cc -c $cc_dll $cc_pic dllib.$src
		then	rm -f libxxx$so
			if	$dld $shared -o libxxx$so dllib.$obj &&
				chmod 555 libxxx$so
			then	rm -f dlmain.$exe
				if	$cc -o dlmain.$exe dlmain.$obj $pwd/libxxx$so &&
					(./dlmain.$exe) >/dev/null 2>&1
				then	break
				fi
			fi
			rm -f libxxx$so dlmain.$exe
			if	$dld $shared -o libxxx$so dllib.$obj -lm -lc &&
				chmod 555 libxxx$so &&
				$cc -o dlmain.$exe dlmain.$obj $pwd/libxxx$so &&
				(./dlmain.$exe) >/dev/null 2>&1
			then	dll_libraries='-lm -lc'
			fi
		fi
		break
	done
	# the dll_libraries probe is still lame
	case $dll_libraries in
	'')	case $hosttype in
		sco.*|sol*.*|sun*)	;;
		*)			dll_libraries='-lm -lc' ;;
		esac
		;;
	esac
	;;
esac

ld_library_path=$LD_LIBRARY_PATH
LD_LIBRARY_PATH=
keepstdlib=0
stdlibenv=
stdlib=
a=`$cc -print-multi-directory 2>/dev/null`
case $a in
.)	;;
*)	for d in `$cc -print-search-dirs 2>/dev/null | sed -e '/^libraries:/!d' -e 's/.*=//' | tr : '\n' | grep /lib/`
	do	if	[ -d ${d}${a} ]
		then	stdlib="$stdlib ${d}${a}"
		else	case $d in
			*/lib/)	d=`echo '' $d | sed -e 's,/$,,'`
				if	[ -d ${d}${a} ]
				then	stdlib="$stdlib ${d}${a}"
				fi
				;;
			esac
		fi
	done
	;;
esac
case $stdlib in
'')	stdlib=`$cc -dryrun doti.$src 2>&1 | sed -e '/ -Y P,/!d' -e 's/.* -Y P,//' -e 's/ .*//' -e 's/:/ /g'`
	case $stdlib in
	?*)	keepstdlib=1
		stdlibenv='$(LD_LIBRARY_PATH:/:/ /G)'
		;;
	esac
	;;
esac
case $keepstdlib in
1)	;;
*)	case $stdlib in
	'')	stdlib=`$cc -v doti.$src 2>&1 |
			sed 's/  */\n/g' |
			sed -e '/^-L/!d' -e 's/^-L//' |
			while read dir
			do	if	test -d "$dir"
				then	(cd "$dir"; pwd)
				fi
			done`
		;;
	*)	eval set x $probe_verbose
		shift
		for o in "$@"
		do	stdlib="$stdlib "`$cc $o doti.$src 2>&1 |
			sed 's/  */\n/g' |
			sed -e '/^-L/!d' -e '/\/lib64$/!d' -e 's/^-L//'`
		done
		;;
	esac
	LD_LIBRARY_PATH=$ld_library_path
	case $stdlib in
	?*)	keepstdlib=1
		o=$stdlib
		stdlib=
		for dir in $o
		do	case " $stdlib " in
			*" $o "*) continue ;;
			esac
			case $dir in
			/usr/lib64)
				i=/usr/local/lib64
				a=/lib64
				;;
			/lib64) i=/usr/local/lib64
				a=/usr/lib64
				;;
			/usr/lib)
				i=/usr/local/lib
				a=/lib
				;;
			lib)	i=/usr/local/lib
				a=/usr/lib
				;;
			*)	i=
				a=
				;;
			esac
			if	test "" != "$i" -a -d "$i"
			then	case " $o " in
				*" $i "*)
					;;
				*)	stdlib="$stdlib $i"
					;;
				esac
			fi
			stdlib="$stdlib $dir"
			if	test "" != "$a" -a -d "$a"
			then	case " $o " in
				*" $a "*)
					;;
				*)	stdlib="$stdlib $a"
					;;
				esac
			fi
		done
		case $hosted in
		1)	case " $stdlib " in
			*" /usr/lib "*)
				;;
			*)	case " $stdlib " in
				*" /usr/local/lib "*)
					;;
				*)	stdlib="$stdlib /usr/local/lib"
					;;
				esac
				stdlib="$stdlib /usr/lib"
				;;
			esac
			case " $stdlib " in
			*" /lib "*)
				;;
			*)	stdlib="$stdlib /lib"
				;;
			esac
		esac
		;;
	*)	keepstdlib=0
		case $dir in
		*/arch/$hosttype/lib/*)
			notlib=`echo $dir | sed "s,/arch/$hosttype/lib/.*,/arch/$hosttype/lib,"`
			;;
		*)	notlib=////
			;;
		esac
		tstlib=
		implib=
		if	$cc -c hosted.$src
		then	for f in `(
				eval set x $probe_verbose
				while	:
				do	shift
					case $# in
					0)	break ;;
					esac
					$cc $1 hosted.$obj
				done
				) 2>&1 | sed -e 's/[ 	:]/\\
		/g' -e 's/-L//g' -e 's/^P,//' -e "s/[\"']//g" -e 's,^[\\\\/]*[\\\\/],/,' | sed -e '/^\$/d' -e '/^[-+]/d' -e '/^[^\\\\\\/]/d' -e '/[\\\\\\/]tmp[\\\\\\/]/d' -e 's/:\$//' -e 's,//*$,,'`
			do	case " $tstlib $implib " in
				*" $f "*)	continue ;;
				esac
				case $f in
				$notlib)	continue ;;
				esac
				if	test -d $f
				then	tstlib="$tstlib $f"
				elif	test -f $f
				then	d=`echo $f | sed -e 's,[\\\\/]*[^\\\\/]*\$,,'`
					case " $tstlib $implib " in
					*" $d "*)	continue ;;
					esac
					case $d in
					*[\\/]usr[\\/]lib)
						x=$d
						d="`echo $d | sed -e 's,[\\\\/][\\\\/]*usr[\\\\/]lib\$,/lib,'`"
						case " $tstlib $implib " in
						*" $d "*)	;;
						*)		implib="$implib $d" ;;
						esac
						implib="$implib $x"
						;;
					*[\\/]lib)
						implib="$implib $d"
						d="`echo $d | sed -e 's,[\\\\/][\\\\/]*lib\$,/usr/lib,'`"
						case " $tstlib $implib " in
						*" $d "*)	;;
						*)		implib="$implib $d" ;;
						esac
						;;
					*)	implib="$implib $d"
						;;
					esac
				fi
			done
		fi
		tstlib="$tstlib $implib"
		if	$cc -Dtype=void -Dcall=exit -c tstlib.$src && mv tstlib.$obj tst.$obj
		then	case $plusplus in
			'')	probe_lxx= ;;
			esac
			l=
			for sym in $probe_l $probe_lxx
			do	case $l in
				"")	l=$sym; continue ;;
				esac
				rm -f tstlib.$exe
				if	$cc -o tstlib.$exe tst.$obj -l$l
				then	eval set x $probe_ldmap
					while	:
					do	shift
						case $# in
						0)	break ;;
						esac
						d=`$cc -Dtype=int -Dcall=$sym $static $1 tstlib.$src -l$l 2>&1 | sed -e '/[\\\\\\/].*[\\\\\\/]lib[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+][abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+]*\.[^\\\\\\/]*\$/!d' -e 's,^[^\\\\\/]*,,' -e 's,[\\\\\\/]lib[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+][abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+]*\.[^\\\\\\/]*\$,,' -e '/^[\\\\\\/]/!d' | sort -u`
						case $d in
						?*)	tstlib="$tstlib $d" ;;
						esac
					done
				fi
				l=
			done
		fi
		libstd=
		libset=
		stdlibroot="/ /usr/"
		for d in $tstlib
		do	case $d in
			[\\/]lib|[\\/]usr[\\/]lib)
				;;
			*)	case " $stdlib " in
				*\ $d\ *)
					;;
				*)	if	ls $d ${PREROOT+$PREROOT/../$d} > tmp.tmp && test -s tmp.tmp
					then	for i in $probe_lib $obj
						do	if	grep -i "\\.$i\$" tmp.tmp >/dev/null
							then	case " $probe_lib_append " in
								*\ $d\ *)
									libstd="$libstd $d"
									;;
								*)	stdlib="$stdlib $d"
									case $d in
									/usr/lib|/usr/lib/*)
										;;
									/usr/lib?*)
										e=`echo $d | sed -e 's,/usr,,'`
										g=`echo $d/libc.* $e/libc.*`
										case "$e $g " in
										*".* "*);;
										*)	stdlib="$stdlib $e"
											stdlibroot=
											;;
										esac
										;;
									esac
									;;
								esac
								case $libset in
								"")	case $i in
									$obj)	;;
									*)	libset=1
										lib=$i
										;;
									esac
									;;
								esac
								break
							fi
						done
					fi
					;;
				esac
				;;
			esac
		done
		for d in `$ld --verbose 2>&1 | sed -e '/SEARCH_DIR/!d' -e 's/[ 	][ 	][ 	]*/ /g' -e 's/SEARCH_DIR(\([^ ]*\));/\1/g' -e 's, //[^ ]*,,' -e 's,",,g'`
		do	if	test -d $d
			then	case " $stdlib $libstd " in
				*\ ${d}\ *)
					;;
				*)	libstd="$libstd $d"
					;;
				esac
			fi
		done
		case $hosted in
		"")	tstlib= ;;
		*)	tstlib="$stdlibroot /usr/ccs/ /usr/local/" ;;
		esac
		case $stdlibroot in
		?*)	d=
			for f in $stdinclude
			do	f=`echo $f | sed -e 's,[^\\\\/]*\$,,'`
				d="$d $f"
			done
			tstlib="$d $tstlib"
			;;
		esac
		$cc -c doti.$src > all.tmp
		for f in $probe_libdir
		do	for d in $stdlib $libstd $tstlib
			do	if	test -d ${d}${f}
				then	ls ${d}${f} ${PREROOT:+$PREROOT/../${d}${f}} |
					while read i
					do	for j in ${d}${f}/${i} ${PREROOT:+$PREROOT/../${d}${f}/${i}}
						do	if	test -f $j -a -r $j -a -s $j
							then	echo $i
								break
							fi
						done
					done > tmp.tmp
					if	test -s tmp.tmp
					then	if	egrep -i "^${prefix_archive}[abcdefghijklmnopqrstuvwxyz0123456789_][abcdefghijklmnopqrstuvwxyz0123456789_]*\\.$lib\$" tmp.tmp >lib.tmp ||
							egrep -i "\\.$obj\$" tmp.tmp >/dev/null ||
							egrep -i "^${prefix_shared}[abcdefghijklmnopqrstuvwxyz0123456789_][abcdefghijklmnopqrstuvwxyz0123456789_]*\\$so(.[0-9]+)*\$" tmp.tmp >>lib.tmp
						then	if	test -s lib.tmp
							then	sed -e "s,.*/,," -e 's,^'${prefix_archive}'\(.*\)\.'$lib'$,\1,g' -e 's,^'${prefix_shared}'\(.*\)\'$so'[.0-9]*,\1,g' lib.tmp | sort -u > tmp.tmp
								xs=`sort all.tmp all.tmp tmp.tmp | uniq -u`
								case $xs in
								'')	continue ;;
								esac
								ok=0
								for x in $xs
								do	case $x in
									*_p)	continue ;; # linux gcc known to hang for -lc_p
									esac
									if	$cc -o doti.$exe doti.$obj -l$x 2>e
									then	ok=1
									else	if	test -s e && egrep -i ":.*[ 	](find|found|locate|search|-l$x)[ 	]" e > /dev/null
										then	if	egrep -i ":.*[ 	](access|permission)[ 	]" e
											then	: maybe
											else	ok=0
												break
											fi
										fi
										case $Lflag in
										1)	if	$cc -L${d}${f} -o doti.$exe doti.$obj -l$x
											then	ok=0
												break
											fi
											;;
										esac
									fi
								done
								case $ok in
								0)	continue ;;
								esac
								sort -u all.tmp tmp.tmp > lib.tmp
								mv lib.tmp all.tmp
							fi
							case " $stdlib $libstd " in
							*" ${d}${f} "*)
								;;
							*)	if	test -d ${d}${f}/fsoft
								then	stdlib="$stdlib ${d}${f}/"'$(FLOAT_OPTION)'
								fi
								stdlib="$stdlib ${d}${f}"
								;;
							esac
						fi
					fi
				fi
			done
		done
		stdlib="$stdlib $libstd"
		case $stdlib in
		*/shlib*)
			dy=
			st=
			for i in $stdlib $libstd
			do	case $i in
				*/shlib)	dy="$dy $i" ;;
				*)		st="$st $i" ;;
				esac
			done
			for i in /var
			do	if	test -d $i/shlib
				then	dy="$dy $i/shlib"
				fi
			done
			stdlib="$dy $st"
			;;
		esac
		;;
	esac
	;;
esac

if	$cc -c prefix.$src
then	eval set x $probe_symprefix
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		if	$nm $nm_nmflags $nmflags prefix.$obj | grep -c ${1}prefix >/dev/null
		then	symprefix=$1
			break
		fi
	done
fi

if	$cc -c warn.$src 2>e && test -f warn.$obj
then	e=`wc -c < e`

	eval set x $probe_debug
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f warn.$obj
		$cc $1 -c warn.$src 2>e && test -f warn.$obj || continue
		case `wc -c < e` in
		$e)	debug=$1; break ;;
		esac
	done

	eval set x $probe_no_protect
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f warn.$obj
		$cc $1 -c warn.$src 2>e && test -f warn.$obj || continue
		case `wc -c < e` in
		$e)	no_protect=$1; break ;;
		esac
	done

	case $version_string in
	$probe_gcc_version)	probe_optimize="$probe_gcc_optimize $probe_optimize" ;;
	esac
	eval set x $probe_optimize
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f warn.$obj
		$cc $1 -c warn.$src 2>e && test -f warn.$obj || continue
		case `wc -c < e` in
		$e)	optimize=$1; break ;;
		esac
	done

	eval set x $probe_strict
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f warn.$obj
		$cc $1 -c warn.$src 2>e && test -f warn.$obj || continue
		n=`wc -c < e`
		if	test $n -ge $e
		then	strict=$1
			break
		fi
	done

	$cc -c warn1.$src 2>e
	o=`wc -c < e`
	eval set x $probe_warn
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		rm -f warn.$obj warn.$exe
		$cc -o warn.$exe $1 warn.$src 2>e && test -f warn.$exe || continue
		n=`wc -c < e`
		for i in $warn_enum
		do	rm -f warn$i.$obj
			$cc -c $1 warn$i.$src 2>e && test -f warn$i.$obj || continue
			n=`wc -c < e`
			if	test $n -gt $o
			then	warn=$1
				break 2
			fi
		done
	done

fi

while	:
do	case $hosted in
	1)	rm -f readonly.$exe
		eval set x '""' $probe_readonly
		while	:
		do	shift
			case $# in
			0)	break ;;
			esac
			for co in '' -Dtest_const
			do	rm -f readonly.$exe
				if	$cc -o readonly.$exe $co $1 readonly.$src && $executable readonly.$exe
				then	if	./readonly.$exe >/dev/null 2>&1
					then	:
					else	readonly=$1
						break 3
					fi
				fi
			done
		done
		rm -f readonly.$exe readonly.s
		if	$cc -S readonly.$src && test -f readonly.s
		then	if	sed	-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)data/\1text/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)zero[ 	][ 	]*/\1set	.,.+/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)space[ 	][ 	]*1/\1byte 0/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)space[ 	][ 	]*2/\1byte 0,0/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)space[ 	][ 	]*3/\1byte 0,0,0/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)space[ 	][ 	]*4/\1byte 0,0,0,0/' \
					readonly.s > ro.s && $cc -o readonly.$exe ro.s && $executable readonly.$exe
			then	if	./readonly.$exe >/dev/null 2>&1
				then	:
				else	readonly='-S.data'
					break
				fi
			fi
			rm -f readonly.$exe
			if	sed	-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)idat/\1code/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)zero[ 	][ 	]*/\1set	.,.+/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)space[ 	][ 	]*1/\1byte 0/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)space[ 	][ 	]*2/\1byte 0,0/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)space[ 	][ 	]*3/\1byte 0,0,0/' \
					-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)space[ 	][ 	]*4/\1byte 0,0,0,0/' \
					readonly.s > ro.s && $cc -o readonly.$exe ro.s && $executable readonly.$exe
			then	if	./readonly.$exe >/dev/null 2>&1
				then	:
				else	readonly='-S.idat'
					break
				fi
			fi
			if	sed	-e 's/^\([ 	]*[.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$:]*[ 	]*\.*\)data/\1rdata/' \
					readonly.s > ro.s && $cc -o readonly.$exe ro.s && $executable readonly.$exe
			then	if	./readonly.$exe >/dev/null 2>&1
				then	:
				else	readonly='-S.rdata'
					break
				fi
			fi
		fi
		;;
	esac
	break
done

case $stdc in
?*)	dialect="$dialect ANSI" ;;
esac
case $plusplus in
?*)	dialect="$dialect C++" ;;
esac
case $hosted in
"")	dialect="$dialect CROSS" ;;
esac
case $doti in
?*)	dialect="$dialect DOTI" ;;
esac
case $gnu in
?*)	dialect="$dialect GNU" ;;
esac
case $so:$dynamic:$static in
::)	;;
*)	dialect="$dialect DYNAMIC"
	case $soversion in
	?*)	dialect="$dialect VERSION" ;;
	esac
	;;
esac
case $implicitc in
?*)	dialect="$dialect IMPLICITC" ;;
esac
case $ptrcopy in
?*)	dialect="$dialect PTRCOPY" ;;
esac
case $ptrimplicit in
?*)	dialect="$dialect PTRIMPLICIT" ;;
esac
case $ptrmkdir in
?*)	dialect="$dialect PTRMKDIR" ;;
esac
case $libpp in
?*)	dialect="$dialect LIBPP" ;;
esac
case $toucho in
?*)	dialect="$dialect TOUCHO" ;;
esac
case $dDflag in
?*)	dialect="$dialect -dD" ;;
esac
# 2005-05-25 use $(CC.INCLUDE.LOCAL) instead
case $include_local in
?*)	dialect="$dialect -I-" ;;
esac
case $Lflag in
?*)	dialect="$dialect -L" ;;
esac

ppcmd='$(CPP)'
ppdir='$(CPP:D)'
eval ppopt='"'$ppopt'"'
eval ppenv='"'$ppenv'"'

set x "" .$exe
shift
exe=
for i
do	rm -f require$i
done
if	$cc -o require require.$src
then	for i
	do	if	$executable require$i
		then	exe=$i
			break
		fi
	done
fi
case $sa:$sd:$so in
::?*)	eval set x $probe_sa
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		for i in $stdlib
		do	eval j="'" $i/lib*$1 "'"
			case $j in
			" $i/lib*$1 ")
				eval j="'" $i/lib*$1.[0123456789]* "'"
				case $j in
				" $i/lib*$1.[0123456789]* ")
					continue
					;;
				esac
				;;
			esac
			sa=$1
			lddynamic=-Bdynamic
			ldstatic=-Bstatic
			break 2
		done
	done
	;;
esac
case $ldscript in
"")	case $so in
	.lib)	ldscript=".def .exp" ;;
	*)	ldscript=".ld" ;;
	esac
	;;
esac
case $hosttype in
'')		hosttype=unknown ;;
sgi.mips3)	dll_variants='sgi.mips2:o32:-mips2 sgi.mips4:64:-mips4' ;;
sgi.mips4)	dll_variants='sgi.mips2:o32:-mips2 sgi.mips3:n32:-mips3' ;;
esac

case $hosted in
"")	ccnative=`echo $cc | sed -e 's,.*/,,'`
	ccs=$ccnative
	for c in cc gcc
	do	case " $ccs " in
		*" $c "*)	;;
		*)		ccs="$ccs $c" ;;
		esac
	done
	for p in $path
	do	for c in $ccs
		do	if	$executable $p/$c
			then	rm -f native.$exe
				if	$p/$c -o native.$exe doti.$src && ./native.$exe
				then	ccnative=$p/$c
					exectype=`package CC="$ccnative" || $SHELL -c "package CC='$ccnative'"`
					case $exectype in
					*[Uu][Ss][Aa][Gg][Ee]:*)
						exectype=`PATH=$_probe_PATH; export PATH; package CC="$ccnative" || $SHELL -c "package CC='$ccnative'"`
						;;
					esac
					break 2
				fi
			fi
		done
	done
	;;
*)	ccnative=$cc
	exectype=$hosttype
	;;
esac

# runtime shared lib exported symbol resolution

case $cc_dll:$shared in
:|:*|*:);;
*)	cat > cmd.c <<'!'
#include <stdio.h>
#include <dlfcn.h>
typedef int (*Lib_f)(int**, int**, int**);
int	gbl_def = 1;
int	gbl_ref = 1;
int	gbl_ext;
int main(int argc, char** argv)
{
	void*	dll;
	Lib_f	lib;
	int*	def;
	int*	ref;
	int*	ext;

	if (!(dll = dlopen(*++argv, RTLD_LAZY)))
		fprintf(stderr, "library not found\n");
	else if (!((lib = (Lib_f)dlsym(dll, "lib"))) && !(lib = (Lib_f)dlsym(dll, "_lib")))
		fprintf(stderr, "symbol not found\n");
	else if ((*lib)(&def, &ref, &ext))
		fprintf(stderr, "function failed\n");
	else if (def == &gbl_def && ref == &gbl_ref && ext == &gbl_ext)
		printf("ALL\n");
	else if (ref == &gbl_ref && ext == &gbl_ext)
		printf("REF\n");
	else if (ext == &gbl_ext)
		printf("EXT\n");
	return 0;
}
!
	cat > lib.c <<'!'
int	gbl_def = 1;
int	gbl_ref;
int	gbl_ext;
int lib(int** def, int** ref, int** ext)
{
	*def = &gbl_def;
	*ref = &gbl_ref;
	*ext = &gbl_ext;
	return 0;
}
!
	if	$cc -c $cc_dll $cc_pic cmd.c &&
		$cc -c $cc_dll $cc_pic lib.c && {
			$cc $cc_dll $export_dynamic -o cmd.exe cmd.o ||
			$cc $cc_dll $export_dynamic -o cmd.exe cmd.o -ldl
		} &&
		$dld $shared -o libgbl.dll lib.o
	then	x=`./cmd.exe ./libgbl.dll`
	else	x=
	fi
	case $x in
	?*)	dialect="$dialect EXPORT=$x"
		;;
	*)	case $sd:$hosttype in
		.dll:*win*)	dialect="$dialect EXPORT=DLL" ;;
		esac
		;;
	esac
	;;
esac

# shellmagic defined if installed shell scripts need magic

echo ': got magic :
echo ok' > ok
chmod +x ok
case `(eval ./ok | /bin/sh) 2>/dev/null` in
ok)	;;
*)	echo '#!/bin/env sh
: got magic :
echo ok' > ok
	chmod +x ok
	case `(eval ./ok | /bin/sh) 2>/dev/null` in
	ok)	shellmagic='$("#")!/bin/env sh'
		;;
	*)	for i in /emx/bin/bash.exe /emx/bin/sh.exe
		do	if	test -x $i
			then	shellmagic='$("#")!'$i
				break
			fi
		done
		;;
	esac
	;;
esac

#
# path cleanup
#

for i in ar ccnative dld ld nm size stdinclude stdlib strip 
do	eval o='$'$i
	v=$o
	case $v in
	*//*)	v=`echo $v | sed 's,///*,/,g'` ;;
	esac
	if	(test . -ef "`pwd`")
	then	k=
		for x in $v
		do	case $x in
			*/../*|*/..)
				case $x in
				/*)	a=/ ;;
				*)	a= ;;
				esac
				IFS=/
				set '' $x
				IFS=$ifs
				r=
				for d
				do	r="$d $r"
				done
				p=
				g=
				for d in $r
				do	case $d in
					..)	g="$g $d" ;;
					*)	case $g in
						'')	case $p in
							'')	p=$d ;;
							*)	p=$d/$p ;;
							esac
							;;
						*)	set $g
							shift
							g=$*
							;;
						esac
						;;
					esac
				done
				case $a in
				'')	for d in $g
					do	p=$d/$p
					done
					;;
				*)	p=$a$p
					;;
				esac
				case $p in
				/)	continue ;;
				esac
				test $x -ef $p && x=$p
				;;
			esac
			k="$k $x"
		done
		set '' $k
		shift
		v=$1
		case $# in
		0)	;;
		*)	shift
			while	:
			do	case $# in
				0)	break ;;
				esac
				k=
				for d
				do	for j in $v
					do	test $d -ef $j && continue 2
					done
					k="$k $d"
				done
				set '' $k
				case $# in
				1)	break ;;
				esac
				shift
				v="$v $1"
				shift
			done
			;;
		esac
	fi
	case $v in
	$o)	;;
	*)	eval $i='$'v ;;
	esac
done

case $keepstdlib in
1)	;;
*)	#
	# favor lib64 over lib
	#
	case $hosttype in
	*64|*[!0-9]64[!a-zA-Z0-9]*)
		o=$stdlib
		stdlib=
		for i in $o
		do	case " $stdlib " in
			*" $i "*)
				continue
				;;
			esac
			case $i in
			*64)	stdlib="$stdlib $i"
				continue
				;;
			esac
			case " $o " in
			*" ${i}64 "*)
				case " $stdlib " in
				*" ${i}64 "*)
					;;
				*)	stdlib="$stdlib ${i}64"
					;;
				esac
				;;
			esac
			stdlib="$stdlib $i"
		done
		;;
	esac
	;;
esac
case $stdlibenv in
?*)	stdlib="$stdlibenv $stdlib" ;;
esac

#
# set up for local override
#

CC_VERSION_STAMP=$version_stamp
CC_VERSION_STRING=$version_string
CC_CC=$cc
CC_NATIVE=$ccnative
CC_EXECTYPE=$exectype
CC_HOSTTYPE=$hosttype
CC_ALTPP_FLAGS=$ppopt
CC_ALTPP_ENV=$ppenv
CC_AR=$ar
CC_AR_ARFLAGS=$ar_arflags
CC_ARFLAGS=$arflags
CC_DEBUG=$debug
CC_DIALECT=$dialect
CC_PICBIG=$cc_PIC
CC_PICSMALL=$cc_pic
CC_PIC=$CC_PICBIG
CC_DLL_ONLY=$cc_dll
case $CC_DLL_ONLY in
'')	CC_DLLBIG=
	CC_DLLSMALL=
	CC_DLL=
	;;
*)	CC_DLLBIG="$CC_DLL_ONLY $CC_PICBIG"
	CC_DLLSMALL="$CC_DLL_ONLY $CC_PICSMALL"
	CC_DLL="$CC_DLL_ONLY $CC_PICBIG"
	;;
esac
CC_DLL_DIR=$dll_dir
CC_DLL_LIBRARIES=$dll_libraries
CC_DLL_VARIANTS=$dll_variants
CC_DYNAMIC=$dynamic
CC_EXPORT_DYNAMIC=$export_dynamic
CC_INCLUDE_LOCAL=$include_local
CC_LD=$ld
CC_LD_DYNAMIC=$lddynamic
CC_LD_LAZY=$ldlazy
CC_LD_NOLAZY=$ldnolazy
CC_LD_ORIGIN=$ldorigin
CC_LD_RECORD=$ldrecord
CC_LD_NORECORD=$ldnorecord
CC_LD_RUNPATH=$ldrunpath
CC_LD_STATIC=$ldstatic
CC_LD_STRIP=$ldstrip
CC_LIB_DLL=$lib_dll
CC_LIB_ALL=$lib_all
CC_LIB_UNDEF=$lib_undef
CC_MAKE_OPTIONS=$makeoptions
CC_NM=$nm
CC_NM_NMFLAGS=$nm_nmflags
CC_NMEDIT=$nmedit
CC_NMFLAGS=$nmflags
CC_NOPROTECT=$no_protect
CC_OPTIMIZE=$optimize
CC_READONLY=$readonly
CC_REPOSITORY=$repository
CC_REQUIRE=$require
CC_RUNPATH=$runpath
CC_SHARED=$shared
CC_SHARED_LD=$dld
CC_SHARED_NAME=$shared_name
CC_SHARED_REGISTRY=$shared_registry
CC_SHARED_REGISTRY_PATH=$probe_shared_registry_path
CC_SHELLMAGIC=$shellmagic
CC_SIZE=$size
CC_STATIC=$static
CC_STDINCLUDE=$stdinclude
CC_STDLIB=$stdlib
CC_STRICT=$strict
CC_STRIP=$strip
CC_STRIP_FLAGS=$stripflags
CC_PREFIX_ARCHIVE=$prefix_archive
CC_PREFIX_DYNAMIC=$prefix_dynamic
CC_PREFIX_SHARED=$prefix_shared
CC_PREFIX_SYMBOL=$symprefix
CC_SUFFIX_ARCHIVE=.$lib
CC_SUFFIX_COMMAND=$suffix_command
CC_SUFFIX_DEBUG=$sdb
CC_SUFFIX_DYNAMIC=$sd
CC_SUFFIX_LD=$ldscript
CC_SUFFIX_OBJECT=.$obj
CC_SUFFIX_SHARED=$so
CC_SUFFIX_SOURCE=.$src
CC_SUFFIX_STATIC=$sa
CC_VERSION=$version_flags
CC_WARN=$warn
CC_ATTRIBUTES=$ATTRIBUTES

exec >&3

#
# check for local override
# all CC_* but { CC_CC CC_VERSION_STAMP CC_VERSION_STRING } may be modified
# additional CC.* may be printed on stdout
#

if	test -f "$dir/probe.lcl"
then	. "$dir/probe.lcl"
fi

#
# the payoff
#

case $version_stamp in
?*)	echo "# $version_stamp" ;;
esac
echo CC.CC = $cc
echo CC.NATIVE = $CC_NATIVE
echo CC.EXECTYPE = $CC_EXECTYPE
echo CC.HOSTTYPE = $CC_HOSTTYPE
echo CC.ALTPP.FLAGS = $CC_ALTPP_FLAGS
echo CC.ALTPP.ENV = $CC_ALTPP_ENV
echo CC.AR = $CC_AR
echo CC.AR.ARFLAGS = $CC_AR_ARFLAGS
echo CC.ARFLAGS = $CC_ARFLAGS
echo CC.DEBUG = $CC_DEBUG
echo CC.DIALECT = $CC_DIALECT
echo CC.DLLBIG = $CC_DLLBIG
echo CC.DLLSMALL = $CC_DLLSMALL
echo CC.DLL = $CC_DLL
echo CC.DLL.DEF = $cc_dll_def
echo CC.DLL.DIR = $CC_DLL_DIR
echo CC.DLL.LIBRARIES = $CC_DLL_LIBRARIES
echo CC.DLL.VARIANTS = $CC_DLL_VARIANTS
echo CC.DYNAMIC = $CC_DYNAMIC
echo CC.EXPORT.DYNAMIC = $CC_EXPORT_DYNAMIC
echo CC.INCLUDE.LOCAL = $CC_INCLUDE_LOCAL
#
# 2004-02-14 release workaround
#
case $CC_SHARED_LD in
$CC_CC)	echo if LDSHARED
	echo CC.LD = $CC_LD
	echo else
	echo CC.LD = $CC_CC
	echo end
	;;
*)	echo CC.LD = $CC_LD
	;;
esac
echo CC.LD.DYNAMIC = $CC_LD_DYNAMIC
echo CC.LD.LAZY = $CC_LD_LAZY
echo CC.LD.NOLAZY = $CC_LD_NOLAZY
echo CC.LD.ORIGIN = $CC_LD_ORIGIN
echo CC.LD.RECORD = $CC_LD_RECORD
echo CC.LD.NORECORD = $CC_LD_NORECORD
echo CC.LD.RUNPATH = $CC_LD_RUNPATH
echo CC.LD.STATIC = $CC_LD_STATIC
echo CC.LD.STRIP = $CC_LD_STRIP
echo CC.LIB.DLL = $CC_LIB_DLL
echo CC.LIB.ALL = $CC_LIB_ALL
echo CC.LIB.UNDEF = $CC_LIB_UNDEF
echo CC.MAKE.OPTIONS = $CC_MAKE_OPTIONS
echo CC.NM = $CC_NM
echo CC.NM.NMFLAGS = $CC_NM_NMFLAGS
case $CC_NMEDIT in
?*)	CC_NMEDIT=" $CC_NMEDIT" ;;
esac
echo CC.NMEDIT ="$CC_NMEDIT"
echo CC.NMFLAGS = $CC_NMFLAGS
echo CC.NOPROTECT = $CC_NOPROTECT
echo CC.OPTIMIZE = $CC_OPTIMIZE
echo CC.PICBIG = $CC_PICBIG
echo CC.PICSMALL = $CC_PICSMALL
echo CC.PIC = $CC_PIC
echo CC.READONLY = $CC_READONLY
echo CC.REPOSITORY = $CC_REPOSITORY
for f in $CC_REQUIRE
do	echo CC.REQUIRE.$f =`cat req.$f`
done
echo CC.RUNPATH = $CC_RUNPATH
echo CC.SHARED = $CC_SHARED
echo CC.SHARED.LD = $CC_SHARED_LD
echo CC.SHARED.NAME = $CC_SHARED_NAME
echo CC.SHARED.REGISTRY = $CC_SHARED_REGISTRY
echo CC.SHARED.REGISTRY.PATH = $CC_SHARED_REGISTRY_PATH
echo CC.SHELLMAGIC = $CC_SHELLMAGIC
echo CC.SIZE = $CC_SIZE
echo CC.STATIC = $CC_STATIC
echo CC.STDINCLUDE = $CC_STDINCLUDE
echo CC.STDLIB = $CC_STDLIB
echo CC.STRICT = $CC_STRICT
echo CC.STRIP = $CC_STRIP
echo CC.STRIP.FLAGS = $CC_STRIP_FLAGS
echo CC.PREFIX.ARCHIVE = $CC_PREFIX_ARCHIVE
echo CC.PREFIX.DYNAMIC = $CC_PREFIX_DYNAMIC
echo CC.PREFIX.SHARED = $CC_PREFIX_SHARED
echo CC.PREFIX.SYMBOL = $CC_PREFIX_SYMBOL
echo CC.SUFFIX.ARCHIVE = $CC_SUFFIX_ARCHIVE
echo CC.SUFFIX.COMMAND = $CC_SUFFIX_COMMAND
echo CC.SUFFIX.DEBUG = $CC_SUFFIX_DEBUG
echo CC.SUFFIX.DYNAMIC = $CC_SUFFIX_DYNAMIC
echo CC.SUFFIX.LD = $CC_SUFFIX_LD
echo CC.SUFFIX.OBJECT = $CC_SUFFIX_OBJECT
echo CC.SUFFIX.SHARED = $CC_SUFFIX_SHARED
echo CC.SUFFIX.SOURCE = $CC_SUFFIX_SOURCE
echo CC.SUFFIX.STATIC = $CC_SUFFIX_STATIC
echo CC.VERSION = $CC_VERSION
case $CC_VERSION_STRING in
*\"*)	i=`echo " $CC_VERSION_STRING" | sed -e 's,",\\\\",g' -e 's,^ ,,' -e 's,.*,"&",'` ;;
*\'*)	i=\"$CC_VERSION_STRING\" ;;
*)	i=$CC_VERSION_STRING ;;
esac
cat <<!
CC.VERSION.STRING = $i
!
echo CC.WARN = $CC_WARN

for i in $CC_ATTRIBUTES
do	eval echo CC.$i = \$$i
done