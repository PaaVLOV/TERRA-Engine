{***********************************************************************************************************************
 *
 * TERRA Game Engine
 * ==========================================
 *
 * Copyright (C) 2003, 2014 by S�rgio Flores (relfos@gmail.com)
 *
 ***********************************************************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 **********************************************************************************************************************
 * TERRA_Widgets
 * Implements all common engine widgets (buttons, windows, images, etc)
 ***********************************************************************************************************************
}
Unit TERRA_Widgets;
{$I terra.inc}

{$IFNDEF MOBILE}
{$DEFINE HASMOUSEOVER}
{$ENDIF}

{$IFDEF WINDOWS}{$UNDEF MOBILE}{$ENDIF}

Interface
Uses TERRA_Utils, TERRA_UI, TERRA_Tween, TERRA_Vector2D, TERRA_Math, TERRA_Color,
  TERRA_FileManager, TERRA_SpriteManager, TERRA_Texture, TERRA_Font, TERRA_Collections;

Const
  layoutHorizontal = 0;
  layoutVertical   = 1;

  ExtendedPressDuration = 2000;

  System_Name_Wnd = '@UI_Window';
  System_Name_Text = '@UI_Text';
  System_Name_Btn = '@UI_BTN';
  System_Name_BG = '@UI_BG';

Type

  UICaption = Class(Widget)
    Protected
      _Caption:AnsiString;
      _TextRect:Vector2D;
      _PreviousFont:Font;
      _OriginalValue:AnsiString;

    Public
      DropShadow:Boolean;

      Procedure SetCaption(Value:AnsiString);

      Procedure UpdateRects; Override;

      Function GetSize:Vector2D; Override;

			Procedure OnLanguageChange(); Override;

      Property Caption:AnsiString Read _Caption Write SetCaption;
  End;

  UITabEntry = Record
    Visible:Boolean;
    Name:AnsiString;
    Index:Integer;
  End;

  UITabList = Class(Widget)
    Protected
      _Tabs:Array Of UITabEntry;
      _TabCount:Integer;
      _TabHighlight:Integer;

      _TabWidthOn:Integer;
      _TabWidthOff:Integer;
      _TabHeightOn:Integer;
      _TabHeightOff:Integer;

      _SelectedIndex:Integer;

      Function GetTabAt(X,Y:Integer):Integer;
      Function GetSelectedCaption: AnsiString;

      Procedure GetTabProperties(Const Selected:Boolean; Out TabColor:Color; Out TabFont:TERRA_Font.Font); Virtual;

    Public
      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; ComponentBG:AnsiString=''); Overload;

      Procedure Render; Override;
      Procedure UpdateRects; Override;

      Procedure AddTab(Name:AnsiString; Index:Integer);
      Procedure SetTabVisibility(Index:Integer; Visibility:Boolean);
      Procedure ClearTabs();

      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
      Function OnMouseMove(X,Y:Integer):Boolean; Override;

      Property SelectedIndex:Integer Read _SelectedIndex Write _SelectedIndex;
      Property SelectedCaption:AnsiString Read GetSelectedCaption;
  End;

  UIWindow = Class(Widget)
    Protected
      _Width: Integer;
      _Height: Integer;

      _WndLayout:UISkinLayout;

      _Caption:AnsiString;

      _IX:Integer;
      _IY:Integer;


    Public
      Selectable:Boolean;
      Frameless:Boolean;
      CloseButton:Widget;

      Procedure Render; Override;
      Procedure UpdateRects; Override;

      Procedure EnableHighlights();

      Procedure SetCaption(Const Value:AnsiString);
      Procedure SetHeight(Const Value: Integer);
      Procedure SetWidth(Const Value: Integer);

      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
			Function OnMouseUp(X,Y:Integer;Button:Word):Boolean; Override;
			Function OnMouseWheel(X,Y:Integer; Delta:Integer):Boolean; Override;

      Constructor Create(Name:AnsiString; UI:UI; X,Y,Z:Single; Width, Height:Integer; ComponentBG:AnsiString=''); Overload;
      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Width, Height:Integer; ComponentBG:AnsiString=''); Overload;
      Destructor Destroy; Override;

      Property Layout:UISkinLayout Read _WndLayout;

      Property Width: Integer Read _Width Write SetWidth;
      Property Height: Integer Read _Height Write SetHeight;

      Property Caption:AnsiString Read _Caption Write SetCaption;
  End;

  UILabel = Class(UICaption)
    Protected
      _Width:Single;
      _Height:Single;

    Public
      OnReveal:WidgetEventHandler;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Caption:AnsiString; TabIndex:Integer=-1);

      Procedure Render; Override;
      Procedure UpdateRects; Override;


      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
  End;

  UIButton = Class(UICaption)
    Protected
      _Width:Integer;
      _Height:Integer;
      _Dual:Boolean;

    Public
      Disabled:Boolean;
      TextColor:Color;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Caption:AnsiString; Skin:AnsiString=''; TabIndex:Integer=-1);

      Procedure Render; Override;
      Procedure UpdateRects; Override;


      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
  End;

  UISpriteButton = Class(UIButton)
    Protected
      _Texture:Texture;


    Public
      BilinearFilter:Boolean;
      Offset:Single;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Skin:AnsiString=''; TabIndex:Integer=-1);
      Procedure SetTexture(Tex:Texture);

      Procedure Render; Override;
  End;

  UIIcon = Class(Widget)
    Protected
      _Width:Integer;
      _Height:Integer;
      _Dual:Boolean;
      _Down:Boolean;
      _Base:Integer;

    Public
      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Icon:AnsiString; TabIndex:Integer=-1);

      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;


      Procedure Render; Override;
      Procedure UpdateRects; Override;

      Property Width:Integer Read _Width;
      Property Height:Integer Read _Height;
  End;

  UISprite = Class(Widget)
    Protected

      Function OnRegion(X,Y:Integer): Boolean; Override;

    Public
      Rect:TextureRect;
      Anchor:Vector2D;
      Flip, Mirror:Boolean;
      BilinearFilter:Boolean;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Picture:AnsiString = ''; TabIndex:Integer=-1);

      Procedure SetTexture(Tex:Texture);

      Procedure Render; Override;
      Procedure UpdateRects; Override;

      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
      Function OnMouseUp(X,Y:Integer;Button:Word):Boolean; Override;
  End;

  UICheckBox = Class(UICaption)
    Protected
      _Checked:Boolean;
      _Variable:PBoolean;
      _Width:Integer;
      _Height:Integer;

      Procedure SetChecked(Value:Boolean); Virtual;

      Function HasMouseOver():Boolean; Override;

    Public
      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Caption:AnsiString; Skin:AnsiString = ''; TabIndex:Integer=-1);

      Procedure Render; Override;
      Procedure UpdateRects; Override;

      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;

      Procedure SetCheckedWithoutPropagation(Value:Boolean);

      Property Checked:Boolean Read _Checked Write SetChecked;
      Property Variable:PBoolean Read _Variable Write _Variable;
  End;

  UIRadioButton = Class(UICheckBox)
    Protected
      Procedure SetChecked(Value:Boolean); Override;

    Public
      Group:Integer;

      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Caption:AnsiString; TabIndex:Integer=-1);
  End;

  UISlider = Class(Widget)
    Protected
      _Value:Single;
      _Max:Single;
      _Width:Integer;
      _Height:Integer;
      _PickWidth:Integer;
      _PickHeight:Integer;
      _Changed:Boolean;


      Procedure SetValue(X:Single);

    Public
      OnChange:WidgetEventHandler;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; TabIndex:Integer=-1);

      Procedure Render; Override;
      Procedure UpdateRects; Override;

      Function OnRegion(X,Y:Integer): Boolean; Override;

      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
			Function OnMouseUp(X,Y:Integer;Button:Word):Boolean; Override;
      Function OnMouseMove(X,Y:Integer):Boolean; Override;


      Property Value:Single Read _Value Write SetValue;
      Property Max:Single Read _Max Write _Max;
  End;

  UIScrollBarHandle = Class(UIIcon)
    Public
      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
			Function OnMouseUp(X,Y:Integer;Button:Word):Boolean; Override;
      Function OnMouseMove(X,Y:Integer):Boolean; Override;
  End;

  UIScrollBar = Class(Widget)
    Protected
      _Value:Single;
      _Max:Single;
      _Length:Integer;

      _BgWidth:Integer;
      _BgHeight:Integer;

      _PickWidth:Integer;
      _PickHeight:Integer;

      _Changed:Boolean;
      _Horizontal:Boolean;

      _Handle:UIScrollBarHandle;
      _HandlePos:Single;
      _HandleOffset:Vector2D;


      Procedure SetLength(Const Value:Integer);
      Procedure SetValue(Const Value: Single);

      Function GetLengthInPixels():Single;

      Procedure HandleMove(X,Y:Integer);

    Public
      OnChange:WidgetEventHandler;

      //Function OnHandleRegion(X,Y:Integer):Boolean;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Size:Integer; Horizontal:Boolean; TabIndex:Integer=-1);

      Procedure Render; Override;
      Procedure UpdateRects; Override;

      Procedure Slide(Ammount:Single);

      Property Value:Single Read _Value Write SetValue;
      Property Max:Single Read _Max Write _Max;

      Property Horizontal:Boolean Read _Horizontal;

      Property ScrollSize:Integer Read _Length Write SetLength;
  End;

  UIProgressBar = Class(Widget)
    Protected
      _Percent:Single;
      _Width:Integer;
      _Height:Integer;

      Function CreateCustomTween(TweenType:Integer; TargetValue:Single):Tween; Override;

    Public
      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Skin:AnsiString = ''; TabIndex:Integer=-1);

      Procedure Render; Override;
      Procedure UpdateRects; Override;


      Property Percent:Single Read _Percent Write _Percent;
  End;

  UIComboBox = Class(Widget)
    Protected
      _ItemIndex:Integer;
      _ItemHighlight:Integer;
      _ShowList:Boolean;
      _Width:Integer;
      _BarWidth:Integer;
      _BarSlices:Integer;
      _HandlePos:Integer;
      _HandleWidth:Integer;
      _HandleHeight:Integer;
      _ListWidth:Integer;
      _ListHeight:Integer;
      _ListSlicesX:Integer;
      _ListSlicesY:Integer;
      _Content:List;
      _Selected:ListObject;

      Function GetItem(Index:Integer):ListObject;
      Function GetItemAtIndex(X,Y:Integer):Integer;

      Procedure SetItemIndex(Const Value:Integer);

    Public
      ShowLabelOnly:Boolean;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Width:Integer; TabIndex:Integer=-1);

      Procedure Render; Override;
      Procedure UpdateRects; Override;


      //Function OnRegion(X,Y:Integer): Boolean; Override;
      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
      Function OnMouseMove(X,Y:Integer):Boolean; Override;

      Procedure SetContent(Content:List);

      Procedure Select(Const Value:AnsiString);

      Property ItemIndex:Integer Read _ItemIndex Write SetItemIndex;
      Property Items[Index:Integer]:ListObject Read GetItem;
      Property Selected:ListObject Read _Selected;
  End;

  UIEditText = Class(UICaption)
    Protected
      _Width:Integer;
      _Height:Single;
      _LineCount:Integer;
      _Lines:Array Of AnsiString;
      _LineIndex:Integer;
      _MaxLines:Integer;

      _SelectedColor:Color;

      _ScrollIndex:Single;
      _Clip:ClipRect;

      {_HorScroll:UIScrollBar;
      _VertScroll:UIScrollBar;}

      _KoreanBaseJamo:Integer;
      _KoreanInitialJamo:Integer;
      _KoreanMedialJamo:Integer;
      _KoreanFinalJamo:Integer;

      Procedure UpdateJamos();

      Procedure StartHighlight(); Override;
      Procedure StopHighlight(); Override;

    Public
      OnEnter:WidgetEventHandler;
      PasswordField:Boolean;
      TextColor:Color;
      Centered:Boolean;

      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Width:Integer; Skin:AnsiString=''; TabIndex:Integer=-1);
      Destructor Destroy; Override;

      Procedure Render; Override;
      Procedure UpdateRects; Override;

      Procedure SetFocus(ShowKeyboard:Boolean);

      Procedure SetText(Const Value:AnsiString);
      Function GetText:AnsiString;

      Procedure SetLineCount(const Value: Integer);

      Function GetCurrentLine:AnsiString;
      Procedure SetCurrentLine(const Value:AnsiString);

      Function OnMouseDown(X,Y:Integer;Button:Word):Boolean; Override;
      Function OnMouseUp(X,Y:Integer;Button:Word):Boolean; Override;
      Function OnKeyPress(Key:Word):Boolean; Override;

      Property Text:AnsiString Read GetText Write SetText;
      Property Line:AnsiString Read GetCurrentLine Write SetCurrentLine;
      Property LineCount:Integer Read _LineCount Write SetLineCount;
  End;

  UITooltip = Class(UICaption)
    Protected
      _Width:Single;
      _Height:Single;
      _Sections:Integer;

    Public

      Procedure Render; Override;
      Procedure UpdateRects; Override;


      Constructor Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Caption:AnsiString=''; Skin:AnsiString='');
  End;

  UILayout = Class(Widget)
    Protected
      _Width:Integer;
      _Height:Integer;

    Public
      Position:Vector2D;
      HorizontalSpacing:Integer;
      VerticalSpacing:Integer;
      LayoutMode:Integer;

      Constructor Create(Name:AnsiString; UI:UI; X,Y,Z:Single; Width, Height, LayoutMode:Integer; TabIndex:Integer=-1);

      Procedure Render; Override;


      Property Width:Integer Read _Width;
      Property Height:Integer Read _Height;
  End;


