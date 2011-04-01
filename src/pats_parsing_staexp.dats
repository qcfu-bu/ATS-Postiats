(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(*                              Hongwei Xi                             *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, Boston University
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
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
// Start Time: March, 2011
//
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list_vt.dats"
staload _(*anon*) = "prelude/DATS/option_vt.dats"

(* ****** ****** *)

staload "pats_symbol.sats"
staload "pats_lexing.sats"
staload "pats_tokbuf.sats"
staload "pats_syntax.sats"

(* ****** ****** *)

staload "pats_parsing.sats"

(* ****** ****** *)

#define l2l list_of_list_vt
#define t2t option_of_option_vt

viewtypedef s0explst_vt = List_vt (s0exp)
viewtypedef labs0explst_vt = List_vt (labs0exp)

(* ****** ****** *)

(*
si0de
  | IDENTIFIER_alp
  | IDENTIFIER_sym
  | R0EAD // this one is removed in Postiats
  | GT
  | LT
  | AMPERSAND
  | BACKSLASH
  | BANG
  | TILDE
  | MINUSGT
*)

implement
p_si0de
  (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_IDENT_alp (x) => let
    val () = incby1 () in i0de_make_string (loc, x)
  end
| T_IDENT_sym (x) => let
    val () = incby1 () in i0de_make_string (loc, x)
  end
//
| T_GT () => let
    val () = incby1 () in i0de_make_sym (loc, symbol_GT)
  end
| T_LT () => let
    val () = incby1 () in i0de_make_sym (loc, symbol_LT)
  end
//
| T_AMPERSAND () => let
    val () = incby1 () in i0de_make_sym (loc, symbol_AMPERSAND)
  end
| T_BACKSLASH () => let
    val () = incby1 () in i0de_make_sym (loc, symbol_BACKSLASH)
  end
| T_BANG () => let
    val () = incby1 () in i0de_make_sym (loc, symbol_BANG)
  end
| T_TILDE () => let
    val () = incby1 () in i0de_make_sym (loc, symbol_TILDE)
  end
//
| T_MINUSGT () => let
    val () = incby1 () in i0de_make_sym (loc, symbol_MINUSGT)
  end
//
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_si0de)
  in
    synent_null ()
  end // end of [_]
//
end // end of [p_si0de]

(* ****** ****** *)

(*
s0taq
  | /*empty*/
  | i0de_dlr DOT
  | i0de_dlr COLON
/*
  | DOLLAR LITERAL_string DOT // this one is removed
*/
*)

implement
p_s0taq (buf, bt, err) = let
  val n0 = tokbuf_get_ntok (buf)
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ 0 of
| _ when
    ptest_fun (
      buf, p_i0de_dlr, ent
    ) => let
    val ent1 = synent_decode {i0de} (ent)
    val tok2 = tokbuf_get_token (buf)
  in
    case+ tok2.token_node of
    | T_DOT () => let
        val () = incby1 () in s0taq_symdot (ent1, tok2)
      end
    | T_COLON () => let
        val () = incby1 () in s0taq_symcolon (ent1, tok2)
      end
    | _ => let
(*
        val () = the_parerrlst_add_ifnbt (bt, ent1.i0de_loc, PE_s0taq)
*)
      in
        tokbuf_set_ntok_null (buf, n0)
      end // end of [_]
  end (* end of [_ when ...] *)
| _ => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [p_s0taq]

(*
sqi0de := si0de | s0taq si0de
*)

implement
p_sqi0de
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ 0 of
| _ when
    ptest_fun (buf, p_si0de, ent) =>
    sqi0de_make_none (synent_decode {i0de} (ent))
| _ when
    ptest_fun (buf, p_s0taq, ent) => let
    val bt = 0
    val ent1 = synent_decode {s0taq} (ent)
    val ent2 = p_si0de (buf, bt, err)
  in
    if err = err0 then
      sqi0de_make_some (ent1, ent2)
    else
      tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_sqi0de)
  in
    synent_null ()
  end
//
end // end of [p_sqi0de]

(* ****** ****** *)

(*
labs0exp ::= l0ab EQ s0exp
*)
fun p_labs0exp (
  buf: &tokbuf, bt: int, err: &int
) : labs0exp = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
//
  val ent1 = p_l0ab (buf, bt, err)
  val bt = 0
  val ent2 = pif_fun (buf, bt, err, p_EQ, err0)
  val ent3 = pif_fun (buf, bt, err, p_s0exp, err0)
//
in
//
if (err = err0) then
  labs0exp_make (ent1, ent3)
else let
  val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_labs0exp)
