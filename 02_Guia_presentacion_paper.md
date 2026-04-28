# Guía de presentación de documentación y script — formato paper

**Proyecto:** Sistema de movilidad urbana con control adaptativo topográfico (PID UTN — AMUTNPA0007734)
**Becado:** Esteban Fidel Sian (BINID)
**Objetivo de la guía:** que el avance final del becado quede formateado y documentado de modo que pueda transformarse, con mínimo trabajo adicional, en una ponencia o paper para congresos del rubro (CASE, AADECA, RPIC, ARGENCON, IEEE LATINCON, entre otros).

---

## Cómo usar esta guía

Cada apartado incluye **preguntas guía** para auto-evaluar lo que se redacta, y **ejemplos ilustrativos** del tipo "❌ así no" / "✅ así sí". Si el becado no puede distinguir entre los ejemplos buenos y malos, ése es el punto de la guía donde tiene que detenerse y trabajar más.

---

## 1. Filosofía general

Un avance de beca y un paper no son lo mismo, pero deben **convivir en un único documento bien escrito**. La regla práctica es:

- Estructura del paper.
- Profundidad y honestidad de un informe interno.
- Reproducibilidad de un trabajo experimental.

Esto significa que el informe del becado se redacta **como si fuera un paper corto** (6 a 10 páginas), con todas las secciones propias del formato. Lo que sobre o falte respecto a un paper publicable se ajusta luego.

**Preguntas guía generales:**

- ¿Mi informe se entiende leyéndolo solo, sin que yo esté al lado explicando?
- ¿Si lo lee alguien que no conoce el PID, entiende el problema, lo que hice y para qué sirve?
- ¿Cada afirmación que hago está respaldada por una ecuación, una simulación, una figura o una cita? (Si no lo está, es opinión, y la opinión no va en un paper.)

---

## 2. Estructura del documento (formato IEEE)

### 2.1. Plantilla y formato físico

- **Plantilla:** IEEE Conference (`IEEEtran` en LaTeX, o la plantilla `.docx` equivalente). Bajar de https://www.ieee.org/conferences/publishing/templates.html.
- **Idioma:** español (los congresos argentinos lo aceptan). Título y abstract también en inglés.
- **Tamaño:** 6 páginas como objetivo, 8 como máximo.
- **Tipografía y márgenes:** los que vienen en la plantilla, sin modificar.
- **Ecuaciones:** numeradas todas, alineadas a la derecha, escritas con editor matemático (no como texto plano). Variables en cursiva (v, i), vectores en negrita (**x**), matrices en mayúscula negrita (**A**).
- **Figuras:** vectoriales (`.eps` o `.pdf`) generadas desde MATLAB con `print -depsc` o `exportgraphics`. Resolución mínima 300 dpi si son raster.
- **Tablas:** con `booktabs` (LaTeX) o estilo limpio sin sombreados.

### 2.2. Secciones obligatorias

```
Título
Autores y filiación
Abstract (español)  +  Abstract (English)
Index Terms / Palabras clave
I.   Introducción
II.  Marco teórico y modelo matemático
III. Representación en variables de estado
IV.  Análisis del sistema
V.   Resultados de simulación
VI.  Discusión
VII. Conclusiones y trabajo futuro
Agradecimientos
Referencias
```

### 2.3. Contenido esperado por sección

#### Título

Concreto y específico. Evitar genérico.

**Preguntas guía:**

- ¿Mi título dice qué hice, sobre qué sistema, y con qué enfoque?
- ¿Alguien que busque "freno regenerativo" o "variables de estado" lo encontraría por palabras clave?

**Ejemplos ilustrativos:**

> ❌ *"Estudio sobre bicicletas eléctricas"* (vago, no dice nada).
> ❌ *"Análisis de un sistema"* (peor todavía).
> ⚠️ *"Modelado de bicicleta eléctrica"* (correcto pero pobre).
> ✅ *"Modelo en variables de estado de una bicicleta eléctrica con freno regenerativo orientado a control adaptativo topográfico"* (concreto, específico, con palabras clave).

#### Abstract (≤ 200 palabras)

