FasdUAS 1.101.10   ��   ��    k             l     ��  ��    3 - CONFIGURATION: Adjust these values as needed     � 	 	 Z   C O N F I G U R A T I O N :   A d j u s t   t h e s e   v a l u e s   a s   n e e d e d   
  
 l         r         m     ����   o      ���� 0 numrows numRows  !  number of rows in the grid     �   6   n u m b e r   o f   r o w s   i n   t h e   g r i d      l        r        m    ����   o      ���� 0 numcols numCols  $  number of columns in the grid     �   <   n u m b e r   o f   c o l u m n s   i n   t h e   g r i d      l        r         m    	 ! ! ?�333333   o      ���� 0 
clickdelay 
clickDelay  &   delay between clicks in seconds     � " " @   d e l a y   b e t w e e n   c l i c k s   i n   s e c o n d s   # $ # l     ��������  ��  ��   $  % & % l     �� ' (��   ' ? 9 Define the vertical range of the grid within the window:    ( � ) ) r   D e f i n e   t h e   v e r t i c a l   r a n g e   o f   t h e   g r i d   w i t h i n   t h e   w i n d o w : &  * + * l    , - . , r     / 0 / m     1 1 ?�333333 0 o      ���� &0 gridstartfraction gridStartFraction - . ( grid starts at 15% of the window height    . � 2 2 P   g r i d   s t a r t s   a t   1 5 %   o f   t h e   w i n d o w   h e i g h t +  3 4 3 l    5 6 7 5 r     8 9 8 m     : : ?�333333 9 o      ���� "0 gridendfraction gridEndFraction 6 , & grid ends at 85% of the window height    7 � ; ; L   g r i d   e n d s   a t   8 5 %   o f   t h e   w i n d o w   h e i g h t 4  < = < l     ��������  ��  ��   =  > ? > l     �� @ A��   @ < 6 Get the "iPhone Mirroring" window's position and size    A � B B l   G e t   t h e   " i P h o n e   M i r r o r i n g "   w i n d o w ' s   p o s i t i o n   a n d   s i z e ?  C D C l   ] E���� E O    ] F G F O    \ H I H k    [ J J  K L K r    $ M N M m     ��
�� boovtrue N 1     #��
�� 
pisf L  O P O l  % %�� Q R��   Q C = Assume the main UI element (the window) is the first element    R � S S z   A s s u m e   t h e   m a i n   U I   e l e m e n t   ( t h e   w i n d o w )   i s   t h e   f i r s t   e l e m e n t P  T U T r   % + V W V 4   % )�� X
�� 
uiel X m   ' (����  W o      ���� 0 	thewindow 	theWindow U  Y Z Y r   , B [ \ [ n   , / ] ^ ] 1   - /��
�� 
posn ^ o   , -���� 0 	thewindow 	theWindow \ J       _ _  ` a ` o      ���� 0 winx winX a  b�� b o      ���� 0 winy winY��   Z  c�� c r   C [ d e d n   C H f g f 1   D H��
�� 
ptsz g o   C D���� 0 	thewindow 	theWindow e J       h h  i j i o      ���� 0 winw winW j  k�� k o      ���� 0 winh winH��  ��   I 4    �� l
�� 
prcs l m     m m � n n   i P h o n e   M i r r o r i n g G m     o o�                                                                                  sevs  alis    \  Macintosh HD               �<�BD ����System Events.app                                              �����<�        ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��   D  p q p l     ��������  ��  ��   q  r s r l     �� t u��   t    Initialize the log string    u � v v 4   I n i t i a l i z e   t h e   l o g   s t r i n g s  w x w l  ^ i y���� y r   ^ i z { z b   ^ e | } | m   ^ a ~ ~ �   & G r i d   C l i c k   O f f s e t s : } 1   a d��
�� 
lnfd { o      ���� 0 	offsetlog 	offsetLog��  ��   x  � � � l  j � ����� � r   j � � � � b   j � � � � b   j � � � � b   j } � � � b   j y � � � b   j u � � � b   j q � � � o   j m���� 0 	offsetlog 	offsetLog � m   m p � � � � � $ W i n d o w   P o s i t i o n :   ( � o   q t���� 0 winx winX � m   u x � � � � �  ,   � o   y |���� 0 winy winY � m   } � � � � � �  ) � 1   � ���
�� 
lnfd � o      ���� 0 	offsetlog 	offsetLog��  ��   �  � � � l  � � ����� � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � ����� 0 	offsetlog 	offsetLog � m   � � � � � � �  W i n d o w   S i z e :   ( � o   � ����� 0 winw winW � m   � � � � � � �    x   � o   � ����� 0 winh winH � m   � � � � � � �  ) � 1   � ���
�� 
lnfd � 1   � ���
�� 
lnfd � o      ���� 0 	offsetlog 	offsetLog��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � 4 . Loop over the grid cells (3 rows x 3 columns)    � � � � \   L o o p   o v e r   t h e   g r i d   c e l l s   ( 3   r o w s   x   3   c o l u m n s ) �  � � � l  �� ����� � Y   �� ��� � ��� � Y   �� ��� � ��� � k   �� � �  � � � l  � ��� � ���   � > 8 Calculate the relative X coordinate (full window width)    � � � � p   C a l c u l a t e   t h e   r e l a t i v e   X   c o o r d i n a t e   ( f u l l   w i n d o w   w i d t h ) �  � � � r   � � � � � ]   � � � � � l  � � ����� � ^   � � � � � l  � � ����� � [   � � � � � o   � ����� 0 colindex colIndex � m   � � � � ?�      ��  ��   � o   � ����� 0 numcols numCols��  ��   � o   � ����� 0 winw winW � o      ���� 0 relx relX �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � W Q For Y, restrict to the vertical range from gridStartFraction to gridEndFraction.    � � � � �   F o r   Y ,   r e s t r i c t   t o   t h e   v e r t i c a l   r a n g e   f r o m   g r i d S t a r t F r a c t i o n   t o   g r i d E n d F r a c t i o n . �  � � � r   � � � � � ]   � � � � � o   � ����� 0 winh winH � l  � � ����� � \   � � � � � o   � ����� "0 gridendfraction gridEndFraction � o   � ����� &0 gridstartfraction gridStartFraction��  ��   � o      ���� *0 grideffectiveheight gridEffectiveHeight �  � � � r   � � � � � [   � � � � � l  � � ����� � ]   � � � � � o   � ����� &0 gridstartfraction gridStartFraction � o   � ����� 0 winh winH��  ��   � ]   � � � � � l  � � ����� � ^   � � � � � l  � � ����� � [   � � � � � o   � ����� 0 rowindex rowIndex � m   � � � � ?�      ��  ��   � o   � ����� 0 numrows numRows��  ��   � o   � ����� *0 grideffectiveheight gridEffectiveHeight � o      ���� 0 rely relY �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 0 * Calculate the absolute screen coordinates    � � � � T   C a l c u l a t e   t h e   a b s o l u t e   s c r e e n   c o o r d i n a t e s �  � � � r   � � � � [   � �   o   � ����� 0 winx winX o   � ����� 0 relx relX � o      ���� 0 absx absX �  r   [   o  ���� 0 winy winY o  
���� 0 rely relY o      ���� 0 absy absY 	 l ��������  ��  ��  	 

 l ����   L F Click at the absolute coordinates using cliclick (Apple Silicon path)    � �   C l i c k   a t   t h e   a b s o l u t e   c o o r d i n a t e s   u s i n g   c l i c l i c k   ( A p p l e   S i l i c o n   p a t h )  Y  <���� I 7����
