{$I terra.inc}
{$IFDEF MOBILE}Library{$ELSE}Program{$ENDIF} BasicSample;

Uses TERRA_Application, TERRA_Scene, TERRA_Client, TERRA_GraphicsManager, TERRA_Viewport,
  TERRA_ResourceManager, TERRA_Color, TERRA_Texture, TERRA_OS, TERRA_PNG,
  TERRA_SpriteManager, TERRA_FileManager, TERRA_Math, TERRA_Vector3D, TERRA_Vector2D;
    
Type
  // A client is used to process application events
  MyGame = Class(AppClient)
    Protected
      _Scene:Scene;

			Procedure OnCreate; Override;
			Procedure OnIdle; Override;
  End;

  // A scene is used to render objects
  MyScene = Class(Scene)
      Procedure RenderSprites(V:Viewport); Override;
  End;

Var
  Tex:Texture = Nil;

{ Game }
Procedure MyGame.OnCreate;
Begin
  // Added Asset folder to search path
  FileManager.Instance.AddPath('assets');

  // Load a Tex
  Tex := TextureManager.Instance.GetTexture('ghost');

  // Create a scene and set it as the current scene
  _Scene := MyScene.Create;
  GraphicsManager.Instance.SetScene(_Scene);

  GraphicsManager.Instance.BackgroundColor := ColorBlue;
End;

// OnIdle is called once per frame, put your game logic here
Procedure MyGame.OnIdle;
Begin
  If Keys[keyEscape] Then
    Application.Instance.Terminate;
End;

{ MyScene }
Procedure MyScene.RenderSprites;
Var
  I:Integer;
  Angle:Single;
  S:Sprite;
Begin
  If Tex = Nil Then
    Exit;

  // This is how sprite rendering works with TERRA.
  // 1st we ask the Renderer to create a new sprite, using a Tex and position.
  // Note that this sprite instance is only valid during the frame its created.
  // If needed we can configure the sprite properties.

  // Note - The third argument of VectorCreate is the sprite Layer, should be a value between 0 and 100
  //        Sprites with higher layer values appear below the others

  // Create a simple fliped sprite
  S := SpriteManager.Instance.AddSprite(220, 60, 50, Tex);
  S.Flip := True;

  // Create a line of sprites
  For I:=0 To 8 Do
  Begin
    S := SpriteManager.Instance.AddSprite(16 + Tex.Width * I, 10, 50, Tex);
    S.Mirror := Odd(I);    // Each odd sprite in line will be reflected
  End;

  // Create a line of rotated sprites
  For I:=0 To 8 Do
  Begin
    S := SpriteManager.Instance.AddSprite(16 + Tex.Width * I, 300, 50, Tex);
    S.SetScaleAndRotationRelative(VectorCreate2D(0.5, 0.5), 1, RAD * (I*360 Div 8));
  End;

  // Some scaled sprites
  S := SpriteManager.Instance.AddSprite(10,120,55, Tex);
  S.SetScale(2.0);    // Double size

  S := SpriteManager.Instance.AddSprite(110,130,55, Tex);
  S.SetScale(1.5);    // 1.5 Size

  S := SpriteManager.Instance.AddSprite(180,145,55, Tex);
  S.SetScale(0.5);    // Half size

  // An alpha blended sprite
  S := SpriteManager.Instance.AddSprite(85, 60, 55, Tex);
  S.SetColor(ColorCreate(255, 255, 255, 128));

  // Some colored sprites
  For I:=0 To 4 Do
  Begin
    S := SpriteManager.Instance.AddSprite(300 + Tex.Width * I,120,50, Tex);

    Case I Of
    0:  S.SetColor(ColorCreate(255,128,255)); // Purple tint
    1:  S.SetColor(ColorCreate(255,128,128)); // Red tint
    2:  S.SetColor(ColorCreate(128,255,128)); // Green tint
    3:  S.SetColor(ColorCreate(128,128,255)); // Blue tint
    4:  S.SetColor(ColorCreate(255,255,128)); // Yellow tint
    End;
  End;

  // A rotating sprite in the bottom, with Scale = 2x
  Angle := RAD * ((GetTime() Div 15) Mod 360);
  S := SpriteManager.Instance.AddSprite(300, 400, 50, Tex);
  S.SetScaleAndRotationRelative(VectorCreate2D(0.5, 0.5), 2.0, Angle);  // Calculate rotation, in degrees, from current time
End;

Begin
  // Start the application
  ApplicationStart(MyGame.Create);
End.