En un párrafo único debe responder a: qué problema, qué se hizo, qué se obtuvo numéricamente, qué se concluyó. Sin citas. Sin acrónimos no expandidos. La versión en inglés es traducción fiel, no resumen distinto.

**Preguntas guía:**

- ¿Mi abstract menciona al menos un número concreto (eficiencia, tiempo de establecimiento, error)?
- ¿Si alguien lee solo el abstract, sabe qué hice y qué obtuve?
- ¿Hay siglas sin expandir o citas? (No tiene que haber.)

**Ejemplos ilustrativos:**

> ❌ Abstract malo (vago, sin números, no dice qué se concluye):
>
> *"En este trabajo se estudia el modelado de bicicletas eléctricas con freno regenerativo. Se utilizan ecuaciones de variables de estado y se hacen simulaciones en MATLAB. Los resultados son satisfactorios y se discuten las posibilidades de control. Se concluye que el sistema funciona."*

> ✅ Abstract bueno (concreto, con números, dice qué se concluye):
>
> *"Este trabajo presenta un modelo en variables de estado de una bicicleta eléctrica con freno regenerativo, formulado con la pendiente del terreno como entrada de perturbación medible. El modelo es lineal en torno a un punto de operación de 5 m/s e incluye el acoplamiento electromecánico de un motor BLDC tipo hub. Se verifica que el sistema es completamente controlable y observable por criterio de Kalman. Mediante simulación en MATLAB se evalúan tres escenarios topográficos (θ = 0°, ±5°) y se obtiene una eficiencia de regeneración del 47 % en frenados típicos urbanos, consistente con los rangos reportados en la literatura. Un análisis de sensibilidad muestra variaciones de hasta 19 % en el polo dominante ante cambios de ±20 % en los parámetros del motor, lo que justifica la necesidad de un control adaptativo. El modelo es la base para el diseño del controlador adaptativo topográfico previsto en la siguiente etapa del proyecto."*

#### Index Terms

4 a 6 palabras clave. Tomar las del PID: *control adaptativo, freno regenerativo, motor brushless DC, movilidad urbana, variables de estado*.

#### I. Introducción

Tres bloques:

1. **Contexto y motivación** (1 párrafo): movilidad eléctrica urbana en Argentina, particularidades de Paraná, recuperación de energía.
2. **Estado del arte y trabajos relacionados** (1–2 párrafos): citar al menos 5 referencias del rubro. Usar la bibliografía disponible en el PID (Oman & Morchin, Chau, Larminie & Lowry, Rashid, Hendershot & Miller).
3. **Aporte y organización del trabajo** (1 párrafo): qué hace este paper, qué no hace, y la estructura de las secciones siguientes.

**Preguntas guía:**

- ¿Mi introducción contesta "¿por qué importa esto?" antes de "¿qué hice?"?
- ¿Cito al menos 5 trabajos previos y los agrupo según qué hicieron, no como una lista enumerativa?
- ¿El último párrafo dice claramente qué hace este paper y qué no?

**Ejemplos ilustrativos:**

> ❌ Apertura mala (sin gancho, sin contexto, demasiado genérica):
>
> *"En este trabajo se realiza el modelado de un sistema. La movilidad eléctrica es un tema importante. Existen muchos trabajos al respecto…"*

> ✅ Apertura buena (con contexto regional, motivación clara):
>
> *"La movilidad urbana eléctrica de baja escala —bicicletas, monopatines y scooters— ha crecido sostenidamente en la última década en Argentina, impulsada por la búsqueda de transporte personal sustentable y por la ausencia de homologación obligatoria para circular en vía pública [1]. En ciudades con topografía variable como Paraná, donde se alternan tramos planos largos con barrancas pronunciadas hacia el río, el desempeño de un vehículo eléctrico personal depende fuertemente de cuán bien el sistema de propulsión y frenado se adapte a la pendiente del momento. En particular, el frenado regenerativo es atractivo no por la magnitud de la energía recuperada —relativamente baja en bicicleta [2]— sino por su integración natural con un control que regule simultáneamente el frenado seguro y la recarga de la batería."*

#### II. Marco teórico y modelo matemático

Esta es la sección donde va el desarrollo del documento Word original, **corregido** según la guía 1. Debe contener:

