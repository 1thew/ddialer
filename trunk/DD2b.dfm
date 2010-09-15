object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'DianetDialer v2.0b'
  ClientHeight = 303
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 48
    Top = 16
    Width = 457
    Height = 279
    ActivePage = TabSheet2
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077
      object Button1: TButton
        Left = 224
        Top = 41
        Width = 193
        Height = 49
        Caption = #1057#1086#1077#1076#1080#1085#1080#1090#1100#1089#1103
        TabOrder = 0
      end
      object Button2: TButton
        Left = 224
        Top = 96
        Width = 193
        Height = 49
        Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100#1089#1103
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 3
        Top = 3
        Width = 414
        Height = 126
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
        TabOrder = 0
        object Label1: TLabel
          Left = 175
          Top = 19
          Width = 72
          Height = 13
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        end
        object Label2: TLabel
          Left = 175
          Top = 46
          Width = 37
          Height = 13
          Caption = #1055#1072#1088#1086#1083#1100
        end
        object Label3: TLabel
          Left = 175
          Top = 72
          Width = 91
          Height = 13
          Caption = #1058#1080#1087' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
        end
        object CheckBox1: TCheckBox
          Left = 16
          Top = 98
          Width = 153
          Height = 17
          Caption = #1047#1072#1087#1086#1084#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
          TabOrder = 0
          OnClick = CheckBox1Click
        end
        object ComboBox1: TComboBox
          Left = 16
          Top = 72
          Width = 153
          Height = 21
          Style = csDropDownList
          TabOrder = 1
        end
        object Edit1: TEdit
          Left = 16
          Top = 18
          Width = 153
          Height = 21
          TabOrder = 2
          Text = 'Edit1'
          OnChange = Edit1Change
        end
        object Edit2: TEdit
          Left = 16
          Top = 45
          Width = 153
          Height = 21
          TabOrder = 3
          Text = 'Edit1'
          OnChange = Edit2Change
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 135
        Width = 414
        Height = 105
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1079#1072#1094#1080#1103
        TabOrder = 1
        object CheckBox2: TCheckBox
          Left = 13
          Top = 24
          Width = 153
          Height = 17
          Caption = #1040#1074#1090#1086#1079#1072#1087#1091#1089#1082' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
          TabOrder = 0
        end
        object CheckBox3: TCheckBox
          Left = 13
          Top = 47
          Width = 276
          Height = 17
          Caption = #1087#1086#1076#1082#1083#1102#1095#1072#1090#1100' '#1080#1085#1090#1077#1088#1085#1077#1090' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
          TabOrder = 1
        end
      end
    end
  end
end