Var
  UseNativeKeyboard:Boolean = False;

Implementation
Uses TERRA_OS, TERRA_Application, TERRA_GraphicsManager, TERRA_Vector3D, TERRA_Log, 
  TERRA_FileUtils, TERRA_Localization, TERRA_Unicode
  {$IFDEF VIRTUALKEYBOARD},TERRA_UIVirtualKeyboard{$ENDIF};

Function UICaption.GetSize: Vector2D;
Begin
  If (_NeedsUpdate) Then
    Self.UpdateRects();

  Result := Inherited GetSize;
End;

Procedure UICaption.OnLanguageChange;
Begin
  Self.SetCaption(Self._OriginalValue);
End;

Procedure UICaption.SetCaption(Value:AnsiString);
Begin
  _OriginalValue := Value;
  _NeedsUpdate := True;

  If (Value<>'') And (Value[1]='#') Then
  Begin
    Value := Copy(Value, 2, MaxInt);
    Value := StringManager.Instance.GetString(Value);
  End;
  _Caption := Value;
End;

Procedure UICaption.UpdateRects;
Var
  Fnt:TERRA_Font.Font;
Begin
  Fnt := Self.GetFont();

  If (_NeedsUpdate) Or (Fnt<>_PreviousFont) Then
  Begin
    _TextRect := Fnt.GetTextRect(_Caption, 1.0);
    _PreviousFont := Fnt;
    _NeedsUpdate := False;
  End;
End;

{ UIWindow }
Constructor UIWindow.Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Width, Height:Integer; ComponentBG:AnsiString);
Begin
  Self._Visible := True;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self._Width := Width;
  Self._Height := Height;
  Self._Dragging := False;
  If (ComponentBG='') Then
    ComponentBG := 'ui_window';

  Self.LoadComponent(ComponentBG);
  Self.Selectable := True;
  UI.AddWidget(Self);

  If (Length(_ComponentList)>0) Then
  Begin
    _IX := Self._ComponentList[0].Buffer.Width;
    _IY := Self._ComponentList[0].Buffer.Height;

    _WndLayout := UISkinLayout.Create(_ComponentList[0]);
  End Else
    _WndLayout := UISkinLayout.Create(Nil);

  Self.UpdateRects();
End;

Constructor UIWindow.Create(Name:AnsiString; UI:UI; X,Y,Z:Single; Width, Height:Integer; ComponentBG:AnsiString);
Begin
  Create(Name, UI, Nil, X,Y,Z, Width, Height, ComponentBG);
End;

Destructor UIWindow.Destroy();
Begin
  If Assigned(_WndLayout) Then
  Begin
    _WndLayout.Destroy();
    _WndLayout := Nil;
  End;

  Inherited;
End;


Function UIWindow.OnMouseDown(X,Y:Integer;Button:Word):Boolean;
Var
  Temp:WidgetEventHandler;
Begin
  If (Not Visible) Or (Not Selectable) Then
  Begin
    Result := False;
    Exit;
  End;

  Temp := Self.OnMouseClick;
  Self.OnMouseClick := Nil;
  Result := Inherited OnMouseDown(X,Y,Button);
  Self.OnMouseClick := Temp;
  If Result Then
    Exit;

  If (Not FrameLess) And (OnRegion(X,Y)) Then
  Begin
    Result := True;

    If (Assigned(OnMouseClick)) And (Not Self.HasTweens()) Then
    Begin
      Self._HitTime := GetTime();
      Self._Hitting := True;
    End;
  End Else
    Result := False;
End;

Function UIWindow.OnMouseUp(X,Y:Integer;Button:Word):Boolean;
Begin
  Result := Inherited OnMouseUp(X,Y, Button);

  If (_Hitting) Then
  Begin
    Result := True;
    _Hitting := False;
    If (GetTime - _HitTime > ExtendedPressDuration) And (Assigned(OnExtendedClick)) Then
      OnExtendedClick(Self)
    Else
      OnMouseClick(Self);

    Self.OnHit();
  End;
End;

Procedure UIWindow.EnableHighlights;
Var
  I:Integer;
  W:Widget;
Begin
  For I:=0 To Pred(ChildrenCount) Do
  Begin
    W := GetChild(I);
    If (Assigned(W)) And (W.CanHighlight) Then
    Begin
      While (W.UpControl<>Nil) And (W.UpControl.Position.Y<W.Position.Y) Do
        W := W.UpControl;
      UI.Highlight := W;
      Exit;
    End;
  End;
End;

Procedure UIWindow.UpdateRects();
Begin
  _Size.X := _WndLayout.GetWidth(_Width);
  _Size.Y := _WndLayout.GetHeight(_Height);
End;
                                                         
Procedure UIWindow.Render;
Var
  MyColor:TERRA_Color.Color;
  //Pos, Size:Vector2D;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();
  Self.UpdateHighlight();

  {If (Not Self.HasTweens) And (Self.Parent = Nil) Then
  Begin
    Pos := Self.GetAbsolutePosition();
    Size := Self.Size;
    If (Pos.X + Size.X<=0) Or (Pos.Y + Size.Y<=0) Or (Pos.X + Size.X>=UIManager.Instance.Width) Or (Pos.Y + Size.Y>=UIManager.Instance.Height) Then
    Begin
      Self.Visible := False;
      Exit;
    End;
  End;}

  MyColor := Self.Color;

  If (Not Frameless) Then
  Begin
    Self.DrawWindow(0, VectorZero, _Width, _Height, _WndLayout, MyColor);
{    Self.DrawComponent(0, VectorZero, 0.0, 0.0, 1/3, 1/3);
    Self.DrawComponent(0, VectorCreate(32.0*Pred(_Width), 0.0, 0.0), 2/3, 0.0, 1.0, 1/3);

    Self.DrawComponent(0, VectorCreate(0.0, 32.0 * Pred(_Height), 0.0), 0.0, 2/3, 1/3, 1.0);
    Self.DrawComponent(0, VectorCreate(32.0 * Pred(_Width), 32.0 * Pred(_Height), 0.0), 2/3, 2/3, 1.0, 1.0);

    For I:=1 To _Width Do
    Begin
      If (_TabCount=0) Then
        Self.DrawComponent(0, VectorCreate(32.0 * Pred(I), 0.0, 0.0), 1/3, 0.0, 2/3, 1/3);
      Self.DrawComponent(0, VectorCreate(32.0 * Pred(I), Pred(_Height) * 32.0, 0.0), 1/3, 2/3, 2/3, 1.0);
    End;

    For I:=1 To _Height Do
    Begin
      Self.DrawComponent(0, VectorCreate(0.0, 32.0 * Pred(I), 0.0), 0.0, 1/3, 1/3, 2/3);
      Self.DrawComponent(0, VectorCreate(Pred(_Width) * 32.0, 32.0 * Pred(I), 0.0), 2/3, 1/3, 1.0, 2/3);
    End;

    For J:=1 To _Height Do
      For I:=1 To _Width Do
      Begin
        Self.DrawComponent(0, VectorCreate(32*Pred(I), 32*Pred(J), 0.0), 1/3, 1/3, 2/3, 2/3);
      End;
 }
  End;

  Inherited Render();
End;

Constructor UIButton.Create(Name:AnsiString;  UI:UI;Parent:Widget; X,Y,Z:Single; Caption:AnsiString; Skin:AnsiString; TabIndex:Integer);
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetCaption(Caption);
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self.TextColor := ColorWhite;
  Self.DropShadow := True;

  If Skin = '' Then
    Skin := 'ui_button';

  Skin := GetFileName(Skin, True);

  _Dual := FileManager.Instance.SearchResourceFile(Skin+'_down.png')<>'';
  If _Dual Then
  Begin
    Self.LoadComponent(Skin+'_up');
    Self.LoadComponent(Skin+'_down');
    Self.LoadComponent(Skin+'_over');
  End Else
    Self.LoadComponent(Skin);

  UI.AddWidget(Self);

  If (Length(_ComponentList)>0) Then
  Begin
    _Width := Self._ComponentList[0].Buffer.Width;
    _Height := Self._ComponentList[0].Buffer.Height;
  End;

  _NeedsUpdate := True;
End;

Procedure UIButton.UpdateRects();
Begin
  Inherited;

  _Size.X := _Width;
  _Size.Y := _Height;
End;

Procedure UIButton.Render;
Var
  MyColor:TERRA_Color.Color;
  ID:Integer;
  TX, TY:Single;
  TempSat:Single;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();
  Self.UpdateHighlight();

  MyColor := Self.Color;
  TextColor.A := MyColor.A;
  TempSat := Self._Saturation;
  If Disabled Then
    Self._Saturation := 0.0;

  If (_Dual) And (Self.IsHighlighted()) Then
  Begin
    If (Self._ComponentCount>=3) Then
      ID := 2
    Else
      ID := 1
  End Else
    ID := 0;

  Self.DrawComponent(ID, VectorZero, 0.0, 0.0, 1.0, 1.0, MyColor, True);
  If (Assigned(Self.Font)) And (Caption<>'') Then
  Begin
    {If (Self.IsHighlighted()) Then
      S := '\w'+S;}

      {If Pos('\p',S)>0 Then
        IntToString(2);}

    TX := (Self._Width - _TextRect.X) * 0.5;
    TY := (Self._Height - _TextRect.Y) * 0.5;

    Self.DrawText(_Caption, VectorCreate(TX, TY, 0.25), Self.TextColor, 1.0, Self.DropShadow);
  End;

  Inherited;

  Self._Saturation := TempSat;
End;

