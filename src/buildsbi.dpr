program buildsbi;

uses
  SysUtils,
  Forms,
  main in 'main.pas' {Main_Form},
  utils in 'utils.pas',
  about in 'about.pas' {AboutBox},
  lang in 'lang.pas' {Lang_Form},
  SHFileOp in 'shfileop.pas',
  logwin in 'logwin.pas' {Log_Form},
  splash in 'splash.pas' {SplashScreen_Form},
  pngutils in 'pngutils.pas',
  U_Interpolation_BiLineaire in 'U_Interpolation_BiLineaire.pas',
  ImageType in 'ImageType.pas',
  imgconv in 'imgconv.pas',
  zipcomm in 'zipcomm.pas' {ZipComment_Form},
  u_zipcom in 'u_zipcom.pas',
  app_comm in 'app_comm.pas',
  ask in 'ask.pas' {Ask_Form},
  u_ask in 'u_ask.pas',
  about_main_form in 'about\about_main_form.pas' {frmAboutDemo},
  about_utils in 'about\about_utils.pas',
  bitmap_font in 'about\bitmap_font.pas',
  delimiters in 'about\delimiters.pas',
  globe in 'about\globe.pas',
  MiniFMOD in 'about\MiniFMOD.pas',
  text_objects_3d in 'about\text_objects_3d.pas',
  config in 'config.pas' {frmConfig};

{$R *.res}
var
  SplashForm : TSplashScreen_Form;

begin
  Application.Initialize;
  Application.Title := 'SBI Builder Wizard - Loading...';

  Application.CreateForm(TMain_Form, Main_Form);
  // Form principale
  Application.CreateForm(TZipComment_Form, ZipComment_Form);
  Application.CreateForm(TAsk_Form, Ask_Form);
  Application.CreateForm(TLang_Form, Lang_Form);
  Application.CreateForm(TLog_Form, Log_Form);

  if IsSplashScreenEnabled() then
  begin
    //Affichage du splash
    SplashForm := TSplashScreen_Form.Create(Application);
    SSHandle := SplashForm.Handle;
    Application.ProcessMessages;
    try
      SplashForm.Show;
      SplashForm.DoFade(400);
      //SplashForm.Show; // affichage de la fiche
      //SplashForm.Update; // force la fiche à se dessiner complètement
      //Delay(1800);
      //SplashForm.Close;
    finally
      SplashForm.Free;// libération de la mémoire
    end;
  end;

  Application.Run;
end.
