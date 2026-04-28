# Guía práctica para redactar el informe

**Proyecto:** Sistema de movilidad urbana con control adaptativo topográfico (PID UTN — AMUTNPA0007734)
**Becado:** Esteban Fidel Sian (BINID)
**Objetivo de esta guía:** que el becado redacte cada sección del informe con un criterio uniforme — mostrar, sección por sección, **una versión mala, una regular y una buena** del mismo contenido, y derivar de cada par de comparaciones tres preguntas-test que se puede aplicar a sí mismo antes de mandar el texto.

Esta guía complementa la *Guía de presentación de documentación y script* (documento 02). Mientras aquélla define la estructura y el formato del paper, ésta enseña a redactar.

---

## 1. Filosofía: redactar es decidir, no transcribir

Un buen informe no se escribe contando lo que se hizo en orden cronológico, sino **decidiendo qué información merece estar y cuál no**. Cada frase compite por su lugar en la página. Si una frase se puede borrar y la sección no pierde información, entonces sobraba — y dejarla puesta debilita las otras.

**El test de la frase borrable**

Tomar una sección ya redactada, y borrar una frase. Si el sentido del párrafo no cambia, esa frase no aportaba. Hacer esto en cada frase. Lo que queda es el informe verdadero. Lo que se borró era relleno.

Este test es la base de toda esta guía: las versiones "malas" que mostraremos son textos llenos de frases que pasan el test de borrabilidad sin pérdida — es decir, frases que están de adorno.

---

## 2. Orden recomendado de redacción

Una de las cosas que más demora el cierre de un avance es **arrancar por la introducción**. La introducción es la sección que mejor se escribe **al final**, cuando uno ya sabe exactamente qué hizo, qué obtuvo y qué concluye. Si se la escribe primero, después hay que reescribirla tres veces.

El orden eficiente es:

1. **Figuras y tablas finales.** Generarlas con sus captions definitivos antes de escribir nada. Son el esqueleto del paper.
2. **Sección de resultados (V).** Una subsección por figura, contando qué muestra y qué se concluye localmente.
3. **Sección de métodos / modelo (II y III).** Lo que hizo falta para llegar a esos resultados.
4. **Análisis del sistema (IV).** Los chequeos de Kalman, autovalores, etc.
5. **Discusión (VI).** Qué significan los resultados, comparados con la literatura.
6. **Conclusiones y trabajo futuro (VII).** Una vez que se sabe exactamente qué se logró.
7. **Introducción (I).** Ahora se puede contar la motivación porque se sabe a qué se apunta.
8. **Abstract.** Última sección de prosa que se escribe. Tiene que reflejar todo lo anterior.
9. **Título.** Lo último de todo. El título se cristaliza solo cuando todo está escrito.
10. **Referencias.** En paralelo, agregando cada vez que se cita algo.

Si se sigue este orden, cada sección se escribe una sola vez. Si se sigue el orden de lectura (1 → 10), cada sección se reescribe entre 2 y 4 veces.

---

## 3. Cómo redactar cada sección

Cada subsección de aquí en adelante tiene la misma estructura:

- **Pregunta-eje:** la pregunta que la sección debe contestar.
- **Versiones mala / regular / buena:** del mismo contenido, redactado con tres niveles distintos de calidad. Las versiones están construidas sobre lo que **el becado ya tiene** (modelo de 2do orden, script `Modelado_V1.m`, análisis de Kalman) o sobre lo que va a tener al cerrar el avance.
- **Tres preguntas-test:** para autoevaluar el propio texto.

---

### 3.1. Título

**Pregunta-eje:** ¿qué hice, sobre qué sistema, con qué enfoque?

**Versión mala:**

> *"Bicicletas eléctricas y freno regenerativo"*

Es un tema, no un trabajo. Cualquier libro o artículo del rubro podría llevar ese título.

**Versión regular:**

> *"Modelado en variables de estado de una bicicleta eléctrica"*

Ya dice qué se hizo y sobre qué, pero es genérico: no diferencia este trabajo de otros cinco posibles con el mismo título.

**Versión buena:**

> *"Modelo en variables de estado de una bicicleta eléctrica con freno regenerativo orientado a control adaptativo topográfico"*

