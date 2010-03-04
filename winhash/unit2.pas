unit Unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Windows;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    creator: TLabel;
    comment: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    procedure md5;
    procedure sha1;
    procedure crc32;
    function teste(was:string):byte;
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

uses md5, sha1, crc32;

{ TForm2 }

procedure TForm2.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit1.Text := Opendialog1.FileName;
end;

function LogEntry(Dig: TMD5Digest): string;
begin
  Result := lowercase(Format('%s', [MD5Print(Dig)]));
end;


procedure TForm2.md5;
var
  f: textfile;
  hilfs_text, hilfs_text1: string;
  datei_name, test1, s, tempe, crc, temp: string;
  i, fehler, anzahl, crctime, lang: integer;
  TMD5: TMD5Digest;
begin
  fehler := 0;
  anzahl := 0;
  ListBox1.Clear;
  CrcTime := GetTickCount;
  assignfile(f, Edit1.Text);
  reset(f);
  setcurrentdir(extractfilepath(edit1.Text));
  while not EOF(f) do
  begin
    readln(f, hilfs_text);
    if pos('CREATOR:', uppercase(hilfs_text)) > 0 then
    begin
      hilfs_text1 := StringReplace(hilfs_text, 'CREATOR:', '',
        [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := StringReplace(hilfs_text1, ';', '', [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := trim(hilfs_text1);
      creator.Caption := 'Creator: ' + hilfs_text;
    end;
    if pos('COMMENT:', uppercase(hilfs_text)) > 0 then
    begin
      hilfs_text1 := StringReplace(hilfs_text, 'COMMENT:', '',
        [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := StringReplace(hilfs_text1, ';', '', [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := trim(hilfs_text1);
      comment.Caption := 'COMMENT: ' + hilfs_text1;
    end;

    if (hilfs_text[1] <> ';') then
    begin
      lang := length(hilfs_text);
      CRC := copy(hilfs_text, 1, 32);
      case hilfs_text[34] of
        '*': i := 35;
        ' ': i := 35;
        else
          i := 34;
      end;    // case

      Datei_name := copy(hilfs_text, i, lang);
      test1 := datei_name;
      if UpperCase(test1) <> UpperCase(extractfilename(Edit1.Text)) then
      begin
        s := '';
        TMD5 := MD5File(Datei_name);
        s := LogEntry(TMD5);//lowercase(s);
      end;

      temp := '';
      if strcomp(Strupper(PChar(s)), Strupper(PChar(crc))) = 0 then
        temp := format('MD5 OK --> %s.', [datei_name])
      else
      begin
        temp := format('MD5 ERROR ---> : %s . File was modified or delete.',
          [datei_name]);
        Inc(fehler);
      end;
      Inc(anzahl);
      ListBox1.Items.add(temp);
    end; //MD5
  end;


  ListBox1.Items.add(' ');
  ListBox1.Items.add(format('Files checked: %d', [anzahl]));
  ListBox1.Items.add(format('Files modified: %d ', [fehler]));
  ListBox1.Items.add(format('Files CRC OK: %d', [anzahl - fehler]));

  CrcTime := GetTickCount - CrcTime;
  if fehler > 0 then
    test1 := 'MD5 HASH ERROR detect'
  else
    test1 := 'ALL OK';
  label3.Caption := (format('TIME: %d millisecs. %s', [crcTime, test1]));

  closefile(f);
end;

procedure TForm2.sha1;
var  f: textfile;
  hilfs_text, hilfs_text1: string;
  datei_name, test1, s, tempe, crc, temp: string;
  i, fehler, anzahl, crctime, lang: integer;
  TSHA1: TSHA1Digest;
begin
  fehler := 0;
  anzahl := 0;
  ListBox1.Clear;
  CrcTime := GetTickCount;
  assignfile(f, Edit1.Text);
  reset(f);
  setcurrentdir(extractfilepath(edit1.Text));
  while not EOF(f) do
  begin
    readln(f, hilfs_text);
    if pos('CREATOR:', uppercase(hilfs_text)) > 0 then
    begin
      hilfs_text1 := StringReplace(hilfs_text, 'CREATOR:', '',
        [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := StringReplace(hilfs_text1, ';', '', [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := trim(hilfs_text1);
      creator.Caption := 'Creator: ' + hilfs_text;
    end;
    if pos('COMMENT:', uppercase(hilfs_text)) > 0 then
    begin
      hilfs_text1 := StringReplace(hilfs_text, 'COMMENT:', '',
        [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := StringReplace(hilfs_text1, ';', '', [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := trim(hilfs_text1);
      comment.Caption := 'COMMENT: ' + hilfs_text1;
    end;

      if (hilfs_text[1] <> ';') then
      begin
        lang := length(hilfs_text);
        CRC := copy(hilfs_text, 1, 40);
        case hilfs_text[42] of
          '*': i := 43;
          ' ': i := 43;
          else
            i := 42;
        end;    // case

        Datei_name := copy(hilfs_text, i, lang);
        test1 := datei_name;
        if UpperCase(test1) <> UpperCase(extractfilename(Edit1.Text)) then
        begin
          s := '';
           TSHA1 := SHA1File(Datei_name);
           s := SHA1Print(TSHA1);
        end;

        temp := '';
        if strcomp(Strupper(PChar(s)), Strupper(PChar(crc))) = 0 then
          temp := format('SHA1 OK --> %s.', [datei_name])
        else
        begin
          temp := format('SHA1 ERROR ---> : %s . File was modified or delete.',
            [datei_name]);
          Inc(fehler);
        end;
        Inc(anzahl);
        ListBox1.Items.add(temp);
      end; //SHA1
    end;


  ListBox1.Items.add(' ');
  ListBox1.Items.add(format('Files checked: %d', [anzahl]));
  ListBox1.Items.add(format('Files modified: %d ', [fehler]));
  ListBox1.Items.add(format('Files CRC OK: %d', [anzahl - fehler]));

  CrcTime := GetTickCount - CrcTime;
  if fehler > 0 then
    test1 := 'SHA1 HASH ERROR detect'
  else
    test1 := 'ALL OK';
  label3.Caption := (format('TIME: %d millisecs. %s', [crcTime, test1]));

  closefile(f);
end;

procedure TForm2.crc32;
var
  f: textfile;
  hilfs_text, hilfs_text1, Datei_Name, tempe, test1, CRC1, CRC2: string;
  lang, CRC, killed, fehler, anzahl, crctime: integer;
  Stream: TMemoryStream;
  File_delete, filecrc_error, file_crc_ok, temp: string;
begin
  File_delete := 'File was delete';
  filecrc_error := 'CRC ERROR: "%s". %s';
  file_crc_ok := 'OK: "%s".';
  killed := 0;
  fehler := 0;
  anzahl := 0;
  ListBox1.Clear;
  CrcTime := GetTickCount;
  assignfile(f, Edit1.Text);
  reset(f);
  setcurrentdir(extractfilepath(edit1.Text));
  while not EOF(f) do
  begin
    readln(f, hilfs_text);
    if pos('CREATOR:', uppercase(hilfs_text)) > 0 then
    begin
      hilfs_text1 := StringReplace(hilfs_text, 'CREATOR:', '',
        [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := StringReplace(hilfs_text1, ';', '', [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := trim(hilfs_text1);
      creator.Caption := 'Creator: ' + hilfs_text1;
    end;
    if pos('COMMENT:', uppercase(hilfs_text)) > 0 then
    begin
      hilfs_text1 := StringReplace(hilfs_text, 'COMMENT:', '',
        [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := StringReplace(hilfs_text1, ';', '', [rfReplaceAll, rfIgnoreCase]);
      hilfs_text1 := trim(hilfs_text1);
      comment.Caption := 'COMMENT: ' + hilfs_text1;
    end;
    //CRC32 Hash aus SFV einlesen
    if hilfs_text[1] <> ';' then
    begin
      lang := length(hilfs_text);
      CRC1 := copy(hilfs_text, lang - 7, lang);
      Datei_name := copy(hilfs_text, 1, lang - 9);
      tempe := '';
      test1 := datei_name;
      temp := ExtractFilename(Edit1.Text);
      if strupper(PChar(test1)) <> strupper(PChar(temp)) then
      begin
        if not FileExists(Datei_name) then
        begin
          tempe := '---> ' + file_delete;//'File was delete';
          Inc(killed);
          crc := 0;
        end
        else
          CRC := GetFileCrc32(Datei_name);
        if (crc = 0) and (fileExists(Datei_name)) then
        begin
          Stream := TMemoryStream.Create;
          Stream.LoadFromFile(datei_name);
          CRC := AsmGetMemoryStreamCrc32(Stream);
          Stream.Free;
        end;
      end;
      CRC2 := inttohex(crc, 8);
      CRC2 := StrLower(PChar(CRC2));
      CRC1 := StrLower(PChar(CRC1));
      if crc2 = crc1 then
        ListBox1.Items.add(format(file_crc_ok, [datei_name]))
      else
      begin
        ListBox1.Items.add(format(filecrc_error, [datei_name, tempe]));
        Inc(fehler);
      end;
      Inc(anzahl);
    end;
  end; //crc32
  closefile(f);
  ListBox1.Items.add(format('Files checked: %d', [anzahl]));
  ListBox1.Items.add(format('Files modified: %d ', [fehler]));
  CrcTime := GetTickCount - CrcTime;
  if fehler > 0 then
    test1 := 'CRC ERROR detect'
  else
    test1 := 'ALL OK';
  label3.Caption := (format('TIME: %d millisecs. %s', [crcTime, test1]));
end;

function TForm2.teste(was:string):byte;
var i,j:byte;
begin
j:=0;
result:=0;  //unbekannt oder crc32
for I := 1 to 40 do    // Iterate
   if ((was[i] = ' ') or (was[i]='.') or (was[i]=':'))then j:=0 else inc(j);
if j= 40 then
 begin
   result:=1;
    label3.caption:='Autodetect: SHA1 found';
    application.ProcessMessages;
   exit;
 end;
j:=0;
for I := 1 to 32 do    // Iterate
   if ((was[i] = ' ') or (was[i]='') or (was[i]='.') or (was[i]=':'))then j:=0
   else inc(j);
if j=32 then
  begin
   result :=2;  //md5
   label3.caption:='Autodetect: MD5 found';
   application.ProcessMessages;
   exit;
   end;
end;


procedure TForm2.Button2Click(Sender: TObject);
var f:textfile;
    hilf:string;
    ergebnis:byte;
begin
 label3.caption:='Please wait';
 application.ProcessMessages;
  if Edit1.Text = '' then
    exit;
  case ComboBox1.ItemIndex of
    0:
    begin
     assignfile(f,Edit1.text);
     reset(f);
     while not EOF(f) do
     begin
      readln(f,hilf);
      ergebnis:=5;
      if hilf[1]<>';' then
        begin
        closefile(f);
        ergebnis:=teste(hilf);
        case ergebnis of
          0 : crc32;
          1 : sha1;
          2 : md5;
         end;
        break;
       end;
    end;
     if ergebnis = 5 then closefile(f);
    end;
    1: md5;
    2: sha1;
    3: crc32;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  close;
  application.Terminate;;
end;

initialization
  {$I unit2.lrs}

end.