- Diagrama de cuerpo libre de la bicicleta.
- Diagrama de circuito equivalente del motor BLDC.
- Ecuación de Newton con todas las fuerzas (aero, rodadura, gravitatoria).
- Ecuación eléctrica del motor (modo motor y modo generador, con convención de signos explícita).
- Linealización con punto de operación declarado.

**Preguntas guía:**

- ¿Otra persona puede llegar a las mismas ecuaciones partiendo de mis hipótesis y diagramas?
- ¿Las hipótesis simplificadoras están listadas explícitamente al principio (ej.: "se asume aire en calma, sin viento", "se desprecia la dinámica de la batería")?
- ¿Toda variable se define la primera vez que aparece?

#### III. Representación en variables de estado

Aquí se consolida el modelo final:

- Definición de estados, entradas, salidas y perturbaciones.
- Matrices A, B_u, B_d, C, D con dimensiones y unidades.
- Diagrama de bloques del sistema completo (motor + dinámica + convertidor + perturbación topográfica).

#### IV. Análisis del sistema

Aquí van los resultados de Kalman:

- Cálculo de la matriz de controlabilidad y su rango.
- Cálculo de la matriz de observabilidad y su rango.
- Polos del sistema (analíticos, en términos de los parámetros, si se pueden simplificar; o numéricos).
- Discusión de qué implican estos resultados para el diseño del controlador.

#### V. Resultados de simulación

Mostrar las figuras desarrolladas según §2.3 de la guía 1. Cada figura **debe** referirse al texto y discutirse, no quedar suelta. Una buena estructura es: una sub-sección por escenario.

- V.A. Respuesta del sistema en plano (θ = 0°).
- V.B. Comportamiento en subida (θ = +5°).
- V.C. Frenado regenerativo en bajada (θ = −5°). **Sección clave** del trabajo.
- V.D. Análisis de sensibilidad paramétrica.
- V.E. Balance energético.

**Preguntas guía:**

- ¿Cada figura está referenciada en el texto antes de aparecer? (Ej.: "...como se observa en la Fig. 3...")
- ¿Cada subsección tiene una conclusión propia, aunque sea de una frase?
- ¿La sección V.C (la clave del trabajo) tiene más espacio y desarrollo que las otras?

#### VI. Discusión

Tres preguntas a responder en orden:

1. ¿Los resultados son físicamente razonables? Comparar con los rangos de Oman & Morchin (Tabla 4.2) y con datos del fabricante del motor.
2. ¿Qué limitaciones tiene el modelo? Mencionar: linealización local, batería ideal, convertidor en estado promediado, sin saturaciones.
3. ¿Qué consecuencias tiene esto para el control adaptativo del PID?

**Preguntas guía:**

- ¿Soy capaz de admitir limitaciones de mi propio trabajo? (Si la sección de limitaciones es vacía o débil, el revisor desconfía del resto.)
- ¿La discusión hace puente con la próxima etapa o queda en el aire?

**Ejemplo ilustrativo — discusión honesta vs. defensiva:**

> ❌ Defensiva: *"El modelo predice perfectamente el comportamiento del sistema en todos los escenarios."*
> ✅ Honesta: *"El modelo predice adecuadamente la dinámica del sistema dentro del rango ±30 % del punto de operación elegido (5 m/s). Para velocidades muy bajas (< 1 m/s), la linealización del término aerodinámico introduce un error superior al 25 %, y para velocidades altas (> 8 m/s) la hipótesis de pequeñas señales deja de ser válida. Estos rangos se acotarán experimentalmente en la siguiente etapa del proyecto."*

#### VII. Conclusiones y trabajo futuro

Un párrafo de conclusiones (qué se logró, en presente perfecto: *"Se desarrolló…", "Se verificó…", "Se obtuvo…"*) y un párrafo de trabajo futuro (qué viene en la próxima etapa del PID: identificación de parámetros sobre el motor real, diseño del controlador adaptativo, validación experimental en el banco).

#### Agradecimientos

Mencionar a la UTN-FRP, al PID AMUTNPA0007734, al programa BINID, al director Ing. Katzenelson y co-director Ing. Maxit.

#### Referencias

