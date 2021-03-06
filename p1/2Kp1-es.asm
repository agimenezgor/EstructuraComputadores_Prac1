section .data               
;Cambiar Nombre y Apellido por vuestros datos.
developer db "_Nombre_ _Apellido1_",0

;Constantes que también están definidas en C.
DimMatrix    equ 4      
SizeMatrix   equ 16

section .text            
;Variables definidas en Ensamblador.
global developer                        

;Subrutinas de ensamblador que se llaman des de C.
global showNumberP1, updateBoardP1, calcIndexP1, rotateMatrixRP1, copyMatrixP1
global shiftNumbersRP1, addPairsRP1
global readKeyP1, playP1

;Variables definidas en C.
extern rowScreen, colScreen, charac
extern m, mRotated, number, score, state

;Funciones de C que se llaman desde ensamblador
extern clearScreen_C, printBoardP1_C, gotoxyP1_C, getchP1_C, printchP1_C
extern insertTileP1_C, printMessageP1_C 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: Recordad que en ensamblador las variables y los parámetros 
;;   de tipo 'char' se tienen que asignar a registros de tipo
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   las de tipo 'short' se tiene que assignar a registros de tipo 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   las de tipo 'int' se tiene que assignar a registros de tipo  
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   las de tipo 'long' se tiene que assignar a registros de tipo 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Las subrutinas en ensamblador que tenéis que implementar son:
;;   showNumberP1, updateBoardP1, rotateMatrixRP1, 
;;   copyMatrixP1, shiftNumbersRP1, addPairsRP1.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Situar el cursor en una fila indicada por la variable (rowScreen) y en 
; una columna indicada por la variable (colScreen) de pantalla 
; llamando a la función gotoxyP1_C.
; 
; Variables globales utilizadas:	
; rowScreen: Fila de la pantalla donde posicionamos el cursor.
; colScreen: Columna de la pantalla donde posicionamos el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter guradado en la varaile (charac) en pantalla, en
; la posición donde está el cursor llamando a la función printchP1_C.
; 
; Variables globales utilizadas:	
; charac   : Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla y guardar el carácter asociado en la varaible (charac) 
; sin mostrarlo en pantalla, llamando a la función getchP1_C
; 
; Variables globales utilizadas:	
; charac   : Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   call getchP1_C
 
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 
   

