program navigate;
uses crt,sysutils;
const
	startline = 2;
	KEY_UP = #72;
	KEY_DOWN = #80;
	KEY_LEFT = #75;
	KEY_RIGHT = #77;
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
	zoom = array of integer;
procedure writescreen(sizeofalllines:zoom;buffer:arstr;whereisx,whereisy,laststring:longint;insrt,syntaxhighlight:boolean;keywords:array of keyword); {every single symbol program will rewrite screen with buffer array}
var
	i,f,p,v:longint;
	tmp:string;
begin
	clrscr;
	if insrt then
		writeln('--INSERT--');
	if not insrt then
		writeln('--COMMAND--');
    	writeln;
	if syntaxhighlight and (pos('.pas',Paramstr(1)) > 0) then
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
				if (p > 0) and (tmp[p+keywords[v].len+1] >= #32) and (((tmp[p-1] = #32) or (tmp[p-1] = #9)) or (p=1)) then
				begin
					insert(keywords[v].color,tmp,p);
					tmp := tmp + RST
				end;
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
	if not syntaxhighlight or (syntaxhighlight and not(pos('.pas',Paramstr(1)) > 0)) then
	begin
		for i := 0 to high(buffer) do
		begin
			gotoXY(1,i+startline);
			for f := 0 to high(buffer[i]) do
				write(buffer[i] [f])
		end;
	end;
	gotoXY(whereisx,whereisy)	
end;
var
	buffer:array of array of char;
	sizeofalllines: array of integer;
	f1,config,inpt:text;
	x:string;
	c,g,temp,temp1:char;
	i,ic,v,f,p,z:integer;
	alllines,laststr,num,countsoc,whereisx,whereisy,laststring,currentbuffer,lastbuffer,zeb,limitcurbuffer,limitlsbuffer,y,realsize:longint;
	up,insrt,arrow,syntaxhighlight,cursorjump,autoident,memallocated:boolean;
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
	y := 0;
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
	limitlsbuffer := 5;
	lastbuffer := 1;
	setlength(buffer,limitcurbuffer);
	setlength(buffer[0],limitlsbuffer);
	buffer[0] [0]:= #0;
	laststring := 1;
	setlength(sizeofalllines,limitcurbuffer);
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
				setlength(sizeofalllines,limitcurbuffer);
			end;
			if g = #9 then
			begin
				if z >= high(buffer[alllines-1]) then
					setlength(buffer[alllines-1],length(buffer[alllines-1]) * 2);
				lastbuffer := lastbuffer + 1;
				buffer[alllines-1] [z] := #9;
				z := z + 1;
				sizeofalllines[alllines-1] := sizeofalllines[alllines-1] + 1;
			end;
			if g = #10 then
			begin
				alllines := alllines + 1;
				currentbuffer := currentbuffer + 1;
				lastbuffer := lastbuffer + 1;
				countsoc := 0;
				laststring := laststring + 1;
				z := 0;
				setlength(buffer[alllines-1],limitlsbuffer);
			end;
			if (g<>#0) and (g >= #32) then
			begin
				if z >= high(buffer[alllines-1]) then
					setlength(buffer[alllines-1],length(buffer[alllines-1]) * 2);
				lastbuffer := lastbuffer + 1;
				sizeofalllines[alllines-1] := sizeofalllines[alllines-1] + 1;
				countsoc := countsoc + 1;
				buffer[alllines-1] [z] := g;
				lastbuffer := lastbuffer + 1;
				z := z + 1;
			end;
		end;
		close(inpt);
	end;
	up := false;
	sizeofalllines[0] := 0;
		insrt := false;
	while true do {main program}
	begin
		if round(currentbuffer*1.5) > limitcurbuffer then
		begin
			limitcurbuffer := limitcurbuffer * 2;
			setlength(buffer,limitcurbuffer);
			setlength(sizeofalllines,limitcurbuffer);
		end;
		while buffer[whereisy-startline] [y] > #0 do
			y := y + 1;
		writescreen(sizeofalllines,buffer,whereisx,whereisy,laststring,insrt,syntaxhighlight,keywords); {rewriting screen every iteration}
		arrow := false;
		c := readkey;
		if c = #0 then
		begin
			c := readkey;
			if (c = KEY_UP) and (whereisy-startline >= 1) then
			begin
				if ((whereisx-1 > high(buffer[whereisy-startline-1])) or (whereisx-1 = high(buffer[whereisy-startline])+1)) and (cursorjump) then
					whereisx := length(buffer[whereisy-startline-1]) + 1;
				whereisy := whereisy - 1;
			end;
			if (c = KEY_DOWN) then
			begin
				if whereisy-startline < alllines then
					whereisy := whereisy + 1;
				if ((whereisx > length(buffer[whereisy-startline-1])) or (whereisx = length(buffer[whereisy-startline])+1)) and (cursorjump) then
					whereisx := length(buffer[whereisy-startline-1]) + 1;
			end;
			if (c = KEY_LEFT) then
			begin
				if whereisx > 1 then
					whereisx := whereisx - 1;
			end;
			if (c = KEY_RIGHT) then
			begin
				if whereisx <= y then
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
				sizeofalllines[whereisy-startline] := sizeofalllines[whereisy-startline] + 1;
				whereisx := whereisx + 1;
				countsoc := countsoc + 1;
				if whereisx > high(buffer[whereisy-startline]) then
					setlength(buffer[whereisy-startline],length(buffer[whereisy-startline]) * 2);
				if whereisx-1 <> length(buffer[whereisy-startline]) then
				begin
					lastbuffer := lastbuffer + 1;
					for i := high(buffer[whereisy-startline]) downto whereisx-1 do
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
					buffer[whereisy-startline] [whereisx-1] := #0;
					lastbuffer := lastbuffer - 1;
					countsoc := countsoc - 1;
					whereisx := whereisx - 1;
					sizeofalllines[whereisy-startline] := sizeofalllines[whereisy-startline] - 1
				end;			
			end;
			if c = #9 then
			begin
				lastbuffer := lastbuffer + 1;
				buffer[whereisy-startline] [whereisx-1]:= #9
			end;
			if c = #13 then
			begin
				alllines := alllines + 1;
				currentbuffer := currentbuffer + 1;
				lastbuffer := lastbuffer + 1;
				whereisy := whereisy + 1;				
				whereisx := 1;
				countsoc := 0;
				laststring := laststring + 1;
				setlength(buffer[alllines-1],limitlsbuffer);
				if whereisy-startline+1 < alllines then
				begin
					zeb := 0;
					for i := alllines-1 downto whereisy-startline	do
					begin
						buffer[i] := buffer[i-1];
						sizeofalllines[i] := sizeofalllines[i-1]
					end;
					setlength(buffer[whereisy-startline],limitlsbuffer);
					for i := 0 to limitlsbuffer-1 do
						buffer[whereisy-startline] [i] := #0;
				end;				
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