Estilo IEEE (numéricas entre corchetes). Mínimo 10 referencias. Mezclar libros del PID, papers de IEEE Xplore y normativa cuando aplique.

---

## 3. Cómo manejar las ecuaciones

### 3.1. Editor

En LaTeX usar entornos `equation` o `align`. En Word usar el **Editor de Ecuaciones** (no fórmulas escritas como texto plano). El borrador original tiene ecuaciones tipeadas como texto, y eso por sí solo descarta cualquier presentación seria del trabajo.

### 3.2. Numeración

Numerar todas las ecuaciones que se referencien en el texto. No numerar ecuaciones que no se referencien.

### 3.3. Notación coherente en todo el documento

Definir de una vez y mantener:

| Símbolo | Significado | Unidad |
|---------|-------------|--------|
| v | velocidad lineal de la bicicleta | m/s |
| ω | velocidad angular de la rueda | rad/s |
| i | corriente del motor | A |
| V_m | tensión en bornes del motor | V |
| V_b | tensión nominal de la batería | V |
| D | ciclo de trabajo del convertidor | — |
| θ | ángulo de la pendiente | rad |
| **x** | vector de estados [v; i] | — |
| **A**, **B**_u, **B**_d, **C** | matrices del sistema | — |

Una sola convención para todo el paper. Si se usa **ω** para la velocidad angular, no aparece de pronto **n** o **rpm**. Si se usa V_m, no se usa después V_t o V(t).

**Preguntas guía:**

- ¿Toda variable que aparece en mis ecuaciones está definida antes de usarse?
- ¿Uso el mismo símbolo para la misma cosa en todo el paper?
- ¿Las unidades acompañan a la variable la primera vez que aparece?

**Ejemplos ilustrativos — ecuaciones tipeadas mal vs. bien:**

> ❌ Como texto plano sin editor (versión actual del borrador):
>
> ```
> mtot·dvtdt=Fmott-Fres(t)
> ```

> ✅ Con editor matemático (cómo debe verse):
>
> $$ m_{tot} \frac{dv(t)}{dt} = F_{mot}(t) - F_{res}(t) \tag{1} $$

### 3.4. Linealización

Mostrar el punto de operación elegido y las hipótesis. Una ecuación clave es:

$$ F_{aero}(v) = \tfrac{1}{2}\rho A C_d v^2 \approx F_{aero}(v_0) + \rho A C_d v_0 \,(v - v_0) $$

con la pendiente `ρ·A·Cd·v₀` que pasa a ser el coeficiente B del modelo lineal. Eso justifica el `B` del script.

---

## 4. Cómo manejar las figuras

### 4.1. Calidad

Generadas siempre desde MATLAB. No screenshots. Comando recomendado:

```matlab
exportgraphics(gcf, 'figuras/fig01_polos.pdf', 'ContentType', 'vector');
exportgraphics(gcf, 'figuras/fig01_polos.png', 'Resolution', 300);
```

### 4.2. Estilo uniforme

Definir al principio del script un `set(0, 'DefaultAxesFontSize', 11)` y demás defaults para que todas las figuras se vean iguales. Un buen preámbulo:

```matlab
set(0, 'DefaultAxesFontName',   'Times');
set(0, 'DefaultAxesFontSize',   11);
set(0, 'DefaultLineLineWidth',  1.5);
set(0, 'DefaultAxesGridAlpha',  0.3);
set(0, 'DefaultFigurePaperPositionMode', 'auto');
```

### 4.3. Etiquetas

- Ejes siempre etiquetados con magnitud y unidad: `Velocidad v [m/s]`, no solo `v`.
- Leyenda dentro del gráfico cuando hay más de una curva.
- Título corto o sin título (preferible sin título; el caption de la figura cumple esa función en el paper).

### 4.4. Caption

El caption debe ser autocontenido: alguien que mira solo la figura tiene que entender qué representa.

**Preguntas guía:**

- ¿Si tapo el cuerpo del paper y miro solo la figura y su caption, entiendo qué muestra y por qué importa?
- ¿El caption menciona al menos un valor numérico relevante?

**Ejemplos ilustrativos — captions:**

