(* ****** ****** *)
//
// HX-2017-03-29:
//
// For template-based
// implementation of functors
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
#include
"share/HATS/atspre_staload_libats_ML.hats"
//
(* ****** ****** *)
//
abstype List0_name
//
(* ****** ****** *)
//
sortdef ftype = t@ype -> type
//
(* ****** ****** *)
//
absprop FUNCTOR(fname: type, ftype)
//
(* ****** ****** *)
//
dataprop
eqfun_t0ype_type
  (ftype, ftype) =
  {f:ftype}
  EQFUN_t0ype_type(f, f) of ()
//
(* ****** ****** *)

extern
fun
{
fname:type
}{a,b:t@ype}
functor_map
{f: t@ype -> type}
(
pf: FUNCTOR(fname, f) | fopr: a -<cloref1> b
) : f(a) -<cloref1> f(b) // end-of [functor_map]

(* ****** ****** *)

extern
praxi
FUNCTOR_List0_elim
  {f:ftype}
(
pf: FUNCTOR(List0_name, f)
) : eqfun_t0ype_type(f, List0)

implement
(a,b:t@ype)
functor_map<List0_name><a,b>
  (pf | fopr) = let
//
prval
EQFUN_t0ype_type() = FUNCTOR_List0_elim(pf)
//
in
  lam(xs) => list_vt2t(list_map_cloref<a><b>(xs, fopr))
end // end of [functor_map<list0_name>]

(* ****** ****** *)

implement
main0((*void*)) =
{
//
prval pf =
$UNSAFE.proof_assert
{FUNCTOR(List0_name, List0)}()
//
val xs = $list{int}(0, 1, 2, 3, 4)
//
val ys = functor_map<List0_name><int,int>(pf | lam(x) => x * x)(xs)
//
val () = println! ("xs = ", xs)
val () = println! ("ys = ", ys)
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [tempfunctor.dats] *)
