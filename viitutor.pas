program art;
uses crt;
var
	middlex,middley:integer;
	command:char;
begin
	clrscr;
	writeln;
	writeln('       _ _   _            _              _ _ _             ');
	writeln('__   _(_|_) | |_ _____  _| |_    ___  __| (_) |_ ___  _ __ ');
	writeln('\ \ / / | | | __/ _ \ \/ / __|  / _ \/ _` | | __/ _ \| ''__|');
	writeln(' \ V /| | | | ||  __/>  <| |_  |  __/ (_| | | || (_) | |   ');
	writeln('  \_/ |_|_|  \__\___/_/\_\\__|  \___|\__,_|_|\__\___/|_|   ');
	writeln(' _         _             _       _ ');
	writeln('| |_ _   _| |_ ___  _ __(_) __ _| |');
	writeln('| __| | | | __/ _ \| ''__| |/ _` | |');
	writeln('| |_| |_| | || (_) | |  | | (_| | |');
	writeln(' \__|\__,_|\__\___/|_|  |_|\__,_|_|');
	middlex := screenwidth div 2;
	middley := screenheight div 2;
	gotoXY(middlex,middley);
	writeln('to type something enter i');
	gotoXY(middlex-12,middley+1);
	command := readkey;
	if command = 'i' then
	begin
		gotoXY(middlex,middley+2);
		writeln('great job!!');
	end;
	delay(1000);
	clrscr;
	gotoXY(middlex,middley);
	writeln('now, to get into a command mod again - type ''esc'' button');
	gotoXY(middlex-28,middley+1);
	command := readkey;
	if command = #27 then
	begin
		gotoXY(middlex,middley+2);
		writeln('great job!');
	end;
	clrscr;
	gotoXY(middlex,middley);
	writeln('to exit program (and automaticly save what you wrote) type ''q'' button');
	gotoXY(middlex-35,middley+1);
	command := readkey;
	if command = 'q' then
	begin
		gotoXY(middlex,middley+2);
		writeln('great job!!Goodbye my dear friend')
	end;
end.
                                   

