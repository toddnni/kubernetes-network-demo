echo "# Leave this open and proceed to next"
while nc -lkv -p 8080; do echo restart; done