Tiene el qué (modelo en variables de estado), el sobre qué (bicicleta con freno regenerativo) y el para qué (control adaptativo topográfico). Las tres palabras clave fuertes del PID están presentes.

**Tres preguntas-test:**

1. ¿Mi título contiene las palabras clave por las que alguien podría buscar este trabajo?
2. Si pongo mi título en Google Scholar, ¿podría confundirse con el de un libro genérico, o se ve que es un trabajo específico?
3. ¿Sobreviviría si tacho una palabra cualquiera, o cada palabra está cumpliendo una función?

---

### 3.2. Abstract

**Pregunta-eje:** ¿si alguien lee solamente el abstract, sabe qué hice y qué obtuve?

**Versión mala:**

> *"En este trabajo se realiza el modelado en variables de estado de una bicicleta eléctrica con freno regenerativo. Se desarrollan las ecuaciones que describen la dinámica mecánica y eléctrica del sistema, y se las combina en un modelo matricial. Se implementa el modelo en MATLAB y se realizan análisis de controlabilidad y observabilidad. Los resultados muestran que el sistema funciona correctamente. Se concluye que el modelado es adecuado para futuros desarrollos de control."*

**Diagnóstico:** no aparece **un solo número**. "Funciona correctamente" y "es adecuado" son frases vacías. Cualquier modelado de cualquier sistema podría llevar este mismo abstract.

**Versión regular:**

> *"Se presenta el modelado en variables de estado de una bicicleta eléctrica con freno regenerativo. El sistema se describe como el acoplamiento electromecánico entre la dinámica longitudinal de la bicicleta y un motor brushless DC tipo hub. A partir de la segunda ley de Newton y de la ecuación de tensión del motor se obtiene un modelo lineal de segundo orden, con la velocidad lineal y la corriente de armadura como variables de estado. El modelo se implementa en MATLAB y, mediante el criterio de Kalman, se verifica que es controlable y observable. El cálculo de autovalores indica que el sistema es asintóticamente estable. El modelo obtenido constituye la base para etapas posteriores del proyecto."*

**Diagnóstico:** ya describe qué se modela y qué se analiza, pero no dice **qué número salió** de cada análisis. El lector sabe que el sistema es estable, pero no si los polos están en `−0.3` o en `−300` — son escenarios físicos completamente distintos.

**Versión buena:**

> *"Este trabajo presenta el modelo en variables de estado de una bicicleta eléctrica con freno regenerativo, formulado como un sistema lineal de segundo orden cuyos estados son la velocidad lineal `v` de la bicicleta y la corriente de armadura `i` del motor brushless DC. La entrada del modelo es la tensión aplicada en bornes del motor por un convertidor Buck-Boost, y las salidas son ambos estados. El modelo acopla la ecuación de Newton (linealizada en torno a un punto de operación de crucero) con la ecuación eléctrica del motor mediante las constantes electromecánicas `Kt` y `Ke`. Con parámetros nominales correspondientes a una bicicleta urbana de 85 kg con motor hub de 350 W, el modelo se implementa en MATLAB y se analiza por criterio de Kalman: el sistema resulta completamente controlable y observable (rango 2 en ambas matrices). Los autovalores son `λ₁ ≈ −0.3 s⁻¹` y `λ₂ ≈ −50 s⁻¹`, asociados respectivamente a un modo mecánico lento y a un modo eléctrico rápido, lo que confirma estabilidad asintótica. El modelo constituye la base teórica para el diseño del controlador adaptativo topográfico previsto en la siguiente etapa del proyecto."*

**Diagnóstico:** mencionar el rango 2, los valores `λ₁` y `λ₂`, la separación entre modos, los 85 kg, el motor de 350 W, y el cierre con la próxima etapa, son las cinco diferencias decisivas. Todos esos datos ya están en el script `Modelado_V1.m`. Lo que diferencia esta versión de la regular **no es trabajo nuevo, es honestidad cuantitativa**.

**Tres preguntas-test:**

1. ¿Aparece al menos un número concreto que sólo pude obtener haciendo este trabajo? (Si los números del abstract son los mismos que están en cualquier libro del rubro, no aporté nada.)
2. Si voy frase por frase y tacho una a una, ¿en cuáles se pierde información real y en cuáles no?
3. ¿El último renglón dice qué viene después? (Sin esto, el lector queda con la sensación de "¿y entonces?".)