in
  tokbuf_set_ntok_null (buf, n0)
end (* end of [if] *)
//
end // end of [p_labs0exp]

(* ****** ****** *)

viewtypedef s0explst12 = list12 (s0exp)

fun s0exp_list12 (
  t_beg: token, ent2: s0explst12, t_end: token
) : s0exp =
  case+ ent2 of
  | ~LIST12one (xs) => s0exp_list (t_beg, (l2l)xs, t_end)
  | ~LIST12two (xs1, xs2) => s0exp_list2 (t_beg, (l2l)xs1, (l2l)xs2, t_end)
// end of [s0exp_list12]

fun s0exp_tytup12 (
  knd: int
, t_beg: token, ent2: s0explst12, t_end: token
) : s0exp =
  case+ ent2 of
  | ~LIST12one (xs) =>
      s0exp_tytup (knd, 0(*npf*), t_beg, (l2l)xs, t_end)
  | ~LIST12two (xs1, xs2) => let
      val npf = list_vt_length (xs1)
      val xs12 = list_vt_append (xs1, xs2)
    in
      s0exp_tytup (knd, npf, t_beg, (l2l)xs12, t_end)
    end
// end of [s0exp_tytup12]

(* ****** ****** *)

viewtypedef labs0explst12 = list12 (labs0exp)

fun s0exp_tyrec12 (
  knd: int
, t_beg: token, ent2: labs0explst12, t_end: token
) : s0exp =
  case+ ent2 of
  | ~LIST12one (xs) =>
      s0exp_tyrec (knd, 0(*npf*), t_beg, (l2l)xs, t_end)
  | ~LIST12two (xs1, xs2) => let
      val npf = list_vt_length (xs1)
      val xs12 = list_vt_append (xs1, xs2)
    in
      s0exp_tyrec (knd, npf, t_beg, (l2l)xs12, t_end)
    end
// end of [s0exp_tyrec12]

fun s0exp_tyrec12_ext (
  name: string
, t_beg: token, ent2: labs0explst12, t_end: token
) : s0exp =
  case+ ent2 of
  | ~LIST12one (xs) =>
      s0exp_tyrec_ext (name, 0(*npf*), t_beg, (l2l)xs, t_end)
  | ~LIST12two (xs1, xs2) => let
      val npf = list_vt_length (xs1)
      val xs12 = list_vt_append (xs1, xs2)
    in
      s0exp_tyrec_ext (name, npf, t_beg, (l2l)xs12, t_end)
    end
// end of [s0exp_tyrec12]

(* ****** ****** *)

fun
p_s0expseq_BAR_s0expseq (
  buf: &tokbuf
, bt: int
, err: &int
) : s0explst12 =
  plist12_fun (buf, bt, p_s0exp)
// end of [p_s0expseq_BAR_s0expseq]

fun
p_labs0expseq_BAR_labs0expseq (
  buf: &tokbuf
, bt: int
, err: &int
) : labs0explst12 =
  plist12_fun (buf, bt, p_labs0exp)
// end of [p_labs0expseq_BAR_labs0expseq]

(* ****** ****** *)

(*
s0arrdim
  | LBRACKET s0expseq RBRACKET
*)
fun
p_s0arrdim (
 buf: &tokbuf, bt: int, err: &int
) : s0arrdim = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val ent1 = p_LBRACKET (buf, bt, err)
  val bt = 0
  val ent2 = (
    if err = err0 then
      pstar_fun0_COMMA (buf, bt, p_s0exp) else list_vt_nil ()
    // end of [if]
  ) : s0explst_vt
  val ent3 = (
    if err = err0 then p_RBRACKET (buf, bt, err) else synent_null ()
  ) : token
in
  if err = err0 then
    s0arrdim_make (ent1, (l2l)ent2, ent3)
  else let
    val () = list_vt_free (ent2) in tokbuf_set_ntok_null (buf, n0)
  end // end of [if]
end (* end of [s0arrdim_make] *)

(* ****** ****** *)

