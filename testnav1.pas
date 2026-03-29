program navigate;
uses crt;
const
	startline = 7;
type
	itemchrptr = ^itemchr;
	itemchr = record
		data:char;
		next:itemchrptr;
	end;
	stackofchar = itemchrptr;
	itemstrptr = ^itemstr;
	itemstr = record
		data:string;
		next:itemstrptr;
	end;
	stackofstring = itemstrptr;
	arstr = array of array of char;
procedure writescreen(buffer:arstr;whereisx,whereisy,laststring:longint;insrt:boolean); {every single symbol program will rewrite screen with buffer array}
var
	i,f:longint;
begin
	clrscr;
	writeln('       _ _   _            _              _ _ _ ');
    	writeln('__   _(_|_) | |_ _____  _| |_    ___  __| (_) |_ ___  _ __ ');
   	writeln('\ \ / / | | | __/ _ \ \/ / __|  / _ \/ _` | | __/ _ \| __|');
    	writeln(' \ V /| | | | ||  __/>  <| |_  |  __/ (_| | | || (_) | |  ');
   	writeln('  \_/ |_|_|  \__\___/_/\_\\__|  \___|\__,_|_|\__\___/|_|  ');
	if insrt then
		writeln('--INSERT--');
	if not insrt then
		writeln('--COMMAND--');
    	writeln;
	for i := 0 to high(buffer) do
	begin
		gotoXY(1,i+startline);
		for f := 0 to high(buffer[i]) do
		begin
			if buffer[i][f] <> #0 then
			begin
				write(buffer[i][f])
			end;
		end;
	end;
	gotoXY(whereisx,whereisy)
end;
var
	buffer:array of array of char;
	sizeofalllines: array of integer;
	f1:text;
	x:string;
	c,g:char;
	i,ic,v,f:integer;
	alllines,laststr,num,countsoc,whereisx,whereisy,laststring:longint;
	up,insrt,arrow:boolean;
begin
	clrscr;
	writeln('       _ _   _            _              _ _ _ '); {first enter to the program}
    	writeln('__   _(_|_) | |_ _____  _| |_    ___  __| (_) |_ ___  _ __ ');
   	writeln('\ \ / / | | | __/ _ \ \/ / __|  / _ \/ _` | | __/ _ \| __|');
    	writeln(' \ V /| | | | ||  __/>  <| |_  |  __/ (_| | | || (_) | |  ');
   	writeln('  \_/ |_|_|  \__\___/_/\_\\__|  \___|\__,_|_|\__\___/|_|  ');
    	writeln;
	insrt := false; {intializing variables}
	ic := 0;
	alllines := 1;
	whereisy := startline;
	whereisx := 1;
	countsoc := 1;
	setlength(buffer,1);
	setlength(buffer[0],1);
	buffer[high(buffer)] [high(buffer[high(buffer)])] := #0;
	setlength(sizeofalllines,length(sizeofalllines) + 1);
	up := false;
	sizeofalllines[0] := 0;
		insrt := false;
	while true do {main program}
	begin
		writescreen(buffer,whereisx,whereisy,laststring,insrt); {rewriting screen every iteration}
		arrow := false;
		c := readkey;
		if c = #0 then
		begin
			c := readkey;
			if (c = #72) and (whereisy <> 1) then
			begin
				whereisy := whereisy - 1;
			end;
			if (c = #80) then
			begin
				if whereisy-startline < alllines then
					gotoXY(whereisx,whereisy+1);
			end;
			if (c = #75) then
			begin
				if whereisx > 1 then
				begin
					gotoXY(whereisx-1,whereisy);
					whereisx := whereisx - 1;
				end
			end;
			if (c = #77) then
				if whereisx <> sizeofalllines[wherey-startline] then
				begin	
					gotoXY(whereisx +1,whereisy);
					whereisx := whereisx + 1;
				end;
			arrow := true;
		end;
		if c = 'i' then
		begin
			insrt := true;
		end;
		
		if (c ='q') and (not insrt) then
		begin 
			break;
		end;
		if (insrt) and (not arrow) then
		begin
			ic := ic + 1;
			if (c > #0) and (ic > 1) and (c <> #8) and (c>=#32)then
			begin
				setlength(buffer[whereisy-startline], length(buffer[whereisy-startline])+1);
				whereisx := whereisx + 1;
				buffer[whereisy - startline] [whereisx-1] := c;
				countsoc := countsoc + 1;
			end;
			if c = #8 then
			begin
				if wherex > 1 then
				begin
					setlength(buffer[high(buffer)],length(buffer[high(buffer)]) - 1);							       countsoc := countsoc - 1;
					whereisx := whereisx - 1;
				end;
			end;
			if c = #9 then
			begin
				setlength(buffer[high(buffer)], length(buffer[high(buffer)]) + 1);
				buffer[high(buffer)] [high(buffer[high(buffer)])] := #9
			end;
			if c = #13 then
			begin
				alllines := alllines + 1;
				setlength(buffer, alllines);
				setlength(buffer[alllines-1], 1);
				whereisy := whereisy + 1;				
				whereisx := 1;
				setlength(sizeofalllines,alllines);
				sizeofalllines[high(sizeofalllines)] := countsoc;
				countsoc := 0;
				laststring := laststring + 1;
				
			end;
			if c = #27 then
			begin
				insrt := false;
				ic := 0
			end;
		end;
	end;
	writeln;
	writeln;
	clrscr;
	if Paramcount = 1 then
	begin
		assign(f1,Paramstr(1));
		rewrite(f1);
		for f := 0 to high(buffer) do
		begin
			for v := 0 to high(buffer[f]) do
			begin
				if buffer[f][v] <> #0 then
					write(f1,buffer[f][v]);
			end;
			writeln(f1);
		end;
		close(f1)
	end;
end.
