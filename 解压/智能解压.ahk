/* ver=1.1
;~~~~~~~~~~~~~~~~~~~~��������~~~~~~~~~~~~~~~~~~~~
1�����ѹ������ֻ��һ���ļ������Ƿ񸲸ǣ�����7z���ʴ���
2��������ҽ���һ���ļ��У���ѹ����������ͬ���ļ��У����½��������ļ�����+�Ӻ�׺�����ļ��д���
3������ж�����԰��ļ��н�ѹ����������ͬ���ļ��У����½������ļ���+�Ӻ�׺�����ļ��д���
;~~~~~~~~~~~~~~~~~~~~��������~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~Party~~~~~~~~~~~~~~~~~~~~
; ���ղ�����
;	ʹ�� TC �� %P%S ����
; ʹ��˵����
; 1. �޸�7z.exe��7zG.exe��·��
; 2. usercmd.ini������
; [em_SmartExtract]
; menu=���ܽ�ѹ
; cmd=��Ϊ�Լ�SmartExtract.ahk��·��
; param=%P%S
;~~~~~~~~~~~~~~~~~~~~Party~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~�ű�˵�������ר����~~~~~~~~~~~~~~~~~~~~
ԭ�ű�Ϊ����������cando���ܽ�ѹ���ο�Party�ġ�SmartExtract-7z���ܽ�ѹ-����ʹ��˵��.ahk���д��ݲ�����˼·�����޸ģ�
;~~~~~~~~~~~~~~~~~~~~�ű�˵�������ר����~~~~~~~~~~~~~~~~~~~~
*/
envget,COMMANDER_PATH,COMMANDER_PATH
global	����·��_7Z=%A_ScriptDir%\..\Tools\7z\7z.exe
global	����·��_7ZG=%A_scriptdir%\..\Tools\7z\7zG.exe
for n, param in A_Args  ; ��ÿ����������ѭ��:
{
    cando_���ܽ�ѹ(param)
}
;������������������������������������������������������������������������������������������������������������������������
; ������ű������candyʹ�ã�ɾ��������м���
;������������������������������������������������������������������������������������������������������������������������
; cando_���ܽ�ѹ:
cando_���ܽ�ѹ(candyselected){
	SmartUnZip_�ײ����ļ���־:=0
	SmartUnZip_�ײ����ļ��б�־:=0
	SmartUnZip_�ײ��ļ�����:=
	SmartUnZip_�ļ�����A:=
	SmartUnZip_�ļ�����B:=

	���б�=%A_Temp%\wannianshuyaozhinengjieya_%A_Now%.txt

	SplitPath ,candyselected,,��Ŀ¼,,���ļ���
	RunWait, %comspec% /c %����·��_7Z% l "%candyselected%" `>"%���б�%",,hide

;������������������������������������������������������������������������������������������������������������������������

	loop,read,%���б�%
	{
		If(RegExMatch(A_LoopReadLine,"^(\d\d\d\d-\d\d-\d\d)") And (RegExMatch(A_LoopReadLine,"(?<!files|folders)$")))
		{
			If( InStr(A_loopreadline,"D")=21 Or InStr(A_loopreadline,"\"))  ;�����������\������D��־�����ж�Ϊ�ļ���
			{
				SmartUnZip_�ײ����ļ��б�־=1
			}

			If InStr(A_loopreadline,"\")
				StringMid,SmartUnZip_�ļ�����A,A_LoopReadLine,54,InStr(A_loopreadline,"\")-54
			Else
				StringTrimLeft,SmartUnZip_�ļ�����A,A_LoopReadLine,53

			If((SmartUnZip_�ļ�����B != SmartUnZip_�ļ�����A ) And ( SmartUnZip_�ļ�����B!="" ))
			{
				SmartUnZip_�ײ����ļ���־=1
				Break
			}
			SmartUnZip_�ļ�����B:=SmartUnZip_�ļ�����A
		}
	}
	FileDelete,%���б�%

;������������������������������������������������������������������������������������������������������������������������
	If(SmartUnZip_�ײ����ļ���־=0 && SmartUnZip_�ײ����ļ��б�־=0 )   ;ѹ���ļ��ڣ��ײ����ҽ���һ���ļ�
	{
		; Run, %����·��_7ZG% x "%candyselected%" -o "%��Ŀ¼%"    ;���ǻ��Ǹ���������7z
		Run, %����·��_7ZG% x "%candyselected%" -aou -o"%��Ŀ¼%"    ;���ǻ��Ǹ���������7z
	}

	Else If(SmartUnZip_�ײ����ļ���־=0 && SmartUnZip_�ײ����ļ��б�־=1 )   ;ѹ���ļ��ڣ��ײ����ҽ���һ���ļ���
	{
		IfExist,%��Ŀ¼%\%SmartUnZip_�ļ�����A%   ;�Ѿ��������ԡ��ײ��ļ������������ļ��У���ô�죿
		{
			Loop
			{
				SmartUnZip_NewFolderName=%��Ŀ¼%\%SmartUnZip_�ļ�����A%( %A_Index% )
				If !FileExist( SmartUnZip_NewFolderName )
				{
					Run, %����·��_7ZG% x "%candyselected%"   -o"%SmartUnZip_NewFolderName%"
					break
				}
			}
		}
		Else  ;û�С��ײ��ļ������������ļ��У��Ǿ�̫����
		{
			Run, %����·��_7ZG% x "%candyselected%" -o"%��Ŀ¼%"
		}
	}
	Else  ;ѹ���ļ��ڣ��ײ��ж���ļ���
	{
		IfExist %��Ŀ¼%\%���ļ���%  ;�Ѿ��������ԡ����ļ��������ļ��У���ô�죿
		{
			Loop
			{
				SmartUnZip_NewFolderName=%��Ŀ¼%\%���ļ���%( %A_Index% )
				If !FileExist( SmartUnZip_NewFolderName )
				{
					Run, %����·��_7ZG% x "%candyselected%"   -o"%SmartUnZip_NewFolderName%"
					break
				}
			}
		}
		Else ;û�У��Ǿ�̫����
		{
			Run, %����·��_7ZG% x  "%candyselected%" -o"%��Ŀ¼%\%���ļ���%"
		}
	}
	; Return
}