---

### 3.3. Palabras clave

**Pregunta-eje:** ¿con qué cinco términos quiero que mi trabajo aparezca en una búsqueda?

**Versión mala:**

> *"Bicicleta, motor, simulación, MATLAB, control"*

Términos demasiado generales — ninguno hace que se distinga este paper de cien parecidos.

**Versión regular:**

> *"Bicicleta eléctrica, motor brushless, freno regenerativo, MATLAB, espacio de estados"*

Mejor, pero `MATLAB` no aporta (la mayoría de los trabajos del rubro usan MATLAB).

**Versión buena:**

> *"Variables de estado, freno regenerativo, motor brushless DC, control adaptativo, movilidad urbana eléctrica"*

Cinco términos, todos del PID, y `MATLAB` se sustituye por algo que sí caracteriza al trabajo (el control adaptativo, núcleo del PID).

**Tres preguntas-test:**

1. ¿Cada palabra clave es lo suficientemente específica como para que un trabajo distinto al mío también la lleve?
2. ¿Aparecen al menos tres de las palabras clave del PID original?
3. ¿Hay alguna palabra clave que sea simplemente una herramienta usada (MATLAB, Python, Word) en lugar de una idea del trabajo? Si la hay, sacarla.

---

### 3.4. Introducción

**Pregunta-eje:** ¿por qué importa este problema, qué se sabe ya, y qué hace este paper?

La introducción se estructura en tres bloques que en orden son: **contexto y motivación → estado del arte → aporte y organización**. Mostraremos cada bloque con sus tres niveles.

#### 3.4.1. Bloque 1 — contexto y motivación (un párrafo)

**Versión mala:**

> *"Hoy en día la movilidad eléctrica es importante. Existen muchos vehículos eléctricos en el mundo. En este trabajo se estudia uno de ellos, la bicicleta eléctrica."*

Tres frases vacías que no dan contexto regional, no señalan un problema, no anclan la motivación.

**Versión regular:**

> *"La movilidad eléctrica urbana ha crecido en las últimas décadas debido a la necesidad de reducir las emisiones de gases de efecto invernadero y la dependencia de combustibles fósiles. Las bicicletas eléctricas ofrecen una alternativa eficiente para distancias cortas. Este trabajo aborda su modelado."*

Mejor, pero todavía es genérica — podría leerse en un trabajo de cualquier país sobre cualquier vehículo eléctrico. No hace mención al contexto regional del PID.

**Versión buena:**

> *"La movilidad urbana eléctrica de baja escala —bicicletas, monopatines y scooters— ha crecido sostenidamente en la última década en Argentina, impulsada por la búsqueda de transporte personal sustentable y por la ausencia de homologación obligatoria para circular en vía pública. En ciudades con topografía variable como Paraná, donde se alternan tramos planos largos con barrancas pronunciadas hacia el río, el desempeño de un vehículo eléctrico personal depende fuertemente de cuán bien el sistema de propulsión y frenado se adapte a la pendiente. En particular, el frenado regenerativo es atractivo no por la magnitud de la energía recuperada —relativamente baja en bicicleta [Oman & Morchin, 2006]— sino por su integración natural con un control que regule simultáneamente el frenado seguro y la recarga de la batería."*

Ancla local (Paraná y barrancas), nombra el problema concreto (adaptación a la pendiente), y de paso desmonta una intuición errónea (que el regenerativo se justifica por la energía recuperada): muestra que el autor entiende el rubro.

#### 3.4.2. Bloque 2 — estado del arte (uno o dos párrafos)

**Versión mala:**

> *"Hay muchos trabajos sobre bicicletas eléctricas. Algunos modelan el sistema con ecuaciones diferenciales. Otros usan control PID. También hay enfoques con redes neuronales. En este trabajo usamos variables de estado."*

Lista de cosas que existen sin agruparlas, sin citas, sin diferenciar enfoques relevantes de irrelevantes.

**Versión regular:**

> *"Diversos autores han modelado vehículos eléctricos. Oman y Morchin [1] desarrollan un modelo de potencia para bicicletas. Chau [2] aborda máquinas eléctricas. Larminie y Lowry [3] estudian la tecnología. En cuanto al control, hay trabajos con PID y con MRAC."*