> ❌ Mínimo (no informativo): *"Fig. 3. Respuesta al escalón."*
> ⚠️ Aceptable pero pobre: *"Fig. 3. Respuesta del sistema al escalón en la entrada de tensión."*
> ✅ Bueno (autocontenido): *"Fig. 3. Respuesta al escalón en la tensión del motor (V_m = 24 V) con θ = 0°. Se observa una constante de tiempo dominante τ ≈ 1.8 s asociada al modo mecánico y un transitorio rápido (≈ 20 ms) asociado al modo eléctrico. La velocidad de equilibrio es de 4.8 m/s."*

---

## 5. Cómo manejar las tablas

Reglas mínimas:

- Sin sombreados de colores.
- Sin bordes verticales.
- Bordes horizontales solo arriba, debajo del encabezado y al final.
- Encabezado con unidades.
- Caption arriba (en IEEE las tablas llevan caption arriba, las figuras abajo).
- Numeradas con romano (Tabla I, Tabla II), las figuras con arábigo (Fig. 1, Fig. 2).

**Preguntas guía:**

- ¿Cada columna tiene unidad en el encabezado?
- ¿La tabla puede leerse aislada del cuerpo del texto?

**Ejemplos ilustrativos — tablas:**

> ❌ Tabla mal armada:
>
> | Param | Valor |
> |-------|-------|
> | masa | 95 |
> | rad | 0.33 |

> ✅ Tabla bien armada:
>
> **TABLA I — Parámetros del modelo nominal**
>
> | Parámetro     | Símbolo | Valor | Unidad   | Fuente             |
> |---------------|---------|-------|----------|--------------------|
> | Masa total    | m       | 95    | kg       | [3, p. 30]         |
> | Radio rueda   | r       | 0.33  | m        | Medido             |
> | Coef. arrastre| C_d     | 1.0   | —        | [3, Tabla 2.1]     |
> | …             | …       | …     | …        | …                  |

---

## 6. Cómo organizar el código

### 6.1. Estructura de archivos

```
proyecto_bici_regenerativa/
├── README.md
├── doc/
│   ├── informe.tex (o informe.docx)
│   ├── informe.pdf
│   └── referencias.bib
├── src/
│   ├── modelo_bici.m            % Función que arma el modelo
│   ├── parametros.m             % Devuelve struct con parámetros
│   ├── Modelado_V2.m            % Script principal
│   ├── Analisis_energia.m       % Balance energético
│   └── Sensibilidad.m           % Análisis de sensibilidad
├── figuras/
│   ├── fig01_polos.pdf
│   ├── fig02_step_vbat.pdf
│   └── ...
└── data/
    └── resultados.mat
```

### 6.2. Header obligatorio en cada `.m`

```matlab
%==========================================================================
% Modelado_V2.m
%
% Modelo en variables de estado de una bicicleta eléctrica con freno
% regenerativo. Calcula matrices A, B, C, D, controlabilidad y
% observabilidad por criterio de Kalman, y simula respuestas en distintos
% escenarios topográficos.
%
% Proyecto:  PID UTN AMUTNPA0007734 - Sistema de movilidad urbana con
%            control adaptativo topográfico
% Autor:     Esteban Fidel Sian
% Director:  Ing. Gustavo G. Katzenelson
% Fecha:     [completar]
% Versión:   2.0
% Requisitos: MATLAB R2021a o superior, Control System Toolbox
%==========================================================================
```

### 6.3. Comentarios

- Cada bloque lógico debe tener un comentario que explique **qué hace** y **por qué**, no qué *operadores* ejecuta.
- Las unidades van en el comentario del lado de cada parámetro.
- Las ecuaciones implementadas se citan en el comentario respecto a una sección o ecuación del informe (`% Ec. (12) del informe`).

**Preguntas guía:**

- ¿Mis comentarios explican el "por qué" o solo el "qué"?
- ¿Si borro todos los comentarios, queda código indescifrable o sigue legible?

**Ejemplos ilustrativos — comentarios:**

> ❌ Comentario inútil (repite lo que ya dice el código):
>
> ```matlab
> A(1,1) = -B/m;   % asigno -B/m a la posición (1,1) de A
> ```

