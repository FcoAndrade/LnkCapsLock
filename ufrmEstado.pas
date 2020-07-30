unit ufrmEstado;

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
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, Vcl.StdCtrls, SVGIconImageList, SVGIconImage, JvComponentBase,
  JvFormTransparent;

const
  WM_UpdateScreen = WM_USER + 1;

type
  TfrmEstado = class(TForm)
    imgImagen: TSVGIconImage;
    ilCapLockAct: TSVGIconImageList;
    FadeTimer: TTimer;
    Shape1: TShape;
    lblEstado: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FadeTimerTimer(Sender: TObject);
  private
    { Private declarations }
    FAlphaIncrement : Integer;
  protected
  public
    { Public declarations }
    procedure MuestraFormEstado;
  end;

var
  frmEstado: TfrmEstado;

implementation

{$R *.dfm}

const
  FADE_SPEED = 15;


{*******************************************************************************

*******************************************************************************}
procedure TfrmEstado.FormCreate(Sender: TObject);
begin
  Visible := False;
end;

{*******************************************************************************

*******************************************************************************}
procedure TfrmEstado.FormShow(Sender: TObject);
begin
  // Abajo Centrado
  Top  := Screen.Height - Height - Trunc(Screen.Height * 0.1);
//  Top  := Trunc(Screen.Height * 0.1);
  Left := (Screen.Width - Width) DIV 2;


  FAlphaIncrement := FADE_SPEED;
end;


{*******************************************************************************

*******************************************************************************}
procedure TfrmEstado.MuestraFormEstado;
begin
  if Visible then
    AlphaBlendValue := 125
  else
    AlphaBlendValue := 0;

  FAlphaIncrement := FADE_SPEED;
  FadeTimer.Enabled := False;
  FadeTimer.Enabled := True;

  ShowWindow(Handle, SW_SHOWNOACTIVATE);
  Visible := True;

end;


{*******************************************************************************

*******************************************************************************}
procedure TfrmEstado.FadeTimerTimer(Sender: TObject);
var
  NewAlpha : integer;
begin
  NewAlpha := AlphaBlendValue + FAlphaIncrement;
  if NewAlpha > 255 then
  begin
    NewAlpha := 255;
    FAlphaIncrement := - FADE_SPEED;
  end
  else
  if NewAlpha < 0 then
  begin
    NewAlpha := 0;
    FadeTimer.Enabled := False;
    Close;
  end;
  AlphaBlendValue := NewAlpha;
end;






end.
