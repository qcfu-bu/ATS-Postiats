(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
** Free Software Foundation; either version 2.1, or (at your option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Start Time: February, 2012
//
(* ****** ****** *)

#include "prelude/params.hats"

(* ****** ****** *)

#if VERBOSE_PRELUDE #then
#print "Loading [arraypr.sats] starts!\n"
#endif // end of [VERBOSE_PRELUDE]

(* ****** ****** *)

absviewtype
arrayptr (a:viewt@ype+, l: addr, n: int) = ptr

(* ****** ****** *)

sortdef t0p = t@ype
sortdef vt0p = viewt@ype

(* ****** ****** *)

castfn
ptr_of_arrayptr
  {a:vt0p}{l:addr}{n:int}
  (A: !arrayptr (INV(a), l, n)):<> ptr l
overload ptr_of with ptr_of_arrayptr

(* ****** ****** *)

fun{a:t0p}
arrayptr_get_at
  {l:addr}{n:int}
  (A: !arrayptr (INV(a), l, n), i: sizeLt (n)):<> a
fun{a:t0p}
arrayptr_set_at
  {l:addr}{n:int}
  (A: !arrayptr (INV(a), l, n), i: sizeLt (n), x: a):<> void
overload [] with arrayptr_get_at
overload [] with arrayptr_set_at

(* ****** ****** *)

fun{a:vt0p}
arrayptr_exch_at
  {l:addr}{n:int}
  (A: !arrayptr (INV(a), l, n), i: sizeLt (n), x: &WRT(a)): void
// end of [arrayptr_exch_at]

(* ****** ****** *)

#if VERBOSE_PRELUDE #then
#print "Loading [arrayptr.sats] finishes!\n"
#endif // end of [VERBOSE_PRELUDE]

(* ****** ****** *)

(* end of [arrayptr.sats] *)