;;;;;
; Convierte el número de la variable (number) de tipo int (DWORD) de 6
; dígitos (number <= 999999) a caracteres ASCII que representen su valor.
; Si (number) es más grande de 999999 cambiaremos el valor a 999999.
; Se tiene que dividir el valor entre 10, de forma iterativa, hasta 
; obtener los 6 dígitos. 
; A cada iteración, el residuo de la división que es un valor
; entre (0-9) indica el valor del dígito que tenemos que convertir
; a ASCII ('0' - '9') sumando '0' (48 decimal) para poderlo mostrar.
; Cuando el cociente sea 0 mostraremos espacios en la parte no significativa.
; Por ejemplo, si number=103 mostraremos "   103" y no "000103".
; Se tienen que mostrar los dígitos (carácter ASCII) desde la posición 
; indicada por las variables (rowScreen) y (colScreen), posición de les 
; unidades, hacia la izquierda.
; Como el primer dígito que obtenemos son las unidades, después las decenas,
; ..., para mostrar el valor se tiene que desplazar el cursor una posición
; a la izquierda en cada iteración.
; Para posicionar el cursor se llamada a la función gotoxyP1 y para 
; mostrar los caracteres a la función printchP1.
;
; Variables globales utilizadas:    
; number    : Valor que queremos mostrar.
; rowScreen : Fila para posicionar el cursor a la pantalla.
; colScreen : Columna para posicionar el cursor a la pantalla.
; charac    : Carácter que queremos mostrar
;;;;;
showNumberP1:
   push rbp
   mov  rbp, rsp
   
   
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Actualizar el contenido del Tablero de Juego con los datos de 
; la matriz (m) y los puntos del marcador (score) que se han hecho.  
; Se tiene que recorrer toda la matriz (m), y para cada elemento de 
; la matriz posicionar el cursor en pantalla y mostrar el número de 
; esa posición de la matriz.
; Para recorrer la matriz en assemblador el indice va de 0 (posició [0][0])
; a 30 (posición [3][3]) con incrementos de 2 porque los datos son de 
; tipo short(WORD) 2 bytes.
; Después, mostrar el marcador (score) en la parte inferior del tablero
; fila 18, columna 26 llamando a la subrutina showNumberP1.
; Finalmente posicionar el cursor en la fila 18, columna 28 llamando a
; la subrutina goroxyP1.
;
; Variables globales utilizadas:    
; rowScreen : Fila para posicionar el cursor en pantalla.
; colScreen : Columna per a posicionar el cursor en pantalla.
; m         : Matriz 4x4 donde hay los números del tablero de juego.
; score     : Puntos acumulados en el marcador hasta el momento.
; number    : Número que queremos mostrar.
;;;;;  
updateBoardP1:
   push rbp
   mov  rbp, rsp
   
   
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;      
; Rotar a la derecha la matriz (m), sobre la matriz (mRotated). 
; La primera fila pasa a ser la cuarta columna, la segunda fila pasa 
; a ser la tercera columna, la tercera fila pasa a ser la segunda
; columna y la cuarta fila pasa a ser la primer columna.
; En el enunciado se explica con más detalle como hacer la rotación.
; NOTA: NO es lo mismo que hacer la matriz traspuesta.
; La matriz (m) no se tiene que modificar, 
; los cambios se tiene que hacer en la matriz (mRotated).
; Para recorrer la matriz en ensamblador el indice va de 0 (posición [0][0])
; a 30 (posición [3][3]) con incrementos de 2 porque los datos son de 
; tipo short(WORD) 2 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador 
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*2),
; multiplicamos por 2 porque los datos son de tipo short(WORD) 2 bytes.
; Una vez se ha hecho la rotación, copiar la matriz (mRotated) a la 
; matriz (m) llamando a la subrtuina copyMatrixP1.
;
; Variables globales utilizadas:    
; m        : matriz 4x4 donde hay los números del tablero de juego.
; mRotated : Matriz 4x4 para hacer la rotación.
;;;;;  
rotateMatrixRP1:
   push rbp
   mov  rbp, rsp
   
   
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Copiar los valores de la matriz (mRotated) a la matriz (m).
; La matriz (mRotated) no se tiene que modificar, 
; los cambios se tienen que hacer en la matriz (m).
; Para recorrer la matriz en ensamblador el índice va de 0 (posición [0][0])
; a 30 (posición [3][3]) con incrementos de 2 porque los datos son de 
; tipo short(WORD) 2 bytes.
; No se muestra la matriz. 
;
; Variables globales utilizadas:    
; m        : Matriz 4x4 donde hay los números del tablero de juego.
; mRotated : Matriz 4x4 para hacer la rotación.
;;;;;  
copyMatrixP1:
   push rbp
   mov  rbp, rsp
   
   
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Desplazar a la derecha los números de cada fila de la matriz (m), 
; manteniendo el orden de los números y poniendo los ceros a la izquierdaa.
; Recorrer la matriz por filas de derecha a izquierda y de abajo hacia arriba.  
; Si se desplaza un número (NO LOS CEROS) pondremos la variable 
; (state) a '2'.
; Si una fila de la matriz es: [0,2,0,4] y state = '1', quedará [0,0,2,4] 
; y state= '2'.
; En cada fila, si encuentra un 0, mira si hay un número distinto de zero,
; en la misma fila para ponerlo en aquella posición.
; Para recorrer la matriz en ensamblador, en este caso, el índice va de la
; posición 30 (posición [3][3]) a la 0 (posición [0][0]) con decrementos de
; 2 porque los datos son de tipo short(WORD) 2 bytes.
; Per a acceder a una posición concreta de la matriz desde ensamblador 
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*2),
; multiplicamos por 2 porque los datos son de tipo short(WORD) 2 bytes.
; Los cambios se tienen que hacer sobre la misma  matriz.
; No se tiene que mostrar la matriz.
;
; Variables globales utilizadas:    
; state    : Estado del juego. (2: Se han hecho movimientos).
; m        : Matriz 4x4 donde hay los números del tablero de juego.
; rowcol   : Vector con la fila y la columna que queremos acceder de la matriz.
; indexMat : Índice para acceder a la matriz m.
;;;;;  
shiftNumbersRP1:
   push rbp
   mov  rbp, rsp

   
   
   mov rsp, rbp
   pop rbp
   ret
      

