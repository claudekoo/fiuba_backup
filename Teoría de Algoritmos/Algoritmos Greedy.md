# Algoritmos Greedy

## Índice

- [Ventajas y desventajas](#ventajas-y-desventajas)
- [Problema de Scheduling](#problema-de-scheduling)
  - [Posibles criterios](#posibles-criterios)
  - [La charla que termina antes](#la-charla-que-termina-antes)
  - [Implementación](#implementaci%C3%B3n)
  - [Complejidad](#complejidad)
- [Árboles de Huffman](#arboles-de-huffman)

Algunos algoritmos greedy que ya vimos anteriormente:
- Dijkstra
- Prim
- Kruskal

En algoritmos greedy, en cada paso se toma la decisión óptima localmente, con la esperanza de encontrar la solución óptima global mediante ella.

## Ventajas y desventajas

**Ventajas:**
- Son intuitivos de pensar y fáciles de entender.
- Suelen funcionar rápido.
- Para problemas complejos, pueden ser una buena aproximación.

**Desventajas:**
- No siempre se llega a la solución óptima.
- Es difícil probar que se llega a la solución óptima.

## Problema de Scheduling

Tengo un aula donde se dan charlas. Cada instructor definió arbitrariamente e independientemente un horario de inicio y fin fijos, por lo que algunas charlas pueden estar superpuestas.

Mi objetivo es que se den la mayor cantidad de charlas, teniendo en cuenta que no se pueden dar más de una charla en un mismo horario.

Tenemos que determinar cómo seleccionamos las charlas: a la hora de hacerlo, un subconjunto de charlas pueden ser incompatibles y no ser elegibles en la solución.

### Posibles criterios

- **Horario de inicio:** seleccionar la charla que comienza antes.
- **Duración:** seleccionar la charla más corta.
- **El menos conflictivo:** seleccionar la charla que tiene menos conflictos con otras charlas.
- **Horario de fin:** seleccionar la charla que termina antes.

Las que no funcionan se pueden determinar con un contraejemplo:  
![charlas_1](imagenes/charlas_1.png)
![charlas_2](imagenes/charlas_2.png)

¿Qué pasa si no encontramos contraejemplo para un caso?  
Podemos intentar probar que utilizando ese criterio de selección, la misma nos lleva a obtener el óptimo global.

### La charla que termina antes

Aparenta ser imposible encontrar un contraejemplo para este criterio, por lo tanto intentaremos demostrar que esta heurística nos lleva a la solución óptima.  
Si demostramos lógicamente que el resultado es óptimo, entonces tendremos nuestro algoritmo greedy.

Primero definamos cómo va a funcionar:

### Pseudocódigo
```pseudo
Sea P set de charlas
Sea A set de charlas seleccionadas

Mientras P no esté vacío:
    Elegir charla i que termina antes
    A = A + {i}
    Eliminar de P todas las charlas que se superponen con i

Retornar A
```

El set retornado por el algoritmo es compatible, ya que en cada iteración se elimminan todas las charlas incompatibles con la seleccionada.

### Análisis del algoritmo: Optimalidad

Llamaremos O a un set de charlas óptimo.

No podemos asegurar que A = O, ya que podrían haber varias soluciones óptimas.

Queremos demostrar que |A| = |O|.

Para ello utilizaremos la idea de que el algoritmo greedy "se mantiene por delante" de la solución óptima.

Podemos enumerar los elementos de A en orden en el que fueron seleccionados:  
${i_1, i_2, ..., i_k}$ con |A| = k.

Además, podemos enumerar los elementos de O en orden de hora de inicio:  
${j_1, j_2, ..., j_m}$ con |O| = m.  
Ordenar por hora de inicio o por hora de finalización es lo mismo ya que las charlas son compatibles.

Compararemos las soluciones parciales construidas por greedy con los segmentos iniciales de la solución óptima.

Demostraremos que greedy siempre tiene al menos tantas charlas como la solución óptima.

### Demostración

Analicemos el primer elemento de O y A:  
Por cómo se selecciona en greedy, podemos ver que: $f(i_1) \leq f(j_1)$

Nunca $f(i_1) > f(j_1)$, ya que si fuese así, sería una violación de la elección greedy.

### Inducción

Queremos demostrar que para todo $r \leq k$, $f(i_r) \leq f(j_k)$.

Esto es cierto para nuestro caso base r = 1.  
Asumiremos que es cierto para r-1 con r>1, entonces $f(i_{r-1}) \leq f(j_{r-1})$.

Como O está compuesto por charlas compatibles:  
$f(j_{r-1}) \leq s(j_r)$

Dadas las últimas dos inecuaciones, es posible obtener:  
$f(i_{r-1}) \leq s(j_r)$

Eso implica que en el momento en que greedy seleccionó $i_r$ también podría haber seleccionado $j_r$. Y como greedy selecciona aquel disponible que termina antes, entonces $f(i_r) \leq f(j_r)$.

Esta lógica podemos aplicarla desde r = 1 hasta r = m, por lo que podemos concluir que nuestro algoritmo greedy es óptimo.

### Implementación

Para implementar de forma eficiente el pseudocódigo, debemos encontrar la forma de recorrer las charlas de forma conveniente según el criterio de selección.

Podemos ordenar las charlas por hora de finalización, y luego elegir el primer elemento de la lista ordenada, sacándo aquellos que no son compatibles.

```python
def scheduling(horarios):
	horarios_ordenados = ordenar_por_horario_fin(horarios)
	charlas = []
	for horario in horarios_ordenados:
		if len(charlas) == 0 or not hay_interseccion(charlas[-1], horario):
			charlas.append(horario)
	return charlas

def hay_intersection(anterior, nueva):
    return anterior[FIN] > nueva[INICIO]:
```

### Complejidad

El ordenamiento de las charlas tiene una complejidad de $O(n\ log\ n)$, y luego recorrerlas tiene una complejidad de $O(n)$. Por lo tanto, la complejidad temporal del algoritmmo es $O(n\ log\ n)$, y su complejidad espacial, intuitivamente, $O(n)$.


## Árboles de Huffman

### Qué son los códigos

Los **códigos** son una forma de representar mensajes utilizando una combinación de símbolos. Pueden tener longitud fija o variable, y se dice que son **decodificables** cuando para cualquier suceción de símbolos, se puede determinar un único mensaje. 

Los códigos de longitud fija son siempre decodificables, mientras que los de longitud variable pueden no serlo, ya que dada una sucesión de símbolos, no es posible determinar si un símbolo termina y otro comienza.

Los **códigos prefijos** son aquellos que son siempre decodificables, ya que no hay ningún código que sea prefijo de otro.

### Propuesta de Huffman

Huffman plantea una codificación prefija y de longitud variable basada en la frecuencia de los caracteres que componen un texto; utiliza un heap(de mínimos) de forma auxiliar para ir generando el árbol de códigos.  
Su solución es óptima, no existen otros códigos prefijos para una misma fuente que la codifique en menor longitud.

Sea Alfabeto $A = (a_1, a_2, ..., a_n)$  
Llamaremos $W = (w_1, w_2, ..., w_n)$ a sus frecuencias.

Vamos a construir $C(W) = (c_1, c_2, ..., c_n)$, códigos prefijos y binarios.

$Longitud(C(W)) = \sum_{i=1}^{n} w_i \cdot size(c_i)$

De tal forma que $Longitud(C(W)) \leq Longitud(T(W))$ para cualquier otro código prefijo T(W).

### Código prefijo: Árbol binario

Podemos representar un código prefijo mediante un árbol binario, donde las hojas son los códigos y cada nodo tiene 2 o ningún hijo. El algoritmo de Huffman permite que este árbol sea compacto y de código prefijo.

![huffman_1](imagenes/huffman_1.png)

### Algoritmo Greedy

Inicialmente cada código $c_i$ es un nodo hoja con peso $w_i$.

Mientras quede más de un nodo sin padre:  
Toma los dos nodos x, y de menor peso sin padre.
Crea un nuevo nodo z con $w_z = w_x + w_y$.
Define a z como padre de x e y.

![huffman_2](imagenes/huffman_2.png)

![huffman_3](imagenes/huffman_3.png)

![huffman_4](imagenes/huffman_4.png)

### Implementación

Utilizaremos un Heap de mínimos, donde el nodo del árbol será el elemento y la frecuencia su clave.

En cada iteración se obtienen los 2 nodos de menor peso y se ingresa un nuevo nodo con la suma de sus pesos.

El último elemento en el heap es la raíz del árbol.

```pseudo
Desde i = 1 a n
  Crear nodo z
  z.char = a[i]
  z.w = w[i]

  Heap.add(z, z.w)

Desde i = 1 a n-1
  x = Heap.get()
  y = Heap.get()

  Crear nodo z
  z.left = x
  z.right = y
  z.w = x.w + y.w

  Heap.add(z, z.w)

Retornar Heap.get()
```

$T(n) = O(n\ log\ n)$

### Optimalidad

Para probar que nuestro resultado es óptimo debemos realizar 2 demostraciones.

- Prueba de selección greedy  
Demostrar que elegir en dos mensajes de menor peso nos acerca a la solución óptima global.

- Prueba de los subproblemas  
Demostrar que el subproblema derivado de nuestra elección se puede solucionar mediante la misma selección greedy.

### Selección greedy

Sea $A = (a_1, a_2, ..., a_n)$ un alfabeto con frecuencias $W = (w_1, w_2, ..., w_n)$.

Sean a y b pertenecientes a A los 2 mensajes con menor frecuencia de la colección.

Existe un código prefijo óptimo tal que:  
$size(c_a) = size(c_b)$ y solo difieren en su ultimo bit.  
Además $size(c_a) = size(c_b) \geq size(c_i)$ con i en A - {a,b}.

x, y en A son siblings en hojas de máxima profundidad en árbol T.

a, b en A tal que $w_x \geq w_y \geq w_b \geq w_a$.

Intercambiamos a con x y b con y, y llamaremos T' al árbol resultante.

![huffman_5](imagenes/huffman_5.png)

Tenemos que:

$Longitud(C(W))= \sum_{i=1}^{n} w_i \cdot size(c_i)$

$Longitud(T(W))-Longitud(T'(W)) =$  
$w_a \cdot (size(a)) + w_b \cdot (size(b)) + w_x \cdot (size(x)) + w_y \cdot (size(y)) - w_a' \cdot (size(a')) - w_b' \cdot (size(b')) - w_x' \cdot (size(x')) - w_y' \cdot (size(y'))$

