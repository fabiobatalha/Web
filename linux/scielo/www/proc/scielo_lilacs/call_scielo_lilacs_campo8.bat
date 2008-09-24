export src=../bases-work/scielo_lilacs/regL
export dest=../bases-work/scielo_lilacs/reg8
export ctrl=../bases-work/scielo_lilacs/ctrl_scielo8
export path=scielo_lilacs/

rm -rf $dest.*
rm -rf $ctrl.*

cisis.lind/wxis IsisScript=scielo_lilacs/conversion/scielo_lilacs_main.xis dbsource=$src dbdestination=$dest dbcontrol=$ctrl proc_path=$path from=13065 count=20 debug=On

cisis.lind/mx $dest fst=@scielo_lilacs/config/auxiliar/IMPORT.FST fullinv=$dest