;;;;;  
; Emparejar números iguales desde la derecha de la matriz (m) y acumular 
; los puntos en el marcador sumando los puntos de las parejas que se hagan.
; Recorrer la matriz por filas de dercha a izquierda y de abajo hacia arriba. 
; Cuando se encuentre una pareja, dos casillas consecutivas con el mismo 
; número, juntamos la pareja poniendo la suma de los números de la 
; pareja en la casilla de la derechay un 0 en la casilla de la izquierda y 
; acumularemos esta suma (puntos que se ganan).
; Si una fila de la matriz es: [8,4,4,2] y state = 1, quedará [8,0,8,2], 
; p = p + (4+4) y state = '2'.
; Si al final se ha juntado alguna pareja (puntos>0), pondremos la variable 
; (state) a '2' para indicar que se ha movido algún número y actualizaremos
; la variable (score) con los puntos obtenidos de hacer las parejas.
; Para recorrer la matriz en ensamblador, en este caso, el índice va de la
; posición 30 (posición [3][3]) a la 0 (posición [0][0]) con decrementos de
; 2 porque los datos son de tipo short(WORD) 2 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador 
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*2),
; multiplicamos por 2 porque los datos son de tipo short(WORD) 2 bytes.
; Los cambios se tienen que hacer sobre la misma  matriz.
; No se tiene que mostrar la matriz.
; 
; Variables globales utilizadas:    
; m        : Matriz 4x4 donde hay los números del tablero de juego.
; score    : Puntos acumulados hasta el momento.
; state    : Estado del juego. (2: Se han hecho movimientos).
;;;;;  
addPairsRP1:
   push rbp
   mov  rbp, rsp

          
   
   mov rsp, rbp
   pop rbp
   ret
   