Function UIButton.OnMouseDown(X, Y: Integer; Button: Word): Boolean;
Begin
  If (OnRegion(X,Y)) And (Self.Visible) And (Not Self.HasTweens) And (Not Disabled) Then
  Begin
    If (Assigned(OnMouseClick)) Then
      OnMouseClick(Self);
    Self.OnHit();
    Result := True;
  End Else
    Result := Inherited OnMouseDown(X,Y, Button);
End;

Procedure UIWindow.SetCaption(const Value:AnsiString);
Begin
  _Caption := Value;
End;

Procedure UIWindow.SetWidth(const Value: Integer);
Begin
  _Width := Value;
  Self.UpdateRects();
End;

Procedure UIWindow.SetHeight(const Value: Integer);
Begin
  _Height := Value;
  Self.UpdateRects();
End;

Function UIWindow.OnMouseWheel(X,Y:Integer; Delta: Integer): Boolean;
Var
  I:Integer;
  Add:Single;
  S:UIScrollbar;
Begin
  Result := False;

  RemoveHint(X+Y); //TODO - check this stupid hint

  For I:=0 To Pred(Self._ChildrenCount) Do
  If (_ChildrenList[I] Is UIScrollbar) Then
  Begin
    S := UIScrollbar(_ChildrenList[I]);

    Add := (Delta/Abs(Delta)) * -0.1;

    If (Not S.Horizontal) Then
      S.Slide(Add * S.Max);

    Result := True;
  End;
End;

{ UISpriteButton }
Constructor UISpriteButton.Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Skin:AnsiString; TabIndex:Integer);
Begin
  Inherited Create(Name, UI, Parent, X,Y,Z, '', Skin, TabIndex);
  Self.BilinearFilter := False;
End;

Procedure UISpriteButton.Render;
Var
  Pos:Vector2D;
  W, H:Single;
Begin
  Inherited;

  If _Texture = Nil Then
    Exit;

  W := _Texture.Width;
  H := (_Size.Y - _Texture.Height) * 0.5;
  Pos := Self.GetAbsolutePosition();
  SpriteManager.Instance.AddSprite(Pos.X + (_Width-W) * 0.5, H + Offset + Pos.Y, 100-(Layer+0.5), _Texture, Nil, BlendBlend, Saturation, BilinearFilter);
End;

Procedure UISpriteButton.SetTexture(Tex: Texture);
Begin
  Self._Texture := Tex;
End;

Constructor UIIcon.Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Icon:AnsiString; TabIndex:Integer);
Var
  Base:AnsiString;
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;

  If Pos('|',Icon)>0 Then
    Base := GetNextWord(Icon,'|')
  Else
    Base := '';

  Log(logDebug, 'Game', 'Seaching icons');
  _Dual := FileManager.Instance.SearchResourceFile(Icon+'_down.png')<>'';
  Log(logDebug, 'Game', 'Loading components');
  If _Dual Then
  Begin
    Self.LoadComponent(Icon+'_up');
    Self.LoadComponent(Icon+'_down');
    Self.LoadComponent(Icon+'_over');
  End Else
    Self.LoadComponent(Icon);

  Log(logDebug, 'Game', 'Adding widget');
  UI.AddWidget(Self);

  Log(logDebug, 'Game', 'Getting length');
  If Length(Self._ComponentList)>0 Then
  Begin
    _Width := _ComponentList[0].Buffer.Width;
    _Height := _ComponentList[0].Buffer.Height;
  End;

  If Base<>'' Then
  Begin
    _Base := Self.LoadComponent(Base);
  End Else
    _Base := -1;
End;

Procedure UIIcon.UpdateRects();
Begin
  _Size.X := _Width;
  _Size.Y := _Height;
End;

Procedure UIIcon.Render;
Var
  ID:Integer;
  MyColor:TERRA_Color.Color;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();

  If (Not DisableHighlights) Then
    Self.UpdateHighlight();

  MyColor := Self.Color;
  {$IFDEF OUYA}
  {If (UI.Highlight<>Nil) And (Not Self.IsHighlighted) And (Assigned(Self.OnMouseClick)) Then
    MyColor := ColorGrey(64);}
  {$ENDIF}

  If (_Down) And (Not Self.IsHighlighted()) Then
    _Down := False;

  If (_Dual) And (_Down) Then
    ID := 1
  Else
  If (_Dual) And (Self._ComponentCount>=3) And (Self.IsHighlighted())  Then
    ID := 2
  Else
    ID := 0;

  If (_Base>=0) Then
    Self.DrawComponent(_Base, VectorZero, 0.0, 0.0, 1.0, 1.0, MyColor, True);

  Self.DrawComponent(ID, VectorCreate(0.0, 0.0, 0.1), 0.0, 0.0, 1.0, 1.0, MyColor, True);

  Inherited;
End;

Function UIIcon.OnMouseDown(X, Y: Integer; Button: Word): Boolean;
Begin
  If (OnRegion(X,Y)) And (Self.Visible) And (Assigned(OnMouseClick))  And (Not Self.HasTweens) Then
  Begin
    Self.OnHit();
    OnMouseClick(Self);
    Result := True;
  End Else
    Result := Inherited OnMouseDown(X,Y, Button);

  _Down := Result;
End;


Constructor UILabel.Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Caption:AnsiString; TabIndex:Integer);
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self._Width := 0;
  Self._Height := 0;
  Self.DropShadow := True;

  Self.SetCaption(Caption);
  _NeedsUpdate := True;

  UI.AddWidget(Self);
End;


Function UILabel.OnMouseDown(X,Y:Integer;Button:Word):Boolean;
Begin
  If  (Assigned(OnMouseClick)) And (OnRegion(X,Y)) And (Not Self.HasTweens) Then
  Begin
    Self.OnHit();
    OnMouseClick(Self);
    Result := True;
  End Else
    Result := Inherited OnMouseDown(X,Y, Button);
End;

(*Function UILabel.OnMouseMove(X,Y:Integer):Boolean;
Var
  Pos:Vector2D;
  AO, OH:Boolean;
Begin
  Pos := Self.GetPosition;
  OH := _HighLight;
  AO := (Assigned(OnMouseClick));
  _HighLight := (AO) And (OnRegion(X,Y)) And (Not Self.HasTweens);
  Result := False;
  If _HighLight  Then
    Result := True;
  {$IFDEF IPHONE}
  If (_Highlight) And (Not OH) And (Not DisableSlideTouch) Then
    Self.OnMouseDown(X, Y, 99);
  {$ENDIF}
End;*)

{Procedure UILabel.Reveal(DurationPerLetter, Delay:Cardinal);
Begin
  Self._RevealTime := Delay + GetTime;

  If Not Assigned(Self.Font) Then
    Exit;

  Self._RevealDuration := Self.Font.GetLength(Caption);
  Self._RevealDuration := DurationPerLetter * Self._RevealDuration;
End;}

Procedure UILabel.UpdateRects();
Begin
  Inherited;
  _Size := _TextRect;
End;

Procedure UILabel.Render();
Var
  S:AnsiString;
  Time:Cardinal;
  Delta:Single;
  Color:TERRA_Color.Color;
  P:Vector2D;
Begin
  Self.UpdateRects;

  If (_Caption = '') Then
    Exit;

  Self.UpdateTransform();

  _Width := Self._TextRect.X;
  _Height := Self._TextRect.Y;

(*  {$IFDEF MOBILE}
  Color := Self.GetColor;
  {$ELSE}
  If (Not Assigned(OnMouseClick)) Or (_HighLight) Then
    Color := Self.GetColor
  Else
    Color := ColorGrey(200, Self.Color.A);
  {$ENDIF}*)

  If (Not DisableHighlights) Then
    Self.UpdateHighlight();

  Color := Self.GetColor;
  Color.R := Self._Color.R;
  Color.G := Self._Color.G;
  Color.B := Self._Color.B ;

{  If (_RevealTime = 0) Or (Self.Font = Nil) Then
    RevealCount := 9999
  Else
  Begin
    Time := GetTime;
    If (Time<_RevealTime) Then
      Delta := 0
    Else
    Begin
      Time := (Time - _RevealTime);
      Delta := Time / _RevealDuration;
      If Delta<0 Then
        Delta := 0.0;
    End;

    If (Delta>=1.0) Then
    Begin
      _RevealTime := 0;
      RevealCount := 9999;
      If Assigned(OnReveal) Then
        OnReveal(Self);
    End Else
      RevealCount := Trunc(Self.Font.GetLength(Caption) * Delta);
  End;}

  //RevealCount, {TODO}!!!
  Self.DrawText(_Caption, VectorZero, Color, Scale,  Self.DropShadow);

  Inherited;
End;


{ UICheckBox }
Constructor UICheckBox.Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Caption:AnsiString; Skin:AnsiString; TabIndex:Integer);
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetCaption(Caption);
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self._Checked := False;
  Self.DropShadow := True;

  If Skin = '' Then
    Skin := 'ui_checkbox';

  Self.LoadComponent(Skin+'_on');
  Self.LoadComponent(Skin+'_off');
  UI.AddWidget(Self);

  If (Length(_ComponentList)>0) Then
  Begin
    _Width := Self._ComponentList[0].Buffer.Width;
    _Height := Self._ComponentList[0].Buffer.Height;
  End;

  _NeedsUpdate := True;
End;

Function UICheckBox.OnMouseDown(X, Y: Integer; Button: Word): Boolean;
Begin
  If (OnRegion(X,Y)) And (Not Self.HasTweens) Then
  Begin
    SetChecked(Not _Checked);
    Result := True;
  End Else
    Result := Inherited OnMouseDown(X,Y, Button);
End;

Function UICheckBox.HasMouseOver: Boolean;
Begin
  Result := True;
End;

Procedure UICheckBox.SetCheckedWithoutPropagation(Value: Boolean);
Begin
  _Checked := Value;
End;

Procedure UICheckBox.SetChecked(Value:Boolean);
Begin
  If (Value = _Checked) Then
    Exit;

  _Checked := Value;
  If Assigned(_Variable) Then
    _Variable^ := _Checked;

  If (Self.Visible) And (Assigned(OnMouseClick)) Then
  Begin
    Self.OnHit();
    OnMouseClick(Self);
  End;
End;

Const
  CheckBoxPixelOfs = 5;

Procedure UICheckBox.UpdateRects();
Begin
  Inherited;

  _Size.X := CheckBoxPixelOfs + _Width + _TextRect.X;
  _Size.Y := FloatMax(_TextRect.Y, _Height);
End;

Procedure UICheckBox.Render;
Var
  ID:Integer;
  MyColor:TERRA_Color.Color;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();

  If (Not DisableHighlights) Then
    Self.UpdateHighlight();

  If Assigned(_Variable) Then
    _Checked := _Variable^;

  If (_Checked) Then
    ID := 0
  Else
    ID := 1;

  MyColor := Self.Color;

  Self.DrawComponent(ID, VectorCreate(0.0, 0.0, 0.0), 0.0, 0.0, 1.0, 1.0, MyColor, True);

  {If (Self.IsHighlighted()) Then
    S := '\w'+S;}
  Self.DrawText(_Caption, VectorCreate(_Width + CheckBoxPixelOfs, (_Size.Y - _TextRect.Y) * 0.5, 5.0), GetColor, Scale, Self.DropShadow);

  Inherited;
End;

Constructor UIRadioButton.Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Caption:AnsiString; TabIndex:Integer);
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetCaption(Caption);
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self._Checked := False;

  Self.LoadComponent('ui_radiobox_on');
  Self.LoadComponent('ui_radiobox_off');
  UI.AddWidget(Self);

  If (Length(_ComponentList)>0) Then
  Begin
    _Width := Self._ComponentList[0].Buffer.Width;
    _Height := Self._ComponentList[0].Buffer.Height;
  End;

  _NeedsUpdate := True;