Tiene citas pero las trata como ladrillos sueltos, no como una conversación entre autores. No hay agrupación temática.

**Versión buena:**

> *"El modelado dinámico de bicicletas eléctricas tiene una literatura consolidada. Oman y Morchin [1] presentan un modelo de potencia que separa las contribuciones aerodinámica, de rodadura y gravitatoria, y reportan eficiencias de regeneración del 40–60 % en condiciones realistas. Larminie y Lowry [2] y Chau [3] extienden este tipo de análisis a vehículos eléctricos en general. En cuanto al modelado del motor brushless, los textos de Hendershot y Miller [4] y Xia [5] son de referencia para la representación equivalente como motor de corriente continua, válida cuando interesa la dinámica promedio y no el detalle de las fases. La integración de ambas dinámicas en un modelo en variables de estado, sin embargo, se aborda con menos frecuencia en la literatura aplicada al diseño de controladores adaptativos para movilidad urbana — particularmente cuando la pendiente del terreno se trata como entrada de control y no como una perturbación a rechazar."*

Las referencias se agrupan por temática (modelado mecánico, modelado eléctrico) y se cierra con un *gap* — un hueco en la literatura que justifica el trabajo.

#### 3.4.3. Bloque 3 — aporte y organización (un párrafo)

**Versión mala:**

> *"En este trabajo se modela una bicicleta eléctrica."*

No dice nada que el título no haya dicho.

**Versión regular:**

> *"En este trabajo se desarrolla un modelo en variables de estado para una bicicleta eléctrica con freno regenerativo y se simula en MATLAB. El paper está organizado en seis secciones."*

Avanza pero todavía es escueto, y el "está organizado en seis secciones" es relleno (eso ya lo ve el lector solo).

**Versión buena:**

> *"Este trabajo aporta un modelo lineal de segundo orden en variables de estado de una bicicleta eléctrica con freno regenerativo, formulado con la pendiente del terreno como entrada de perturbación medible y orientado al diseño posterior de un controlador adaptativo. Se verifica controlabilidad y observabilidad por criterio de Kalman, se simulan tres escenarios topográficos y se cuantifica la eficiencia del frenado regenerativo. El modelo no incluye la dinámica de la batería ni saturaciones del convertidor de potencia; estas extensiones quedan reservadas a etapas posteriores del proyecto."*

Dice qué hace, qué obtiene y **qué no hace** — esa última frase, declarar las limitaciones del propio aporte, es lo que separa una introducción competente de una pretenciosa.

**Tres preguntas-test para la introducción completa:**

1. ¿Mi introducción contesta "¿por qué importa esto?" antes de "¿qué hice?"?
2. ¿Cito al menos cinco trabajos previos y los **agrupo por tema** (no como lista enumerativa)?
3. ¿El último párrafo dice claramente lo que **no** hago, además de lo que sí?

---

### 3.5. Marco teórico y modelo matemático

**Pregunta-eje:** ¿otra persona puede llegar a las mismas ecuaciones partiendo de mis hipótesis?

Esta sección es predominantemente técnica, no de prosa. Aquí la metodología no es "mala / regular / buena" sino **una checklist de hipótesis y una plantilla mínima**.

#### Plantilla mínima de la sección

```
A. Hipótesis del modelo
   (lista numerada de 4–6 supuestos simplificadores)

B. Dinámica mecánica
   - Diagrama de cuerpo libre (figura)
   - Segunda ley de Newton con todas las fuerzas
   - Modelado de cada fuerza resistiva
   - Linealización con punto de operación explícito

C. Dinámica eléctrica
   - Diagrama del circuito equivalente (figura)
   - Ecuación de Kirchhoff
   - Convención de signos en modo motor y modo generador

D. Acoplamiento electromecánico
   - Ecuaciones T = Kt·i  y  e = Ke·ω
   - Relación cinemática v = ω·r
```

#### Hipótesis, ejemplo de cómo declararlas

**Versión mala** (hipótesis implícitas, no declaradas):

> *"Aplicando la segunda ley de Newton al sistema..."*

El lector tiene que adivinar qué se está despreciando.

**Versión buena** (hipótesis explícitas):

