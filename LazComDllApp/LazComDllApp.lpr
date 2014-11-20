program LazComDllApp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, ComObjUnit, LazComLib_1_0_TLB
  { you can add units after this };

type

  { TLazComDll }

  TLazComDll = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TLazComDll }

procedure TLazComDll.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h','help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  UseComObj();

  // stop program loop
  Terminate;
end;

constructor TLazComDll.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TLazComDll.Destroy;
begin
  inherited Destroy;
end;

procedure TLazComDll.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ',ExeName,' -h');
end;

var
  Application: TLazComDll;
begin
  Application:=TLazComDll.Create(nil);
  Application.Title:='Lazarus Com Dll App';
  Application.Run;
  Application.Free;
end.

