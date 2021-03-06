#!/usr/bin/env bash
set -euo pipefail

#!/bin/sh

###################################################
# This is a wrapper around dmenu, providing basic #
# calculator-like functionality using python.     #
#                                                 #
# Git repo: https://github.com/mortie/mmenu       #
###################################################

# mmenu works the same as dmenu_run for the most part, except that if you type
# something that's not a command, the input string is fed to python. The result
# of running the expression is then shown as the prompt in a new run of dmenu.
# In this new run, only the entry '$' is available, and will exit the session;
# any other input will again be fed into python.
#
# Some more variables and functions are available in your expression:
#     ans: The result of the previous expression.
#     base(num, b=16): convert num to base b.
#
# Additional stuff:
#     `clip` after expressions will copy ans to your clipboard with 'xsel -ib'.
#     `$c` or `$C` will be replaced with your clipboard content using 'xsel -b'.

# Wrapper around which to get only the return code, not stdout/err
exists() {
	which "$1" >/dev/null 2>/dev/null
}

# menu_cmd, defaulting to dmenu
if [ -z "$1" ]; then
	menu_cmd="dmenu"
else
	menu_cmd="$1"
fi

# options_cmd, defaulting to dmenu_path
if [ -z "$2" ]; then
	options_cmd="dmenu_path"
else
	options_cmd="$2"
fi

prettyfunc() {
	if echo "$2" | grep "^$1 " >/dev/null 2>/dev/null; then
		echo "$1($(echo "$2" | sed "s/^$1 //"))"
		return 0
	else
		return 1
	fi
}

run() {
	# If we get an argument, we're in calculator mode, and the argument is the
	# result of the previous expression.
	if [ "$1" = "" ]; then
		cmd=$($options_cmd | $menu_cmd -p "run:")
	else
		cmd=$(echo "$" | $menu_cmd -p "$1:")
		if [ "$cmd" = "$" ]; then
			exit 0
		fi
	fi

	if [ "$cmd" = "" ]; then
		exit 0
	fi

	# Replace $c with clipboard contents
	paste="$(xsel -b)"
	export paste
	cmd=$(printf "%s" "$cmd" | awk '{ gsub("\\$[cC]", ENVIRON["paste"]); print($0) }')

	# If not in calculator mode, and the command exists, run it
	if [ "$1" = "" ] && exists "$(echo "$cmd" | cut -d ' ' -f 1)"; then
		echo "$cmd" | sh

	# If we're in command mode and receive "clip",
	# add it to the clipboard
	elif [ "$1" != "" ] && [ "$cmd" = "clip" ]; then
		printf "%s" "$1" | xsel -ib

	# Otherwise just run the expression through python
	else

		# Require less typing of symbols to call solve/base
		cmd="$(prettyfunc solve "$cmd" || prettyfunc base "$cmd" || echo "$cmd")"

		pycode="
import sys
import math
from math import ceil, floor, log, log10, pow, sqrt, \
	cos, sin, tan, acos, asin, atan, atan2, hypot, degrees, radians, \
	pi, e

ans = $([ "$1" = "" ] && echo 0 || echo "$1")

def digit_to_char(digit):
	if digit < 10:
		return str(digit)
	return chr(ord('a') + digit - 10)

def base(num, b=16):
	if num < 0:
		return '-' + base(-num, b)
	(d, m) = divmod(num, b)
	if d > 0:
		return base(d, b) + digit_to_char(m)
	return digit_to_char(m)

def solve(s):
	try:
		from sympy.parsing.sympy_parser import parse_expr, \
			standard_transformations, implicit_multiplication
		from sympy import Eq, solve
	except ImportError:
		return 'Missing sympy module.'

	transformations = ( \
		standard_transformations + ( \
		implicit_multiplication,))

	parts = s.split('=')
	part1 = parse_expr(parts[0], transformations=transformations)
	part2 = parse_expr(parts[1], transformations=transformations)

	r = (solve(Eq(part1, part2)))
	if len(r) == 1:
		return r[0]
	else:
		return r

res=''
try:
	res=($cmd)
except Exception as e:
	res='Exception'
	sys.stderr.write(str(e)+'\n')

print('{!r}'.format(res))
"

		# Run python, and then rerun with python's output as input
		ans="$(python -c "$pycode")"
		if [ "$?" != 0 ]; then
			ans="'Syntax Error'"
		fi
		run "$ans"
	fi
}

run
