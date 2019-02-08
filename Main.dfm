object BAD: TBAD
  Left = 0
  Top = 0
  Caption = 'BAD'
  ClientHeight = 358
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusHPMP: TLabel
    Left = 8
    Top = 220
    Width = 56
    Height = 13
    Caption = 'HP: 0 MP: 0'
  end
  object Label1: TLabel
    Left = 152
    Top = 220
    Width = 34
    Height = 13
    Caption = 'Gold: 0'
  end
  object mLog: TMemo
    Left = 0
    Top = 246
    Width = 323
    Height = 112
    Align = alBottom
    TabOrder = 0
  end
  object Button6: TButton
    Left = 258
    Top = 211
    Width = 65
    Height = 33
    Caption = 'Auto-Buff'
    TabOrder = 1
    OnClick = Button6Click
  end
  object Button8: TButton
    Left = 263
    Top = 460
    Width = 73
    Height = 25
    Caption = 'Button8'
    TabOrder = 2
  end
  object Button9: TButton
    Left = -8
    Top = 431
    Width = 113
    Height = 25
    Caption = 'Button9'
    TabOrder = 3
  end
  object TnPages: TTabbedNotebook
    Left = 0
    Top = 0
    Width = 323
    Height = 214
    Align = alTop
    PageIndex = 3
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'Tahoma'
    TabFont.Style = []
    TabOrder = 4
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Game'
      object StatusG: TGroupBox
        Left = 0
        Top = 0
        Width = 315
        Height = 186
        Align = alClient
        TabOrder = 0
        object chAutoGrupo: TCheckBox
          Left = 3
          Top = 11
          Width = 74
          Height = 17
          Caption = 'AutoGrupo'
          TabOrder = 0
          OnClick = chAutoGrupoClick
        end
        object chRevive: TCheckBox
          Left = 2
          Top = 34
          Width = 53
          Height = 25
          Caption = 'Revive'
          TabOrder = 1
        end
        object Button5: TButton
          Left = 3
          Top = 154
          Width = 53
          Height = 27
          Caption = 'charlist'
          TabOrder = 2
          OnClick = Button5Click
        end
        object Button17: TButton
          Left = 216
          Top = 156
          Width = 66
          Height = 25
          Caption = 'Trocar char'
          TabOrder = 3
          OnClick = Button17Click
        end
        object _charSlot: TLabeledEdit
          Left = 288
          Top = 160
          Width = 24
          Height = 21
          EditLabel.Width = 18
          EditLabel.Height = 13
          EditLabel.Caption = 'Slot'
          TabOrder = 4
          Text = '0'
        end
        object GroupBox1: TGroupBox
          Left = 226
          Top = 3
          Width = 86
          Height = 87
          Caption = 'Relog/Dead'
          TabOrder = 5
          object rdPerga: TRadioButton
            Left = 3
            Top = 21
            Width = 80
            Height = 19
            Caption = 'Usar Perga'
            TabOrder = 0
            OnClick = rdPergaClick
          end
          object rdRota: TRadioButton
            Left = 3
            Top = 46
            Width = 46
            Height = 16
            Caption = 'Rota'
            TabOrder = 1
            OnClick = rdRotaClick
          end
          object RadioButton3: TRadioButton
            Left = 3
            Top = 68
            Width = 46
            Height = 15
            Caption = 'N/D'
            Checked = True
            TabOrder = 2
            TabStop = True
          end
        end
        object chLog: TCheckBox
          Left = 3
          Top = 65
          Width = 39
          Height = 25
          Caption = 'Log'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object Button7: TButton
          Left = 62
          Top = 154
          Width = 39
          Height = 27
          Caption = 'World'
          TabOrder = 7
          OnClick = Button7Click
        end
        object Button4: TButton
          Left = 55
          Top = 88
          Width = 49
          Height = 33
          Caption = 'Button4'
          TabOrder = 8
          OnClick = Button4Click
        end
        object Edit1: TEdit
          Left = 112
          Top = 88
          Width = 41
          Height = 21
          TabOrder = 9
          Text = 'Edit1'
        end
        object Edit2: TEdit
          Left = 168
          Top = 96
          Width = 49
          Height = 21
          TabOrder = 10
          Text = 'Edit2'
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Move'
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 315
        Height = 186
        Align = alClient
        TabOrder = 0
        object Button10: TButton
          Left = 3
          Top = 3
          Width = 38
          Height = 25
          Caption = 'Move'
          TabOrder = 0
          OnClick = Button10Click
        end
        object vMove: TEdit
          Left = 47
          Top = 7
          Width = 74
          Height = 21
          TabOrder = 1
        end
        object ListBox1: TListBox
          Left = 3
          Top = 72
          Width = 86
          Height = 109
          ItemHeight = 13
          TabOrder = 2
          OnClick = ListBox1Click
        end
        object Button11: TButton
          Left = 2
          Top = 44
          Width = 89
          Height = 25
          Caption = 'Carregar'
          TabOrder = 3
          OnClick = Button11Click
        end
        object mCoords: TMemo
          Left = 223
          Top = 3
          Width = 89
          Height = 151
          TabOrder = 4
        end
        object Button12: TButton
          Left = 223
          Top = 158
          Width = 89
          Height = 25
          Caption = 'Mover'
          TabOrder = 5
          OnClick = Button12Click
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Skill'
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 315
        Height = 186
        Align = alClient
        TabOrder = 0
        object chMagic: TCheckBox
          Left = 3
          Top = 26
          Width = 46
          Height = 17
          Caption = 'Skill'
          TabOrder = 0
          OnClick = chMagicClick
        end
        object chFis: TCheckBox
          Left = 2
          Top = 3
          Width = 62
          Height = 17
          Caption = 'Padr'#227'o'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = chFisClick
        end
        object ChAutoBuff: TCheckBox
          Left = 3
          Top = 49
          Width = 63
          Height = 17
          Caption = 'AutoBuff'
          TabOrder = 2
          OnClick = ChAutoBuffClick
        end
        object chEvok: TCheckBox
          Left = 3
          Top = 72
          Width = 46
          Height = 25
          Caption = 'Evok'
          TabOrder = 3
          OnClick = chEvokClick
        end
        object LabeledEdit2: TLabeledEdit
          Left = 158
          Top = 22
          Width = 83
          Height = 21
          EditLabel.Width = 153
          EditLabel.Height = 13
          EditLabel.Caption = 'BM Trans/Evok Ranger MG/DMG'
          TabOrder = 4
          Text = '64 36 0 0'
        end
        object Button2: TButton
          Left = 247
          Top = 21
          Width = 56
          Height = 22
          Caption = 'Setar'
          TabOrder = 5
          OnClick = Button2Click
        end
        object onMob: TCheckBox
          Left = 3
          Top = 96
          Width = 58
          Height = 25
          Caption = 'On Mob'
          TabOrder = 6
          OnClick = onMobClick
        end
        object _oMob: TLabeledEdit
          Left = 3
          Top = 154
          Width = 309
          Height = 21
          EditLabel.Width = 44
          EditLabel.Height = 13
          EditLabel.Caption = 'List Mobs'
          TabOrder = 7
        end
        object chBuild: TCheckBox
          Left = 160
          Top = 72
          Width = 81
          Height = 17
          Caption = 'chBuild'
          Checked = True
          State = cbChecked
          TabOrder = 8
          OnClick = chBuildClick
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Item'
      object Button13: TButton
        Left = 0
        Top = 162
        Width = 65
        Height = 25
        Caption = 'Inventario'
        TabOrder = 0
        OnClick = Button13Click
      end
      object Button14: TButton
        Left = 62
        Top = 162
        Width = 56
        Height = 25
        Caption = 'Equipe'
        TabOrder = 1
        OnClick = Button14Click
      end
      object Button15: TButton
        Left = 122
        Top = 162
        Width = 47
        Height = 25
        Caption = 'Bau'
        TabOrder = 2
        OnClick = Button15Click
      end
      object Button16: TButton
        Left = 201
        Top = 162
        Width = 57
        Height = 25
        Caption = 'Usar Item'
        TabOrder = 3
        OnClick = Button16Click
      end
      object usItem: TLabeledEdit
        Left = 264
        Top = 164
        Width = 33
        Height = 21
        EditLabel.Width = 44
        EditLabel.Height = 13
        EditLabel.Caption = 'ID    QTD'
        TabOrder = 4
        Text = '0 0'
      end
      object Button1: TButton
        Left = 2
        Top = -1
        Width = 81
        Height = 25
        Caption = 'Registrar Itens'
        TabOrder = 5
        OnClick = Button1Click
      end
      object listDelete: TComboBox
        Left = 89
        Top = 1
        Width = 220
        Height = 21
        TabOrder = 6
        Text = '412 413 419 420 4907 477 478 479 480 816 923'
      end
      object chAutoDrop: TCheckBox
        Left = 3
        Top = 34
        Width = 63
        Height = 17
        Caption = 'AutoDrop'
        Checked = True
        State = cbChecked
        TabOrder = 7
        OnClick = chAutoDropClick
      end
      object Button3: TButton
        Left = 2
        Top = 57
        Width = 75
        Height = 25
        Caption = 'Agrupar'
        TabOrder = 8
        OnClick = Button3Click
      end
      object listAmount: TComboBox
        Left = 83
        Top = 61
        Width = 226
        Height = 21
        TabOrder = 9
        Text = '412 413 419 420'
      end
      object chAmount: TCheckBox
        Left = 5
        Top = 88
        Width = 86
        Height = 17
        Caption = 'Auto-Agrupar'
        Checked = True
        State = cbChecked
        TabOrder = 10
        OnClick = chAmountClick
      end
      object Button20: TButton
        Left = 5
        Top = 131
        Width = 79
        Height = 25
        Caption = 'Deletar Item'
        TabOrder = 11
        OnClick = Button20Click
      end
      object _dSlot: TLabeledEdit
        Left = 95
        Top = 135
        Width = 29
        Height = 21
        EditLabel.Width = 18
        EditLabel.Height = 13
        EditLabel.Caption = 'Slot'
        TabOrder = 12
        Text = '255'
      end
    end
  end
  object CheckBox1: TCheckBox
    Left = 151
    Top = 227
    Width = 70
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 5
  end
  object alive: TTimer
    OnTimer = aliveTimer
    Left = 8
    Top = 248
  end
  object clickCarb: TTimer
    Interval = 10
    OnTimer = clickCarbTimer
    Left = 48
    Top = 248
  end
  object sPk: TTimer
    Interval = 100
    OnTimer = sPkTimer
    Left = 88
    Top = 248
  end
  object AtkFis: TTimer
    Enabled = False
    Interval = 10
    OnTimer = AtkFisTimer
    Left = 128
    Top = 248
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 160
    Top = 248
  end
end
