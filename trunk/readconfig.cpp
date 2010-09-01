// ---------------------------------------------------------------------------

#pragma hdrstop

#include "readconfig.h"
//#include <studio.h>

// ---------------------------------------------------------------------------

#pragma package(smart_init)

void CheckConfig()
{

  AnsiString st;

    /* файл можно открыть в режиме fmCreate, тогда, если
       файл существует, он будет открыт для записи,
	   если файла нет, то он будет создан */


    /* открыть для записи или создать файл meteo.txt */

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
		// файл открыт для записи
		FileSeek(f,0,2); // установить указатель на конец файла
		FileWrite(f,st.c_str(),st.Length());
		FileClose(f);
	}

	else
	{
		/* ошибка доступа к файлу: ни открыть,
		   ни создать не получилось */

	}

};
