#ne segmentin e memories text ruhet kodi
.text
.globl main						#direktiva e cila sinjalizon sistemin operativ se programi duhet te startoj me main
fib:
addi $sp,$sp,-12				#ne stack,per secilen thirrje do te ruajme 3 te dhena ka 4 bajt gjithsej 12 bajt(x,adresen ku duhet te kthehemi dhe rezultatin), percaktimi i hapsires per te nevojshme per alokim mund te percaktohet duke shkruajtur kodin, duke pare se cfare informacioni na duhet mbajtur ne mend para se te filloj funksioni ose pasi te perfundoi
sw $ra,8($sp)					#ne stack e ruajme adresen ku duhet te kthehemi(retrun adress) ne menyre qe mos ta humbim pasi qe ajo mbishkruhet pergjate thirrjes rekurzive te funksionit
sw $a0,4($sp)		#e ruajme x ne stack sepse pas thirrjes per x-1 na duhet per x-2


bne $a0,1,xZero					#nese parametri qe i pasohet funksionit eshte 1 ktheje paramterin, perndryshe kontrollojme a eshte 0(shkojme te 0)
add $v0,$a0,$zero											 #mundemi direkt me kthy vleren 1
addi $sp,$sp,12					#largojme nga stack(pop) te dhenat qe i kemi futur 
jr $ra							#kthehemi tek rreshti adresa e se cilit eshte ruajtur ne ra

xZero:
bne $a0,0,Else						#nese parametri qe i pasohet funksionit eshte 0 ktheje paramterin, perndryshe nga ai eshte me i madh se 1(shkojme te else)
add $v0,$a0,$zero                                    				     #mundemi direkt me kthy vleren 0
addi $sp,$sp,12										#largojme nga stack(pop) te dhenat 					
jr $ra												#kthehemi tek rreshti adresa e se cilit eshte ruajtur ne ra

Else:

addi $a0,$a0,-1									#e bejme gati parametrin x-1 per ta derguar te funksioni fib
jal fib											#"therrasim" funksionin fib me vleren e x-1, duke e ruajtur ne regjistrin ra adresen e rreshtit pasues

sw $v0,0($sp)									#eshte me rendesi te ruajme v0-ne ne stack sepse ne do ta therrasim funksionin fib edhe me vleren x-2, ne kete rast v0 mbishkruet, e neve ky rezultat na duhet per mbledhje
lw $a0,4($sp)									#tani na duhet ta therrasim funksionin fibonacci per x-2, per kete ne e marrim vleren e x nga stack, kjo eshte arsyeja pse e kemi ruajtur

addi $a0,$a0,-2									#e jme gati x-2 per ta derguar te funksioni fib
jal fib											#kjo thirrje e funksionit fib do te ruaj rezultatin e funksionit ne $v0, andaj eshte me rendesi qe kur prej stack te nxerrim rezultatin e x-1 ta ruajme ne nje regjister tjeter, ne menyre qe mos ta mbishkruajme sepse na duhet per mbledhje
																
lw $t0,0($sp)									#e marrim rezultatin e x-1 dhe e ruajme ne regjistrin t0 ne menyre qe mos ta mbishkruajme v0-ne

add $v0,$v0,$t0   								#ketu i mbledhim rezultatet per fib(x-1) dhe fib(x-2) dhe e kthejme rezultatin(e vendosum ne v0)

lw $ra,8($sp)
addi $sp,$sp,12	
jr $ra

main:
addi $s0,$zero,0    #vendosja e i ne  regjisterin s0

la $t1,numberOfSeries   #ne regjistrin t1 vendosim adresen e karakterit te pare te stringut numberOfSeries te cilin e marrim nga memoria 
#e printojme stringun numberOfSeries
li $v0,4								#4 kodi per printimin e stringut
add $a0,$t1,$zero						#ne a0 vendosim adresen qe ruhet ne t1 dhe funksioni e merr si parameter
syscall									#funksioni qe mundeson shtypjen e te dhenave ne ekran

# cin >> x, marrim inputin prej userit
li $v0,5								#5 eshte kodi per te marr input
syscall
move $t2,$v0   					#do te na duhet vlera e userit me vone, $v0 do te mbishkruhet keshtu qe e zhvendosim $t2

#printimi i stringut fibs
la $t1,fibS
li $v0,4
add $a0,$t1,$zero 
syscall

#unaza while
loop:
slt $t1,$s0,$t2      #kontrollojme per i<x, nese po $t1=1, nese jo $t1=0 (i<x ? $t1=1 : $t1=0 )
beq $t1,$zero,exit    #nese t1=0 atehere i>=x keshtu qe dalim prej unazes(kercejme tek etiketa "exit"), te gjithe anetaret jane printuar

#printimi i stringut wSpace 
la $t3,wSpace
li $v0,4
add $a0,$t3,$zero 
syscall

move $a0,$s0			 #eshte e zakonshme te vendosim ne regjistrat a0-a4 parametrat qe i pasohen funksioneve, andaj e zhvendosim vleren nga t0 ne a0
jal fib					#kercejme te funksioni fib dhe ne regjistrin ra e ruajme adresen e rreshtit te ardhshem te kodit

sw $v0,factResult 			  #shkruajme ne memorie rezultatin e funksionit ashtu qe mos te mbishkruhet sepse regjistrin v0 do ta perdorim per printim 

#printimi i rezultatit te funksionit fib(int)
li $v0,1
lw $a0,factResult             	 #leximi nga memoria i rezultatit te funksionit fib te cilin e ruajtem me par dhe vendosja ne regjistrin a0
syscall				

addi $s0,$s0,1					#rrisim i-ne per 1 ashtuqe unaza te mos mbes ne cikel te pafundem

j loop							#kercejme tek etiketa "loop"(tek kushti i<x)

exit:							#pasi qe jane printuar te gjithe anetaret (i=x) dalim nga unaza per te perfunduar programin
#sinjalizojme sistemin operativ qe programi perfundoi
li $v0,10						
syscall

#ne segmentin data i ruajme te dhenat te cilat nuk i zene regjistrat 
.data
numberOfSeries: .asciiz "Enter the number of terms of series : "						#etiketimi i nje adrese memorike si numberOfSeries, emer me te cilin do t'i qasemi ketij stringu, asciiz qendron per te dhenat qe shkruhen ne kodin ASCII dhe jane null terminated
fibS: .asciiz "\nFibonnaci Series : "													
wSpace: .asciiz " "																			
factResult: .word 0																		#etiketimi dhe qasja eshte e njejte, vetem se word perdoret per te ruajtur te dhena 32 bitshe, e ne rastin tone e perdorim per ta ruajtur rezultatin e faktorielit(vlera 0 mbishkruhet) 					