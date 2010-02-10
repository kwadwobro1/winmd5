program winmd5;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  Unit1,
  Unit2,
  LResources { you can add units after this };

{$IFDEF WINDOWS}{$R winmd5.rc}{$ENDIF}


begin
  {$I winmd5.lrs}
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