(*
atms0exp
  | i0nt
  | LITERAL_char
  | sqi0de
  | OP si0de
//
  | LPAREN s0expseq RPAREN
  | LPAREN s0expseq BAR s0expseq RPAREN
//
  | ATLPAREN s0expseq RPAREN // knd = 0
  | ATLPAREN s0expseq BAR s0expseq RPAREN
//
  | QUOTELPAREN s0expseq RPAREN // knd = 1
  | QUOTELPAREN s0expseq BAR s0expseq RPAREN
//
  | ATLBRACE labs0expseq RBRACE
  | ATLBRACE labs0expseq BAR labs0expseq RBRACE
  | QUOTELBRACE labs0expseq RBRACE
  | QUOTELBRACE labs0expseq BAR labs0expseq RBRACE
//
  | ATLBRACKET s0exp RBRACKET s0arrind // for instance: @[a][n]
//
// HX: boxed types
//
  | DLRTUP_T LPAREN s0expseq RPAREN
  | DLRTUP_T LPAREN s0expseq BAR s0expseq RPAREN
  | DLRTUP_VT LPAREN s0expseq RPAREN
  | DLRTUP_VT LPAREN s0expseq BAR s0expseq RPAREN
  | DLRREC_T LBRACE labs0expseq RBRACE
  | DLRREC_T LBRACE labs0expseq BAR labs0expseq RBRACE
  | DLRREC_VT LBRACE labs0expseq RBRACE
  | DLRREC_VT LBRACE labs0expseq BAR labs0expseq RBRACE
//
// HX: unboxed external struct types
//
  | DLREXTYPE_STRUCT LITERAL_string OF LBRACE labs0expseq RBRACE
//
  | MINUSLT e0fftagseq GT
  | MINUSLTGT
//
  | LBRACE s0quaseq RBRACE
//
  | LBRACKET s0quaseq RBRACKET
  | HASHLBRACKET s0quaseq RBRACKET
//
*)

(* ****** ****** *)

fun
p_atms0exp_tok (
  buf: &tokbuf, bt: int, err: &int, tok: token
) : s0exp = let
  val err0 = err
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (buf, p_sqi0de, ent) =>
    s0exp_sqid (synent_decode {sqi0de} (ent))
| _ when
    ptest_fun (buf, p_i0nt, ent) =>
    s0exp_i0nt (synent_decode {i0nt} (ent))
| T_OP _ => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_si0de (buf, bt, err)
  in
    if err = err0 then
      s0exp_opid (tok, ent2) else synent_null ()
    // end of [if]
  end
| T_CHAR _ => let
    val () = incby1 () in s0exp_char (tok)
  end
//
| T_LPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0expseq_BAR_s0expseq (buf, bt, err)
    val ent3 = p_RPAREN (buf, bt, err) // err = err0
  in
    if err = err0 then
      s0exp_list12 (tok, ent2, ent3)
    else let
      val () = list12_free (ent2) in synent_null ()
    end // end of [if]
  end
| T_ATLPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0expseq_BAR_s0expseq (buf, bt, err)
    val ent3 = p_RPAREN (buf, bt, err) // err = err0
  in
    if err = err0 then
      s0exp_tytup12 (0(*knd*), tok, ent2, ent3)
    else let
      val () = list12_free (ent2) in synent_null ()
    end // end of [if]
  end
| T_QUOTELPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0expseq_BAR_s0expseq (buf, bt, err)
    val ent3 = p_RPAREN (buf, bt, err) // err = err0
  in
    if err = err0 then
      s0exp_tytup12 (1(*knd*), tok, ent2, ent3)
    else let
      val () = list12_free (ent2) in synent_null ()
    end // end of [if]
  end
| T_ATLBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_labs0expseq_BAR_labs0expseq (buf, bt, err)
    val ent3 = p_RBRACE (buf, bt, err) // err = err0
  in
    if err = err0 then
      s0exp_tyrec12 (0(*knd*), tok, ent2, ent3)
    else let
      val () = list12_free (ent2) in synent_null ()
    end // end of [if]
  end
//
| T_ATLBRACKET () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0exp (buf, bt, err)
    val ent3 = pif_fun (buf, bt, err, p_RBRACKET, err0)
    val ent4 = pif_fun (buf, bt, err, p_s0arrdim, err0)
  in
    if err = err0 then
      s0exp_tyarr (tok, ent2, ent4) else synent_null ()
    // end of [if]
  end