End;

Function UIRadioButton.OnMouseDown(X, Y: Integer; Button: Word): Boolean;
Begin
  If (OnRegion(X,Y)) And (Not Self.HasTweens) And (Not _Checked) Then
  Begin
    SetChecked(True);
    Result := True;
  End Else
  Result := Inherited OnMouseDown(X,Y, Button);
End;

Procedure UIRadioButton.SetChecked(Value:Boolean);
Var
  I:Integer;
  W:Widget;
  RB:UIRadioButton;
  It:Iterator;
Begin
  If (_Checked = Value) Then
    Exit;

  _Checked := Value;
  If Assigned(_Variable) Then
    _Variable^ := _Checked;

  If (Not Value) Then
    Exit;

  If Assigned(OnMouseClick) Then
    OnMouseClick(Self);

  It := UI.Widgets.CreateIterator;
  While It.HasNext Do
  Begin
    W := Widget(It.GetNext());
    If (W Is UIRadioButton) Then
    Begin
      If (W.Name = Self.Name) Then
        Continue;

      RB := UIRadioButton(W);
      If (RB.Group = Self.Group) Then
        RB.SetChecked(Not Value);
    End;
  End;

  It.Destroy;
End;


Constructor UISlider.Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; TabIndex:Integer);
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self._Value := 0.0;
  Self._Max := 100;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;

  Self.LoadComponent('ui_slider1');
  Self.LoadComponent('ui_slider2');
  UI.AddWidget(Self);

  If (Length(_ComponentList)>0) And (Assigned(_ComponentList[0])) And (Assigned(Self._ComponentList[0].Buffer)) Then
  Begin
    _Width := Self._ComponentList[0].Buffer.Width;
    _Height := Self._ComponentList[0].Buffer.Height;
  End;

  If (Length(_ComponentList)>1) And (Assigned(_ComponentList[1])) And (Assigned(Self._ComponentList[1].Buffer)) Then
  Begin
    _PickWidth := Self._ComponentList[1].Buffer.Width;
    _PickHeight := Self._ComponentList[1].Buffer.Height;
  End;
End;

Procedure UISlider.UpdateRects();
Begin
  _Size.X := _Width;
  _Size.Y := _Height;
End;

Procedure UISlider.Render();
Var
  Ofs:Single;
  MyColor:TERRA_Color.Color;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();

  If (_Changed) Then
  Begin
    _Changed := False;
    If Assigned(OnChange) Then
      OnChange(Self);
  End;

  MyColor := Self.GetColor();

  Self.DrawComponent(0, VectorZero, 0.0, 0.0, 1.0, 1.0, MyColor);
  Ofs := 1.0 + (_Value/_Max)*(_Width-_PickWidth);
  Self.DrawComponent(1, VectorCreate(Ofs, -(_PickHeight Shr 1), 1.0), 0.0, 0.0, 1.0 , 1.0, MyColor);

  Inherited;
End;

Function UISlider.OnRegion(X,Y:Integer):Boolean;
Var
  Pos:Vector2D;
Begin
  Pos := Self.GetAbsolutePosition();
  Result := (X>=Pos.X) And (X<=Pos.X+_Width) And (Y>=Pos.Y-16) And (Y<=Pos.Y+16);
End;

Function UISlider.OnMouseDown(X,Y:Integer;Button:Word):Boolean;
Begin
  If Not Visible Then
  Begin
    Result := False;
    Exit;
  End;

  If  (Button<>0) And (OnRegion(X,Y)) Then
  Begin
    _Dragging := True;
    Result := True;
  End Else
    Result := False;
End;

Function UISlider.OnMouseUp(X,Y:Integer;Button:Word):Boolean;
Begin
  RemoveHint(X+Y+Button); //TODO - check this stupid hint
  _Dragging := False;
  Result := False;
End;

Function UISlider.OnMouseMove(X,Y:Integer):Boolean;
Var
  Pos:Vector2D;
Begin
  Pos := Self.GetAbsolutePosition();
  If  (_Dragging) And (X>=Pos.X) And (X<=Pos.X+_Width) And (Y>=Pos.Y-_PickHeight) And (Y<=Pos.Y+_PickHeight)  Then
  Begin
    _Changed := True;
    _Value := (((X - Pos.X)/_Width)*_Max);
  End Else
    _Dragging := False;
    Result := False;
End;

{UIScrollBar}
Constructor UIScrollBar.Create(Name:AnsiString; UI:UI; Parent:Widget; X,Y,Z:Single; Size:Integer; Horizontal:Boolean;TabIndex:Integer);
Var
  S, HandleTex:AnsiString;
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self._Value := 0.0;
  Self._Max := 100;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self._Horizontal := Horizontal;
  Self._Length := Size;

  If Horizontal Then
    S := 'horizontal'
  Else
    S := 'vertical';

  HandleTex := 'ui_slider_handle_'+S;

  Self.LoadComponent(HandleTex);
  Self.LoadComponent('ui_slider_bg_'+S);

  UI.AddWidget(Self);

  _Handle := UIScrollBarHandle.Create(Name+'_handle', UI, Self, 0, 0, 1, HandleTex);
  Self.AddChild(_Handle);

  If (Length(_ComponentList)>0) And (Assigned(_ComponentList[0])) And (Assigned(Self._ComponentList[0].Buffer)) Then
  Begin
    _PickWidth := Self._ComponentList[0].Buffer.Width;
    _PickHeight := Self._ComponentList[0].Buffer.Height;
  End;

  If (Length(_ComponentList)>1) And (Assigned(_ComponentList[1])) And (Assigned(Self._ComponentList[1].Buffer)) Then
  Begin
    _BgWidth := Self._ComponentList[1].Buffer.Width;
    _BgHeight := Self._ComponentList[1].Buffer.Height;
  End;
End;


Procedure UIScrollBar.Render;
Var
  Size:Vector2D;
  I, Height:Integer;
  Count:Integer;
  HH:Single;
  MyColor:TERRA_Color.Color;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();

  MyColor := Self.GetColor();

  If (_Changed) Then
    _Changed := False;

//If  (UI.Instance.Dragger = Self)  Then  MyColor := ColorBlue;

  If (_Horizontal) Then
  Begin
    HH := _BgWidth * 0.25;
    _HandleOffset.X := -(_PickWidth * 0.5);
    _HandleOffset.Y := (_BgHeight - _PickHeight) * 0.5;

    Self.DrawComponent(1, VectorCreate(0, 0, 0), 0.0, 0.0, 0.25, 1.0, MyColor);
    For I:=0 To Pred(_Length) Do
      Self.DrawComponent(1, VectorCreate(HH*I, 0, 0), 0.25, 0.0, 0.75, 1.0, MyColor);

    Self.DrawComponent(1, VectorCreate(Pred(_Length)*HH, 0, 0), 0.75, 0.0, 1.0, 1.0, MyColor);

    //Self.DrawComponent(0, VectorCreate(_HandleOffset.X  + _HandlePos, _HandleOffset.Y, 0.2), 0.0, 0, 1.0, 1.0, MyColor);
    _Handle._Position.X := _HandleOffset.X  + _HandlePos;
    _Handle._Position.Y := _HandleOffset.Y;
  End Else
  Begin
    HH := _BgHeight * 0.25;
    _HandleOffset.X := (_BgWidth - _PickWidth) * 0.5;
    _HandleOffset.Y := -(_PickHeight * 0.5);

    Self.DrawComponent(1, VectorCreate(0, 0, 0), 0.0, 0.0, 1.0, 0.25, MyColor);
    For I:=0 To Pred(_Length) Do
      Self.DrawComponent(1, VectorCreate(0, HH*I, 0), 0.0, 0.25, 1.0, 0.75, MyColor);

    Self.DrawComponent(1, VectorCreate(0, Pred(_Length)*HH, 0), 0.0, 0.75, 1.0, 1.0, MyColor);

    //Self.DrawComponent(0, VectorCreate(_HandleOffset.X, _HandleOffset.Y + _HandlePos, 0.2), 0.0, 0, 1.0, 1.0, MyColor);
    _Handle._Position.X := _HandleOffset.X;
    _Handle._Position.Y := _HandleOffset.Y + _HandlePos;
  End;


//  Ofs := 1.0 + (_Value/_Max)*(_Width-_PickWidth);
//  Self.DrawComponent(1, VectorCreate(Ofs, -(_PickHeight Shr 1), 1.0), 0.0, 0.0, 1.0 , 1.0);
  Inherited;
End;

Procedure UIScrollBar.UpdateRects();
Begin
  If _Horizontal Then
  Begin
    _Size.X := GetLengthInPixels();
    _Size.Y := _BgHeight;
  End Else
  Begin
    _Size.X := _BgWidth;
    _Size.Y := GetLengthInPixels();
  End;
End;

Procedure UIScrollBar.SetLength(const Value: Integer);
Begin
  Self._Length := Value;
  Self.UpdateRects();
End;

{Function UIScrollBar.OnHandleRegion(X, Y: Integer): Boolean;
Var
  Pos:Vector2D;
  X1,X2,Y1,Y2:Single;
Begin
  Pos := Self.GetAbsolutePosition();
  If _Horizontal Then
  Begin
    X1 := Pos.X + _HandleOffset.X + _HandlePos;
    X2 := Pos.X + _HandleOffset.X + _HandlePos + _PickWidth;
    Y1 := Pos.Y + _HandleOffset.Y;
    Y2 := Pos.Y + _HandleOffset.Y + _PickHeight;
  End Else
  Begin
    X1 := Pos.X + _HandleOffset.X;
    X2 := Pos.X + _HandleOffset.X + _PickWidth;
    Y1 := Pos.Y + _HandleOffset.Y + _HandlePos;
    Y2 := Pos.Y + _HandleOffset.Y + _HandlePos + _PickHeight;
  End;

  Result := (X>=X1) And (X<=X2) And (Y>=Y1) And (Y<=Y2);
End;}

Function UIScrollBar.GetLengthInPixels: Single;
Begin
  If (_Horizontal) Then
    Result := _BgWidth  * 0.25 * (_Length+2)
  Else
    Result := _BgHeight  * 0.25 * (_Length+2);
End;

Procedure UIScrollBar.SetValue(const Value: Single);
Begin
  _Value := Value;
  If Assigned(OnChange) Then
    OnChange(Self);
End;

Procedure UIScrollBar.Slide(Ammount: Single);
Begin
  Value := Value + Ammount;
  If Value<0 Then
    Value := 0
  Else
  If (Value>Max) Then
    Value := Max;

  If Assigned(OnChange) Then
    OnChange(Self);
End;

Procedure UIScrollBar.HandleMove(X, Y: Integer);
Var
  Pos:Vector2D;
Begin
  Pos := Self.GetAbsolutePosition();
  If (_Horizontal) Then
    _HandlePos := X-Pos.X
  Else
    _HandlePos := Y-Pos.Y;

  _Changed := True;
  If (_HandlePos<0) Then
    _HandlePos := 0
  Else
  If (_HandlePos>Size.X) And (Self._Horizontal) Then
    _HandlePos := Size.X
  Else
  If (_HandlePos>Size.Y) And (Not Self._Horizontal) Then
    _HandlePos := Size.Y
  Else
  Begin
    _Value := (_HandlePos/GetLengthInPixels()) * _Max;
    If Assigned(OnChange) Then
      OnChange(Self);
  End;
End;

{ UIScrollBarHandle }
Function UIScrollBarHandle.OnMouseDown(X,Y:Integer;Button:Word):Boolean;
Begin
  RemoveHint(Button); //TODO - check this stupid hint

  Result := False;

  If Not Visible Then
    Exit;

  If OnRegion(X,Y) Then
  Begin
    UI.Dragger := Self;
    Log(logDebug, 'UI', 'Scrollbar handle now dragging');
    Result := True;
  End;
