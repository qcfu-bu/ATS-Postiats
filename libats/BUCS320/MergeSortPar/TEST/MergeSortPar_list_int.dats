(* ****** ****** *)
(*
** DivideConquer:
** MergeSortPar_list
**
*)
(* ****** ****** *)

#define
ATS_DYNLOADFLAG 0

(* ****** ****** *)
//
%{^
//
#include <pthread.h>
//
%} // end of [%{^]
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
#include
"share/HATS\
/atspre_staload_libats_ML.hats"
//
(* ****** ****** *)

#staload "./testlib.dats"

(* ****** ****** *)
//
local
#define
MERGESORTPAR_LIST
in
#include "./../mylibies.hats"
end // end of [local]
//
(* ****** ****** *)
//
#include "./../mydepies.hats"
#include "./../mydepies_list.hats"
//
#staload DCP = $DivideConquerPar
#staload FWS = $FWORKSHOP_chanlst
//
(* ****** ****** *)
//
#staload MSP_list = $MergeSortPar_list
//
(* ****** ****** *)
//
assume
$MergeSort_list.elt_t0ype = int
//
implement
gcompare_val_val<int>(x, y) = compare(x, y)
//
implement
MergeSortPar_list_int
  (fws, xs) = let
//
val () = $tempenver(fws)
//
implement
$DCP.DivideConquerPar$submit<>
  (fwork) =
{
val () =
$FWS.fworkshop_insert_lincloptr
( fws
, llam() => 0 where
  {
    val () = fwork()
    val () = // fwork needs to be freed
    cloptr_free($UNSAFE.castvwtp0{cloptr(void)}(fwork))
  } // end of [fworkshop_insert_lincloptr]
) (* end of [val] *)
}
//
in
  $MSP_list.MergeSortPar_list<>(xs)
end // end of [MergeSortPar_list_int]
//
(* ****** ****** *)

(* end of [MergeSortParPar_list_int.dats] *)