//
| T_DLRTUP knd => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_LPAREN (buf, bt, err)
  in
    if err = err0 then let
      val ent3 = p_s0expseq_BAR_s0expseq (buf, bt, err)
      val ent4 = p_RPAREN (buf, bt, err) // err = err0
    in
      if err = err0 then
        s0exp_tytup12 (knd, tok, ent3, ent4)
      else let
        val () = list12_free (ent3) in synent_null ()
      end (* end of [if] *)
    end else
      synent_null ()
    // end of [if]
  end
| T_DLRREC knd => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_LBRACE (buf, bt, err)
  in
    if err = err0 then let
      val ent3 = p_labs0expseq_BAR_labs0expseq (buf, bt, err)
      val ent4 = p_RBRACE (buf, bt, err) // err = err0
    in
      if err = err0 then
        s0exp_tyrec12 (knd, tok, ent3, ent4)
      else let
        val () = list12_free (ent3) in synent_null ()
      end (* end of [if] *)
    end else
      synent_null ()
    // end of [if]
  end
//
| T_DLREXTYPE_STRUCT () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0tring (buf, bt, err)
    val ent3 = (
      if err = err0 then p_OF (buf, bt, err) else synent_null ()
    ) : token // end of [val]
    val ent4 = p_LBRACE (buf, bt, err)
  in
    if err = err0 then let
      val ent5 = p_labs0expseq_BAR_labs0expseq (buf, bt, err)
      val ent6 = p_RBRACE (buf, bt, err) // err = err0
    in
      if err = err0 then let
        val- T_STRING (name) = ent2.token_node
      in
        s0exp_tyrec12_ext (name, tok, ent5, ent6)
      end else let
        val () = list12_free (ent5) in synent_null ()
      end (* end of [if] *)
    end else
      synent_null ()
    // end of [if]
  end