End;

Function UIScrollBarHandle.OnMouseUp(X,Y:Integer;Button:Word):Boolean;
Begin
  IntToString(X+Y+Button); //TODO - check this stupid hint
  
  If (UI.Dragger = Self) Then
  Begin
    UI.Dragger := Nil;
    Log(logDebug, 'UI', 'Scrollbar handle now released');
  End;

  Result := False;
End;

Function UIScrollBarHandle.OnMouseMove(X,Y:Integer):Boolean;
Begin
  If  (UI.Dragger = Self) Then
  Begin
    Log(logDebug, 'UI', 'Scrollbar handle now moving');
    UIScrollBar(_Parent).HandleMove(X, Y);
    Self._TransformChanged := True;
    Result := True;
  End Else
    Result := False;
End;

{ UIProgressBar }
Constructor UIProgressBar.Create(Name:AnsiString; UI:UI; Parent:Widget; X, Y, Z: Single; Skin:AnsiString; TabIndex:Integer);
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self._Percent := 0;

  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;

  If Skin = '' Then
    Skin := 'ui_progressbar';

  Self.LoadComponent(Skin);
  UI.AddWidget(Self);

  If (Length(_ComponentList)>0) And (Assigned(_ComponentList[0])) And (Assigned(Self._ComponentList[0].Buffer)) Then
  Begin
    _Width := Self._ComponentList[0].Buffer.Width;
    _Height := Self._ComponentList[0].Buffer.Height Div 2;
  End;
End;

Function UIProgressBar.CreateCustomTween(TweenType: Integer; TargetValue: Single): Tween;
Begin
  Case TweenType Of
  wtValue:  Result := Tween.Create(Self, tweenFloat, @Self._Percent, TargetValue, Self);
  Else
    Result := Nil;
  End;
End;

Procedure UIProgressBar.UpdateRects();
Begin
  _Size.X := _Width;
  _Size.Y := _Height;
End;

Procedure UIProgressBar.Render;
Var
  K:Single;
  MyColor:TERRA_Color.Color;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();
  
  MyColor := Self.GetColor;

  If (_Percent<0) Then
    _Percent := 0;
  If (_Percent>100) Then
    _Percent := 100;

  K := _Percent/100;
  
  If K>0.0 Then
    Self.DrawComponent(0, VectorCreate(0.0, 0, 0.0), 0.0, 0.0, K, 0.5, MyColor, False);

  If K<1.0 Then
  Begin
    MyColor := ColorGrey(255, MyColor.A);
    Self.DrawComponent(0, VectorCreate(0.0, -_Height, 0.0), K, 0.5, 1.0, 1.0, MyColor, False);
  End;

  Inherited;
End;

{ UIComboBox }

Constructor UIComboBox.Create(Name:AnsiString; UI:UI; Parent:Widget; X, Y, Z: Single; Width:Integer; TabIndex:Integer);
Begin
  Self._Visible := True;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;

  Self._TabIndex := TabIndex;
  Self._Width := Width;
  Self.LoadComponent('ui_combobox');
  Self.LoadComponent('ui_combobox2');
  Self.LoadComponent('ui_list');
  Self._ItemHighlight := -1;
  Self._Content := Nil;

  If (Length(_ComponentList)>0) Then
  Begin
    _BarWidth := _ComponentList[0].Buffer.Width;
    _BarSlices := Trunc(_BarWidth*0.5);
  End;

  If (Length(_ComponentList)>1) Then
  Begin
    _HandlePos := Trunc(_Width*_BarSlices + _BarSlices * 0.5);
    _HandleWidth := _ComponentList[1].Buffer.Width;
    _HandleHeight := _ComponentList[1].Buffer.Height;
  End;

  If (Length(_ComponentList)>2) Then
  Begin
    _ListWidth := _ComponentList[2].Buffer.Width;
    _ListHeight := _ComponentList[2].Buffer.Height;
    _ListSlicesX := Trunc(_ListWidth*0.5);
    _ListSlicesY := Trunc(_ListHeight*0.5);
  End;

  UI.AddWidget(Self);
End;

Procedure UIComboBox.SetContent(Content:List);
Begin
  _Content := Content;
  _ItemIndex := 0;
  _Selected := Nil;
  _ItemHighlight := -1;
End;

Function UIComboBox.GetItem(Index: Integer):ListObject;
Begin
  If (_Content<>Nil) And (Index>=0) And (Index<_Content.Count) Then
    Result := _Content.GetItemByIndex(Index)
  Else
    Result := Nil;
End;

Procedure UIComboBox.SetItemIndex(Const Value:Integer);
Begin
  _ItemIndex := Value;
  _Selected := _Content.GetItemByIndex(Value);
End;

Function UIComboBox.GetItemAtIndex(X,Y:Integer):Integer;
Var
  Pos:Vector2D;
  I,HH:Integer;
  X1,X2,Y1,Y2:Integer;
Begin
  Result := -1;
  Pos := Self.GetAbsolutePosition();

  X1 := Trunc(Pos.X + _ListWidth*0.25);
  X2 := Trunc(Pos.X+Succ(_Width)*_BarSlices);

  If (Assigned(_Content)) Then
  For I:=0 To Pred(_Content.Count) Do
  Begin
    HH := Trunc(_HandleHeight + _ListHeight * 0.25 + 8+_ListSlicesY*I);
    Y1 := Trunc(Pos.Y+HH);
    Y2 := Trunc(Pos.Y+HH+_ListHeight*0.25);

    If  (X>=X1) And (X<=X2) And (Y>=Y1) And (Y<=Y2) Then
    Begin
      Result  := I;
      Exit;
    End;
  End;
End;

Function UIComboBox.OnMouseDown(X, Y: Integer; Button: Word): Boolean;
Var
  Pos:Vector2D;
  CurrentHeight:Single;
Begin
  Result := False;

  RemoveHint(Button); //TODO - check this stupid hint

  If Not Visible Then
    Exit;

  Pos := Self.GetAbsolutePosition();

  If (_ItemHighlight < 0) And (_ShowList) Then
    _ItemHighlight := Self.GetItemAtIndex(X,Y);

  CurrentHeight := _HandleHeight;
  If (Self._ShowList) And (Assigned(_Content)) Then
    CurrentHeight := CurrentHeight + _ListHeight * 0.5 +  _ListSlicesY * _Content.Count;

  If (_ItemHighlight>=0) Then
  Begin
    SetItemIndex(_ItemHighlight);
    _ItemHighlight := -1;
    _ShowList := False;
    UI.Focus := Nil;
    Result := True;

    If (Assigned(OnMouseClick)) Then
      OnMouseClick(Self);
  End Else
  If (X>=Pos.X+_HandlePos) And (X<=Pos.X+_HandlePos+_HandleWidth) And (Y>=Pos.Y) And (Y<=Pos.Y+_HandleHeight) And (Not ShowLabelOnly) Then
  Begin
    _ShowList := Not _ShowList;
    Result := True;
    If (_ShowList) Then
      UI.Focus := Self;
  End Else
  If (X>=Pos.X) And (X<=Pos.X+_HandlePos+_HandleWidth) And (Y>=Pos.Y) And (Y<=Pos.Y+CurrentHeight)  Then
  Begin
    Result := True;
  End;
End;

Function UIComboBox.OnMouseMove(X, Y: Integer): Boolean;
Begin
  Result := False;
  _ItemHighLight := -1;
  If Not _ShowList Then
    Exit;

  _ItemHighLight := Self.GetItemAtIndex(X,Y);
End;

Procedure UIComboBox.Render;
Var
  LW,YY:Integer;
  I,J:Integer;
  MyColor:TERRA_Color.Color;
  P:ListObject;
  ZOfs:Single;
  S:AnsiString;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();

  If (_ItemIndex<0) Or (_Content = Nil) Then
    Exit;

  If (Not ShowLabelOnly) Then
  Begin
    Self.DrawComponent(0, VectorCreate(0, 0, 0), 0.0, 0.0, 1.0/4, 1.0, ColorWhite);
    For J:=0 To Pred(_Width) Do
    Begin
      Self.DrawComponent(0, VectorCreate(J*_BarSlices, 0, 0.0), 0.25, 0.0, 0.75, 1.0, ColorWhite);
    End;
    Self.DrawComponent(0, VectorCreate(-_BarWidth*0.75 + _Width *_BarSlices, 0, 0.0), 0.75, 0.0, 1.0, 1.0, ColorWhite);
  End;

  Self.DrawComponent(1, VectorCreate(_HandlePos, 0, 0.0), 0.0, 0.0, 1.0, 1.0, ColorWhite);

  If (_Selected<>Nil) And (Assigned(Self.Font)) Then
  Begin
    S := _Selected.ToString();
    If (S<>'') And (S[1]='#') Then
      S := StringManager.Instance.GetString(Copy(S, 2, MaxInt));
    Self.DrawText(S, VectorCreate(5, 5, 2.0), Self.Color, Scale);
  End;

  If (_ShowList) And (UI.Focus<>Self) Then
    _Showlist := False;

  I := 0;
  LW := 0;
  While (I<_BarSlices*Pred(_Width)) Do
  Begin
    Inc(LW);
    Inc(I, _ListSlicesX);
  End;
  IntToString(LW+I);

  If (_ShowList) Then
  Begin
    ZOfs := 8;

    Self.DrawComponent(2, VectorCreate(0.0, _HandleHeight, ZOfs), 0.0, 0.0, 0.25, 0.25, ColorWhite);
    For I:=0 To LW Do
      Self.DrawComponent(2, VectorCreate(I*_ListSlicesX, _HandleHeight, ZOfs), 0.25, 0.0, 0.75, 0.25, ColorWhite);
    Self.DrawComponent(2, VectorCreate(LW*Pred(_ListSlicesX), _HandleHeight, ZOfs), 0.75, 0.0, 1.0, 0.25, ColorWhite);

    P := _Content.First;
    For J:=0 To Pred(_Content.Count) Do
    Begin
      YY := _HandleHeight+_ListSlicesY*J;
      Self.DrawComponent(2, VectorCreate(0.0, YY, ZOfs), 0.0, 0.25 , 0.25, 0.75, ColorWhite);
      For I:=0 To LW Do
        Self.DrawComponent(2, VectorCreate(I*_ListSlicesX, YY, ZOfs), 0.25, 0.25 , 0.75, 0.75, ColorWhite);
      Self.DrawComponent(2, VectorCreate(LW*Pred(_ListSlicesX), YY, ZOfs), 0.75, 0.25 , 1.0, 0.75, ColorWhite);

      {$IFNDEF MOBILE}
      If (J<>_ItemHighlight) Then
        MyColor := ColorGrey(64, Self.Color.A)
      Else
      {$ENDIF}
        MyColor := Self.Color;


      If Assigned(Self.Font) Then
      Begin
        S := P.ToString();
        If (S<>'') And (S[1]='#') Then
          S := StringManager.Instance.GetString(Copy(S, 2, MaxInt));

        Self.DrawText(S, VectorCreate(_ListWidth*0.25, _HandleHeight + _ListHeight * 0.25 + 8+_ListSlicesY*J, ZOfs + 0.5), MyColor, Scale);
      End;

      P := P.Next;
    End;
    YY := _HandleHeight+_ListSlicesY*Pred(_Content.Count);
    Self.DrawComponent(2, VectorCreate(0.0, YY, ZOfs), 0.0, 0.75, 0.25, 1.0, ColorWhite);
    For I:=0 To LW Do
      Self.DrawComponent(2, VectorCreate(I*_ListSlicesX, YY, ZOfs), 0.25, 0.75, 0.75, 1.0, ColorWhite);
    Self.DrawComponent(2, VectorCreate(LW*Pred(_ListSlicesX), YY, ZOfs), 0.75, 0.75, 1.0, 1.0, ColorWhite);
  End;

  Inherited;
