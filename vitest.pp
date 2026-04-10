unit vitest;
interface
uses crt;
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
	arstr = array of string;
var
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
procedure writescreen(var oldbuffer:arstr;buffer:arstr;whereisx,whereisy,laststring:longint;insrt,syntaxhighlight:boolean;keywords:array of keyword;c:char);
implementation
procedure writescreen(var oldbuffer:arstr;buffer:arstr;whereisx,whereisy,laststring:longint;insrt,syntaxhighlight:boolean;keywords:array of keyword;c:char);
var
	i,tump,p:integer;
begin
		if insrt then
		begin
			gotoXY(1,1);
			writeln('-- INSERT --');
		end
		else
		begin
			gotoXY(1,1);
			writeln('-- COMMAND --');
		end;
		for i := 0 to high(buffer) do
		begin
			if buffer[i] <> oldbuffer[i] then
			begin
				gotoXY(1,i+startline);
				clreol;
				write(buffer[i]);
			end;
			if syntaxhighlight and (pos('.pas',Paramstr(1)) > 0) then
			begin
				for tump := 0 to high(keywords) do
				begin
					p := pos(keywords[tump].wrd,buffer[i]);
					if (p > 0) and ((p=1) or (buffer[i] [p-1] <= #32)) then
					begin
						gotoXY(p,i+startline);
						write(keywords[tump].color,keywords[tump].wrd,rst);
					end;
				end;
			end;
		end;
		gotoXY(whereisx,whereisy);
end;
end.
