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
procedure writescreen(buffer:arstr;whereisx,whereisy:longint;insrt:boolean); {every single symbol program will rewrite screen with buffer array}
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
end;
procedure SOSInit(var dat:stackofstring);
begin
	dat := nil
end;
procedure SOCInit(var dat:stackofchar);
begin
	dat := nil;
end;
procedure foundlaststring(dat:stackofstring;var num:longint);
begin
	while dat <> nil do
	begin
		dat := dat^.next;
		num := num + 1
	end
end;
function foundlastchar(dat:stackofchar):longint;
begin
	foundlastchar := 0;
	while dat <> nil do
	begin
		foundlastchar := foundlastchar + 1;
		dat := dat^.next;
	end
end;
var
	buffer:array of array of char;
	sizeofalllines: array of integer;
	f1:text;
	x:string;
	c,g:char;
	i,ic,v,f:integer;
	alllines,laststr,countlid,num,countsoc,whereisx,whereisy:longint;
	insrt,arrow,isq,up:boolean;
	dat,lastitemdat:stackofstring;
	whlstr,tmpchar,tmpchar1:stackofchar;
begin
	clrscr;
	writeln('       _ _   _            _              _ _ _ '); {first enter to the program}
    	writeln('__   _(_|_) | |_ _____  _| |_    ___  __| (_) |_ ___  _ __ ');
   	writeln('\ \ / / | | | __/ _ \ \/ / __|  / _ \/ _` | | __/ _ \| __|');
    	writeln(' \ V /| | | | ||  __/>  <| |_  |  __/ (_| | | || (_) | |  ');
   	writeln('  \_/ |_|_|  \__\___/_/\_\\__|  \___|\__,_|_|\__\___/|_|  ');
    	writeln;
	insrt := false; {intializing variables}
	SOSInit(dat);
	SOCInit(whlstr);
	ic := 0;
	alllines := 1;
	whereisy := startline;
	whereisx := 1;
	countsoc := 1;
	countlid := 1;
	setlength(buffer,length(buffer) + 1);
	setlength(buffer[high(buffer)],length(buffer[high(buffer)]) + 1);
	buffer[high(buffer)] [high(buffer[high(buffer)])] := #0;
	setlength(sizeofalllines,length(sizeofalllines) + 1);
	up := false;
	sizeofalllines[0] := 0;
		insrt := false;
	while true do {main program}
	begin
		writescreen(buffer,whereisx,whereisy,insrt); {rewriting screen every iteration}
		countlid := 1;
		lastitemdat := dat;
		if lastitemdat <> nil then
			while lastitemdat^.next <> nil do
			begin
				lastitemdat := lastitemdat^.next;
				countlid := countlid + 1;
			end;
		arrow := false;
		c := readkey;
		if (up) and (c <> #0) then
		begin
			buffer[high(buffer) - 1] [high(buffer[high(buffer)])] := c;
			up := false;
		end;
		if c = #0 then
		begin
			c := readkey;
			if (c = #72) and (whereisy <> 1) then
			begin
				gotoXY(whereisx,whereisy - 1);
				up := true;
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
				if wherex <> sizeofalllines[wherey-startline] then
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
			isq := true;
			if dat = nil then
			begin
				new(dat);
				dat^.next := nil;
				dat^.data := '';
				lastitemdat := dat;
			end;
			if whlstr <> nil then
			begin 
				alllines := alllines + 1;
				tmpchar := whlstr;
				num := foundlastchar(tmpchar);
				for i := 1 to num do
				begin
					if tmpchar^.data >= #32 then
						lastitemdat^.data :=tmpchar^.data + lastitemdat^.data;
					tmpchar := tmpchar^.next;
				end;
				new(lastitemdat^.next);
				lastitemdat := lastitemdat^.next;
				lastitemdat^.next := nil;
				lastitemdat^.data := '';
				whlstr := nil;
			end;
			break;
		end;
		if (insrt) and (not arrow) then
		begin
			ic := ic + 1;
			if (c > #0) and (ic > 1) and (c <> #8) and (c>=#32)then
			begin
				new(tmpchar1);
				tmpchar1^.data := c;
				tmpchar1^.next := whlstr;
				whlstr := tmpchar1;
				setlength(buffer[high(buffer)], length(buffer[high(buffer)]) + 1);
				buffer[high(buffer)] [high(buffer[high(buffer)])] := c;
				countsoc := countsoc + 1;
				whereisx := whereisx + 1;
			end;
			if c = #8 then
			begin
				if wherex > 1 then
				begin
					setlength(buffer[high(buffer)],length(buffer[high(buffer)]) - 1);
					gotoXY(wherex-1,wherey);
					if whlstr <> nil then
						whlstr := whlstr^.next;
					countsoc := countsoc - 1;
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
				if dat = nil then
				begin
					new(dat);
					dat^.next := nil;
					dat^.data := '';
					lastitemdat := dat;
				end;
				setlength(buffer, length(buffer) + 1);
				gotoXY(1,wherey + 1);
				alllines := alllines + 1;
				tmpchar := whlstr;
				num := foundlastchar(tmpchar);
				for i := 1 to num do
				begin
					if tmpchar^.data >= #32 then
						lastitemdat^.data :=tmpchar^.data + lastitemdat^.data;
					tmpchar := tmpchar^.next;
				end;
				new(lastitemdat^.next);
				lastitemdat := lastitemdat^.next;
				lastitemdat^.next := nil;
				lastitemdat^.data := '';
				whlstr := nil;
				whereisx := 1;
				whereisy := whereisy + 1;
				setlength(sizeofalllines,length(sizeofalllines) + 1);
				sizeofalllines[high(sizeofalllines)] := countsoc;
				countsoc := 0;
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