> ✅ Comentario útil (explica el porqué y la fuente):
>
> ```matlab
> A(1,1) = -B/m;   % término viscoso en la dinámica de v, ec. (8) del informe
> ```

### 6.4. Modularidad

Encapsular la construcción del modelo en una función reutilizable:

```matlab
function sys = modelo_bici(p)
% MODELO_BICI Construye el modelo en variables de estado.
%   sys = modelo_bici(p) recibe una estructura p con campos
%   m, B, r, R, L, Kt, Ke y devuelve un objeto ss.
    A = [-p.B/p.m,        p.Kt/(p.m*p.r);
         -p.Ke/(p.L*p.r), -p.R/p.L      ];
    Bu = [0; 1/p.L];
    Bd = [-9.81; 0];                          % entrada de pendiente
    C  = eye(2);
    D  = zeros(2, 2);
    sys = ss(A, [Bu Bd], C, D);
    sys.InputName  = {'V_m', 'sin(theta)'};
    sys.OutputName = {'v', 'i'};
    sys.StateName  = {'v', 'i'};
end
```

Esto permite barrer parámetros sin reescribir el código.

### 6.5. Versionado

Como mínimo guardar copias incrementales: `Modelado_V1.m`, `Modelado_V2.m`, etc. Lo correcto es **un repositorio git** local con commits etiquetados y un `.gitignore` que excluya archivos generados (`*.asv`, `*.mat` grandes, `figuras/*.pdf` si pesan mucho).

### 6.6. Reproducibilidad

El script principal debe ejecutarse de cabo a rabo sin intervención manual: poner los parámetros en una sola estructura, generar todas las figuras, guardar resultados. Cualquiera con MATLAB y los mismos archivos debe poder reproducir el informe.

**Pregunta guía — el test del compañero:**

> Le doy mi carpeta a un compañero de la facultad que nunca vio el proyecto. Le digo: "ejecutá `Modelado_V2.m`". ¿Le sale todo? ¿Le aparecen las figuras del paper? Si me llama por chat para preguntar algo, **fallé**.

---

## 7. Cómo manejar las referencias

### 7.1. Gestor

Usar un gestor (Mendeley, Zotero, JabRef). Exportar a BibTeX si se trabaja en LaTeX, o a Word con el plugin si se trabaja en Word.

### 7.2. Estilo IEEE

Numerado entre corchetes en orden de aparición.

**Ejemplos ilustrativos — referencias:**

> ❌ Mal armada (faltan datos, formato inconsistente):
>
> *[1] Oman, libro de bicicletas eléctricas, 2006.*

> ✅ Bien armada (formato IEEE completo):
>
> *[1] H. Oman and W. Morchin, Electric Bicycles: A Guide to Design and Use. Hoboken, NJ: Wiley-IEEE Press, 2006.*
> *[2] K. T. Chau, Electric Vehicle Machines and Drives: Design, Analysis and Application. Hoboken, NJ: Wiley-IEEE Press, 2015.*
> *[3] J. Larminie and J. Lowry, Electric Vehicle Technology Explained, 2nd ed. Chichester: Wiley, 2012.*

### 7.3. Mínimo de referencias y dónde citar

- Cada afirmación de hecho debe tener cita.
- Cada parámetro tomado de literatura debe tener cita.
- Modelos clásicos (Newton, Kirchhoff) no requieren cita pero sí los modelos específicos del rubro.
- Mínimo 10 referencias para un paper corto.

**Preguntas guía:**

- ¿Estoy citando al menos los 5 libros centrales del PID (Oman & Morchin, Chau, Larminie, Rashid, Hendershot & Miller)?
- ¿Cada número de tabla, cada coeficiente, cada afirmación histórica tiene su cita?
- ¿Cito sin haber leído? (Si la respuesta es sí, hay que leer antes de citar.)

### 7.4. Citas frecuentes para este trabajo

- Oman & Morchin para la dinámica de la bicicleta y el modelo de potencia/regeneración.
- Chau o Larminie & Lowry para el contexto de vehículos eléctricos.
- Hendershot & Miller o Xia para el motor BLDC.
- Rashid (Power Electronics Handbook) para el convertidor Buck-Boost.
- Yiannnis et al. (System Identification and Adaptive Control) para el marco del control adaptativo.

