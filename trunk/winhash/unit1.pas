unit Unit1;

{$mode objfpc}{$H+}

//

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    comment: TEdit;
    creator: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    verify : boolean;
    hashdatei:string;
    procedure MD5_erstellen;
    procedure SHA1_erstellen;
    procedure CRC32_erstellen;
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

const
  version: string = '0.1.1 opensource';

implementation

uses md5, sha1, crc32, unit2;

{ TForm1 }

function Check(const AFilename: string): string;
begin
  if Length(AFilename) = 0 then
  begin
    Result := AFilename;
    Exit;
  end;

  if AFilename[Length(AFilename)] <> '\' then
    Result := AFilename + '\'
  else
    Result := AFilename;
end;


function LogEntry(Dig: TMD5Digest): string;
begin
  Result := lowercase(Format('%s', [MD5Print(Dig)]));
end;

function ReverseString(const AText: string): string;
var
  I: integer;
  P: PChar;
begin
  SetLength(Result, Length(AText));
  P := PChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

function ret_name(was: string): string;
var
  I: integer;
  hilf, hilf1: string;
begin
  hilf := '';
  hilf1 := was;
  for I := length(was) - 1 downto 1 do
  begin    // Iterate
    if ((was[i] = '\') or (was[i] = '/')) then
      break
    else
      hilf := hilf + was[i];
  end;    // for
  i := length(hilf);
  Delete(hilf1, length(was), i);
  Result := reversestring(hilf);
end;


procedure GetFiles(ADirectory: string; AMask: string; AList: TStrings;
  ARekursiv: boolean);
var
  SR: TSearchRec;
begin
  if (ADirectory <> '') and (ADirectory[length(ADirectory)] <> '\') then
    ADirectory := ADirectory + '\';

  if (FindFirst(ADirectory + AMask, faAnyFile - faDirectory, SR) = 0) then
  begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') and (SR.Attr <> faDirectory) then
        AList.Add(ADirectory + SR.Name)
    until FindNext(SR) <> 0;
    SysUtils.FindClose(SR);
  end;

  if ARekursiv then
    if (FindFirst(ADirectory + '*.*', faDirectory, SR) = 0) then
    begin
      repeat
        if (SR.Name <> '.') and (SR.Name <> '..') then
          GetFiles(ADirectory + SR.Name, AMask, AList, True);
      until FindNext(SR) <> 0;
      SysUtils.FindClose(SR);
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
    edit1.Text := Check(SelectDirectoryDialog1.FileName);
end;

//MD5 Hash berechnen und erstellen
procedure TForm1.MD5_erstellen;
var
  sr: TSearchRec;
  FileAttrs, CrcTime, i: integer;
  fehler: boolean;
  S, hilf, hilfs, test1: string;
  f: textfile;
  plist: TStringList;
  TMD5: TMD5Digest;
begin
  ListBox1.Clear;
  i := 0;

  CrcTime := GetTickCount;
  s := ret_name(edit1.Text);
  if s = '' then
    s := 'WinHash.md5'
  else
    s := s + '.md5';
  if s[2] = ':' then
    s := 'WinHash.md5';

  hilfs := s;
  hilf := check(edit1.Text);
  setcurrentdir(edit1.Text);
  assignfile(f, hilf + s);
  try
    rewrite(f);
  except
  end;
  writeln(f, format('; created by WinHash version %s (c) by Dirk Paehl.', [version]));
  writeln(f, '; MD5 MODE');
  if creator.Text <> '' then
    writeln(f, '; creator: ' + creator.Text);
  if comment.Text <> '' then
    writeln(f, '; comment: ' + comment.Text);
  writeln(f, '; http://www.paehl.de');
  plist := TStringList.Create;
  if checkbox1.Checked then
    GetFiles(hilf, '*.*', plist, True)
  else
    GetFiles(hilf, '*.*', plist, False);
  for i := 0 to plist.Count - 1 do    // Iterate
  begin
    test1 := extractfileExt(plist.strings[i]);
    if strupper(PChar(test1)) <> '.MD5' then
    begin
      test1 := plist.strings[i];
      Delete(test1, 1, length(Edit1.Text));
      TMD5 := MD5File(plist.strings[i]);
      s := LogEntry(TMD5);

      ListBox1.Items.add(s + ' ' + test1);
      writeln(f, s + '  ' + test1);
    end;
  end;    // for
  CrcTime := GetTickCount - CrcTime;
  closefile(f);
  label2.Caption := (format('TIME: %d millisecs', [crcTime]));
end;

//SHA1 Hash berechnen und erstellen
procedure TForm1.SHA1_erstellen;
var
  sr: TSearchRec;
  FileAttrs, CrcTime, i: integer;
  fehler: boolean;
  S, hilf, hilfs, test1: string;
  f: textfile;
  plist: TStringList;
  TSHA1: TSHA1Digest;
begin
  ListBox1.Clear;
  i := 0;

  CrcTime := GetTickCount;
  s := ret_name(edit1.Text);
  if s = '' then
    s := 'WinHash.sha'
  else
    s := s + '.sha';
  if s[2] = ':' then
    s := 'WinHash.sha';

  hilfs := s;
  hilf := check(edit1.Text);
  setcurrentdir(edit1.Text);
  assignfile(f, hilf + s);
  try
    rewrite(f);
  except
  end;
  writeln(f, format('; created by WinHash version %s (c) by Dirk Paehl.', [version]));
  writeln(f, '; SHA1 MODE');
  if creator.Text <> '' then
    writeln(f, '; creator: ' + creator.Text);
  if comment.Text <> '' then
    writeln(f, '; comment: ' + comment.Text);
  writeln(f, '; http://www.paehl.de');
  plist := TStringList.Create;
  if checkbox1.Checked then
    GetFiles(hilf, '*.*', plist, True)
  else
    GetFiles(hilf, '*.*', plist, False);
  for i := 0 to plist.Count - 1 do    // Iterate
  begin
    test1 := extractfileExt(plist.strings[i]);
    if strupper(PChar(test1)) <> '.SHA' then
    begin
      test1 := plist.strings[i];
      Delete(test1, 1, length(Edit1.Text));
      TSHA1 := SHA1File(plist.strings[i]);
      s := SHA1Print(TSHA1);

      ListBox1.Items.add(s + ' ' + test1);
      writeln(f, s + '  ' + test1);
    end;
  end;    // for
  CrcTime := GetTickCount - CrcTime;
  closefile(f);
  label2.Caption := (format('TIME: %d millisecs', [crcTime]));
end;

//CRC32 Hash berechnen und erstellen
procedure TForm1.CRC32_erstellen;
var
  FileAttrs, CrcTime, i, crc: integer;
  fehler: boolean;
  S, hilf, hilfs, test1, test2: string;
  f: textfile;
  plist: TStringList;
  Stream: TMemoryStream;
begin
  ListBox1.Clear;
  i := 0;

  CrcTime := GetTickCount;
  s := ret_name(edit1.Text);
  if s = '' then
    s := 'WinHash.sfv'
  else
    s := s + '.sfv';
  if s[2] = ':' then
    s := 'WinHash.sfv';

  hilfs := s;
  hilf := check(edit1.Text);
  setcurrentdir(edit1.Text);
  assignfile(f, hilf + s);
  try
    rewrite(f);
  except
  end;
  writeln(f, '; Generated by WIN-SFV32 v1.0');
  writeln(f, format('; (Compatible: WINHASH version %s (c) by Dirk Paehl)', [version]));

  if creator.Text <> '' then
    writeln(f, '; creator: ' + creator.Text);
  if comment.Text <> '' then
    writeln(f, '; comment: ' + comment.Text);
  writeln(f, '; http://www.paehl.de');
  plist := TStringList.Create;
  if checkbox1.Checked then
    GetFiles(hilf, '*.*', plist, True)
  else
    GetFiles(hilf, '*.*', plist, False);
  for i := 0 to plist.Count - 1 do    // Iterate
  begin
    test1 := extractfileExt(plist.strings[i]);
    if strupper(PChar(test1)) <> '.SFV' then
    begin
      test1 := extractfileExt(plist.strings[i]);
      test2 := plist.strings[i];
      Delete(test2, 1, length(Edit1.Text));
      try
        Stream := TMemoryStream.Create;
        Stream.LoadFromFile(test2);
        CRC := AsmGetMemoryStreamCrc32(Stream);
        Stream.Free;
      except
        try
          crc := ASMGetFileCrc32(test2);
        except
          CRC := 0;
        end;
      end;

      ListBox1.Items.add(test2 + ' ' + strlower(PChar(inttohex(crc, 8))));
      writeln(f, test2 + ' ' + inttohex(crc, 8));
    end;
  end;    // for
  CrcTime := GetTickCount - CrcTime;
  closefile(f);
  label2.Caption := (format('TIME: %d millisecs', [crcTime]));
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  label2.Caption := 'Please wait';
  case comboBox1.ItemIndex of
    0: MD5_erstellen;
    1: SHA1_erstellen;
    2: CRC32_erstellen;
  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ShowMessage('WinHash is (c) by Dirk Paehl'#13#10 + 'http://www.paehl.de');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    form2.ShowModal;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
 if verify then
  begin
   form2.Edit1.Text:=hashdatei;
   hashdatei:='';
   form2.ShowModal;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: byte;
begin
  verify := False;
  Form1.Caption := 'WinHash (c) ' + version + ' by Dirk Paehl';
  if paramcount > 0 then
  begin
    for i := 1 to paramcount do
    begin
      if fileExists(ParamStr(i)) then begin verify := True; hashdatei:=ParamStr(i); break; end;
      if uppercase(PChar(ParamStr(i))) = '/V' then verify := True;
      if DirectoryExists (ParamStr(i)) then Edit1.Text := Check(ParamStr(i));
    end;
  end;
end;

initialization
  {$I unit1.lrs}

end.