$size(a)=size(x')$  $size(x)=size(a')$  
$size(b)=size(y')$  $size(y)=size(b')$  
Y como los pesos no cambian:  
$(w_a - w_x)\cdot size(a) + (w_b - w_y) \cdot size(b) + (w_x - w_a) \cdot size(x) + (w_y - w_b) \cdot size(y)$  

Dado $w_x \geq w_y \geq w_b \geq w_a$ y $size(a) \leq size(b) \leq size(x) \leq size(y)$, entonces:

$Longitud(T(W))-Longitud(T'(W)) \geq 0$, es decir T' disminuye o mantiene el tamaño de T.

### Prueba de los subproblemas

Sea $A = (a_1, a_2, ..., a_n)$ un alfabeto con frecuencias $W = (w_1, w_2, ..., w_n)$.
Sean a y b en A los 2 mensajes de menor frecuencia.

$A' = A - {a,b} + {z}$ con $w_z = w_a + w_b$ y el resto de los pesos iguales.

Sea T el árbol de códigos prefijos óptimo para C.
Sea T' el árbol de códigos prefijos óptimo para C'.

Probaremos que T se puede obtener de T' reemplazando la hoja z por un nodo con hijos a y b, así demostrando que la solución greedy de un subproblema nos lleva a la solución óptima global.




