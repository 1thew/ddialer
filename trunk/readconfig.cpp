// ---------------------------------------------------------------------------

#pragma hdrstop

#include "readconfig.h"
//#include <studio.h>

// ---------------------------------------------------------------------------

#pragma package(smart_init)

void CheckConfig()
{

  AnsiString st;

    /* ���� ����� ������� � ������ fmCreate, �����, ����
       ���� ����������, �� ����� ������ ��� ������,
	   ���� ����� ���, �� �� ����� ������ */


    /* ������� ��� ������ ��� ������� ���� meteo.txt */

	int f;
	st = "login=\npass=\nautoconnect=0\nautoload=0\nsavedata=0\n";

	if ( FileExists("meteo.txt") )
		f = FileOpen("meteo.txt",fmOpenWrite);
	else
	{
	   f = FileCreate("meteo.txt");
	}

	if ( f != -1 )
	{
		// ���� ������ ��� ������
		FileSeek(f,0,2); // ���������� ��������� �� ����� �����
		FileWrite(f,st.c_str(),st.Length());
		FileClose(f);
	}

	else
	{
		/* ������ ������� � �����: �� �������,
		   �� ������� �� ���������� */

	}

};
