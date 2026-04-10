program navigate;
uses crt,sysutils,vitest;
var
	buffer,oldbuffer:array of string;
	f1,config,inpt:text;
	x,tmp:string;
	c,g:char;
	i,ic,v,f,p,z:integer;
	alllines,countsoc,whereisx,whereisy,laststring,currentbuffer,lastbuffer,limitcurbuffer:longint;
	insrt,arrow,syntaxhighlight,cursorjump,autoident:boolean;
	keywords:array [1..keyword_count] of keyword = (
		(wrd: 'begin';color: ylw;len:5),
		(wrd: 'end';color:ylw;len:3),
		(wrd: 'if';color:ylw;len:2),
		(wrd: 'then';color:ylw;len:4),
		(wrd: 'for';color:ylw;len:3),
		(wrd: 'do';color:ylw;len:2),
		(wrd: 'integer';color:cyn;len:7),
		(wrd: 'boolean';color:cyn;len:7),
		(wrd: 'procedure';color:ylw;len:9),
		(wrd: 'program';color:ylw;len:7),
		(wrd: 'writeln';color:cyn;len:7)
	);
begin
	clrscr;
	insrt := false; {intializing variables}
	ic := 0;
	cursorjump := false;
	syntaxhighlight := false;
	cursorjump := false;
	if FileExists('config/vii.conf') then
	begin
		assign(config,'config/vii.conf');
		reset(config);
		while not eof(config) do
		begin
			readln(config,x);
			p := pos('auto-ident',x);
			if p > 0 then
			begin
				p := pos('true',x);
				if p > 0 then
				begin
					autoident := true;
				end;
			end;
			p := pos('syntax-highlighting',x);
			if p > 0 then
			begin
				p := pos('true',x);
				if p > 0 then
				begin
					syntaxhighlight := true;
				end;
			end;
			p := pos('automatic_cursor_jumping',x);
			if p > 0 then
			begin
				p := pos('true',x);
				if p>0 then
				begin
					cursorjump := true
				end;
			end
		end;
		close(config);
	end;
	z := 0;
	alllines := 1;
	whereisy := startline;
	whereisx := 1;
	countsoc := 1;
	currentbuffer := 1;
	limitcurbuffer := 10;
	lastbuffer := 1;
	setlength(oldbuffer,limitcurbuffer);
	setlength(buffer,limitcurbuffer);
	laststring := 1;
	if FileExists(Paramstr(1)) then
	begin
		assign(inpt,Paramstr(1));
		reset(inpt);
		while not eof(inpt) do
		begin
			read(inpt,g);
			if alllines >= limitcurbuffer then
			begin
				limitcurbuffer := limitcurbuffer * 2;
				setlength(buffer,limitcurbuffer);
			end;
			if g = #9 then
			begin
				lastbuffer := lastbuffer + 1;
				buffer[alllines-1] [z] := #9;
				z := z + 1;
			end;
			if g = #10 then
			begin
				alllines := alllines + 1;
				currentbuffer := currentbuffer + 1;
				lastbuffer := lastbuffer + 1;
				countsoc := 0;
				laststring := laststring + 1;
				z := 0;
			end;
			if (g<>#0) and (g >= #32) then
			begin
				lastbuffer := lastbuffer + 1;
				countsoc := countsoc + 1;
				buffer[alllines-1] [z] := g;
				lastbuffer := lastbuffer + 1;
				z := z + 1;
			end;
		end;
		close(inpt);
	end;
	insrt := false;
	while true do {main program}
	begin
		writescreen(oldbuffer,buffer,whereisx,whereisy,laststring,insrt,syntaxhighlight,keywords,c); {rewriting screen every iteration}
		for i := 0 to high(buffer) do
		begin
			oldbuffer[i] := buffer[i]
		end;
		arrow := false;
		c := readkey;
		if c = #0 then
		begin
			c := readkey;
			if (c = KEY_UP) and (whereisy-startline >= 1) then
			begin
				if ((whereisx-1 > high(buffer[whereisy-startline-1])) or (whereisx-1 = high(buffer[whereisy-startline])+1)) and (cursorjump) then
					whereisx := length(buffer[whereisy-startline]);
				whereisy := whereisy - 1;
			end;
			if (c = KEY_DOWN) then
			begin
				if whereisy-startline < alllines then
					whereisy := whereisy + 1;
				if ((whereisx > length(buffer[whereisy-startline])) or (whereisx = length(buffer[whereisy-startline]) + 1)) and (cursorjump) then
					whereisx := length(buffer[whereisy-startline]) + 1;
			end;
			if (c = KEY_LEFT) then
			begin
				if whereisx > 1 then
					whereisx := whereisx - 1;
			end;
			if (c = KEY_RIGHT) then
			begin
				if whereisx <= length(buffer[whereisy-startline]) then
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
				lastbuffer := lastbuffer + 1;
				whereisx := whereisx + 1;
				countsoc := countsoc + 1;
				insert(c,buffer[whereisy-startline],whereisx-1)
			end;
			if (c = #8) and (whereisy-startline >= 0)then
			begin
				if whereisx > 1 then
				begin
					lastbuffer := lastbuffer - 1;
					countsoc := countsoc - 1;
					whereisx := whereisx - 1;
					delete(buffer[whereisy-startline],whereisx,1);
				end
				else
				begin
					if whereisy-startline > 0 then
					begin
						buffer[whereisy-startline-1] := buffer[whereisy-startline-1] + buffer[whereisy-startline];
						buffer[whereisy-startline] := '';
						oldbuffer[whereisy-startline] := 'z';
						whereisy := whereisy - 1;
						for i := whereisy-startline+1 to high(buffer) do
						begin
							buffer[i] := buffer[i+1];
							oldbuffer[i] := '';
						end;
						oldbuffer[high(buffer)] := 'z';
						whereisx := length(buffer[whereisy-startline]) + 1;
					end;
					gotoXY(1,alllines+startline-1);
					clreol;
					alllines := alllines - 1;
					setlength(oldbuffer,alllines);
					setlength(buffer,alllines);
					laststring := laststring - 1;
				end;
			end;
			if c = #9 then
			begin
				lastbuffer := lastbuffer + 1;
				insert(c,buffer[whereisy-startline],whereisx);
			end;
			if c = #13 then
			begin
				alllines := alllines + 1;
				setlength(buffer,length(buffer) + 1);
				setlength(oldbuffer,length(oldbuffer) + 1);
				countsoc := 0;
				laststring := laststring + 1;
				if (whereisx-1 <> length(buffer[whereisy-startline])) then
				begin
					tmp := copy(buffer[whereisy-startline],whereisx,length(buffer[whereisy-startline])-whereisx+2);
					for i := high(buffer) downto whereisy-startline + 2 do
					begin
						buffer[i] := buffer[i-1];
						oldbuffer[i] := '';
					end;
					delete(buffer[whereisy-startline],whereisx,length(buffer[whereisy-startline])-whereisx+2);
					buffer[whereisy-startline+1] := tmp;
					tmp := '';
					oldbuffer[whereisy-startline+1] := '';
				end
				else if (whereisy-startline < high(buffer)) then
				begin
					for i := high(buffer) downto whereisy-startline + 2 do
					begin
						buffer[i] := buffer[i-1];
						oldbuffer[i] := '';
					end;
					buffer[whereisy-startline+1] := '';
					oldbuffer[whereisy-startline+1] := 'z';
				end;
				whereisy := whereisy + 1;
				whereisx := 1;
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
		for f := 0 to alllines-1 do
		begin
			for v := 0 to length(buffer[f]) do
			begin
				if buffer[f][v] <> #0 then
					write(f1,buffer[f][v]);
			end;
			writeln(f1);
		end;
		close(f1)
	end;
end.
