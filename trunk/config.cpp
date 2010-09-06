// ---------------------------------------------------------------------------

#pragma hdrstop

#include "config.h"

// ---------------------------------------------------------------------------

#pragma package(smart_init)

// функция проверяет доступность conf.ini и в случае необходимости его создаст
void CheckConfig()
{

  AnsiString st;



	/* файл можно открыть в режиме fmCreate, тогда, если
	   файл существует, он будет открыт для записи,
	   если файла нет, то он будет создан */


	/* открыть для записи или создать файл meteo.txt */

	int f;
	// строка для формирования дефолтных опций в конфиге
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
