program navigate;
uses crt,sysutils;
const
	startline = 7;
	rst = #27'[0m';
	red1 = #27'[31m';
	grn = #27'[32m';
	ylw = #27'[33m';
	blu = #27'[34m';
	mag = #27'[35m';
	cyn = #27'[36m';
	wht = #27'[37m';
	keyword_count = 11;
type
	KeyWord = record
		wrd:string;
		color:string;
		len:integer;
	end;
	arstr = array of array of char;
procedure writescreen(buffer:arstr;whereisx,whereisy,laststring:longint;insrt,syntaxhighlight:boolean;keywords:array of keyword); {every single symbol program will rewrite screen with buffer array}
var
	i,f,p,v:longint;
	tmp:string;
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
	if syntaxhighlight then
	begin
		for i := 0 to high(buffer) do
	begin
		gotoXY(1,i+startline);
		for v := 0 to  high(buffer[i]) do
			tmp := tmp + buffer[i] [v];
		if syntaxhighlight then
		begin	
			for v := 1 to keyword_count do
			begin
				p := pos(keywords[v].wrd,tmp);
				if p > 0 then
					tmp := keywords[v].color + tmp + RST
			end;
		end;
		if syntaxhighlight then
    		begin
        		for v := 0 to high(keywords) do 
			begin
            		tmp := StringReplace(tmp, keywords[v].wrd, keywords[v].color + keywords[v].wrd + RST, [rfReplaceAll]);
        	end;
		write(tmp);
	end;
		tmp := '';
		write(RST);
	end;
	end;
	if not syntaxhighlight then
	begin
		for i := 0 to high(buffer) do
		begin
			gotoXY(1,i+startline);
			for f := 0 to high(buffer[i]) do
				write(buffer[i] [f])
		end;
	end;
	gotoXY(whereisx+1,whereisy)	
end;
var
	buffer:array of array of char;
	sizeofalllines: array of integer;
	f1,config:text;
	x:string;
	c,g,temp,temp1:char;
	i,ic,v,f,p:integer;
	alllines,laststr,num,countsoc,whereisx,whereisy,laststring:longint;
	up,insrt,arrow,syntaxhighlight,cursorjump,autoident:boolean;
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
	writeln('       _ _   _            _              _ _ _ '); {first enter to the program}
    	writeln('__   _(_|_) | |_ _____  _| |_    ___  __| (_) |_ ___  _ __ ');
   	writeln('\ \ / / | | | __/ _ \ \/ / __|  / _ \/ _` | | __/ _ \| __|');
    	writeln(' \ V /| | | | ||  __/>  <| |_  |  __/ (_| | | || (_) | |  ');
   	writeln('  \_/ |_|_|  \__\___/_/\_\\__|  \___|\__,_|_|\__\___/|_|  ');
    	writeln;
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
	alllines := 1;
	whereisy := startline;
	whereisx := 1;
	countsoc := 1;
	setlength(buffer,1);
	setlength(buffer[0],1);
	buffer[high(buffer)] [high(buffer[high(buffer)])] := #0;
	setlength(sizeofalllines,1);
	up := false;
	sizeofalllines[0] := 0;
		insrt := false;
	while true do {main program}
	begin
		writescreen(buffer,whereisx,whereisy,laststring,insrt,syntaxhighlight,keywords); {rewriting screen every iteration}
		arrow := false;
		c := readkey;
		if c = #0 then
		begin
			c := readkey;
			if (c = #72) and (whereisy <> 1) then
			begin
				if ((whereisx > sizeofalllines[whereisy-startline-1]) or (whereisx = sizeofalllines[whereisy-startline]+1)) and (cursorjump) then
					whereisx := sizeofalllines[whereisy-startline-1] + 1;
				whereisy := whereisy - 1;
			end;
			if (c = #80) then
			begin
				if whereisy-startline < alllines then
					whereisy := whereisy + 1;
				if ((whereisx > sizeofalllines[whereisy-startline-1]) or (whereisx = sizeofalllines[whereisy-startline]+1)) and (cursorjump) then
					whereisx := sizeofalllines[whereisy-startline-1] + 1;
			end;
			if (c = #75) then
			begin
				if whereisx > 1 then
					whereisx := whereisx - 1;
			end;
			if (c = #77) then
			begin
				if whereisx <= sizeofalllines[whereisy - startline] then
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
				sizeofalllines[whereisy-startline] := sizeofalllines[whereisy-startline] + 1;
				whereisx := whereisx + 1;
				countsoc := countsoc + 1;
				if whereisx-1 <> sizeofalllines[whereisy-startline] then
				begin
					setlength(buffer[whereisy-startline],length(buffer[whereisy-startline])+1);
					for i := sizeofalllines[whereisy-startline] downto whereisx-1 do
					begin
						buffer[whereisy-startline] [i+1] := buffer[whereisy-startline] [i];
					end;
				end;
				buffer[whereisy - startline] [whereisx-1] := c;
			end;
			if c = #8 then
			begin
				if whereisx > 1 then
				begin
					if whereisx-1 < sizeofalllines[whereisy - startline] then
					begin
						for i := whereisx-1 to sizeofalllines[whereisy-startline]-1 do
							buffer[whereisy-startline] [i] := buffer[whereisy-startline] [i+1]
					end;
					setlength(buffer[whereisy-startline],length(buffer[whereisy-startline]) - 1);
					countsoc := countsoc - 1;
					whereisx := whereisx - 1;
					sizeofalllines[whereisy-startline] := sizeofalllines[whereisy-startline] - 1
				end;
			end;
			if c = #9 then
			begin
				setlength(buffer[high(buffer)], length(buffer[high(buffer)]) + 1);
				buffer[whereisy-startline] [whereisx-1]:= #9
			end;
			if c = #13 then
			begin

				setlength(sizeofalllines,alllines);
				if whereisy-startline < alllines then
				begin
					setlength(sizeofalllines,length(sizeofalllines) + 1);
					for i := whereisy-startline downto alllines do
					begin
						sizeofalllines[i+1] := sizeofalllines[i]
					end;
				end;
				alllines := alllines + 1;
				setlength(buffer, alllines);
				setlength(buffer[alllines-1], 1);
				whereisy := whereisy + 1;				
				whereisx := 1;
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
