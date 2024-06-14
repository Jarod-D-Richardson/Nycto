
openocd -f $1 -c "program $2 reset exit 0x08000000"