End;

Procedure UIComboBox.UpdateRects();
Begin
  _Size.X := _HandlePos+_HandleWidth;
  _Size.Y := Self._HandleHeight;
End;

Procedure UIComboBox.Select(const Value: AnsiString);
Var
  P:ListObject;
  I:Integer;
Begin
  I := 0;
  P := _Content.First;
  While Assigned(P) Do
  If (P.ToString() = Value) Then
  Begin
    SetItemIndex(I);
    Exit;
  End Else
  Begin
    Inc(I);
    P := P.Next;
  End;
End;

{ UIEditText }
Constructor UIEditText.Create(Name:AnsiString; UI:UI; Parent:Widget; X, Y, Z: Single; Width:Integer; Skin:AnsiString; TabIndex:Integer);
Begin
  Self._Visible := True;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;

  If Skin = '' Then
    Skin := 'ui_edit';

  UI.AddWidget(Self);

  Self._TabIndex := TabIndex;
  Self.LoadComponent(Skin);
  Self.LoadComponent(Skin+'2');
  Self.Text := '';
  Self._Width := Width;

  Self.SetLineCount(1);
  Self._LineIndex := 0;
  Self._MaxLines := 0;

  Self._SelectedColor := ColorWhite;

  Self.PasswordField := False;
  Self.TextColor := ColorWhite;

  Self._KoreanInitialJamo := -1;
  Self._KoreanMedialJamo := -1;
  Self._KoreanFinalJamo := -1;

  Self._Clip := TERRA_SpriteManager.ClipRect.Create();

  If (Length(_ComponentList)>0) Then
  Begin
    _Height := Self._ComponentList[0].Buffer.Height;
  End;
End;

Procedure UIEditText.SetLineCount(const Value: Integer);
Begin
  If (LineCount = Value) Then
    Exit;

  _LineCount := Value;
  _MaxLines := 1;
  SetLength(_Lines, _LineCount);

  Self.UpdateRects();

  {If (LineCount>1) And (_HorScroll=Nil) Then
  Begin
    _HorScroll := UIScrollBar.Create(Name+'_horizontal_scroll', UI, Self, 0, 5, 1, 1, True);
    _HorScroll.Align := waBottomCenter;
    Repeat
      _HorScroll._Length := _HorScroll._Length + 1;
      _HorScroll.UpdateRects();
    Until (_HorScroll.Size.X>=Self.Size.X - 100);
  End;

  If (LineCount>1) And (_VertScroll=Nil) Then
  Begin
    _VertScroll := UIScrollBar.Create(Name+'_vertical_scroll', UI, Self, 5, 0, 1, 1, False);
    _VertScroll.Align := waRightCenter;
    Repeat
      _VertScroll._Length := _VertScroll._Length + 1;
      _VertScroll.UpdateRects();
    Until (_VertScroll.Size.Y>=Self.Size.Y - _Height);
  End;}
End;

Procedure UIEditText.UpdateRects();
Begin
  If (_ComponentList=Nil) Or (Self._ComponentList[0]=Nil) Then
    Exit;

  _Size.X := (Self._ComponentList[0].Buffer.Width/2)+(Self._ComponentList[0].Buffer.Width/4)*(Self._Width);
  _Size.Y := _LineCount * _Height;
End;

Procedure UIEditText.SetFocus(ShowKeyboard:Boolean);
Begin
  UI.Focus := Self;
  If Not ShowKeyboard Then
    Exit;

  {$IFDEF MOBILE}
  {$IFDEF VIRTUALKEYBOARD}
  If (Not UseNativeKeyboard) Then
    VirtualKeyboard(UI.VirtualKeyboard).ShowFocus()
  Else
  {$ENDIF}
  focusKeyboard(PAnsiChar(Self.Text));
  {$ELSE}
  {$IFDEF VIRTUALKEYBOARD}
  VirtualKeyboard(UI.VirtualKeyboard).ShowFocus();
  {$ENDIF}
  {$ENDIF}
End;

Function UIEditText.OnMouseUp(X, Y: Integer; Button: Word): Boolean;
Begin
  RemoveHint(X+Y+Button); //TODO - check this stupid hint
  {If (Assigned(Self._HorScroll)) And (_HorScroll.OnRegion(X,Y)) Then
  Begin
    Result := _HorScroll.OnMouseUp(X, Y, Button);
    Exit;
  End;

  If (Assigned(Self._VertScroll)) And (_VertScroll.OnRegion(X,Y)) Then
  Begin
    Result := _VertScroll.OnMouseUp(X, Y, Button);
    Exit;
  End;}

  Result := False;
End;

Function UIEditText.OnMouseDown(X, Y: Integer; Button: Word): Boolean;
Var
  I:Integer;
Begin
  Result := False;

  If Not Visible Then
    Exit;

  RemoveHint(Button); //TODO - check this stupid hint

  {If (Assigned(Self._HorScroll)) And (_HorScroll.OnRegion(X,Y)) Then
  Begin
    Result := _HorScroll.OnMouseDown(X, Y, Button);
    Exit;
  End;

  If (Assigned(Self._VertScroll)) And (_VertScroll.OnRegion(X,Y)) Then
  Begin
    Result := _VertScroll.OnMouseDown(X, Y, Button);
    Exit;
  End;}

  //Pos := Self.GetAbsolutePosition();
  If (OnRegion(X,Y)) Then
  Begin
    SetFocus(True);
    Result := True;
  End;
End;

Procedure UIEditText.Render;
Var
  I,J,N, Count:Integer;
  A,B,X:Single;
  MyColor:TERRA_Color.Color;
  S:AnsiString;
  P, Tx:Vector2D;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();

  P := Self.GetAbsolutePosition();
  _Clip.X := P.X;
  _Clip.Y := P.Y;
  _Clip.Width := Size.X;
  _Clip.Height := Size.Y;
  Self._ClipRect := _Clip;

  If (UI.Highlight<>Nil) And (Not Self.IsHighlighted())
  And (UI.Focus=Self) And (Pos('KEY_', UI.Highlight.Name)<>1) Then
    UI.Focus := Nil;

  Self.UpdateHighlight((UI.Focus = Self));

  If (UI.Focus <> Self) And (Self.IsHighlighted()) Then
    Self.SetFocus(False);

  MyColor := ColorScale(Self.GetColor(), _SelectedColor);

  TextColor.A := MyColor.A;

  For J:=1 To _LineCount Do
  Begin
    If (_LineCount<=1) Then
      N := 0
    Else
      N := 1;

    Self.DrawComponent(N, VectorCreate(0, _Height * Pred(J), 0), 0.0, 0.0, 1.0/4, 1.0, MyColor, False);
    For I:=1 To _Width Do
    Begin
      If (Odd(I)) Then
        Self.DrawComponent(N, VectorCreate(-32+I*32, _Height * Pred(J), 0.0), 0.25, 0.0, 0.5, 1.0, MyColor, False)
      Else
        Self.DrawComponent(N, VectorCreate(-64+I*32, _Height * Pred(J), 0.0), 0.5, 0.0, 0.75, 1.0, MyColor, False);
    End;
    Self.DrawComponent(N, VectorCreate(-96+Succ(_Width)*32, _Height * Pred(J), 0.0), 0.75, 0.0, 1.0, 1.0, MyColor, False);
  End;

  Count := 0;
  For J:=0 To Pred(_LineCount) Do
  If (_Lines[J]<>'') Then
  Begin
    Inc(Count);

    If PasswordField Then
    Begin
      SetLength(S, Length(_Lines[J]));
      For I:=1 To Length(_Lines[J]) Do
        S[I] := '*';
    End Else
      S := _Lines[J];

    Tx := Self.Font.GetTextRect(S, 1.0);
    Tx.Y := Self.Font.GetTextHeight('W', 1.0);

    If (UI.Focus = Self) And (J=_LineIndex) And (Blink(200)) Then
      S := S +'_';

    If (Centered) Then
      X := (Self.Size.X-Tx.X)*0.5
    Else
      X := 10;

    Self.DrawText(S, VectorCreate(X-_ScrollIndex, _Height * J + (_Height-Tx.Y)*0.5, 1.0), ColorScale(Self.TextColor, 0.75), Scale, False);
  End;

  If (Caption<>'') And (Count = 0) Then
  Begin
    Tx := Self.Font.GetTextRect(Caption, 1.0);
    If (Centered) Then
      X := (Self.Size.X-Tx.X)*0.5
    Else
      X := 10;

    Self.DrawText(Caption, VectorCreate(X, (Self.Size.Y-Tx.Y)*0.5, 1.0), ColorScale(Self.TextColor, 0.75), Scale, False);
  End;

  Inherited;
End;


Procedure UIEditText.UpdateJamos;
Var
  Jamo:Word;
  N:Integer;
Begin
  Delete(_Lines[_LineIndex], Length(_Lines[_LineIndex])-2, 3);
  If (_KoreanMedialJamo>=0) Then
  Begin
    If (_KoreanFinalJamo>=0) Then
      N := _KoreanFinalJamo
    Else
      N := 0;
    Jamo := (_KoreanInitialJamo*588)+(_KoreanMedialJamo*28)+N+44032;
  End Else
    Jamo := _KoreanBaseJamo;
  _Lines[_LineIndex] := _Lines[_LineIndex] + UnicodeToUCS2(Jamo);
End;

Function UIEditText.OnKeyPress(Key:Word): Boolean;
Var
  I, Len:Integer;
  KeyValue:AnsiString;
  W,W2:Single;
  ChangedLine, Found:Boolean;
  It:Iterator;
  Wd:Widget;
