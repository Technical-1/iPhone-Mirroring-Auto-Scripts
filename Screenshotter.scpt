FasdUAS 1.101.10   ��   ��    k             l     ��  ��    < 6 Get the "iPhone Mirroring" window's position and size     � 	 	 l   G e t   t h e   " i P h o n e   M i r r o r i n g "   w i n d o w ' s   p o s i t i o n   a n d   s i z e   
  
 l    ? ����  O     ?    O    >    k    =       r        m    ��
�� boovtrue  1    ��
�� 
pisf      l   ��  ��    C = Assume the main UI element (the window) is the first element     �   z   A s s u m e   t h e   m a i n   U I   e l e m e n t   ( t h e   w i n d o w )   i s   t h e   f i r s t   e l e m e n t      r        4    �� 
�� 
uiel  m    ����   o      ���� 0 	thewindow 	theWindow     !   r    * " # " n     $ % $ 1    ��
�� 
posn % o    ���� 0 	thewindow 	theWindow # J       & &  ' ( ' o      ���� 0 winx winX (  )�� ) o      ���� 0 winy winY��   !  *�� * r   + = + , + n   + . - . - 1   , .��
�� 
ptsz . o   + ,���� 0 	thewindow 	theWindow , J       / /  0 1 0 o      ���� 0 winw winW 1  2�� 2 o      ���� 0 winh winH��  ��    4    �� 3
�� 
prcs 3 m     4 4 � 5 5   i P h o n e   M i r r o r i n g  m      6 6�                                                                                  sevs  alis    \  Macintosh HD               �<�BD ����System Events.app                                              �����<�        ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��     7 8 7 l     ��������  ��  ��   8  9 : 9 l  @ O ;���� ; r   @ O < = < b   @ K > ? > l  @ G @���� @ n   @ G A B A 1   E G��
�� 
psxp B l  @ E C���� C I  @ E�� D��
�� .earsffdralis        afdr D m   @ A��
�� afdrdesk��  ��  ��  ��  ��   ? m   G J E E � F F $ n e w _ s c r e e n s h o t . p n g = o      ����  0 screenshotfile screenshotFile��  ��   :  G H G l     ��������  ��  ��   H  I J I l     �� K L��   K C = Capture the window region using the 'screencapture' command.    L � M M z   C a p t u r e   t h e   w i n d o w   r e g i o n   u s i n g   t h e   ' s c r e e n c a p t u r e '   c o m m a n d . J  N O N l     �� P Q��   P 8 2 (winX, winY, winW, winH) were determined earlier.    Q � R R d   ( w i n X ,   w i n Y ,   w i n W ,   w i n H )   w e r e   d e t e r m i n e d   e a r l i e r . O  S T S l  P w U���� U r   P w V W V b   P s X Y X b   P k Z [ Z b   P g \ ] \ b   P e ^ _ ^ b   P a ` a ` b   P _ b c b b   P [ d e d b   P Y f g f b   P U h i h m   P S j j � k k   s c r e e n c a p t u r e   - R i o   S T���� 0 winx winX g m   U X l l � m m  , e o   Y Z���� 0 winy winY c m   [ ^ n n � o o  , a o   _ `���� 0 winw winW _ m   a d p p � q q  , ] o   e f���� 0 winh winH [ m   g j r r � s s    Y n   k r t u t 1   n r��
�� 
strq u o   k n����  0 screenshotfile screenshotFile W o      ���� 0 
capturecmd 
captureCmd��  ��   T  v�� v l  x  w���� w I  x �� x��
�� .sysoexecTEXT���     TEXT x o   x {���� 0 
capturecmd 
captureCmd��  ��  ��  ��       �� y z��   y ��
�� .aevtoappnull  �   � **** z �� {���� | }��
�� .aevtoappnull  �   � **** { k      ~ ~  
    9 � �  S � �  v����  ��  ��   |   }  6�� 4�������������������������� E�� j l n p r������
�� 
prcs
�� 
pisf
�� 
uiel�� 0 	thewindow 	theWindow
�� 
posn
�� 
cobj�� 0 winx winX�� 0 winy winY
�� 
ptsz�� 0 winw winW�� 0 winh winH
�� afdrdesk
�� .earsffdralis        afdr
�� 
psxp��  0 screenshotfile screenshotFile
�� 
strq�� 0 
capturecmd 
captureCmd
�� .sysoexecTEXT���     TEXT�� �� <*��/ 4e*�,FO*�k/E�O��,E[�k/E�Z[�l/E�ZO��,E[�k/E�Z[�l/E�ZUUO�j �,a %E` Oa �%a %�%a %�%a %�%a %_ a ,%E` O_ j ascr  ��ޭ