//
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0quaseq_vt (buf, bt, err)
    val ent3 = p_RBRACE (buf, bt, err) // err = err0
  in
    if err = err0 then
      s0exp_uni (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in synent_null ()
    end (* end of [if] *)
  end
//
| T_LBRACKET () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0quaseq_vt (buf, bt, err)
    val ent3 = p_RBRACKET (buf, bt, err) // err = err0
  in
    if err = err0 then
      s0exp_exi (0(*funres*), tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in synent_null ()
    end (* end of [if] *)
  end
| T_HASHLBRACKET () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0quaseq_vt (buf, bt, err)
    val ent3 = p_RBRACKET (buf, bt, err) // err = err0
  in
    if err = err0 then
      s0exp_exi (1(*funres*), tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in synent_null ()
    end (* end of [if] *)
  end
//
| _ => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [p_atms0exp_tok]

fun
p_atms0exp (
  buf: &tokbuf, bt: int, err: &int
) : s0exp =
  ptokwrap_fun (buf, bt, err, p_atms0exp_tok, PE_atms0exp)
// end of [p_atms0exp]

(* ****** ****** *)

(*
apps0exp := {atms0exp}+
*)

fun
p_apps0exp (
  buf: &tokbuf, bt: int, err: &int
) : s0exp = let
  fun loop (
    x0: s0exp, xs1: s0explst_vt
  ) : s0exp =
    case+ xs1 of
    | ~list_vt_cons (x1, xs1) => let
        val x0 = s0exp_app (x0, x1) in loop (x0, xs1)
      end // end of [list_vt_cons]
    | ~list_vt_nil () => x0
  // end of [loop]
  val xs = pstar1_fun (buf, bt, err, p_atms0exp)
in
//
case+ xs of
| ~list_vt_cons (x, xs) => loop (x, xs)
| ~list_vt_nil () => synent_null () // HX: [err] changed
//
end // end of [p_apps0exp]

(* ****** ****** *)

(*
exts0exp := DLREXTYPE LITERAL_string {atms0exp}
*)

fun
p_exts0exp (
  buf: &tokbuf, bt: int, err: &int
) : s0exp = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_DLREXTYPE () => let
    val bt = 0
    val () = incby1 ()
    val str = p_s0tring (buf, bt, err)
  in
    if err = err0 then let
      val arg = pstar_fun (buf, bt, p_atms0exp)
      val arg = list_of_list_vt (arg)
    in
      s0exp_extype (tok, str, arg)
    end else let
(*
      val () = the_parerrlst_add_ifnbt (bt, loc, PE_exts0exp)
*)
    in
      tokbuf_set_ntok_null (buf, n0)
    end // end of [if]
  end
| _ => let
    val () = err := err + 1
(*
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_exts0exp)
*)
  in
    synent_null ()
  end
//
end // end of [p_exts0exp]

(* ****** ****** *)

(*
s0exp
  : apps0exp
  | exts0exp
  | s0exp COLON s0rt
  | LAM s0margseq colons0rtopt EQGT s0exp // COLON > LAM
*)

fun
p_s0exp0 ( // no annotation
  buf: &tokbuf, bt: int, err: &int
) : s0exp = let
  var ent: synent?
in
//
case+ 0 of
| _ when
    ptest_fun (
      buf, p_apps0exp, ent
    ) => synent_decode {s0exp} (ent)
| _ when
    ptest_fun (
      buf, p_exts0exp, ent
    ) => synent_decode {s0exp} (ent)
| _ => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [p_s0exp0]

(* ****** ****** *)

fun s0exp_annopt
  (ent1: s0exp, ent2: s0rtopt_vt): s0exp =
  case+ ent2 of
  | ~Some_vt s0t => s0exp_ann (ent1, s0t) | ~None_vt () => ent1
// end of [s0exp_annopt]

fun
p_s0exp_tok ( // no annotation
  buf: &tokbuf, bt: int, err: &int, tok: token
) : s0exp = let
  val err0 = err
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (
      buf, p_s0exp0, ent
    ) => let
    val ent1 = synent_decode {s0exp} (ent)
    val bt = 0
    val ent2 = p_colons0rtopt_vt (buf, bt, err)
  in
    if err = err0 then
      s0exp_annopt (ent1, ent2)
    else let
      val () = option_vt_free (ent2) in synent_null ((*dangling COLON*))
    end // end of [if]
  end
| T_LAM _ => let
    val bt = 0
    val () = incby1 ()
    val ent2 = pstar_fun {s0marg} (buf, bt, p_s0marg)
    val ent3 = p_colons0rtopt_vt (buf, bt, err) // err = err0
    val ent4 = (
      if err = err0 then p_EQGT (buf, bt, err) else synent_null ()
    ) : token
    val ent5 = (
      if err = err0 then p_s0exp (buf, bt, err) else synent_null ()
    ) : s0exp
  in
    if err = err0 then
      s0exp_lam (tok, (l2l)ent2, (t2t)ent3, ent5)
    else let
      val () = list_vt_free (ent2)
      val () = option_vt_free (ent3)
    in
      synent_null ()
    end // end of [if]
  end
| _ => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [p_s0exp_tok]

implement
p_s0exp
  (buf, bt, err) = 
  ptokwrap_fun (buf, bt, err, p_s0exp_tok, PE_s0exp)
// end of [p_s0exp]

(* ****** ****** *)

(*
s0rtext
  | s0rt
  | LBRACE si0de COLON s0rt BAR s0exp barsemis0expseq RBRACE
*)
implement
p_s0rtext
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (buf, p_s0rt, ent) =>
    s0rtext_srt (synent_decode {s0rt} (ent))
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_si0de (buf, bt, err)
    val ent3 = (
      if err = err0 then p_COLON (buf, bt, err) else synent_null ()
    ) : token // end of [val]
    val ent4 = (
      if err = err0 then p_s0rtext (buf, bt, err) else synent_null ()
    ) : s0rtext // end of [val]
    val ent5 = (
      if err = err0 then p_BAR (buf, bt, err) else synent_null ()
    ) : token // end of [val]
    val ent6 = (
      if err = err0 then p_s0exp (buf, bt, err) else synent_null ()
    ) : s0exp // end of [val]
    val ent7 = (
      if err = err0 then
        pstar_sep_fun (buf, bt, p_BARSEMI_test, p_s0exp)
      else list_vt_nil ()
    ) : s0explst_vt
    val ent8 = (
      if err = err0 then p_RBRACE (buf, bt, err) else synent_null ()
    ) : token // end of [val]
  in
    if err = err0 then
      s0rtext_sub (tok, ent2, ent4, ent6, (l2l)ent7, ent8)
    else let
      val () = list_vt_free (ent7)
      val () = the_parerrlst_add_ifnbt (bt, loc, PE_s0rtext)
    in
      tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
//
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_s0rtext)
  in
    synent_null ()
  end
//
end // end of [p_s0rtext]

(* ****** ****** *)

(*
s0qua
  | apps0exp
  | si0de commasi0deseq COLON s0rtext
*)

fun
p_s0qua_rule2 (
  buf: &tokbuf, bt: int, err: &int
) : s0qua = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val ent1 = p_si0de (buf, bt, err)
(*
  val bt = 0 // HX: this yields too many false positives
*)
  val ent2 = (
    if err = err0 then
      pstar_sep_fun (buf, bt, p_COMMA_test, p_si0de)
    else list_vt_nil ()
  ) : List_vt (i0de)
  val ent3 = (
    if err = err0 then p_COLON (buf, bt, err) else synent_null ()
  ) : token // end of [val]
  val ent4 = (
    if err = err0 then p_s0rtext (buf, bt, err) else synent_null ()
  ) : s0rtext // end of [val]
in
  if err = err0 then
    s0qua_vars (ent1, (l2l)ent2, ent4)
  else let
    val () = list_vt_free (ent2)
  in
    tokbuf_set_ntok_null (buf, n0)
  end (* end of [if] *)
end // end of [p_s0qua_rule2]

implement
p_s0qua
  (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ 0 of
| _ when
    ptest_fun (
      buf, p_s0qua_rule2, ent
    ) => synent_decode {s0qua} (ent)
| _ when
    ptest_fun (buf, p_apps0exp, ent) =>
    s0qua_prop (synent_decode {s0exp} (ent))
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_s0qua)
  in
    synent_null ()
  end
//
end // end of [p_s0qua]

implement
p_s0quaseq_vt (buf, bt, err) =
  pstar_fun0_BARSEMI {s0qua} (buf, bt, p_s0qua)
// end of [p_s0quaseq_vt]

(* ****** ****** *)

implement
p_eqs0expopt_vt
  (buf, bt, err) = let
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_EQ () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0exp (buf, bt, err)
  in
    if synent_is_null (ent2) then let
      val () = tokbuf_set_ntok (buf, n0) in None_vt ()
    end else Some_vt (ent2) (* end of [if] *)
  end
| _ => None_vt ()
//
end // end of [p_eqs0expopt_vt]

(* ****** ****** *)

implement
p_ofs0expopt_vt
  (buf, bt, err) = let
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_OF () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0exp (buf, bt, err)
  in
    if synent_is_null (ent2) then let
      val () = tokbuf_set_ntok (buf, n0) in None_vt ()
    end else Some_vt (ent2) (* end of [if] *)
  end
| _ => None_vt ()
//
end // end of [p_ofs0expopt_vt]

(* ****** ****** *)

(*
q0marg ::= LBRACE s0quaseq RBRACE
*)
implement
p_q0marg (
  buf, bt, err
) : q0marg = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0quaseq_vt (buf, bt, err)
    val ent3 = p_RBRACE (buf, bt, err)
  in
    if err = err0 then
      q0marg_make (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2)
      val () = the_parerrlst_add_ifnbt (bt, loc, PE_q0marg)
    in
      tokbuf_set_ntok_null (buf, n0)
    end // end of [if]
  end
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_q0marg)
  in
    synent_null ()
  end
