# vii-in-development-
text editor created on pascal, still on development and must be added base functionality,that it havent,like navigate between strings and reading old files
to create new text in file follow this steps:
1.give compile.sh permissions:
chmod +x compile.sh
2.compile all files:
sh compile.sh
3.to know how to use vii:
viitutor
4.to edit your files:
testnav1 your_file
to configurate your file follow this steps:
1.enter to the config directory:
cd config
2.open vii.conf
vii vii.conf #you can use other text editors
3.if you dont have vii.conf you must create it with
vii vii.conf #or other text editor
Manual to configurate vii
true means on
false means off
1. auto-ident
turns on/off function, that remember where your cursor was and with enter startsin the old position(only if ident line before you start typing)
2.syntax-highlighting
turns on/off function, that highlighting proramming languge syntax
Support languages: Pascal
3.automatic_cursor_jumping
turns on/off function, that allow you to jump in the top of the other string if you are on the top of you current string:
past line<-- and you automaticly jump over there
current line <-- you here
future line
-and how it looks without this function
past line   <--- you will jump over there(not so comfortable)
currnet line<-- you here
future line
