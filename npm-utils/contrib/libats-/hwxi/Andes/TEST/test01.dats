(* ****** ****** *)
(*
SP-2015-08
*)
(* ****** ****** *)
(*
20150803,-0.002674,-0.002675,-0.004310,-0.004311,19168686800.00,502,19220137700.00,502,2098.04,-0.002757
20150804,-0.002135,-0.002161,-0.001183,-0.001219,19126948200.00,502,19168686800.00,502,2093.32,-0.002250
20150805,0.003722,0.003300,0.002644,0.002488,19190023700.00,502,19126948200.00,502,2099.84,0.003115
20150806,-0.007521,-0.007796,-0.005732,-0.005846,19040222100.00,502,19190023700.00,502,2083.56,-0.007753
20150807,-0.003013,-0.003048,-0.002303,-0.002376,18981600500.00,502,19040222100.00,502,2077.57,-0.002875
20150810,0.012667,0.012645,0.015684,0.015641,19221624500.00,502,18981600500.00,502,2104.18,0.012808
20150811,-0.009154,-0.009331,-0.009085,-0.009144,19042261400.00,502,19221624500.00,502,2084.07,-0.009557
20150812,0.001136,0.000904,0.002017,0.001669,19059476200.00,502,19042261400.00,502,2086.05,0.000950
20150813,-0.001209,-0.001357,-0.002642,-0.002797,19033641800.00,502,19059476200.00,502,2083.39,-0.001275
20150814,0.003978,0.003976,0.004158,0.004151,19109324800.00,502,19033641800.00,502,2091.54,0.003912
20150817,0.005274,0.005085,0.005528,0.005403,19206569000.00,502,19109324800.00,502,2102.44,0.005211
20150818,-0.002598,-0.002779,-0.002471,-0.002564,19150232200.00,502,19206569000.00,502,2096.92,-0.002626
20150819,-0.008168,-0.008234,-0.008467,-0.008561,18992551400.00,502,19150232200.00,502,2079.61,-0.008255
20150820,-0.020963,-0.020964,-0.021053,-0.021062,18594385900.00,502,18992551400.00,502,2035.73,-0.021100
20150821,-0.031656,-0.031813,-0.027378,-0.027476,18002840800.00,502,18594385900.00,502,1970.89,-0.031851
20150824,-0.039372,-0.039397,-0.039529,-0.039606,17293554400.00,502,18002840800.00,502,1893.21,-0.039414
20150825,-0.013371,-0.013385,-0.014286,-0.014322,17062083500.00,502,17293554400.00,502,1867.61,-0.013522
20150826,0.039178,0.039099,0.033078,0.032963,17729192800.00,502,17062083500.00,502,1940.51,0.039034
20150827,0.024267,0.024166,0.027277,0.027133,18157629900.00,502,17729192800.00,502,1987.66,0.024298
20150828,0.000638,0.000510,0.002764,0.002624,18166385000.00,502,18157629900.00,502,1988.87,0.000609
20150831,-0.008319,-0.008432,-0.006471,-0.006560,18012263100.00,502,18174105500.00,502,1972.18,-0.008392
*)
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
#include
"share/HATS/atspre_staload_libats_ML.hats"
//
(* ****** ****** *)
//
staload
MATH =
"libats/libc/SATS/math.sats"
//
staload _ =
"libats/libc/DATS/math.dats"
//
(* ****** ****** *)

#staload "./../SATS/andes_comp.sats"

(* ****** ****** *)

val
theIndexes =
$list{double}
(
2098.04
,
2093.32
,
2099.84
,
2083.56
,
2077.57
,
2104.18
,
2084.07
,
2086.05
,
2083.39
,
2091.54
,
2102.44
,
2096.92
,
2079.61
,
2035.73
,
1970.89
,
1893.21
,
1867.61
,
1940.51
,
1987.66
,
1988.87
,
1972.18
) (* theIndexes *)

(* ****** ****** *)

val-
list_cons(index0, theIndexes) = theIndexes

(* ****** ****** *)

val
theChanges =
auxlst(index0, theIndexes) where
{
fun
auxlst(x0: double, xs: List(double)): List0(double) =
(
case+ xs of
| list_nil() => list_nil()
| list_cons(x1, xs) => list_cons((x1 - x0) / x0, auxlst(x1, xs))
)
}

(* ****** ****** *)
//
val () =
assertloc(length(theChanges) >= 2)
//
(* ****** ****** *)

val
theChanges_stdev = list_stdev(theChanges)

(* ****** ****** *)

implement
main0() = () where
{
//
val () = println! ("theChanges_stdev(daily) = ", theChanges_stdev)
val () = println! ("theChanges_stdev(annual) = ", theChanges_stdev*$MATH.sqrt(252.0))
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [test01.dats] *)