> *"Para el modelado se asume:*
>
> *(i) la bicicleta se comporta como una masa puntual; se desprecia la dinámica del cuadro y la suspensión;*
>
> *(ii) el aire está en calma (velocidad de viento nula respecto al suelo);*
>
> *(iii) los neumáticos no derrapan (rodadura pura);*
>
> *(iv) el motor brushless DC se modela en su equivalente de corriente continua promediado, es decir, se desprecia la dinámica de conmutación de fases;*
>
> *(v) la batería se modela como fuente ideal de tensión, sin variación con el SOC ni resistencia interna;*
>
> *(vi) el convertidor Buck-Boost se modela en estado promediado, despreciando la dinámica de conmutación a alta frecuencia."*

Las seis hipótesis listadas explican exactamente cuáles dinámicas no están en el modelo. Esto es lo que el lector necesita para juzgar si el modelo le sirve para su propio problema.

**Tres preguntas-test:**

1. ¿Listo todas las hipótesis simplificadoras al inicio de la sección, antes de cualquier ecuación?
2. ¿Si otro becado toma mis hipótesis y trata de derivar las mismas ecuaciones, llega al mismo resultado sin tener que adivinar nada?
3. ¿Cada variable se define la primera vez que aparece, con su unidad?

---

### 3.6. Representación en variables de estado

**Pregunta-eje:** ¿cuáles son los estados, las entradas, las salidas y las matrices, con sus dimensiones y unidades?

Esta sección debe ser **breve y mecánica**: una serie de definiciones formales.

#### Plantilla mínima

```
Sea x = [v; i] ∈ ℝ²    (vector de estados)
    u = V_m ∈ ℝ        (entrada de control)
    d = sin(θ) ∈ ℝ     (perturbación medible)
    y = [v; i] ∈ ℝ²    (salidas)

El modelo lineal queda:

    ẋ = A·x + B_u·u + B_d·d
    y = C·x + D·u

con

    A = [...]    (con unidades de cada elemento)
    B_u = [...]
    B_d = [...]
    C = I_2
    D = 0
```

**Tres preguntas-test:**

1. ¿Para cada matriz declaro sus dimensiones?
2. ¿Cada elemento de las matrices tiene unidad consistente?
3. ¿La sección se puede leer en menos de un minuto? (Si toma más, sobra prosa.)

---

### 3.7. Análisis del sistema

**Pregunta-eje:** ¿el modelo cumple las condiciones formales para que sirva al control que se va a diseñar después?

Esta sección presenta los resultados de Kalman y los autovalores. La metodología recomendada: **una afirmación por línea, cada una con su número**.

**Versión mala:**

> *"Se calculó la matriz de controlabilidad y se obtuvo que el sistema es controlable. También se analizó la observabilidad y resultó observable. Los autovalores indican estabilidad."*

Tres afirmaciones cualitativas, cero números.

**Versión buena:**

> *"La matriz de controlabilidad `C_o = [B_u  A·B_u]` tiene rango 2, igual al orden del sistema; por lo tanto, el par (A, B_u) es completamente controlable. La matriz de observabilidad `O_b = [C; C·A]` también tiene rango 2, así que el par (A, C) es completamente observable. Los autovalores de A son `λ₁ ≈ −0.3 s⁻¹` y `λ₂ ≈ −50 s⁻¹`. Ambos tienen parte real negativa, por lo que el sistema es asintóticamente estable. La separación de magnitudes entre los autovalores es de aproximadamente dos órdenes, indicando una dinámica de dos escalas: un modo eléctrico rápido (asociado a la inductancia y resistencia del motor) y un modo mecánico lento (asociado a la masa y al coeficiente viscoso). Esta separación habilita un análisis por escalas temporales para el diseño del controlador."*

Cada frase aporta un número o una conclusión derivada de un número. La última oración es la bisagra hacia el diseño del control.

**Tres preguntas-test:**

1. ¿Cada conclusión cualitativa está respaldada por al menos un valor numérico explícito?
2. ¿Saco el "se concluye que" y digo directamente la conclusión?
3. ¿La sección termina enlazando con el diseño del controlador, o queda flotando en el vacío?

---

### 3.8. Resultados de simulación (cómo presentar cada figura)

**Pregunta-eje:** ¿cada figura responde una pregunta concreta y se discute al lado?