Begin
  If (Not Self.Visible) Then
  Begin
    Result := False;
    Exit;
  End;

  If (Key = keyShift) Or (Key = keyControl) Or (Key = keyAlt) Then
  Begin
    Result := False;
    Exit;
  End;

  {$IFDEF DEBUG_CORE}Log(logDebug, 'UI', 'EditText: Got key : '+IntToString(Key));{$ENDIF}
  {$IFDEF DEBUG_CORE}Log(logDebug, 'UI', 'Backspace Is  '+IntToString(keyBackspace));{$ENDIF}

  ChangedLine := False;

  If (Key = keyBackspace) Then
  Begin
    W := Self.Font.GetTextWidth(_Lines[_LineIndex]);

    If (_KoreanFinalJamo>=0) Then
    Begin
      _KoreanFinalJamo := -1;
      UpdateJamos();
    End Else
    If (_KoreanMedialJamo>=0) Then
    Begin
      _KoreanMedialJamo := -1;
      UpdateJamos();
    End Else
    Begin
      _KoreanInitialJamo := -1;
      Len := ucs2_Length(_Lines[_LineIndex]);

      If (Length(_Lines[_LineIndex])>=2) And (ucs2_ascii(_Lines[_LineIndex], Len-1)='\') Then
        _Lines[_LineIndex] := ucs2_copy(_Lines[_LineIndex], 1, Len-2)
      Else
      If (_Lines[_LineIndex]<>'') Then
      Begin
        I := Len;
        If (ucs2_ascii(_Lines[_LineIndex], I)='}') Then
        Begin
          While (I>=1) Do
          If (ucs2_ascii(_Lines[_LineIndex], I)='\') Then
            Break
          Else
            Dec(I);

          If (I>0) Then
            _Lines[_LineIndex] := ucs2_Copy(_Lines[_LineIndex], 1, Pred(I))
          Else
            _Lines[_LineIndex] := ucs2_Copy(_Lines[_LineIndex], 1, Pred(Len));
        End Else
          _Lines[_LineIndex] := ucs2_Copy(_Lines[_LineIndex], 1, Pred(Len));
      End Else
      If (_LineCount>1) And (_LineIndex>0) Then
      Begin
        Dec(_LineIndex);
        ChangedLine := True;
        W := Self.Font.GetTextWidth(_Lines[_LineIndex]);
        If (W>_Width*32) Then
          _ScrollIndex := W - (_Width*32)
        Else
          _ScrollIndex := 0;
      End;
    End;

    W2 := Self.Font.GetTextWidth(_Lines[_LineIndex]);
    If (Not ChangedLine) And (_ScrollIndex>0) And (W2<W) Then
      _ScrollIndex := _ScrollIndex - (W-W2);
  End Else
  If (Key = keyEnter) Then
  Begin
    If (_LineCount>1) And (_LineIndex<Pred(_LineCount)) Then
    Begin
      Inc(_LineIndex);
      _ScrollIndex := 0;
      _MaxLines := _LineIndex;
    End;

    If Assigned(OnEnter) Then
      OnEnter(Self);
  End Else
  If (Key = keyTab) Then
  Begin
    Found := False;
    It := UI.Widgets.CreateIterator();
    While It.HasNext Do
    Begin
      Wd := Widget(It.GetNext());
      If (Wd.Visible) And (Wd<>Self) And (Wd Is UIEditText) And (WD.Position.Y>Self.Position.Y) Then
      Begin
        UIEditText(Wd).SetFocus(True);
        Found := True;
        Break;
      End;
    End;
    It.Destroy();

    If Not Found Then
    Begin
      It := UI.Widgets.CreateIterator();
      While It.HasNext Do
      Begin
        Wd := Widget(It.GetNext());
        If (Wd.Visible) And (Wd<>Self) And (Wd Is UIEditText) And (WD.Position.Y<=Self.Position.Y) Then
        Begin
          UIEditText(Wd).SetFocus(True);
          Found := True;
          Break;
        End;
      End;
      It.Destroy();
    End;
  End Else
  Begin
    KeyValue := UnicodeToUCS2(Key);

    If (Assigned(Self.Font)) Then
    Begin
      W := Self.Font.GetTextWidth(_Lines[_LineIndex]);

      If (_KoreanInitialJamo<0) Or (_KoreanFinalJamo>=0) Then
      Begin
        _KoreanInitialJamo := GetKoreanInitialJamo(Key);
        _KoreanMedialJamo := -1;
        _KoreanFinalJamo := -1;
        _KoreanBaseJamo := Key;
        _Lines[_LineIndex] := _Lines[_LineIndex] + KeyValue;
      End Else
      If (_KoreanMedialJamo<0) And (_KoreanFinalJamo<0) Then
      Begin
        _KoreanMedialJamo := GetKoreanMedialJamo(Key);
        If _KoreanMedialJamo<0 Then
        Begin
          _KoreanInitialJamo := GetKoreanInitialJamo(Key);
          _Lines[_LineIndex] := _Lines[_LineIndex] + KeyValue;
        End Else
          UpdateJamos();
      End Else
      If (_KoreanFinalJamo<0) Then
      Begin
        _KoreanFinalJamo := GetKoreanFinalJamo(Key);

        If (_KoreanFinalJamo<0) Then
        Begin
          _KoreanInitialJamo := GetKoreanInitialJamo(Key);
          _KoreanMedialJamo := -1;
          _Lines[_LineIndex] := _Lines[_LineIndex] + KeyValue;
        End Else
          UpdateJamos();
      End Else
      Begin
        _Lines[_LineIndex] := _Lines[_LineIndex] + KeyValue;
      End;

      W2 := Self.Font.GetTextWidth(_Lines[_LineIndex]);
      If (W2>_Width*32) And (W2>W) Then
        _ScrollIndex := _ScrollIndex + (W2-W);
    End;
  End;
  Result := True;
End;

Procedure UISlider.SetValue(X: Single);
Begin
  _Changed := (_Value <> X);
  _Value := X;
End;

Procedure UIEditText.SetText(const Value:AnsiString);
Begin
  Self._KoreanInitialJamo := -1;
  Self._KoreanMedialJamo := -1;
  Self._KoreanFinalJamo := -1;

  If (_LineCount<1) Then
    SetLineCount(1);

  Self._ScrollIndex := 0;
  Self._Lines[0] := Value;
End;

Function UIEditText.GetText:AnsiString;
Var
  I:Integer;
Begin
  If (_LineCount=1) Then
    Result := _Lines[0]
  Else
  Begin
    Result := '';
    For I:=0 To _LineIndex Do
    Begin
      Result := Result + _Lines[I];
      If (I<_LineIndex) Then
        Result := Result + '\n';
    End;
  End;
End;


Function UIEditText.GetCurrentLine:AnsiString;
Begin
  Result := _Lines[_LineIndex];
End;

Procedure UIEditText.SetCurrentLine(const Value:AnsiString);
Begin
  _Lines[_LineIndex] := Value;
End;

Procedure UIEditText.StartHighlight;
Begin
  _SelectedColor := ColorBlack;
End;

Procedure UIEditText.StopHighlight;
Begin
  _SelectedColor := ColorWhite;
End;

Destructor UIEditText.Destroy;
Begin
  DestroyObject(@Self._Clip);

  Inherited;
End;

{ UILayout }
Constructor UILayout.Create(Name:AnsiString; UI:UI; X,Y,Z:Single; Width,Height, LayoutMode:Integer; TabIndex:Integer=-1);
Begin
  RemoveHint(LayoutMode);
  
  Self._Visible := True;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;

  Self._TabIndex := TabIndex;
  Self._Width := Width;
  Self._Height := Height;
  Self.VerticalSpacing := 10;
  Self.HorizontalSpacing := 10;
  UI.AddWidget(Self);
End;



{Procedure UILayout.Render;
Var
  Pos, Size:Vector2D;
  X,Y, Max:Single;
  I:Integer;
Begin
  Pos := Self.GetPosition;
  X := 0;
  Y := 0;
  Max := 0;

  For I:=0 To Pred(_ChildrenCount) Do
  Begin
    _ChildrenList[I].Align := waTopLeft;
    _ChildrenList[I].Position := VectorCreate2D(X, Y);
    _ChildrenList[I].Render;

    Size := _ChildrenList[I].Size;

    Case LayoutMode Of
    layoutHorizontal:
      Begin
        If (Size.Y>Max) Then
          Max := Size.Y;
        X := X + Size.X + HorizontalSpacing;
        If (X>=Width) Then
        Begin
          X := 0;
          Y := Y + Max + VerticalSpacing;
          Max := 0;
        End;
      End;

    layoutVertical:
      Begin
        If (Size.X>Max) Then
          Max := Size.X;
        Y := Y + Size.Y + VerticalSpacing;
        If (X>=Width) Then
        Begin
          Y := 0;
          X := X + Max + HorizontalSpacing;
          Max := 0;
        End;
      End;

    End;
  End;
End;}

Procedure UILayout.Render;
Var
  Size:Vector2D;
  X,Y, Padding, Max:Single;
  I:Integer;
  W:Widget;
Begin
  _Size.X := _Width;
  _Size.Y := _Height;

  Self.UpdateRects();
  Self.UpdateTransform();

  Case LayoutMode Of
    layoutHorizontal: Max := HorizontalSpacing;
    layoutVertical: Max := VerticalSpacing;
  End;

  Max := 0.0;
  For I:=0 To Pred(Self.ChildrenCount) Do
  Begin
    W := Self.GetChild(I);
    If (W=Nil) Or (Not W.Visible) Then
      Continue;

    W.UpdateRects();

    Case LayoutMode Of
      layoutHorizontal: Max := Max + W.Size.X + HorizontalSpacing;
      layoutVertical: Max := Max + W.Size.Y + VerticalSpacing;
    End;
  End;

  Padding := 0.0;
  Case LayoutMode Of
    layoutHorizontal: Padding := Width - Max;
    layoutVertical: Padding := Height - Max;
  End;

  If (Padding<0) Then
    Padding := 0;
  Padding := Padding * 0.5;

  X := 0;
  Y := 0;
  Case LayoutMode Of
    layoutHorizontal:
      Begin
        X := Padding; Y := 0;
      End;
    layoutVertical:
      Begin
        X := 0; Y := Padding;
      End;
  End;

  For I:=0 To Pred(Self.ChildrenCount) Do
  Begin
    W := Self.GetChild(I);
    If (W=Nil) Or (Not W.Visible) Then
      Continue;

    W.Align := waTopLeft;
    W.Position := VectorCreate2D(X, Y);
    W.Render();

    Size := W.Size;

    Case LayoutMode Of
      layoutHorizontal:
      Begin
        If (Size.Y>Max) Then
          Max := Size.Y;
        X := X + Size.X + HorizontalSpacing;
        If (X>=Width) Then
        Begin
          X := Padding;
          Y := Y + Max + VerticalSpacing;
          Max := 0;
        End;
      End;

    layoutVertical:
      Begin
        If (Size.X>Max) Then
          Max := Size.X;
        Y := Y + Size.Y + VerticalSpacing;
        If (X>=Width) Then
        Begin
          Y := Padding;
          X := X + Max + HorizontalSpacing;
          Max := 0;
        End;
      End;

    End;
  End;

  Inherited;
End;

{ UISprite }
Constructor UISprite.Create(Name:AnsiString; UI:UI; Parent:Widget; X, Y, Z: Single;  Picture:AnsiString; TabIndex: Integer);
Begin
  Self._Visible := True;
  Self._TabIndex := TabIndex;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self.BilinearFilter := False;

  UI.AddWidget(Self);

  Self.Rect.U1 := 0;
  Self.Rect.U2 := 1.0;
  Self.Rect.V1 := 0;
  Self.Rect.V2 := 1.0;

  If (Picture<>'') Then
  Begin
    Self.Rect.Texture := TextureManager.Instance.GetTexture(Picture);

    If (Assigned(Self.Rect.Texture)) Then
      Self.Rect.Texture.PreserveQuality := True
    Else
      Log(logWarning, 'UI', 'Missing texture for SpriteWidget: '+Picture);
  End Else
    Self.Rect.Texture := Nil;


  Self.Pivot := VectorCreate2D(0, 0);
  Self.Anchor := VectorCreate2D(0, 0);
End;

Function UISprite.OnMouseDown(X, Y: Integer; Button: Word): Boolean;
Var
    Pos:Vector2D;
Begin
  Result := Inherited OnMouseDown(X,Y, Button);

  If (OnRegion(X,Y)) And (Assigned(OnMouseClick)) And (Self.Visible) Then
  Begin
    If (Not Self.HasTweens) Then
    Begin
      Self.OnHit();
      OnMouseClick(Self);
    End;
    Result := True;
  End;
End;

Function UISprite.OnMouseUp(X, Y: Integer; Button: Word): Boolean;
Var
    Pos:Vector2D;
Begin
  RemoveHint(Button);

  If (OnRegion(X,Y)) And (Self.Visible) And (Assigned(OnMouseClick)) Then
  Begin
    Result := True;
  End Else
    Result := False;
End;

Function UISprite.OnRegion(X, Y: Integer): Boolean;
Var
  WH, Pos:Vector2d;
  OfsX, OfsY:Single;
Begin
  If (OutsideClipRect(X,Y)) Then
  Begin
    Result := False;
    Exit;
  End;

  Pos := Self.GetAbsolutePosition;
  Self.GetScrollOffset(OfsX, OfsY);
  Pos.X := Pos.X + OfsX;
  Pos.Y := Pos.Y + OfsY;

  WH := Self.Size;

  Result := (X>=Pos.X) And (Y>=Pos.Y) And (X<=Pos.X+WH.X*Scale) And (Y<=Pos.Y+WH.Y*Scale);
End;

Procedure UISprite.Render;
Var
  ID:Integer;
  MyColor:TERRA_Color.Color;
  S:Sprite;
  Temp, Pos, Center:Vector2D;
  OfsX, OfsY, Layer:Single;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();

  Layer := Self.GetLayer;

  If (Not DisableHighlights) And (Assigned(Self.OnMouseClick)) Then
    Self.UpdateHighlight();

  MyColor := Self.Color;

  {$IFDEF OUYA}
  If (UI.Highlight<>Nil) And (Not Self.IsHighlighted) And (Assigned(Self.OnMouseClick)) Then
    MyColor := ColorGrey(64);
  {$ENDIF}

  If Rect.Texture=Nil Then
    Exit;

  Self.GetScrollOffset(OfsX, OfsY);
  If (OfsX<>0) Or (OfsY<>0) Then
  Begin
    Temp := _Position;
    _Position.X := _Position.X + OfsX;
    _Position.Y := _Position.Y + OfsY;
    Self._TransformChanged := True;
    Self.UpdateTransform();

    Pos := Self.GetAbsolutePosition();
    _Position := Temp;
  End Else
    Pos := Self.GetAbsolutePosition();

  If (Pos.X>UIManager.Instance.Width) Or (Pos.Y>UIManager.Instance.Height)
  Or (Pos.X<-Size.X) Or (Pos.Y<-Size.Y) Then
    Exit;


  Center := Self.GetSize();
  Center.X := Center.X * _Pivot.X * Scale;
  Center.Y := Center.Y * _Pivot.Y * Scale;
  Center.Add(Pos);

  S := SpriteManager.Instance.AddSprite(Pos.X, Pos.Y, 100-Layer, Rect.Texture, Nil, BlendBlend, Self.GetSaturation(), BilinearFilter);
  S.Anchor := Anchor;
  S.SetColor(MyColor);
  S.Rect := Rect;
  S.SetTransform(_Transform);
  S.Flip := Self.Flip;
  S.ClipRect := Self.ClipRect;
  S.Mirror := Self.Mirror;

  Inherited;
End;

Procedure UISprite.SetTexture(Tex: Texture);
Begin
  If Tex = Nil Then
    Exit;
    
  Self.Rect.Texture := Tex;
  Self.Rect.Width := Tex.Width;
  Self.Rect.Height := Tex.Height;
  Self.Rect.U1 := 0.0;
  Self.Rect.V1 := 0.0;
  Self.Rect.U2 := 1.0;
  Self.Rect.V2 := 1.0;
End;

Procedure UISprite.UpdateRects();
Begin
  If Assigned(Rect.Texture) Then
  Begin
    Rect.Texture.Prefetch();

    If (Rect.Width<=0) Then
      Rect.Width := Trunc(SafeDiv(Rect.Texture.Width, Rect.Texture.Ratio.X));

    If (Rect.Height<=0) Then
      Rect.Height := Trunc(SafeDiv(Rect.Texture.Height, Rect.Texture.Ratio.Y));
  End;

  _Size.X := Rect.Width;
  _Size.Y := Rect.Height;
End;



{ UITooltip }
Constructor UITooltip.Create(Name: AnsiString; UI: UI; Parent: Widget; X, Y, Z: Single; Caption, Skin:AnsiString);
Begin
  Self._Visible := True;
  Self._TabIndex := -1;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self._Width := 0;
  Self._Height := 0;
  Self.DropShadow := True;

  Self.SetCaption(Caption);
  _NeedsUpdate := True;

  If Skin = '' Then
    Skin := 'ui_tooltip';

  Self.LoadComponent(Skin);
  UI.AddWidget(Self);

  If (Length(_ComponentList)>0) Then
  Begin
    _Width := Self._ComponentList[0].Buffer.Width;
    _Height := Self._ComponentList[0].Buffer.Height;
  End;
End;

Procedure UITooltip.Render;
Var
  I:Integer;
  MyColor:TERRA_Color.Color;
  TX, TY:Single;
Begin
  MyColor := Self.GetColor();

  Self.DrawComponent(0, VectorZero, 0.0, 0.0, 0.25, 1.0, MyColor);
  For I:=1 To _Sections Do
    Self.DrawComponent(0, VectorCreate(_Width*0.25*I, 0, 0), 0.25, 0.0, 0.75, 1.0, MyColor);
  Self.DrawComponent(0, VectorCreate(_Width*0.25*Succ(_Sections), 0, 0), 0.75, 0.0, 1.0, 1.0, MyColor);

  TX := (Self._Size.X - _TextRect.X) * 0.5;
  TY := (Self._Size.Y - _TextRect.Y) * 0.5;

  Self.DrawText(_Caption, VectorCreate(TX, TY, 0.25), MyColor, 1.0, Self.DropShadow);
End;

Procedure UITooltip.UpdateRects;
Begin
  _Size.X := Succ(_Sections) * _Width * 0.5;
  _Size.Y := _Height;
End;

{ UITabList }
Constructor UITabList.Create(Name: AnsiString; UI: UI; Parent: Widget; X, Y, Z: Single; ComponentBG: AnsiString);
Begin
  Self._Visible := True;
  Self._Name := Name;
  Self._Parent := Parent;
  Self.SetPosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self._TabIndex := -1;
  {Self._Width := Width;
  Self._Height := Height;}

  If (ComponentBG='') Then
    ComponentBG := 'ui_tab';

  Self.LoadComponent(ComponentBG+'_on');
  Self.LoadComponent(ComponentBG+'_off');
  UI.AddWidget(Self);

  If Assigned(Parent) Then
    Parent.TabControl := Self;

  If (Length(_ComponentList)>0) Then
  Begin
    _TabWidthOn := Self._ComponentList[0].Buffer.Width;
    _TabHeightOn := Self._ComponentList[0].Buffer.Height;
  End;

  If (Length(_ComponentList)>1) Then
  Begin
    _TabWidthOff := Self._ComponentList[1].Buffer.Width;
    _TabHeightOff := Self._ComponentList[1].Buffer.Height;
  End;

  Self.UpdateRects();
End;


Procedure UITabList.ClearTabs;
Begin
  _TabCount := 0;
End;

Procedure UITabList.AddTab(Name: AnsiString; Index: Integer);
Var
  I:Integer;
Begin
  For I:=0 To Pred(_TabCount) Do
  If (_Tabs[I].Index = Index) Then
  Begin
    _Tabs[I].Name := Name;
    Exit;
  End;

  Inc(_TabCount);
  SetLength(_Tabs, _TabCount);
  _Tabs[Pred(_TabCount)].Name := Name;
  _Tabs[Pred(_TabCount)].Index := Index;
  _Tabs[Pred(_TabCount)].Visible := True;
End;

Procedure UITabList.SetTabVisibility(Index: Integer; Visibility: Boolean);
Var
  I,J:Integer;
Begin
  For I:=0 To Pred(_TabCount) Do
  If (_Tabs[I].Index = Index) Then
  Begin
    _Tabs[I].Visible := Visibility;
    If (Not Visibility) And (_SelectedIndex = Index) Then
    Begin
      For J:=0 To Pred(_TabCount) Do
      If (_Tabs[J].Visible) Then
      Begin
        _SelectedIndex := J;
        Break;
      End;
    End;

    Exit;
  End;
End;

Procedure UITabList.UpdateRects;
Begin
  _Size.X := _TabWidthOff * Pred(_TabCount) + _TabWidthOn;
  _Size.Y := FloatMax(_TabHeightOn, _TabHeightOff);
End;

Function UITabList.GetTabAt(X, Y: Integer): Integer;
Var
  I:Integer;
  P:Vector2D;
  TX,WW:Single;
Begin
  P := Self.GetAbsolutePosition();

  TX := P.X;
  For I:=0 To Pred(_TabCount) Do
  If (_Tabs[I].Visible) Then
  Begin
    If (_Tabs[I].Index = Self._SelectedIndex) Or (_Tabs[I].Index = _TabHighlight) Then
      WW := _TabWidthOn
    Else
      WW := _TabWidthOff;

    If (X>=TX) And (X<TX+WW) And (Y>=P.Y) And (Y<P.Y+_TabHeightOn)Then
    Begin
      Result := _Tabs[I].Index;
      Exit;
    End;

    TX := TX + WW;
  End;

  Result := -1;
End;

Function UITabList.GetSelectedCaption: AnsiString;
Var
  I:Integer;
Begin
  For I:=0 To Pred(_TabCount) Do
  If (_Tabs[I].Index = Self._SelectedIndex) Then
  Begin
    Result := _Tabs[I].Name;
    Exit;
  End;

  Result := '';
End;

Procedure UITabList.Render;
Var
  I:Integer;
  MyColor:TERRA_Color.Color;
  Fnt:TERRA_Font.Font;
  Rect:Vector2D;
  X, WW, HH, Add:Single;
  IsSel:Boolean;
Begin
  Self.UpdateRects();
  Self.UpdateTransform();

  If (Not DisableHighlights) Then
    Self.UpdateHighlight();

  If (_TabCount<=0) Then
    Exit;

  X := 0.0;
  For I:=0 To Pred(_TabCount) Do
  If (_Tabs[I].Visible) Then
  Begin
    IsSel := (I=_TabHighlight) Or (I=_SelectedIndex);

    GetTabProperties(IsSel, MyColor, Fnt);

    If (IsSel) Then
    Begin
      Self.DrawComponent(0, VectorCreate(X, 0, 0), 0.0, 0.0, 1.0, 1.0, MyColor);
      WW := _TabWidthOn;
      HH := _TabHeightOn;
      Add := 0;
    End Else
    Begin
      Self.DrawComponent(1, VectorCreate(X, _TabHeightOn - _TabHeightOff, 0), 0.0, 0.0, 1.0, 1.0, MyColor);
      WW := _TabWidthOff;
      HH := _TabHeightOff;
      Add := _TabHeightOn - _TabHeightOff;
    End;

    Rect := Fnt.GetTextRect(_Tabs[I].Name);
    Self.DrawText(_Tabs[I].Name, VectorCreate(X + ((WW-Rect.X) * 0.5), Add + (HH - Rect.Y) * 0.5, 1.0), MyColor, Scale, True, Fnt);

    X := X + WW;
  End;
End;

Function UITabList.OnMouseDown(X, Y: Integer; Button: Word): Boolean;
Var
  N:Integer;
Begin
  N := GetTabAt(X, Y);

  If (N>=0) And (N<>_SelectedIndex) Then
  Begin
    _SelectedIndex := N;
    _TabHighlight := -1;

    Self.OnHit();

    Result := True;
    Exit;
  End;

  Result := Inherited OnMouseDown(X,Y, Button);
End;

Function UITabList.OnMouseMove(X,Y:Integer):Boolean;
Var
  I:Integer;
Begin
  {Result := False;

  If (Visible) Then
  Begin
    _TabHighlight := GetTabAt(X,Y);
  End;}

  Result := Inherited OnMouseMove(X,Y);
End;

Procedure UITabList.GetTabProperties(const Selected: Boolean; Out TabColor: Color; Out TabFont: Font);
Begin
  If Selected Then
    TabColor := Self.Color
  Else
    TabColor := ColorGrey(200, Self.Color.A);

  TabFont := Self.GetFont();
End;

End.