�� .sysoexecTEXT���     TEXT b  3 b  + b  ' m   � : / o p t / h o m e b r e w / b i n / c l i c l i c k   c : l &���� c  & o  "���� 0 absx absX m  "%��
�� 
long��  ��   m  '*   �!!  , l +2"����" c  +2#$# o  +.���� 0 absy absY$ m  .1��
�� 
long��  ��  ��  �� 0 x   m  ����   m  �� ��   %&% I =B�~'�}
�~ .sysodelanull��� ��� nmbr' o  =>�|�| 0 
clickdelay 
clickDelay�}  & ()( l CC�{�z�y�{  �z  �y  ) *+* l CC�x,-�x  , - ' Append this cell's offsets to the log.   - �.. N   A p p e n d   t h i s   c e l l ' s   o f f s e t s   t o   t h e   l o g .+ /�w/ r  C�010 b  C�232 b  C�454 b  C�676 b  C�898 b  C�:;: b  Cz<=< b  Cv>?> b  Cr@A@ b  CjBCB b  CfDED b  C^FGF b  CZHIH b  CVJKJ b  CRLML b  CNNON b  CJPQP o  CF�v�v 0 	offsetlog 	offsetLogQ m  FIRR �SS 
 C e l l  O l JMT�u�tT [  JMUVU o  JK�s�s 0 colindex colIndexV m  KL�r�r �u  �t  M m  NQWW �XX  ,K l RUY�q�pY [  RUZ[Z o  RS�o�o 0 rowindex rowIndex[ m  ST�n�n �q  �p  I m  VY\\ �]]  :  G l 	Z]^�m�l^ m  Z]__ �``  R e l a t i v e   (�m  �l  E l ^ea�k�ja c  ^ebcb o  ^a�i�i 0 relx relXc m  ad�h
�h 
long�k  �j  C m  fidd �ee  ,  A l jqf�g�ff c  jqghg o  jm�e�e 0 rely relYh m  mp�d
�d 
long�g  �f  ? m  ruii �jj  )   /  = l 	vyk�c�bk m  vyll �mm  A b s o l u t e   (�c  �b  ; l z�n�a�`n c  z�opo o  z}�_�_ 0 absx absXp m  }��^
�^ 
long�a  �`  9 m  ��qq �rr  ,  7 l ��s�]�\s c  ��tut o  ���[�[ 0 absy absYu m  ���Z
�Z 
long�]  �\  5 m  ��vv �ww  )3 1  ���Y
�Y 
lnfd1 o      �X�X 0 	offsetlog 	offsetLog�w  �� 0 colindex colIndex � m   � ��W�W   � l  � �x�V�Ux \   � �yzy o   � ��T�T 0 numcols numColsz m   � ��S�S �V  �U  ��  �� 0 rowindex rowIndex � m   � ��R�R   � l  � �{�Q�P{ \   � �|}| o   � ��O�O 0 numrows numRows} m   � ��N�N �Q  �P  ��  ��  ��   � ~~ l     �M�L�K�M  �L  �K   ��� l     �J���J  � 2 , Write the log to a text file on the Desktop   � ��� X   W r i t e   t h e   l o g   t o   a   t e x t   f i l e   o n   t h e   D e s k t o p� ��� l ����I�H� r  ����� l ����G�F� I ���E��
�E .earsffdralis        afdr� m  ���D
�D afdrdesk� �C��B
�C 
rtyp� m  ���A
�A 
ctxt�B  �G  �F  � o      �@�@ 0 desktoppath desktopPath�I  �H  � ��� l ����?�>� r  ����� b  ����� o  ���=�= 0 desktoppath desktopPath� m  ���� ���   g r i d _ o f f s e t s . t x t� o      �<�< 0 logfile logFile�?  �>  � ��� l     �;�:�9�;  �:  �9  � ��� l �&��8�7� Q  �&���� k  ���� ��� r  ����� I ���6��
�6 .rdwropenshor       file� 4  ���5�
�5 
file� o  ���4�4 0 logfile logFile� �3��2
�3 
perm� m  ���1
�1 boovtrue�2  � o      �0�0 0 filereference fileReference� ��� l ������ I ���/��
�/ .rdwrseofnull���     ****� o  ���.�. 0 filereference fileReference� �-��,
�- 
set2� m  ���+�+  �,  � "  clear the file if it exists   � ��� 8   c l e a r   t h e   f i l e   i f   i t   e x i s t s� ��� I ���*��
�* .rdwrwritnull���     ****� o  ���)�) 0 	offsetlog 	offsetLog� �(��'
�( 
refn� o  ���&�& 0 filereference fileReference�'  � ��%� I ���$��#
�$ .rdwrclosnull���     ****� o  ���"�" 0 filereference fileReference�#  �%  � R      �!�� 
�! .ascrerr ****      � ****� o      �� 0 errmsg errMsg�   � k  &�� ��� Q  ���� I ���
� .rdwrclosnull���     ****� 4  ��
� 
file� o  �� 0 logfile logFile�  � R      ���
� .ascrerr ****      � ****�  �  �  � ��� I &���
� .sysodlogaskr        TEXT� b  "��� m   �� ��� & E r r o r   w r i t i n g   l o g :  � o   !�� 0 errmsg errMsg�  �  �8  �7  � ��� l     ����  �  �  � ��� l     ����  � * $ Automatically screenshot the window   � ��� H   A u t o m a t i c a l l y   s c r e e n s h o t   t h e   w i n d o w� ��� l     ����  �  �  � ��� l     ����  � H B Build a POSIX path for the screenshot file (saved on the Desktop)   � ��� �   B u i l d   a   P O S I X   p a t h   f o r   t h e   s c r e e n s h o t   f i l e   ( s a v e d   o n   t h e   D e s k t o p )� ��� l ':��
�	� r  ':��� b  '6��� l '2���� n  '2��� 1  .2�
� 
psxp� l '.���� I '.���
� .earsffdralis        afdr� m  '*�
� afdrdesk�  �  �  �  �  � m  25�� ��� & g r i d _ s c r e e n s h o t . p n g� o      � �   0 screenshotfile screenshotFile�
  �	  � ��� l     ��������  ��  ��  � ��� l     ������  � C = Capture the window region using the 'screencapture' command.   � ��� z   C a p t u r e   t h e   w i n d o w   r e g i o n   u s i n g   t h e   ' s c r e e n c a p t u r e '   c o m m a n d .� ��� l     ������  � 8 2 (winX, winY, winW, winH) were determined earlier.   � ��� d   ( w i n X ,   w i n Y ,   w i n W ,   w i n H )   w e r e   d e t e r m i n e d   e a r l i e r .� ��� l ;j������ r  ;j��� b  ;f��� b  ;^��� b  ;Z��� b  ;V��� b  ;R��� b  ;N��� b  ;J� � b  ;F b  ;B m  ;> �   s c r e e n c a p t u r e   - R o  >A���� 0 winx winX m  BE �  ,  o  FI���� 0 winy winY� m  JM		 �

  ,� o  NQ���� 0 winw winW� m  RU �  ,� o  VY���� 0 winh winH� m  Z] �   � n  ^e 1  ae��
�� 
strq o  ^a����  0 screenshotfile screenshotFile� o      ���� 0 
capturecmd 
captureCmd��  ��  �  l kr���� I kr����
�� .sysoexecTEXT���     TEXT o  kn���� 0 
capturecmd 
captureCmd��  ��  ��    l     ��������  ��  ��    l sz���� I sz����
�� .sysodlogaskr        TEXT m  sv � � G r i d   c l i c k s   c o m p l e t e .   L o g   w r i t t e n   t o   g r i d _ o f f s e t s . t x t .   L o g   a n d   S c r e e n s h o t   a r e   o n   y o u r   D e s k t o p .��  ��  ��   �� l     ��������  ��  ��  ��       "������ ! 1 : ��������!"#$%&'(��)*����������������������    ����������������������������������������������������������������
�� .aevtoappnull  �   � ****�� 0 numrows numRows�� 0 numcols numCols�� 0 
clickdelay 
clickDelay�� &0 gridstartfraction gridStartFraction�� "0 gridendfraction gridEndFraction�� 0 	thewindow 	theWindow�� 0 winx winX�� 0 winy winY�� 0 winw winW�� 0 winh winH�� 0 	offsetlog 	offsetLog�� 0 relx relX�� *0 grideffectiveheight gridEffectiveHeight�� 0 rely relY�� 0 absx absX�� 0 absy absY�� 0 desktoppath desktopPath�� 0 logfile logFile�� 0 filereference fileReference��  0 screenshotfile screenshotFile�� 0 
capturecmd 
captureCmd��  ��  ��  ��  ��  ��  ��  ��  ��  ��   ��+����,-��
�� .aevtoappnull  �   � ****+ k    z..  
//  00  11  *22  333  C44  w55  �66  �77  �88 �99 �:: �;; �<< �== >> ����  ��  ��  , ���������� 0 rowindex rowIndex�� 0 colindex colIndex�� 0 x  �� 0 errmsg errMsg- S���� !�� 1�� :�� o�� m�������������������� ~���� � � � � � � ��������������� ����RW\_dilqv���������������������������~�}�|�{�z��y�x��w	�v�u�� 0 numrows numRows�� 0 numcols numCols�� 0 
clickdelay 
clickDelay�� &0 gridstartfraction gridStartFraction�� "0 gridendfraction gridEndFraction
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
�� 
lnfd�� 0 	offsetlog 	offsetLog�� 0 relx relX�� *0 grideffectiveheight gridEffectiveHeight�� 0 rely relY�� 0 absx absX�� 0 absy absY�� 
�� 
long
�� .sysoexecTEXT���     TEXT
�� .sysodelanull��� ��� nmbr
�� afdrdesk
�� 
rtyp
�� 
ctxt
�� .earsffdralis        afdr�� 0 desktoppath desktopPath�� 0 logfile logFile
�� 
file
�� 
perm
�� .rdwropenshor       file�� 0 filereference fileReference
�� 
set2
�� .rdwrseofnull���     ****
� 
refn
�~ .rdwrwritnull���     ****
�} .rdwrclosnull���     ****�| 0 errmsg errMsg�{  �z  
�y .sysodlogaskr        TEXT
�x 
psxp�w  0 screenshotfile screenshotFile
�v 
strq�u 0 
capturecmd 
captureCmd��{mE�OmE�O�E�O�E�O�E�O� F*��/ >e*�,FO*�k/E�O��,E[�k/E` Z[�l/E` ZO�a ,E[�k/E` Z[�l/E` ZUUOa _ %E` O_ a %_ %a %_ %a %_ %E` O_ a %_ %a %_ %a %_ %_ %E` O �j�kkh   �j�kkh �a �!_  E` O_ �� E`  O�_  �a �!_   E` !O_ _ E` "O_ _ !E` #O +ja $kh a %_ "a &&%a '%_ #a &&%j ([OY��O�j )O_ a *%�k%a +%�k%a ,%a -%_ a &&%a .%_ !a &&%a /%a 0%_ "a &&%a 1%_ #a &&%a 2%_ %E` [OY�&[OY�Oa 3a 4a 5l 6E` 7O_ 7a 8%E` 9O ;*a :_ 9/a ;el <E` =O_ =a >jl ?O_ a @_ =l AO_ =j BW )X C D *a :_ 9/j BW X E DhOa F�%j GOa 3j 6a H,a I%E` JOa K_ %a L%_ %a M%_ %a N%_ %a O%_ Ja P,%E` QO_ Qj (Oa Rj G�� ��   ?? @�tA@  o�sB
�s 
pcapB �CC   i P h o n e   M i r r o r i n g
�t 
cwinA �DD   i P h o n e   M i r r o r i n g���� ���X���! �EE< G r i d   C l i c k   O f f s e t s : 
 W i n d o w   P o s i t i o n :   ( 7 8 9 ,   1 9 6 ) 
 W i n d o w   S i z e :   ( 3 4 4   x   7 6 4 ) 
 
 C e l l   1 , 1 :   R e l a t i v e   ( 5 7 ,   2 0 4 )   /   A b s o l u t e   ( 8 4 6 ,   4 0 0 ) 
 C e l l   2 , 1 :   R e l a t i v e   ( 1 7 2 ,   2 0 4 )   /   A b s o l u t e   ( 9 6 1 ,   4 0 0 ) 
 C e l l   3 , 1 :   R e l a t i v e   ( 2 8 7 ,   2 0 4 )   /   A b s o l u t e   ( 1 0 7 6 ,   4 0 0 ) 
 C e l l   1 , 2 :   R e l a t i v e   ( 5 7 ,   3 8 2 )   /   A b s o l u t e   ( 8 4 6 ,   5 7 8 ) 
 C e l l   2 , 2 :   R e l a t i v e   ( 1 7 2 ,   3 8 2 )   /   A b s o l u t e   ( 9 6 1 ,   5 7 8 ) 
 C e l l   3 , 2 :   R e l a t i v e   ( 2 8 7 ,   3 8 2 )   /   A b s o l u t e   ( 1 0 7 6 ,   5 7 8 ) 
 C e l l   1 , 3 :   R e l a t i v e   ( 5 7 ,   5 6 0 )   /   A b s o l u t e   ( 8 4 6 ,   7 5 6 ) 
 C e l l   2 , 3 :   R e l a t i v e   ( 1 7 2 ,   5 6 0 )   /   A b s o l u t e   ( 9 6 1 ,   7 5 6 ) 
 C e l l   3 , 3 :   R e l a t i v e   ( 2 8 7 ,   5 6 0 )   /   A b s o l u t e   ( 1 0 7 6 ,   7 5 6 ) 
" @qꪪ���# @��fffff$ @��"""""% @�Ϊ����& @��"""""' �FF > M a c i n t o s h   H D : U s e r s : j r k : D e s k t o p :( �GG ^ M a c i n t o s h   H D : U s e r s : j r k : D e s k t o p : g r i d _ o f f s e t s . t x t�� P) �HH L / U s e r s / j r k / D e s k t o p / g r i d _ s c r e e n s h o t . p n g* �II � s c r e e n c a p t u r e   - R 7 8 9 , 1 9 6 , 3 4 4 , 7 6 4   ' / U s e r s / j r k / D e s k t o p / g r i d _ s c r e e n s h o t . p n g '��  ��  ��  ��  ��  ��  ��  ��  ��  ��   ascr  ��ޭ