unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Menus, XPMan,ShellAPI, MPlayer,
  jpeg, WinSkinData, RzTray;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    N4: TMenuItem;
    N3: TMenuItem;
    N7: TMenuItem;
    N9: TMenuItem;
    N11: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    XPManifest1: TXPManifest;
    Timer2: TTimer;
    Timer3: TTimer;
    SkinData1: TSkinData;
    RzTrayIcon1: TRzTrayIcon;
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private declarations }
     procedure WMnCHitTest(var M:tWMnCHitTest);message WM_nCHittest;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  s1,s2,s3,s4,s5,s6,q,r,s:integer;
  s7,s8,s17:string;
  p:pchar;
  s9,s10,s11,s12,s13,s14,s15,s16:integer;
  x,f,m,hm:word;
  xianzai:tdatetime;

implementation

uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit7;

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  label1.Caption:=datetimetostr(now);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  dir:string;
begin
  ShowWindow(Application.Handle, SW_HIDE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
  GetWindowLong(Application.Handle, GWL_EXSTYLE)
  or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
  dir:=extractfiledir(application.ExeName);
  mediaplayer1.FileName:=dir+'\call.wav';
  mediaplayer2.FileName:=dir+'\wake.wav';
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  if messagebox(0,'确定要退出吗？','退出',MB_YESNO or MB_iconquestion)=idyes
then
  close;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  form2.ShowModal;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  form3.ShowModal;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  if s3=1 then
    begin
    s3:=2;
    messagebox(0,'闹钟定时已关闭！','注意',mb_ok or mb_iconasterisk);
    end;
  if s10=1 then
    begin
    s10:=2;
    messagebox(0,'闹钟定时已关闭！','注意',mb_ok or mb_iconasterisk);
    end;  
  if q=1 then
  begin
    mediaplayer1.Stop;
  end;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  if messagebox(0,'确定退出吗？','退出',mb_yesno or mb_iconquestion)=idyes then
  close;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  form4.ShowModal;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  if s4=1 then
    begin
      s4:=2;
      messagebox(0,'定时关机功能已关闭！','注意',mb_ok or mb_iconasterisk);
    end;
  if s12=1 then
    begin
      s12:=2;
      messagebox(0,'定时关机功能已关闭！','注意',mb_ok or mb_iconasterisk);
    end;
end;


procedure TForm1.N8Click(Sender: TObject);
begin
  form5.ShowModal;
end;


procedure TForm1.N9Click(Sender: TObject);
begin
  if s6=1 then
    begin
      s6:=2;
      messagebox(0,'定时提醒功能已关闭！','注意',mb_ok or mb_iconasterisk);
    end;
  if s14=1 then
    begin
      s14:=2;
      messagebox(0,'定时提醒功能已关闭！','注意',mb_ok or mb_iconasterisk);
      end;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  form7.ShowModal;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  if s3=1 then
    begin
      s1:=s1-1;
      if s1<=0 then
        begin
          s3:=2;
          mediaplayer1.Open;
          mediaplayer1.Play;
          q:=1;
        end;
     end;
  if s4=1 then
    begin
      s2:=s2-1;
      if s2<=0 then
        begin
          s4:=2;
          if FileExists(ExtractFilePath(Application.Exename)+'down.bat') then
            begin
              p:=pchar(ExtractFilePath(Application.Exename)+'down.bat');
              ShellExecute(0, nil, p, nil, nil, SW_NORMAL);
            end;
         end;
     end;
  if s6=1 then
    begin
      s5:=s5-1;
      if s5<=0 then
        begin
          s6:=2;
          mediaplayer2.Open;
          mediaplayer2.Play;
          form6.ShowModal;
        end;
    end;
  if s=1 then
    begin
      r:=r-1;
      if r<=0 then
        begin
          s:=2;
          WinExec(pchar(s8),SW_normal);
        end;
    end;
end;


procedure TForm1.N11Click(Sender: TObject);
begin
  if s=1 then
    begin
      s:=2;
      messagebox(0,'定时打开功能已关闭！','注意',mb_ok or mb_iconasterisk);
    end;
  if s16=1 then
    begin
      s16:=2;
      messagebox(0,'定时打开功能已关闭！','注意',mb_ok or mb_iconasterisk);
    end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  if s10=1 then
    begin
      xianzai:=now;
      decodetime(xianzai,x,f,m,hm);
      if s9=strtoint(inttostr(x)+inttostr(f)+inttostr(m)) then
      begin
        s10:=2;
        mediaplayer1.Open;
        mediaplayer1.Play;
        q:=1;
      end;
    end;
  if s12=1 then
    begin
      xianzai:=now;
      decodetime(xianzai,x,f,m,hm);
      if s11=strtoint(inttostr(x)+inttostr(f)+inttostr(m)) then
      begin
        s12:=2;
        if FileExists(ExtractFilePath(Application.Exename)+'down.bat') then
        begin
          p:=pchar(ExtractFilePath(Application.Exename)+'down.bat');
          ShellExecute(0, nil, p, nil, nil, SW_NORMAL);
        end;
      end;
    end;
  if s14=1 then
    begin
      xianzai:=now;
      decodetime(xianzai,x,f,m,hm);
      if s13=strtoint(inttostr(x)+inttostr(f)+inttostr(m)) then
      begin
        s14:=2;
        mediaplayer2.Open;
        mediaplayer2.Play;
        form6.ShowModal;
      end;
    end;
  if s16=1 then
    begin
      xianzai:=now;
      decodetime(xianzai,x,f,m,hm);
      if s15=strtoint(inttostr(x)+inttostr(f)+inttostr(m)) then
      begin
        s16:=2;
        WinExec(pchar(s17),SW_normal);
      end;
   end;     
end;

procedure TForm1.WMnCHitTest(var M: tWMnCHitTest);
begin
if M.Result=HTCLient then M.result:=htCaption;
   inherited;

end;

end.
