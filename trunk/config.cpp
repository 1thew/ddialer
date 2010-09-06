// ---------------------------------------------------------------------------

#pragma hdrstop

#include "config.h"

// ---------------------------------------------------------------------------

#pragma package(smart_init)

// ������� ��������� ����������� conf.ini � � ������ ������������� ��� �������
void CheckConfig()
{

  AnsiString st;



	/* ���� ����� ������� � ������ fmCreate, �����, ����
	   ���� ����������, �� ����� ������ ��� ������,
	   ���� ����� ���, �� �� ����� ������ */


	/* ������� ��� ������ ��� ������� ���� meteo.txt */

	int f;
	// ������ ��� ������������ ��������� ����� � �������
	st = "login=\npass=\nautoconnect=0\nautoload=0\nsavedata=0\n";

	if ( FileExists("config.ini") )
	{
		f = FileOpen("config.ini",fmOpenWrite);
		FileClose(f);
	}
	else
	{
	   f = FileCreate("config.ini");
	   FileClose(f);
	   f = FileOpen("config.ini",fmOpenWrite);
		FileWrite(f,st.c_str(),st.Length());
		FileClose(f);
	}

};