---

## 8. Lista de control antes de entregar

Repasar todos estos ítems antes de dar por cerrado el informe. Si alguno falla, **no está terminado**.

- [ ] El título describe específicamente lo que se hizo.
- [ ] Hay abstract en español y en inglés, ≤ 200 palabras cada uno.
- [ ] El abstract menciona al menos un resultado numérico concreto.
- [ ] Las palabras clave están entre las del PID o son consistentes con el rubro.
- [ ] Cada ecuación está numerada y escrita con editor matemático.
- [ ] Cada variable se define la primera vez que aparece.
- [ ] La notación es consistente en todo el documento.
- [ ] Cada figura tiene caption autocontenido y se referencia en el texto.
- [ ] Cada tabla tiene caption arriba y se referencia en el texto.
- [ ] Hay al menos 10 referencias en formato IEEE.
- [ ] Cada parámetro tiene fuente.
- [ ] Las ecuaciones lineales están justificadas con un punto de operación explícito.
- [ ] Hay análisis de controlabilidad y observabilidad explícitos.
- [ ] Hay al menos una figura por cada escenario topográfico (plano, subida, bajada).
- [ ] Hay análisis energético del frenado regenerativo.
- [ ] Hay análisis de sensibilidad paramétrica.
- [ ] La discusión menciona limitaciones del modelo.
- [ ] Las conclusiones se cierran con trabajo futuro alineado al cronograma del PID.
- [ ] Los scripts MATLAB se ejecutan sin error desde cero.
- [ ] El repositorio tiene README con instrucciones de uso.
- [ ] El informe compila/se exporta a PDF sin warnings.
- [ ] Hay revisión ortográfica completa (en español, sin "perdidas" sin tilde, "regerativo", etc.).

**Preguntas guía finales antes de mandar:**

- ¿Lo leí en voz alta de principio a fin? (Es la mejor forma de detectar frases mal escritas.)
- ¿Lo dejé descansar 24 hs y lo releí con ojos frescos? (Casi siempre se encuentran errores nuevos.)
- ¿Lo leyó al menos una persona ajena al proyecto?

---

## 9. Camino hacia el congreso

Una vez aprobado el informe interno, transformarlo en envío de congreso requiere:

1. **Identificar el congreso objetivo.** Sugerencias para 2026/2027 en Argentina: AADECA (Asociación Argentina de Control Automático), RPIC (Reunión de Procesamiento de la Información y Control), ARGENCON, CASE (Congreso Argentino de Sistemas Embebidos).
2. **Adaptar la plantilla** a la del congreso (suelen ser variantes de IEEE).
3. **Reducir o ampliar** según el límite de páginas del CFP (Call For Papers).
4. **Pedir revisión interna** al director y co-director del PID.
5. **Submission.** Subir antes del deadline. Conservar el comprobante.
6. **Defensa.** Si es aceptado, preparar presentación de 15 minutos: una diapositiva por sección del paper, foco en la sección V (resultados).

**Preguntas guía para la defensa:**

- ¿Puedo explicar mi trabajo en 1 minuto a alguien que no conoce el tema? (El elevator pitch.)
- ¿Puedo explicarlo en 5 minutos a alguien del rubro? (La introducción de la presentación.)
- ¿Puedo defender cada decisión técnica que tomé? (La sesión de preguntas.)

---

## 10. Consejo final

Un buen avance de beca no es un paper publicable, pero **un buen avance se nota inmediatamente porque no requiere reescribirse para convertirse en uno**. Si al final del trabajo el director pide "vamos a publicarlo" y la respuesta es "necesito 2 meses para reescribirlo", el avance no estuvo bien hecho. Si la respuesta es "lo adaptamos en 2 semanas a la plantilla del congreso", el avance estuvo bien hecho.

El objetivo de esta guía es que el segundo escenario sea el resultado real.

**Pregunta guía de cierre:**

> Si dentro de 5 años retomo este trabajo (o lo retoma otro becado), ¿el material que dejé hoy es suficiente para que la continuación arranque sin reconstruir lo hecho? Esa es la prueba real de un avance bien terminado.
