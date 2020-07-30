unit ufrmPrincipal;

{
  Copyright 2020 Francisco Javier Andrade Guillade (https://www.luniksoft.info)

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,
  JvComponentBase, JvTrayIcon, ufrmEstado, JvAppInst, Vcl.Imaging.pngimage;

type
  TfrmPrincipal = class(TForm)
    ActionList1: TActionList;
    actSalir: TAction;
    actMinimizar: TAction;
    trayiconCaps: TJvTrayIcon;
    ImageList1: TImageList;
    trayiconNum: TJvTrayIcon;
    Panel1: TPanel;
    btnMinimizar: TBitBtn;
    btnSalir: TBitBtn;
    Panel2: TPanel;
    imgLogo: TImage;
    LinkLabel1: TLinkLabel;
    LinkLabel2: TLinkLabel;
    Label1: TLabel;
    lblVersion: TLabel;
    Label2: TLabel;
    procedure actSalirExecute(Sender: TObject);
    procedure actMinimizarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure trayiconCapsDblClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
    FHook: hHook;
    KeyState: TKeyboardState;
  public
    { Public declarations }
    procedure UpdateScreen(var message: TMessage); message WM_UpdateScreen;

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses StrUtils, ShellAPI, JclFileUtils;

type
  pKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;

  KBDLLHOOKSTRUCT = packed record
    vkCode: DWORD;
    scanCodem: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: ULONG_PTR;
  end;

var
  hkHook: hHook;


{*******************************************************************************

*******************************************************************************}
procedure TfrmPrincipal.actMinimizarExecute(Sender: TObject);
begin
  Hide;
end;

{*******************************************************************************

*******************************************************************************}
function LowLevelKeyboardProc(code: Integer; WParam: WParam; LParam: LParam): LRESULT stdcall;
const
  LLKHF_UP = $0080;
var
  Hook: pKBDLLHOOKSTRUCT;
  bControlKeyDown: Boolean;
begin
  try
    Hook := pKBDLLHOOKSTRUCT(LParam);
    case code of
      HC_ACTION:
        begin
          if (Hook^.flags and LLKHF_UP) <> 0 then
            if Hook.vkCode in [VK_NUMLOCK, VK_CAPITAL] then
              PostMessage(frmPrincipal.Handle, WM_UpdateScreen, Hook.vkCode, 0);
        end;
    end;
  finally
    Result := CallNextHookEx(hkHook, code, WParam, LParam);
  end;
end;


{*******************************************************************************

*******************************************************************************}
procedure HookIt;
begin
  hkHook := SetWindowsHookEx(WH_KEYBOARD_LL, @LowLevelKeyboardProc, hInstance, 0);
end;

{*******************************************************************************

*******************************************************************************}
procedure UnHookIt;
begin
  UnHookWindowsHookEx(hkHook);
end;

{*******************************************************************************

*******************************************************************************}
procedure TfrmPrincipal.actSalirExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnHookIt;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  Info: TJclFileVersionInfo;
begin
  Info := TJclFileVersionInfo.Create(ParamStr(0));
  lblVersion.Caption := Info.FileVersion;

  frmEstado := TfrmEstado.Create(self);

  // Refrescamos iconos
  GetKeyboardState(KeyState);
  trayiconCaps.IconIndex := KeyState[VK_CAPITAL];
  trayiconNum.IconIndex := 2 + KeyState[VK_NUMLOCK];

  HookIt;
end;


{*******************************************************************************

*******************************************************************************}
procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  if assigned(frmEstado) then
    frmEstado.Free;
end;

procedure TfrmPrincipal.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(HInstance, 'open', PChar(Link), nil, nil, SW_NORMAL);
end;

{*******************************************************************************

*******************************************************************************}
procedure TfrmPrincipal.trayiconCapsDblClick(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Visible := True;
end;

{*******************************************************************************

*******************************************************************************}
procedure TfrmPrincipal.UpdateScreen(var message: TMessage);
begin
  if message.LParam = 0 then
    if KeyState[message.WParam] = 0 then
      KeyState[message.WParam] := 1
    else
      KeyState[message.WParam] := 0;

  if message.WParam = VK_CAPITAL then
  begin
    frmEstado.lblEstado.Caption := 'Caps Lock ' + IfThen(KeyState[VK_CAPITAL] = 0, 'Off', 'On');
    frmEstado.imgImagen.ImageIndex := KeyState[VK_CAPITAL];
    trayiconCaps.IconIndex := frmEstado.imgImagen.ImageIndex;
    frmEstado.MuestraFormEstado;
  end
  else
  if message.WParam = VK_NUMLOCK then
  begin
    frmEstado.lblEstado.Caption := 'Num Lock ' + IfThen(KeyState[VK_NUMLOCK] = 0, 'Off', 'On');
    frmEstado.imgImagen.ImageIndex := 2 + KeyState[VK_NUMLOCK];
    trayiconNum.IconIndex := frmEstado.imgImagen.ImageIndex;
    frmEstado.MuestraFormEstado;
  end;

end;


end.