//
end // end of [p_q0marg]

(* ****** ****** *)

(*
cona0rgopt ::= | /*(empty)*/ | OF s0exp
*)
fun
p_cona0rgopt (
  buf: &tokbuf, bt: int, err: &int  
) : s0expopt = let
  val res = p_ofs0expopt_vt (buf, bt, err) in (t2t)res
end // end of [p_cona0rgopt]

(*
coni0ndopt ::= /*(empty)*/ | LPAREN s0expseq RPAREN
*)
fun
p_coni0ndopt (
  buf: &tokbuf, bt: int, err: &int  
) : s0expopt = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_LPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = pstar_fun0_COMMA {s0exp} (buf, bt, p_s0exp)
    val ent3 = p_RPAREN (buf, bt, err)
  in
    if err = err0 then let
      val s0e = s0exp_list (tok, (l2l)ent2, ent3) in Some (s0e)
    end else let
      val () = list_vt_free (ent2)
(*
      val () = the_parerrlst_add_ifnbt (bt, tok.i0de_loc, PE_coni0nd)
*)
    in
      tokbuf_set_ntok_null (buf, n0)
    end // end of [if]
  end
| _ => None ()
//
end // end of [p_coni0ndopt]

(* ****** ****** *)

(*
e0xndec ::= conq0uaseq di0de cona0rgopt
*)
implement
p_e0xndec
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val ent1 = pstar_fun {q0marg} (buf, bt, p_q0marg)
  val ent2 = p_di0de (buf, bt, err) // err = err0
  val bt = 0
  val ent3 = (
    if err = err0 then p_cona0rgopt (buf, bt, err) else None ()
  ) : s0expopt // end of [val]
