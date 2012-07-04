while [ 1 ] 
do

 echo "Type Ctrl+c to quit loop"
 sleep 2
 nanoc co && nanoc vi
done