#### El patrón de subsección por figura

Cada subsección de resultados debe seguir esta estructura:

```
1. Una frase que enuncia la pregunta de la simulación.
2. La figura (con caption autocontenido).
3. Dos o tres frases que extraen los números de la figura.
4. Una frase de conclusión local.
```

#### Ejemplo aplicado al frenado regenerativo en bajada

**Versión mala:**

> *"En la Figura 5 se observa la simulación del frenado regenerativo. Se ve que la corriente cambia de signo y la velocidad disminuye. El sistema funciona como se esperaba."*

No hay números, no hay pregunta, no hay conclusión.

**Versión buena:**

> *"Para evaluar el comportamiento del sistema en frenado regenerativo, se simula una bajada con θ = −5° desde una velocidad inicial de 8 m/s con el ciclo de trabajo del convertidor configurado para imponer una corriente de carga de 5 A en la batería. La Figura 5 muestra la evolución de v(t) e i(t) durante 4 s.*
>
> *La velocidad se reduce de 8 m/s a 2.5 m/s en 3.2 s. La corriente de armadura adopta valores negativos (signo opuesto al modo motor), confirmando el flujo de energía hacia la batería. Integrando V_m·i a lo largo de la simulación, se recupera una energía de 1.34 Wh, equivalente al 47 % de la energía cinética disipada. Este valor se ubica en el extremo inferior del rango (40–60 %) reportado por Oman y Morchin para frenado regenerativo en bicicleta urbana, lo que es consistente con un convertidor sin optimizar."*

La pregunta está enunciada al inicio. Los números (8 → 2.5 m/s, 3.2 s, 1.34 Wh, 47 %) están todos. La conclusión local **conecta con la literatura**.

**Tres preguntas-test por figura:**

1. ¿Mi caption se entiende sin el cuerpo del texto?
2. ¿Mi prosa adyacente al texto contiene al menos tres números extraídos de la figura?
3. ¿Cada subsección termina con una conclusión local que ata el resultado a la literatura o al objetivo del paper?

---

### 3.9. Discusión

**Pregunta-eje:** ¿qué significan los resultados, qué tan creíbles son, y dónde quedan sus límites?

La discusión es la sección donde más se nota la madurez del autor. Los becados suelen escribirla **defensivamente** ("todo salió bien") en lugar de **críticamente** ("salió esto, esto y esto, con estas limitaciones").

**Versión mala (defensiva):**

> *"Los resultados muestran que el modelo predice perfectamente el comportamiento del sistema en todos los escenarios. La eficiencia obtenida es excelente y comparable con la literatura. El modelo es válido para todas las condiciones de uso de la bicicleta."*

Triple sobreafirmación. "Perfectamente", "excelente" y "todas las condiciones" son afirmaciones que ningún modelo lineal puede sostener honestamente.

**Versión regular (descriptiva pero plana):**

> *"El modelo predice una eficiencia de regeneración del 47 %, dentro del rango reportado en la literatura. Las simulaciones en distintos escenarios topográficos muestran comportamientos coherentes con la física del sistema. El modelo tiene limitaciones porque es lineal."*

Avanza, pero "limitaciones porque es lineal" es genérico — no dice cuándo deja de servir.

**Versión buena (crítica y honesta):**

> *"La eficiencia del 47 % obtenida en simulación se ubica en el extremo inferior del rango 40–60 % reportado por Oman y Morchin [1]. Esta coincidencia es razonable pero debe leerse con cautela: en este modelo se asume un convertidor Buck-Boost ideal en estado promediado, lo que sobreestima el rendimiento real. La eficiencia experimental, una vez que el banco de pruebas esté disponible, será necesariamente menor.*
>
> *El modelo lineal es válido para velocidades dentro de ±30 % del punto de operación elegido (5 m/s). Para v < 1 m/s, la linealización del término aerodinámico introduce un error mayor al 25 %. Para v > 8 m/s, las hipótesis de pequeñas señales y de aire en calma dejan de cumplirse en condiciones urbanas reales (corrientes de aire entre edificios, frenadas bruscas). Estos rangos de validez se acotarán experimentalmente en la siguiente etapa del proyecto.*
>
> *El análisis de sensibilidad muestra que una variación del ±20 % en el coeficiente viscoso B desplaza el polo dominante en un 19 %, mientras que las variaciones en R y L afectan principalmente al modo eléctrico rápido sin alterar la dinámica mecánica. Esto tiene una consecuencia directa para el diseño del control: la incertidumbre en B es la principal fuente de variabilidad y justifica un esquema adaptativo que pueda re-sintonizarse en función del estado de carga, peso del ciclista, presión de los neumáticos y pendiente."*