;;;;;; 
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla (una sola vez, sin hacer un bucle) llamando a la 
; subrutina getchP1 que la guarda en la variable (charac).
; Según la tecla leída llamaremos a las subrutinas que corresponda.
;    ['i' (arriba),'j'(izquierda),'k' (a bajo) o 'l'(derecha)] 
; Desplazar los números y hacer las parejas según la dirección escogida.
; Según la tecla pulsada, rotar la matriz llamando (rotateMatrixRP1),
; para poder hacer los desplazamientos de los números hacia la derecha
; (shiftNumbersRP1),  hacer las parejas hacia la derecha (addPairsRP1) 
; y volver a desplazar los números hacia la izquierda (shiftNumbersRP1) 
; con las parejas hechas, después seguir rotando llamando (rotateMatrixRP1) 
; hasta dejar la matriz en la posición inicial. 
; Para la tecla 'l' (dercha) no hay que hacer rotaciones, para el
; resto se tienen que hacer 4 rotaciones.
;    '<ESC>' (ASCII 27)  poner (state = '0') para salir del juego.
; Si no es ninguna de estas teclea no hacer nada.
; Los cambios producidos por estas subrutina no se tiene que mostrar en 
; pantalla, por lo tanto, hay que actualizar después el tablero llamando 
; la subrutina UpdateBoardP1.
;
; Variables globales utilizadas: 
; charac   : Carácter que leemos de teclado.
; state    : Indica el estado del juego. '0':salir, '1':jugar
;;;;;  
readKeyP1:
   push rbp
   mov  rbp, rsp

   push rax 
      
   call getchP1    ; Leer una tecla y dejarla en charac.
   mov  al, BYTE[charac]
      
   readKeyP1_i:
   cmp al, 'i'      ; arriba
   jne  readKeyP1_j
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      call rotateMatrixRP1
      call rotateMatrixRP1
      jmp  readKeyP1_End
      
   readKeyP1_j:
   cmp al, 'j'      ; izquierda
   jne  readKeyP1_k
      call rotateMatrixRP1
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      call rotateMatrixRP1
      jmp  readKeyP1_End
      
   readKeyP1_k:
   cmp al, 'k'      ; abajo
   jne  readKeyP1_l
      call rotateMatrixRP1
      call rotateMatrixRP1
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      jmp  readKeyP1_End

   readKeyP1_l:
   cmp al, 'l'      ; derecha
   jne  readKeyP1_ESC
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      jmp  readKeyP1_End

   readKeyP1_ESC:
   cmp al, 27      ; Salir del programa
   jne  readKeyP1_End
      mov BYTE[state], '0'

   readKeyP1_End:
   pop rax
      
   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Juego del 2048
; Función principal del juego
; Permite jugar al juego del 2048 llamando todas las funcionalidades.
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
;
; Pseudo-código:
; Inicializar estado del juego, (state='1')
; Borrar pantalla (llamar a la función clearScreen_C).
; Mostrar el tablero de juego (llamar a la función PrintBoardP1_C).
; Actualizar el contenido del Tablero de Juego y los puntos que se han 
; hecho (llamar a la función updateBoardP1).
; Mientras (state=='1') hacer
;   Leer una tecla (llamar a la función readKeyP1). Según la tecla 
;     leída llamar a las funciones que corresponda.
;     - ['i','j','k' o 'l'] desplazar los números y hacer las parejas 
;                           según la dirección escogida.
;     - '<ESC>'  (código ASCII 27) poner (state = '0') para salir.   
;   Si hemos movido algún número al hacer los desplazamientos o al hacer
;   las parejas (state==2) generar una nueva ficha (llamando a la función
;   insertTileP1_C) y poner la variable state a '1' (state='1').
;   Actualizar el contenido del Taublero de Juego y los puntos que se han
;   hecho (llamar a la función updateBoardP1).
; Fin mientras.
; Mostrar un mensaje debajo del tablero según el valor de la variable 
; (state). (llamar a la función printMessageP1_C).
; Salir: 
; Se ha terminado el juego.

; Variables globales utilizadas: 
; state  : Indica el estado del juego. '0':salir, '1':jugar
;;;;;  
playP1:
   push rbp
   mov  rbp, rsp
   
   mov BYTE[state], '1'      ;state = '1';  //estado para empezar a jugar   
   
   call clearScreen_C
   call printBoardP1_C
   call updateBoardP1

   playP1_Loop:               ;while  {     //Bucle principal.
   cmp  BYTE[state], '1'     ;(state == '1')
   jne  playP1_End
      
      call readKeyP1          ;readKeyP1_C();
      cmp BYTE[state], '2'   ;state == '2' //Si se ha hecho algun movimiento
      jne playP1_Next 
         call insertTileP1_C   ;insertTileP1_C(); //Añadr ficha (2)
         mov BYTE[state],'1'  ;state = '1';
      playP1_Next
      call updateBoardP1       ;updateBoardP1_C();
      
   jmp playP1_Loop

   playP1_End:
   call printMessageP1_C      ;printMessageP1_C();
                              ;Mostrar el mensaje para indicar como acaba.
   mov rsp, rbp
   pop rbp
   ret
