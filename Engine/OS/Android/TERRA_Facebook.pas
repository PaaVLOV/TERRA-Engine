Unit TERRA_Facebook;

{$I terra.inc}

Interface
Uses TERRA_Utils, TERRA_Java, JNI;

Const
  FacebookClassPath = 'com.pascal.terra.TERRAFacebook';

Type
  Facebook = Class(TERRAObject)
    Protected
      _Facebook:JavaObject;

    Public
      Constructor Create();
      Destructor Destroy; Override;

      Procedure Post(msg, link, desc, imageURL:AnsiString);
      Procedure LikePage(page, url:AnsiString);
  End;

Implementation
Uses TERRA_Error, TERRA_Application, TERRA_OS, TERRA_Log;

{ Facebook }
Constructor Facebook.Create();
Var
  Params:JavaArguments;
  Frame:JavaFrame;
Begin
  Java_Begin(Frame);
  Params := JavaArguments.Create(Frame);
  Params.AddString(Application.Instance.Client.GetFacebookID());
  _Facebook := JavaObject.Create(FacebookClassPath, Params, Frame);
  Params.Destroy();
  Java_End(Frame);
End;

Destructor Facebook.Destroy;
Var
  Frame:JavaFrame;
Begin
  Log(logDebug, 'App', 'Deleting facebook object');

  Java_Begin(Frame);
  _Facebook.Destroy();
  Java_End(Frame);
End;

Procedure Facebook.LikePage(page, url:AnsiString);
Var
  Params:JavaArguments;
  Frame:JavaFrame;
Begin
  Page := '"id":"'+Page+'"';

  Java_Begin(Frame);
  Params := JavaArguments.Create(Frame);
  Params.AddString(Page);
  Params.AddString(URL);
  _Facebook.CallVoidMethod('likePage', Params);
  Params.Destroy();
  Java_End(Frame);
End;

Procedure Facebook.Post(msg, link, desc, imageURL:AnsiString);
Var
  Params:JavaArguments;
  Frame:JavaFrame;
Begin
  Log(logDebug, 'App', 'Posting to facebook: '+Msg);

  Java_Begin(Frame);
  Params := JavaArguments.Create(Frame);
  Params.AddString(Msg);
  Params.AddString(Link);
  Params.AddString(Desc);
  Params.AddString(ImageURL);
  _Facebook.CallVoidMethod('post', Params);
  Params.Destroy();
  Java_End(Frame);
End;

End.