Tres párrafos, cada uno respondiendo a una de las tres preguntas obligatorias de la discusión:

1. ¿Los resultados son creíbles? (Sí, pero con caveats.)
2. ¿Dónde dejan de valer? (Rango ±30 % de v₀.)
3. ¿Qué consecuencia tienen para lo que viene? (Justifican el control adaptativo.)

**Tres preguntas-test:**

1. ¿Hay al menos un párrafo dedicado exclusivamente a las limitaciones del modelo?
2. ¿Cuando comparo con la literatura, lo hago con números específicos o con frases vagas tipo "es similar"?
3. ¿La discusión hace puente con la próxima etapa del proyecto, o queda en el aire?

---

### 3.10. Conclusiones y trabajo futuro

**Pregunta-eje:** ¿qué se logró concretamente, y qué viene después?

Es la sección más cortita del paper (idealmente 2 párrafos: uno de cada cosa). Y la más confundida con el abstract. **No es un resumen del trabajo** — el abstract ya cumple esa función. Las conclusiones son **decisiones derivadas** del trabajo.

**Versión mala (resumen disfrazado de conclusión):**

> *"En este trabajo se modeló una bicicleta eléctrica con freno regenerativo en variables de estado. Se hicieron simulaciones en MATLAB. Se obtuvieron resultados satisfactorios. Como trabajo futuro se propone seguir investigando."*

Es un mini-abstract. "Resultados satisfactorios" no es una conclusión. "Seguir investigando" no es trabajo futuro.

**Versión buena:**

> *"Se desarrolló y verificó un modelo en variables de estado de una bicicleta eléctrica con freno regenerativo, válido en torno a un punto de operación de crucero (5 m/s) y con la pendiente del terreno como entrada de perturbación medible. Los autovalores del sistema, separados en aproximadamente dos órdenes de magnitud, permiten un diseño de control por escalas temporales. La eficiencia simulada del frenado regenerativo (47 %) y el análisis de sensibilidad confirman que un controlador con ganancias fijas no alcanza para cubrir el espectro de condiciones de uso, y justifican la estrategia adaptativa.*
>
> *El trabajo futuro inmediato consiste en (i) la identificación experimental de los parámetros R, L, Kt, Ke y B sobre el motor brushless real disponible en el laboratorio, mediante los procedimientos descriptos en [Oman & Morchin, cap. 7]; (ii) el diseño del controlador adaptativo por Gain Scheduling sobre la pendiente; y (iii) la validación experimental sobre el banco de pruebas. Estas tareas corresponden a la segunda etapa del cronograma del proyecto PID."*

Cada frase es decisión: "se separan los autovalores → escalas temporales", "ganancias fijas no alcanzan → adaptativo". El trabajo futuro tiene tres tareas concretas con cronograma del PID.

**Tres preguntas-test:**

1. ¿Mis conclusiones son distintas del abstract o son lo mismo en otras palabras?
2. ¿Cada conclusión es una **decisión derivada** del trabajo, no un resumen del mismo?
3. ¿Mi trabajo futuro tiene tareas concretas con verbos de acción, o solamente "seguir investigando"?

---

### 3.11. Referencias

**Pregunta-eje:** ¿cada cita se puede recuperar inequívocamente?

La metodología práctica:

- Una cita por afirmación de hecho.
- Una cita por parámetro tomado de la literatura.
- Mínimo 10 referencias para un paper corto.
- Formato IEEE estricto.

**Versión mala:**

> *[1] Oman, libro de bicicletas, 2006.*

Faltan datos: editorial, ciudad, autor completo.

**Versión buena:**

> *[1] H. Oman and W. Morchin, Electric Bicycles: A Guide to Design and Use. Hoboken, NJ: Wiley-IEEE Press, 2006.*