in
  if err = err0 then
    e0xndec_make ((l2l)ent1, ent2, ent3)
  else let
    val () = list_vt_free (ent1) in tokbuf_set_ntok_null (buf, n0)
  end (* end of [if] *)
end // end of [p_e0xndec]

(* ****** ****** *)

(*
d0atcon ::= conq0uaseq di0de coni0ndopt cona0rgopt
*)
fun
p_d0atcon (
  buf: &tokbuf, bt: int, err: &int  
) : d0atcon = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val ent1 = pstar_fun {q0marg} (buf, bt, p_q0marg)
  val ent2 = p_di0de (buf, bt, err) // err = err0
  val bt = 0
  val ent3 = (
    if err = err0 then p_coni0ndopt (buf, bt, err) else None ()
  ) : s0expopt // end of [val]
  val ent4 = (
    if err = err0 then p_cona0rgopt (buf, bt, err) else None ()
  ) : s0expopt // end of [val]
in
  if err = err0 then
    d0atcon_make ((l2l)ent1, ent2, ent3, ent4)
  else let
    val () = list_vt_free (ent1)
  in
    tokbuf_set_ntok_null (buf, n0)
  end (* end of [if] *)
end // end of [p_d0atcon]

(* ****** ****** *)

implement
p_d0atconseq
  (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_BAR () => let
    val () = incby1 ()
    val xs = pstar_fun0_BAR (buf, bt, p_d0atcon) in l2l (xs)
  end // end of [T_BAR]
| _ => let
    val xs = pstar_fun0_BAR (buf, bt, p_d0atcon) in l2l (xs)
  end // end of [T_BAR]
//
end // end of [p_d0atconseq]

(* ****** ****** *)

(*
a0typ ::= s0exp0 | pi0de COLON s0exp0 // s0exp0: annotationless
*)
implement
p_a0typ
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  val () = tokbuf_incby1 (buf)
  val tok2 = tokbuf_get_token (buf)
  val () = tokbuf_set_ntok (buf, n0)
in
//
case+ tok2.token_node of
| T_COLON () => let
    val ent1 = p_pi0de (buf, bt, err)
    val bt = 0
    val ent2 = pif_fun (buf, bt, err, p_COLON, err0)
    val ent3 = pif_fun (buf, bt, err, p_s0exp0, err0)
  in
    if err = err0 then
      a0typ_make_some (ent1, ent3)
    else let
(*
      val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_a0typ)
*)
    in
      tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
| _ => let
    val ent1 = p_s0exp0 (buf, bt, err)
  in
    if err = err0 then
      a0typ_make_none (ent1)
    else let
(*
      val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_a0typ)
*)
    in
      tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
//
end // end of [p_a0typ]

(* ****** ****** *)

viewtypedef a0typlst12 = list12 (a0typ)

fun d0cstarg_atyplst12 (
  t_beg: token, ent2: a0typlst12, t_end: token
) : d0cstarg =
  case+ ent2 of
  | ~LIST12one (xs) =>
      d0cstarg_dyn (0(*npf*), t_beg, (l2l)xs, t_end)
  | ~LIST12two (xs1, xs2) => let
      val npf = list_vt_length (xs1)
      val xs12 = list_vt_append (xs1, xs2)
    in
      d0cstarg_dyn (0(*npf*), t_beg, (l2l)xs12, t_end)
    end
// end of [d0cstarg_amtyp12]

implement
p_d0cstarg
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  macdef incby1 () = tokbuf_incby1 (buf)
  var ent: synent?
in
//
case+ tok.token_node of
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0quaseq_vt (buf, bt, err)
    val ent3 = p_RBRACE (buf, bt, err)
  in
    if err = err0 then
      d0cstarg_sta (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
| T_LPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = plist12_fun (buf, bt, p_a0typ)
    val ent3 = p_RPAREN (buf, bt, err)
  in
    if err = err0 then
      d0cstarg_atyplst12 (tok, ent2, ent3)
    else let
      val () = list12_free (ent2) in tokbuf_set_ntok_null (buf, n0)
    end // end of [if]
  end
| _ => let
    val () = err := err + 1 in synent_null ()
  end
//
end // end of [p_d0cstarg]

(* ****** ****** *)

(* end of [pats_parsing_staexp.dats] *)
