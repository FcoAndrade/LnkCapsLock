program LnkCapsLock;
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

uses
  Vcl.Forms,
  JclAppInst,
  ufrmEstado in 'ufrmEstado.pas' {frmEstado},
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  JclAppInstances.CheckSingleInstance; // Added instance checking
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