**Tres preguntas-test:**

1. ¿Cualquiera de mis lectores puede ir a la biblioteca o a IEEE Xplore y conseguir cada referencia con los datos que doy?
2. ¿Hay alguna afirmación numérica en mi paper que no tenga cita y no provenga de mis simulaciones?
3. ¿Estoy citando libros que efectivamente leí, o la cita es de adorno?

---

## 4. Cómo se ven las transiciones entre secciones

Una sección no termina en seco y la siguiente no arranca de la nada. Cada sección debe terminar **señalando lo que viene** y la siguiente debe arrancar **enlazando con lo que terminó**.

**Versión mala (ruptura brusca):**

> *Final de Sección II:* "...con esto se completa el modelo."
>
> *Inicio de Sección III:* "El sistema en variables de estado se representa como..."

**Versión buena (con transición):**

> *Final de Sección II:* "Las dos ecuaciones diferenciales obtenidas, una mecánica y otra eléctrica, están acopladas mediante las constantes Kt y Ke. La sección siguiente las consolida en una representación matricial en variables de estado."
>
> *Inicio de Sección III:* "Tomando como vector de estados x = [v; i] y como entrada u = V_m, el sistema (4)–(8) se reescribe..."

Tres líneas extra y el paper se lee como un texto continuo en lugar de como un conjunto de fichas pegadas.

---

## 5. Lista final de revisión por sección

Aplicar a cada sección, en orden, antes de mandar:

| Sección | Test obligatorio |
|---------|------------------|
| Título | ¿Sobrevive a tachar una palabra cualquiera? |
| Abstract | ¿Tiene al menos un número que solo este trabajo entrega? |
| Palabras clave | ¿Cinco términos, ninguno trivial (no "MATLAB")? |
| Introducción | ¿Cuenta el "por qué" antes que el "qué"? |
| Marco teórico | ¿Las hipótesis están listadas explícitamente? |
| Variables de estado | ¿Cada matriz tiene dimensiones y unidades? |
| Análisis | ¿Hay un número detrás de cada conclusión? |
| Resultados | ¿Cada figura tiene tres números extraídos en la prosa? |
| Discusión | ¿Hay un párrafo dedicado a limitaciones? |
| Conclusiones | ¿Son distintas del abstract? |
| Referencias | ¿Cada una se puede recuperar a partir de los datos dados? |

Si cualquier ítem se responde "no", ese es el lugar donde hay que volver.

---

## 6. El test de la persona ajena

La prueba final, antes de entregar, es darle el paper a alguien que no tiene contexto del proyecto — puede ser otro becado de un PID distinto, un compañero de carrera, incluso un familiar con formación técnica. Pedirle que lo lea y, sin discutir nada, que conteste tres preguntas:

1. ¿De qué se trata el trabajo?
2. ¿Qué hizo el autor concretamente?
3. ¿Qué obtuvo?

Si las tres respuestas son razonablemente correctas, el paper está bien escrito. Si la persona duda, da una respuesta vaga o pregunta "¿podés explicarme antes?", **el paper no está listo**.

Esta prueba detecta lo que ningún corrector ortográfico encuentra: que el texto **se entienda solo**, sin el autor al lado.

---

## 7. Consejo final

La escritura científica es una habilidad. Como cualquier habilidad, mejora con horas de práctica y empeora con la postergación. Las versiones "buenas" mostradas en esta guía no se escribieron en un solo intento — son el resultado de tres o cuatro pasadas de revisión. La primera versión que sale de la cabeza casi siempre es la versión "regular" o incluso la "mala". El trabajo de pulir es **donde se hace la diferencia**.

Una regla útil: **escribir la sección completa, dejarla descansar 24 horas, y volver a leerla con ojos nuevos**. La cantidad de "frases borrables" que aparecen en esa segunda lectura suele sorprender al propio autor.

Y otra: **leer en voz alta**. Si una frase no se puede leer en voz alta sin trabarse, está mal escrita. La escritura técnica que suena artificial cuando se la pronuncia, también lee artificial cuando se la lee.

El objetivo final no es escribir un paper que apruebe una revisión — es escribir un paper que **el propio autor pueda releer dentro de cinco años y entender qué hizo y por qué**. Si pasa esa prueba, también va a pasar las demás.
