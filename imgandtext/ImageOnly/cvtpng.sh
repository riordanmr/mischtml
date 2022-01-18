for i in *.PNG; do sips -s format jpeg $i --out $i.jpg; echo $i.jpg | awk '{origfn=$1; newfn=$1; sub(".PNG","",newfn); cmd="mv " origfn " " newfn; system(cmd)}'; done
