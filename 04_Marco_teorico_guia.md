# Guía de marco teórico

**Proyecto:** Sistema de movilidad urbana con control adaptativo topográfico (PID UTN — AMUTNPA0007734)
**Becado:** Esteban Fidel Sian (BINID)
**Objetivo de esta guía:** servir de mapa teórico para el trabajo de modelado, simulación y diseño del controlador adaptativo, organizando los temas en el orden lógico en el que se necesitan. No reemplaza a los libros de la bibliografía; los complementa indicando **qué leer, en qué orden, y para qué**.

---

## Cómo usar esta guía

Cada sección sigue la misma estructura:

- **Por qué importa para este proyecto.** Una frase que conecta el tema con el trabajo concreto del becado.
- **Conceptos clave.** El núcleo técnico, en forma sintética. No reemplaza al libro, pero indica qué debe aparecer en el informe del becado al referirse a ese tema.
- **Bibliografía recomendada.** Capítulos específicos de los libros disponibles en el PID, con menciones a referencias adicionales cuando hace falta.
- **Preguntas guía.** Para autoevaluar la comprensión del tema antes de avanzar.
- **Ejemplo ilustrativo.** Aplicado al sistema de la bicicleta, casi siempre con números concretos.
- **Trampas frecuentes.** Cuando aplica — errores comunes que conviene tener identificados.

El orden de las secciones es **estrictamente progresivo**: cada una asume que las anteriores se entienden. Saltar de orden suele ser la causa principal por la que un tema no termina de cerrar.

**Mapa general de los once temas:**

```
I.   Fundamentos físicos del vehículo  ┐
II.  Máquinas eléctricas                │  Componentes
III. Electrónica de potencia            │
IV.  Almacenamiento de energía         ┘

V.   Frenado regenerativo                ─  Integración

VI.  Modelado en variables de estado   ┐
VII. Análisis de sistemas lineales      │  Matemática
VIII.Teoría de control clásico          │
IX.  Identificación de sistemas        ┘

X.   Control adaptativo                 ┐  Síntesis
XI.  Sensado de pendiente y topografía ┘     del proyecto
```

---

## I. Fundamentos físicos del vehículo

### Por qué importa

Es la base del modelo mecánico de la bicicleta que el becado ya está usando. La mitad de los errores conceptuales del borrador inicial están en esta sección.

### Conceptos clave

**Segunda ley de Newton aplicada a un vehículo.** Para un cuerpo de masa `m` que se mueve con velocidad `v`:

`m · dv/dt = ΣF`

donde la suma de fuerzas incluye:

- **Fuerza propulsora** (`F_mot`): la que aplica el motor al eje y se transmite al suelo a través de la rueda.
- **Resistencia aerodinámica** (`F_aero = ½·ρ·A·Cd·v²`): proporcional al cuadrado de la velocidad relativa al aire. No lineal.
- **Resistencia a la rodadura** (`F_roll = Crr·m·g·cos(θ)`): aproximadamente constante con la velocidad. Depende del tipo de neumático y del peso.
- **Componente gravitatoria en pendiente** (`F_grav = m·g·sin(θ)`): positiva en subida (frena), negativa en bajada (acelera).

**Linealización en torno a un punto de operación.** Como `F_aero` es no lineal en `v`, para llevar el modelo a forma `ẋ = Ax + Bu` hay que linealizar:

`F_aero(v) ≈ F_aero(v₀) + (dF_aero/dv)|_{v₀} · (v − v₀) = F_aero(v₀) + ρ·A·Cd·v₀ · (v − v₀)`

El coeficiente `B_aero = ρ·A·Cd·v₀` es lo que se interpreta como una "fricción viscosa equivalente" en el modelo lineal, válida sólo cerca del punto de operación.

**Cinemática de la rueda.** La velocidad lineal del vehículo y la velocidad angular de la rueda están vinculadas por el radio:

`v = ω · r`

(asumiendo rodadura pura, sin patinamiento.)

### Bibliografía recomendada

- **Oman, H. y Morchin, W.** — *Electric Bicycles: A Guide to Design and Use.* Wiley-IEEE Press, 2006. **Capítulo 2** entero. Es la fuente directa de las ecuaciones que el becado ya usa. Tablas 2.1 a 2.4 dan valores numéricos de Cd, Crr y A.
- **Larminie, J. y Lowry, J.** — *Electric Vehicle Technology Explained.* Wiley, 2012. **Capítulo 7** (Vehicle Modelling). Mismas ecuaciones aplicadas a vehículos eléctricos en general — útil para ver el panorama más allá de la bicicleta.

### Preguntas guía

- ¿Cuál es la dependencia funcional de cada una de las tres fuerzas resistivas con la velocidad? (Cuadrática, constante, constante.)
- Si la velocidad se duplica, ¿cuánto cambia cada componente? ¿Cuál es la que más crece?
- ¿Por qué necesito linealizar y qué pago por linealizar?

### Ejemplo ilustrativo

Para una bicicleta urbana con `m = 95 kg`, `Cd = 1.0`, `A = 0.5 m²`, `ρ = 1.2 kg/m³`, `Crr = 0.007`, en una pendiente de 5°, viajando a 5 m/s:

- `F_aero = 0.5 · 1.2 · 0.5 · 1.0 · 5² = 7.5 N`
- `F_roll = 0.007 · 95 · 9.81 · cos(5°) ≈ 6.5 N`
- `F_grav = 95 · 9.81 · sin(5°) ≈ 81.2 N`

Las tres tienen magnitudes comparables, salvo `F_grav` en pendiente, que es **un orden de magnitud mayor**. Esto explica por qué la pendiente domina la dinámica de la bicicleta urbana en Paraná y por qué el control adaptativo del PID se centra en ella.

### Trampas frecuentes

- Tratar la rodadura como si fuera proporcional a `v`. **No lo es** — es aproximadamente constante.
- Olvidar el `cos(θ)` en `F_roll` y el `sin(θ)` en `F_grav`. En pendientes chicas (< 10°), `cos(θ) ≈ 1` y se puede ignorar; en pendientes mayores, no.
- Linealizar sin declarar el punto de operación. El coeficiente `B_aero` depende de `v₀`; si no se dice cuál es `v₀`, el modelo no es reproducible.

---

## II. Máquinas eléctricas — el motor brushless DC

### Por qué importa

El motor del prototipo es un BLDC tipo *hub*. Sin entender cómo se modela, el becado no puede justificar las constantes `Kt` y `Ke` de su modelo.

### Conceptos clave

**Motor de corriente continua (DC) clásico.** Es el modelo más simple y, sin embargo, **el que se usa para representar al BLDC en estado promediado**. Sus ecuaciones son:

- Eléctrica: `V = R·i + L·di/dt + e`, donde `e = Ke·ω` es la fuerza contraelectromotriz (back-EMF).
- Mecánica: `T_m = Kt·i`, donde `T_m` es el torque generado.

Las constantes `Kt` (constante de torque, en N·m/A) y `Ke` (constante de back-EMF, en V·s/rad) son **numéricamente iguales en sistema SI** para un motor ideal, aunque tienen unidades distintas. Esa igualdad se desprende del balance de potencias eléctrica y mecánica.

**Motor de imanes permanentes (PMSM).** Reemplaza el devanado de campo del DC clásico por imanes permanentes. Mantiene la estructura matemática del modelo DC pero con menos pérdidas (no hay corriente de excitación) y mayor densidad de potencia.

**Motor brushless DC (BLDC).** Es un motor síncrono de imanes permanentes con dos diferencias respecto al DC clásico:

1. No hay escobillas — la conmutación se hace electrónicamente con un puente de transistores.
2. La corriente es trifásica (típicamente con conmutación trapezoidal).

Cuando interesa la dinámica promedio (como en el modelo del becado), el BLDC se aproxima como **un DC equivalente**, con una `R` y una `L` que son funciones de los parámetros por fase. Esta aproximación es aceptable mientras la frecuencia de conmutación sea mucho mayor que las dinámicas de interés.

**Acoplamiento electromecánico — la conexión entre las dos ecuaciones.** Las constantes `Kt` y `Ke` son el "puente" entre el dominio eléctrico y el mecánico. Un motor que entrega corriente `i` produce torque `Kt·i`; ese torque mueve la rueda, y la rueda al moverse genera back-EMF `Ke·ω`. Es un sistema acoplado en lazo cerrado natural.

### Bibliografía recomendada

- **Hendershot, J. R. y Miller, T. J. E.** — *Design of Brushless Permanent-Magnet Machines.* Motor Design Books, 2010. Capítulos iniciales para el modelo equivalente del BLDC. Parte del catálogo del PID.
- **Xia, C.** — *Permanent Magnet Brushless DC Motor Drives and Controls.* Wiley, 2012. Capítulo 1 da el modelo eléctrico básico; capítulo 2, la conmutación.
- **Kenjo, T. y Nagamori, S.** — *Permanent-Magnet and Brushless DC Motors.* Oxford University Press, 1985. Texto clásico, breve, accesible. Para una primera lectura.
- **Chau, K. T.** — *Electric Vehicle Machines and Drives.* Wiley-IEEE Press, 2015. Capítulo 4 trata específicamente motores PMSM/BLDC en aplicaciones vehiculares.

### Preguntas guía

- ¿Por qué `Kt` y `Ke` numéricamente coinciden en SI? ¿Qué principio físico lo garantiza?
- ¿En qué condiciones es válido aproximar un BLDC como un DC equivalente?
- ¿Qué pierdo al hacer esa aproximación? (Pista: dinámica de conmutación, efectos del *cogging*, armónicos.)

### Ejemplo ilustrativo

Un motor BLDC de hub de bicicleta, 350 W nominal, 36 V:

- Resistencia por fase: `R ≈ 0.3 Ω` → resistencia equivalente DC ≈ 0.5 Ω (dos fases en serie en cada instante de conmutación).
- Inductancia por fase: `L ≈ 0.5 mH` → equivalente DC ≈ 1 mH.
- `Kt = Ke ≈ 1.2` en SI: significa que con 1 A circulando, el motor entrega 1.2 N·m de torque, y girando a 1 rad/s genera 1.2 V de back-EMF.

A 30 km/h (8.3 m/s) con `r = 0.33 m`, la velocidad angular es `ω = 25 rad/s` y la back-EMF vale `Ke·ω = 30 V`, comparable a la tensión de la batería. Es por esto que el frenado regenerativo es viable en este rango: la back-EMF del motor "compite" con la tensión de la batería y, controlando el convertidor, se puede invertir el flujo de potencia.

### Trampas frecuentes

- Confundir `Kt` y `Ke` con valores diferentes y tratarlos como independientes — en un motor ideal son la misma constante.
- Usar el modelo DC equivalente cuando la dinámica de conmutación importa (por ejemplo, cuando se estudian armónicos de torque). Para este proyecto, en cambio, sí es válido usar el equivalente DC.

---

## III. Electrónica de potencia — convertidores y conmutación

### Por qué importa

El convertidor Buck-Boost es la **entrada de control real** del sistema. La tensión `V_m` que aparece en el modelo del becado es el resultado de modular el ciclo de trabajo `D` del convertidor; sin entender esto, el lazo de control no se puede cerrar.

### Conceptos clave

**Modulación por ancho de pulso (PWM).** Una llave electrónica que conmuta a alta frecuencia (típicamente 10–30 kHz en aplicaciones de movilidad) entre encendido y apagado. La fracción del período en que la llave está encendida es el **ciclo de trabajo** `D ∈ [0, 1]`. La tensión promedio aplicada a la carga es `V_promedio = D · V_fuente` (en el caso más simple).

**Convertidor Buck (reductor).** Sirve para alimentar al motor con una tensión menor que la de la batería. `V_motor = D · V_bat`. Útil en arranque a baja velocidad (cuando la back-EMF del motor es chica).

**Convertidor Boost (elevador).** Sirve para forzar el flujo de corriente desde el motor hacia la batería en frenado regenerativo, cuando la back-EMF es menor que la tensión de la batería. `V_salida = V_entrada / (1 − D)`.

**Convertidor Buck-Boost.** Combina las dos topologías. Es el caso del PID: el sistema debe operar como Buck en modo motor (a baja velocidad) y como Boost en modo regenerativo (a baja velocidad de bajada cuando hace falta elevar la tensión generada para cargar la batería).

**Modelado en estado promediado.** Para los lazos de control que operan a frecuencias mucho menores que la de conmutación, el convertidor se modela ignorando los detalles de conmutación. Lo que queda es una relación estática entre `D` y `V_motor`. Esa simplificación es la que permite incluir el convertidor en un modelo lineal en variables de estado.

### Bibliografía recomendada

- **Rashid, M. H.** — *Power Electronics: Circuits, Devices and Applications.* Prentice Hall. Capítulos 5 (DC-DC converters) y 6 (PWM techniques). Texto base del PID.
- **Rashid, M. H. (ed.)** — *Power Electronics Handbook.* Butterworth-Heinemann. Más profundo y exhaustivo. Capítulo sobre convertidores Buck-Boost.
- **Erickson, R. y Maksimović, D.** — *Fundamentals of Power Electronics.* Springer. Texto académico estándar; introduce el modelo en estado promediado de manera muy clara. **Recomendado para el modelo dinámico del convertidor**.

### Preguntas guía

- ¿Por qué necesito un Buck-Boost y no alcanza con uno solo de los dos?
- ¿Qué frecuencia de conmutación elijo y por qué?
- En modo regenerativo, ¿qué condición de tensión hace que la corriente fluya **hacia** la batería y no al revés?
- ¿Cuándo puedo usar el modelo en estado promediado y cuándo me obliga a modelar la conmutación explícitamente?

### Ejemplo ilustrativo

Batería de 36 V nominal, motor con back-EMF que en `v = 5 m/s` vale `Ke · ω = 1.2 · 15 = 18 V`. Para inyectar corriente al motor con `V_motor = 12 V`, el convertidor en modo Buck necesita `D = 12/36 = 0.33`. En frenado a `v = 4 m/s` (back-EMF ≈ 14.5 V), si quiero mantener una corriente de carga de 5 A hacia la batería, el convertidor en modo Boost regula el ciclo de trabajo de manera que la tensión vista por la batería sea ligeramente mayor a 36 V — el control fija el ciclo `D` para que el lazo de corriente se cierre con la consigna deseada.

### Trampas frecuentes

- Tratar la tensión que aparece en el modelo (`V_m`) como si fuera la tensión nominal de la batería. **No lo es**: es la tensión que el convertidor impone en bornes del motor, función de `D`.
- Ignorar la saturación de `D` en el rango `[0, 1]`. El controlador puede pedir tensiones que físicamente no se pueden aplicar, y eso debe modelarse al menos como saturación de la entrada.

---

## IV. Almacenamiento de energía — baterías

### Por qué importa

En el modelo actual del becado la batería se trata como fuente ideal. Para cerrar la sección de "limitaciones" del paper y para sentar las bases de la siguiente etapa del PID, hay que entender qué se está despreciando.

### Conceptos clave

**Tipos de baterías para movilidad eléctrica.** Hoy, las de ion-litio dominan el mercado (mayor densidad de energía, ciclos largos, sin efecto memoria). Las de plomo-ácido sobreviven en aplicaciones de bajo costo o alta robustez. Las de NiMH son intermedias.

**Modelado simplificado.** El modelo más usado en simulación es:

`V_bat = V_OC(SOC) − R_int · i_bat`

donde `V_OC` es la tensión de circuito abierto (función no lineal del estado de carga `SOC`), `R_int` es la resistencia interna, y `i_bat` es la corriente que entra (signo positivo) o sale (negativo) de la batería.

**Estado de carga (SOC).** Fracción de la capacidad nominal que queda almacenada. Se estima por integración de corriente (*coulomb counting*) o por algoritmos más sofisticados (filtros de Kalman aplicados al modelo de batería).

**Fuel gauge en aplicaciones de movilidad.** Oman & Morchin discute en el cap. 4 las limitaciones de los *fuel gauges* comerciales aplicados a bicicletas eléctricas: el régimen dinámico es distinto del que esperan esos circuitos, lo que produce errores de estimación importantes.

### Bibliografía recomendada

- **Oman, H. y Morchin, W.** — *Electric Bicycles*. **Capítulo 4** entero. Cubre tipos de baterías, carga, descarga, *fuel gauges*, y específicamente la sección 4.9 trata energía recuperable por frenado regenerativo (datos de la Tabla 4.2).
- **Larminie y Lowry** — *Electric Vehicle Technology Explained*. **Capítulo 2** (Batteries). Visión general de tipos de baterías para vehículos eléctricos.
- **Dhameja, S.** — *Electric Vehicle Battery Systems.* Newnes, 2002. Texto orientado al diseño de sistemas, incluido en la bibliografía del PID.

### Preguntas guía

- ¿Qué consecuencia tiene tratar la batería como fuente ideal en el modelo del becado? (Pista: sobreestima la potencia disponible, sobreestima la eficiencia de regeneración, ignora la dependencia con el SOC.)
- ¿Cuántos Wh tiene una batería típica de bicicleta y cuántos Wh recupera por frenado en un viaje urbano promedio?
- ¿Qué impacto tiene la temperatura sobre la capacidad de la batería? (Lo discute Oman & Morchin.)

### Ejemplo ilustrativo

Una bicicleta urbana con batería de Li-ion 36 V / 10 Ah tiene 360 Wh de capacidad nominal. Una jornada típica de uso urbano consume aproximadamente 15 Wh/km (Oman & Morchin); para 24 km de uso diario eso son 360 Wh, prácticamente la capacidad entera. Si se logra un 50 % de eficiencia de regeneración en 5 % del trayecto (las bajadas), eso recupera aproximadamente 1.3 % de la capacidad — un agregado modesto, que reafirma la idea de que **el frenado regenerativo en bicicleta no es por ahorro energético grande, sino por su valor como mecanismo de frenado controlado**.

### Trampas frecuentes

- Asumir que la tensión de la batería es constante. Cae con el SOC y con la corriente.
- Calcular la energía recuperable usando la capacidad nominal sin restar la eficiencia del convertidor y la del motor en modo generador.

---

## V. Frenado regenerativo

### Por qué importa

Es uno de los dos ejes técnicos del PID (junto con el control adaptativo). Sin entender bien la física y los límites del frenado regenerativo, el modelo del becado pierde sentido.

### Conceptos clave

**Principio físico.** En frenado regenerativo, el motor se opera como generador. La energía cinética del vehículo se convierte en energía eléctrica a través del par electromagnético resistente, y esa energía se inyecta en la batería. La conversión es **inevitablemente parcial**: se pierde energía por:

- Disipación óhmica en el devanado del motor (`I²R`).
- Pérdidas por histéresis y corrientes parásitas en el hierro.
- Pérdidas por fricción mecánica residual.
- Eficiencia del convertidor de potencia.
- Eficiencia de carga de la batería.

La eficiencia total típica para una bicicleta es **40 a 60 %** (Oman & Morchin, cap. 4.9).

**Convención de signos en el modelo.** En modo motor, la corriente fluye de la batería al motor (`i > 0` por convención) y el torque acelera el vehículo (`T > 0`). En modo regenerativo, la corriente cambia de signo (`i < 0`) y el torque se vuelve frenante (`T < 0`). El mismo modelo lineal cubre ambos casos si la convención de signos es consistente.

**Implementación práctica.** Requiere un convertidor bidireccional (Buck-Boost) y un sistema de control que decida en cada instante si el motor opera en modo motor o generador, y con qué intensidad de frenado. El controlador del frenado regenerativo cierra un lazo de corriente: la consigna es la corriente de carga deseada hacia la batería, y la salida del controlador es el ciclo de trabajo del convertidor.

**Comparación con frenado mecánico.** El frenado regenerativo no reemplaza al freno mecánico convencional — lo complementa. Para frenadas de emergencia o detenciones completas, el freno mecánico es indispensable. La regeneración cubre las desaceleraciones suaves y el control de velocidad en bajada.

### Bibliografía recomendada

- **Oman, H. y Morchin, W.** — *Electric Bicycles*. **Sección 4.9** (Recoverable Energy). Da los datos numéricos clave (Tabla 4.2) y la discusión de viabilidad.
- **Chau, K. T.** — *Electric Vehicle Machines and Drives*. Capítulo sobre control de tracción, donde discute integración del frenado regenerativo con el control de velocidad.
- **Larminie y Lowry** — *Electric Vehicle Technology Explained*. Capítulo 7, sección de regenerative braking.

### Preguntas guía

- ¿Por qué la eficiencia del frenado regenerativo en bicicleta nunca supera el 60 %?
- ¿Qué fracción de la energía cinética se recupera en una frenada urbana típica? ¿Y en una bajada larga?
- ¿Qué cambia si el ciclista pesa 60 kg en lugar de 90 kg? (El ΔE_k es proporcional a la masa.)
- ¿En qué momento se decide pasar de modo motor a modo regenerativo?

### Ejemplo ilustrativo

Frenado de 8 m/s a 2 m/s para una bicicleta+ciclista de 95 kg:

- Energía cinética disipada: `½ · 95 · (8² − 2²) = ½ · 95 · 60 = 2850 J ≈ 0.79 Wh`.
- A 50 % de eficiencia, se recuperan unos 0.40 Wh.
- Para una batería de 360 Wh, el aporte de una sola frenada es 0.11 % — pequeño individualmente, pero acumulativo a lo largo del día.

### Trampas frecuentes

- Plantear el frenado regenerativo como un mecanismo de ahorro energético sustancial. **No lo es** — su valor es la integración con un sistema de control que regula simultáneamente desaceleración y carga.
- Olvidar que el frenado regenerativo solo funciona mientras el motor gira. A velocidad baja (cerca de cero) la back-EMF es despreciable y no hay regeneración.

---

## VI. Modelado en variables de estado

### Por qué importa

Es el lenguaje matemático del trabajo del becado. Sin claridad sobre qué es un estado, qué es una entrada y qué es una salida, las matrices son sólo símbolos sin significado.

### Conceptos clave

**Idea central.** Un sistema dinámico se describe completamente por un conjunto mínimo de variables (los **estados**) cuya evolución temporal queda determinada por las propias variables y por las **entradas** del sistema. Las **salidas** son combinaciones lineales o no lineales de los estados (y eventualmente de las entradas).

**Forma estándar lineal.**

```
ẋ = A·x + B·u
y = C·x + D·u
```

con `x ∈ ℝⁿ` (estados), `u ∈ ℝᵐ` (entradas), `y ∈ ℝᵖ` (salidas), `A` matriz `n×n`, `B` matriz `n×m`, `C` matriz `p×n`, `D` matriz `p×m`.

**SISO, SIMO, MIMO.** Clasificación según número de entradas y salidas:

- SISO: 1 entrada, 1 salida.
- SIMO: 1 entrada, varias salidas.
- MISO: varias entradas, 1 salida.
- MIMO: varias entradas, varias salidas.

**Perturbaciones medibles vs. no medibles.** Si una entrada externa al sistema (ej. la pendiente θ) se puede medir, se la trata como entrada y se la incluye en `B` con su propia columna. Si no se puede medir, se la trata como perturbación no medida y se diseña un controlador robusto a ella. **Distinción clave para este proyecto**: la pendiente se mide con un acelerómetro/IMU, así que es entrada medible.

**Linealización de un modelo no lineal.** Si el sistema es `ẋ = f(x, u)` (no lineal), se linealiza alrededor de un punto de operación `(x₀, u₀)` calculando el jacobiano:

`A = ∂f/∂x|_{x₀,u₀},  B = ∂f/∂u|_{x₀,u₀}`

El modelo lineal vale en una vecindad de ese punto y debe declararse cuál es.

**Interpretación física de las matrices.** En el modelo de la bicicleta:

- `A` describe la dinámica natural (sin entrada externa): cómo evolucionan los estados por sí mismos.
- `B` describe cuánto y cómo afecta la entrada de control a los estados.
- `C` describe qué se mide.

### Bibliografía recomendada

- **Ogata, K.** — *Ingeniería de Control Moderna.* Pearson. **Capítulo 9** (Análisis de sistemas de control en el espacio de estados). Texto base obligatorio. Está en español, lo que ayuda.
- **Franklin, G., Powell, J. D. y Emami-Naeini, A.** — *Feedback Control of Dynamic Systems.* Capítulo 7 sobre representaciones en variables de estado.
- **Kuo, B. C.** — *Sistemas de Control Automático.* Texto clásico en español, capítulos sobre espacio de estados.

### Preguntas guía

- ¿Por qué digo que el modelo de la bicicleta tiene **2 estados** y no 3 o 1?
- ¿Cuál es la diferencia formal entre una entrada y una perturbación?
- Si cambio las unidades de mis estados (por ejemplo `v` en km/h en lugar de m/s), ¿qué le pasa a las matrices?
- ¿Por qué el modelo lineal vale solo en una vecindad del punto de operación?

### Ejemplo ilustrativo

Modelo de la bicicleta del becado, formulado correctamente como MIMO:

```
x = [v, i]ᵀ    (estados)
u = V_m         (entrada de control)
d = sin(θ)     (perturbación medible — pendiente)
y = [v, i]ᵀ    (salidas)
```

Las dimensiones son: A (2×2), Bu (2×1), Bd (2×1), C (2×2 = I), D (2×1 = 0). Si tratamos `u` y `d` juntos como entrada extendida `ũ = [u, d]ᵀ`, entonces `B̃ = [Bu  Bd]` es 2×2 y el sistema queda como un MIMO 2×2.

### Trampas frecuentes

- Llamar MIMO a un sistema que tiene una sola entrada de control y dos salidas (eso es SIMO).
- No declarar el punto de operación en torno al que se linealiza.
- Confundir estados con salidas. En el modelo del becado, casualmente coinciden (`y = x`), pero conceptualmente son cosas distintas.

---

## VII. Análisis de sistemas lineales

### Por qué importa

Es lo que el script `Modelado_V1.m` está calculando con `ctrb`, `obsv` y `eig`. El becado tiene que poder explicar **qué significa** cada uno de esos comandos antes de mostrar los resultados en el paper.

### Conceptos clave

**Estabilidad por autovalores.** Para un sistema lineal `ẋ = A·x`, la estabilidad asintótica equivale a que **todos los autovalores de A tengan parte real negativa**. Es equivalente al criterio de Lyapunov en el caso lineal. Si algún autovalor tiene parte real positiva, el sistema es inestable; si es exactamente cero, es marginalmente estable (no asintótico).

**Controlabilidad.** Un sistema `(A, B)` es **completamente controlable** si, partiendo de cualquier estado inicial, existe alguna entrada `u(t)` que lo lleva a cualquier estado final en tiempo finito. **Criterio de Kalman**: el rango de la matriz de controlabilidad

`C_o = [B  AB  A²B  …  Aⁿ⁻¹B]`

debe ser igual a `n` (orden del sistema). En MATLAB: `rank(ctrb(A, B)) == n`.

**Observabilidad.** Un sistema `(A, C)` es **completamente observable** si, observando la salida `y(t)` en un intervalo de tiempo, se puede reconstruir el estado inicial. **Criterio de Kalman**: el rango de la matriz de observabilidad

`O_b = [C; CA; CA²; …; CAⁿ⁻¹]`

debe ser igual a `n`. En MATLAB: `rank(obsv(A, C)) == n`.

**Implicaciones prácticas.** Si el sistema no es controlable, no se puede diseñar un controlador que ubique los polos en cualquier lugar. Si no es observable, no se puede estimar el estado a partir de la salida medida (lo que descarta el uso de observadores). Para diseñar un controlador moderno (LQR, *pole placement*, observador), ambas propiedades deben cumplirse.

**Función de transferencia.** Para un sistema SISO, `G(s) = C(sI − A)⁻¹B + D`. Sus polos coinciden con los autovalores de `A` (salvo cancelaciones polo-cero). En MATLAB: `tf(ss(A, B, C, D))`.

**Realización mínima.** Si el sistema no es completamente controlable u observable, hay estados "redundantes" que no aportan a la relación entrada-salida. La **realización mínima** elimina esa redundancia. En MATLAB: `minreal(sys)`.

### Bibliografía recomendada

- **Ogata, K.** — *Ingeniería de Control Moderna*. **Sección 9-5** (Controlabilidad) y **9-6** (Observabilidad). Es la presentación canónica de los criterios de Kalman, en español, con ejemplos.
- **Chen, C.-T.** — *Linear System Theory and Design.* Oxford University Press. Texto matemáticamente más sólido, para profundizar.
- **Skogestad, S. y Postlethwaite, I.** — *Multivariable Feedback Control.* Wiley. Capítulos 4 y 5 — la perspectiva MIMO de estos temas.

### Preguntas guía

- Si mi sistema es estable pero no controlable, ¿se puede modificar la dinámica con realimentación?
- Si tiene polos muy separados (por ejemplo `−0.3` y `−50`), ¿qué implica para el control?
- ¿Por qué MATLAB devuelve `rank(ctrb) = 2` para mi sistema y eso me alegra?
- ¿Qué pasa con la controlabilidad si una columna de `B` se vuelve nula?

### Ejemplo ilustrativo

Para el modelo del becado con parámetros del script V1:

```
A = [-0.029, 4.27;  -363.6, -50]   (aprox.)
```

Autovalores: `λ ≈ −0.3, −50`. Ambos negativos → **estable**. La separación de magnitudes es de ≈ 170×, lo que indica una clara **separación de escalas temporales**: el modo eléctrico se establece rápido (`τ_e ≈ 20 ms`) y el modo mecánico evoluciona lento (`τ_m ≈ 3 s`). Para el diseño del controlador esto significa que el lazo de corriente se puede diseñar primero y de manera independiente, asumiendo que la velocidad mecánica varía lentamente — es la **estrategia de control en cascada**.

### Trampas frecuentes

- Calcular `rank(ctrb(A, B))` y compararlo con un número equivocado de estados (`n`). Si el sistema tiene 2 estados, `n = 2`, no 3 ni 1.
- Confundir los polos del sistema con los polos de la función de transferencia: pueden diferir si hay cancelaciones polo-cero (estados no controlables u observables).

---

## VIII. Teoría de control clásico

### Por qué importa

El becado no diseña el controlador en este avance, pero el informe debe mostrar que entiende **qué controlador se va a diseñar después** y por qué su modelo lo facilita.

### Conceptos clave

**Lazo cerrado y realimentación.** El controlador mide la salida `y(t)`, la compara con la consigna `r(t)` y genera una entrada `u(t) = K · (r − y)` que reduce el error. La realimentación es lo que distingue un sistema controlado de un sistema en lazo abierto.

**Control PID.** El controlador más usado en la industria. Su acción de control es:

`u(t) = Kp·e(t) + Ki·∫e dt + Kd·de/dt`

donde `e(t) = r(t) − y(t)`. Las tres ganancias se sintonizan empíricamente (Ziegler-Nichols) o analíticamente con un modelo del proceso.

**Realimentación de estados.** Si los estados se conocen (medidos directamente o estimados con un observador), la ley de control es `u = −K·x`. Las ganancias `K` se calculan para ubicar los polos del sistema en lazo cerrado donde se desee. Requiere que el sistema sea controlable.

**LQR (Linear Quadratic Regulator).** Variante de la realimentación de estados donde `K` se elige para minimizar un funcional cuadrático que pondera el error de estado y el esfuerzo de control. Da un buen compromiso automático entre desempeño y ahorro de energía. En MATLAB: `K = lqr(A, B, Q, R)`.

**Observadores.** Si los estados no se pueden medir todos directamente, se usa un observador (filtro de Luenberger o filtro de Kalman) para estimarlos a partir de las salidas medidas. Requiere observabilidad.

**Sistema en lazo cerrado.** Cuando se cierra el lazo, las matrices del sistema cambian: `A_cl = A − B·K`. Los autovalores de `A_cl` son los polos del lazo cerrado y determinan el desempeño dinámico.

### Bibliografía recomendada

- **Ogata, K.** — *Ingeniería de Control Moderna.* Capítulos 6 (PID) y 10 (Diseño en espacio de estados con realimentación de estados, LQR, observadores). Texto base.
- **Franklin, Powell y Emami-Naeini** — *Feedback Control of Dynamic Systems.* Capítulo 7 (espacio de estados) y 9 (control multivariable).
- **Kuo, B. C.** — *Sistemas de Control Automático.* Texto clásico en español.

### Preguntas guía

- ¿Por qué el control PID es el más usado en la industria?
- ¿Qué diferencia hay entre realimentación de estados y realimentación de salida?
- ¿Cuándo necesito un observador?
- ¿Para qué sirve LQR si ya puedo hacer *pole placement*?

### Ejemplo ilustrativo

Para el lazo de corriente del frenado regenerativo en la bicicleta, la consigna es `i_ref` (corriente de carga deseada hacia la batería). Un PI clásico:

`u(t) = Kp · (i_ref − i) + Ki · ∫(i_ref − i) dt`

donde `u` se traduce en el ciclo de trabajo `D` del convertidor. Con `Kp = 0.5` y `Ki = 2`, en plano (θ = 0) se obtiene un tiempo de establecimiento de 1.5 s y sobrepico < 5 %. En subida (θ = +5°), las mismas ganancias producen saturación; en bajada (θ = −5°), oscilaciones — **necesidad de adaptación** que es exactamente lo que motiva el PID.

### Trampas frecuentes

- Diseñar un PID por intuición y no verificar la estabilidad en lazo cerrado.
- Olvidar la saturación de la entrada de control. Un PID que pide ciclos de trabajo > 1 está pidiendo algo físicamente imposible.

---

## IX. Identificación de sistemas

### Por qué importa

En la siguiente etapa del PID, los parámetros del modelo (`R`, `L`, `Kt`, `Ke`, `B`) se medirán experimentalmente sobre el motor real. El becado debe entregar el modelo con la estructura preparada para esa identificación.

### Conceptos clave

**Idea central.** La identificación es el procedimiento de estimar los parámetros (o la estructura misma) de un modelo a partir de mediciones experimentales del sistema real.

**Identificación paramétrica vs. no paramétrica.** Paramétrica: se asume una estructura del modelo (ej.: `ẋ = Ax + Bu`) y se estiman los valores de las matrices. No paramétrica: se obtiene una representación experimental del sistema (ej.: la respuesta al escalón, el diagrama de Bode) sin asumir estructura.

**Mínimos cuadrados.** El método más usado para identificación paramétrica. Dadas mediciones de `u(t)` e `y(t)`, los parámetros se estiman minimizando el error cuadrático entre la salida medida y la salida del modelo.

**Identificación experimental de motores.** Procedimientos clásicos:

- **R**: medición directa con multímetro entre fases.
- **L**: medición con LCR, o respuesta al escalón con motor bloqueado.
- **Ke**: ensayo en vacío. Se gira el motor a velocidad constante con un mecanismo externo y se mide la tensión generada en bornes. `Ke = V/ω`.
- **Kt**: ensayo con freno calibrado. Se aplica corriente conocida, se mide el torque desarrollado. `Kt = T/i`.
- **B**: *coast-down test*. Se acelera el motor a velocidad conocida, se desconecta y se registra la curva de desaceleración libre. Del ajuste exponencial se extrae `B/m`.

**Persistencia de excitación.** Para identificar correctamente, la entrada debe excitar todos los modos del sistema. Una entrada constante no permite identificar dinámicas — se necesitan escalones, chirps o señales pseudoaleatorias binarias (PRBS).

### Bibliografía recomendada

- **Yiannis, B. y otros** — *System Identification and Adaptive Control.* Springer. Texto del PID, especialmente útil para enlazar identificación con control adaptativo.
- **Ljung, L.** — *System Identification: Theory for the User.* Prentice Hall. Texto referencia mundial. Capítulos 1–3 para introducción.
- **Oman, H. y Morchin, W.** — *Electric Bicycles*. **Capítulo 7** (Measurement of Performance). Procedimientos prácticos para medir parámetros en bicicletas eléctricas — el coast-down test y la medición de aerodinámica están directamente acá.

### Preguntas guía

- ¿Por qué necesito persistencia de excitación?
- ¿Qué precisión espero en cada parámetro? ¿Cuál es el más fácil de medir y cuál el más difícil?
- ¿Qué pasa si los datos experimentales tienen ruido? (Pista: hay que filtrar o usar mínimos cuadrados ponderados.)

### Ejemplo ilustrativo

Coast-down test para estimar `B/m`. Se acelera la bicicleta a 5 m/s con motor encendido, se desconecta y se mide `v(t)`. Si la dinámica residual es aproximadamente:

`m · dv/dt = −B · v − F_roll`

la velocidad sigue una exponencial decreciente cuyo tiempo característico es `τ = m/B`. Si la simulación o medición da `τ = 30 s` con `m = 95 kg`, entonces `B ≈ 3.2 N·s/m` — coherente con el orden de magnitud calculado a partir de la fricción aerodinámica linealizada.

### Trampas frecuentes

- Medir parámetros dinámicos con entradas estáticas. El coast-down requiere ver la transitoria, no el equilibrio.
- Confundir el coeficiente viscoso del modelo lineal con la fricción real, que es no lineal y tiene componente constante.

---

## X. Control adaptativo

### Por qué importa

Es el objetivo final del PID. El modelo del becado y todas las herramientas anteriores convergen en esto.

### Conceptos clave

**Por qué adaptar.** Un controlador con ganancias fijas es óptimo en un único punto de operación. Si el sistema o sus condiciones cambian (carga variable, parámetros que derivan, perturbaciones distintas), el controlador deja de ser óptimo y, en casos extremos, puede volverse inestable. Adaptar significa modificar las ganancias del controlador en función del estado o las condiciones del sistema.

**Gain Scheduling.** La estrategia más simple. Se diseñan varios controladores fijos, cada uno para un punto de operación diferente, y se conmuta o interpola entre ellos según la condición actual. La condición que dispara el cambio es una variable medible llamada **scheduling variable**. Para el PID, la pendiente θ es la candidata natural.

**MRAC (Model Reference Adaptive Control).** El controlador ajusta sus ganancias en línea para que la respuesta del sistema en lazo cerrado se asemeje a la de un modelo de referencia preestablecido. La adaptación se hace mediante una ley basada en el error entre la salida real y la del modelo de referencia (regla MIT, regla Lyapunov).

**Self-tuning regulators.** El controlador identifica los parámetros del sistema en línea (módulo de identificación) y recalcula las ganancias del controlador en función de los parámetros estimados.

**Comparación.** Gain Scheduling es robusto, sencillo y predecible, pero requiere conocer de antemano los puntos de operación. MRAC y self-tuning son más sofisticados y manejan incertidumbre paramétrica, pero requieren cuidado con la estabilidad de la adaptación misma.

**Para este proyecto.** Gain Scheduling sobre la pendiente θ es la estrategia recomendable como primer enfoque. La pendiente es medible, varía lentamente (segundos), y los parámetros del sistema son razonablemente conocidos.

### Bibliografía recomendada

- **Astrom, K. J. y Wittenmark, B.** — *Adaptive Control.* Addison-Wesley, 2a ed. Texto referencia. Capítulos 1, 9 (Gain scheduling) y 5 (MRAC).
- **Yiannis, B. y otros** — *System Identification and Adaptive Control.* Springer. Texto del PID.
- **Goodwin, G. y Sin, K. S.** — *Adaptive Filtering, Prediction and Control.* Prentice Hall. Texto matemáticamente sólido.

### Preguntas guía

- ¿Por qué Gain Scheduling y no MRAC para este proyecto?
- ¿Cuántos puntos de operación voy a programar? ¿Cómo interpolo entre ellos?
- ¿Qué pasa si la pendiente cambia más rápido que el tiempo de adaptación del controlador?
- ¿Cómo se garantiza la estabilidad en la transición entre dos controladores adyacentes?

### Ejemplo ilustrativo

Esquema simplificado de Gain Scheduling para la bicicleta:

```
Si θ < −3° (bajada pronunciada)  →  ganancias diseñadas para regeneración fuerte
Si −3° ≤ θ < +3° (plano)          →  ganancias nominales
Si θ ≥ +3° (subida)               →  ganancias diseñadas para alta tracción
```

Entre los tres rangos se interpola linealmente. La pendiente se mide con IMU, se filtra con un pasabajos para suprimir vibraciones, y la salida del filtro alimenta al *scheduler*.

### Trampas frecuentes

- Tratar el control adaptativo como una panacea. No es magia: requiere un buen modelo de partida y un diseño cuidadoso.
- Adaptar demasiado rápido — provoca inestabilidad de la adaptación misma (límites de Astrom-Wittenmark).
- Olvidar verificar la estabilidad del sistema completo (planta + adaptación) y no solo del controlador.

---

## XI. Sensado de pendiente y topografía

### Por qué importa

Sin medición de pendiente confiable, el control adaptativo topográfico no funciona. El becado no implementa el sensado, pero el modelo debe asumir explícitamente cómo se va a medir θ.

### Conceptos clave

**IMU (Inertial Measurement Unit).** Un sensor combinado que integra acelerómetro de 3 ejes, giróscopo de 3 ejes, y a veces magnetómetro. Tecnología madura, barata, y disponible como módulo embebido (MPU-6050, BNO055, ICM-20948 son chips típicos).

**Cómo se obtiene θ a partir de un acelerómetro.** Si el vehículo está estacionario, el acelerómetro mide directamente la componente de la gravedad sobre cada eje. Para un acelerómetro montado con el eje X alineado con el avance del vehículo:

`a_x = g · sin(θ)`

de donde `θ = arcsin(a_x / g)`. En vehículo móvil, esta ecuación es contaminada por la aceleración del propio vehículo, y hay que combinar la lectura con el giróscopo para separar las dos componentes.

**Filtro complementario.** Combina la lectura instantánea del acelerómetro (precisa pero ruidosa) con la integración del giróscopo (suave pero con deriva). El filtro entrega una estimación robusta de la inclinación. Es la solución estándar en aplicaciones de movilidad.

**Frecuencia de muestreo.** Para una bicicleta urbana, una tasa de 50–100 Hz es suficiente. Se filtra con un pasabajos a 1–2 Hz para suprimir vibraciones sin perder la dinámica relevante de cambio de pendiente.

**Pendiente como entrada vs. perturbación.** Si la pendiente se mide y se realimenta al controlador, se trata como entrada (con ese formalismo, el control puede compensarla *feedforward*). Si no se mide, se trata como perturbación a rechazar (control robusto). Para este PID, la pendiente es entrada medible.

### Bibliografía recomendada

- **Titterton, D. y Weston, J.** — *Strapdown Inertial Navigation Technology.* IET. Texto referencia para IMU y filtros.
- **Borenstein, J. et al.** — *Where Am I? Sensors and Methods for Mobile Robot Positioning.* Universidad de Michigan, 1996 (disponible online). Capítulos 3 y 4.
- **Datasheets de chips IMU específicos** — leer al menos uno (MPU-6050 es accesible y bien documentado) para entender ruido, sesgo, calibración.

### Preguntas guía

- ¿Por qué un solo acelerómetro no alcanza para medir pendiente en un vehículo en movimiento?
- ¿Qué pasa si la IMU no está montada perfectamente alineada con el eje del vehículo? (Pista: hace falta calibración.)
- ¿Qué frecuencia de muestreo se necesita y por qué?

### Ejemplo ilustrativo

Una IMU MPU-6050 montada en el cuadro de la bicicleta, con el eje X alineado con el avance. En estacionario, sobre una rampa de 5°:

`a_x = 9.81 · sin(5°) ≈ 0.855 m/s²`

Si la resolución del acelerómetro es 0.001 m/s² (16 bits, ±2 g), la resolución angular es aproximadamente 0.006° — más que suficiente. El problema real no es la resolución, sino el ruido (≈ 0.05 m/s²) y la separación entre componente gravitatoria y aceleración del vehículo, que es donde entra el filtro complementario.

### Trampas frecuentes

- Asumir que el acelerómetro mide directamente la pendiente. Mide aceleración total: gravedad + aceleración del vehículo + ruido + sesgo.
- No filtrar las vibraciones de la rueda sobre la calzada, que dominan el espectro a frecuencias mayores a 5 Hz.

---

## XII. Síntesis — cómo todos los temas se integran

El recorrido completo del proyecto es:

1. **(I)** La bicicleta es un sistema mecánico que obedece la segunda ley de Newton, con tres fuerzas resistivas dependiendo de la velocidad de manera distinta.
2. **(II)** El motor BLDC inyecta una fuerza propulsora proporcional a la corriente, y a la vez genera una back-EMF proporcional a la velocidad.
3. **(III)** La corriente del motor está controlada por el ciclo de trabajo de un convertidor Buck-Boost que se alimenta de una batería.
4. **(IV)** La batería tiene una capacidad finita, una tensión que depende del SOC, y restricciones de carga y descarga.
5. **(V)** En frenado regenerativo, el motor opera como generador y el convertidor invierte el flujo de potencia hacia la batería.
6. **(VI)** Todo el sistema se modela como un sistema lineal en variables de estado con la velocidad y la corriente como estados, el ciclo de trabajo como entrada, y la pendiente como entrada de perturbación medible.
7. **(VII)** El sistema se analiza por criterios de Kalman: si es controlable y observable, queda habilitado para diseño de control; los autovalores caracterizan su dinámica natural.
8. **(VIII)** Sobre ese modelo se diseña un controlador clásico (PI o realimentación de estados) que cierra el lazo de corriente.
9. **(IX)** Los parámetros del modelo se identifican experimentalmente con ensayos clásicos (coast-down, ensayo de vacío con generador, ensayo con freno calibrado).
10. **(X)** El controlador se vuelve adaptativo (Gain Scheduling) ajustando sus ganancias en función de la pendiente.
11. **(XI)** La pendiente se mide con una IMU y un filtro complementario.

Las once secciones forman un sistema. El becado modela en (VI) y analiza en (VII). El resto del trabajo del PID se construye sobre eso.

---

## Glosario rápido

| Término | Definición sintética |
|---------|---------------------|
| BLDC | Brushless DC, motor síncrono de imanes permanentes con conmutación electrónica. |
| Buck | Convertidor reductor de tensión. |
| Boost | Convertidor elevador de tensión. |
| Ciclo de trabajo (D) | Fracción del período PWM en que la llave está encendida. |
| Back-EMF | Tensión inducida en un motor cuando gira: `e = Ke·ω`. |
| Coast-down | Ensayo de desaceleración libre para identificar fricción. |
| Gain scheduling | Técnica de control adaptativo basada en conmutar entre controladores diseñados para distintos puntos de operación. |
| IMU | Unidad inercial de medida (acelerómetro + giróscopo). |
| Kalman (criterio de) | Criterio algebraico para verificar controlabilidad y observabilidad. |
| Lyapunov | Método para analizar estabilidad de sistemas dinámicos. |
| MIMO | Multiple-Input Multiple-Output, sistema con varias entradas y varias salidas. |
| PID (controlador) | Proporcional-Integral-Derivativo. |
| PMSM | Permanent Magnet Synchronous Motor. |
| PWM | Pulse-Width Modulation, técnica de modulación por ancho de pulso. |
| SOC | State of Charge, estado de carga de una batería. |

---

## Cómo este marco teórico se usa en el informe

El informe del becado **no debe contener** todo este material — sería una tesis de grado. Lo que debe contener es:

- En la **Sección II (Marco teórico)** del paper: las secciones I, II, III, V de esta guía resumidas a una página, con citas a los libros del PID.
- En la **Sección III (Variables de estado)**: la sección VI de esta guía, aplicada al caso concreto.
- En la **Sección IV (Análisis)**: la sección VII de esta guía, con los números del modelo.
- En la **Sección VI (Discusión)** y **VII (Conclusiones)**: referencia hacia adelante a las secciones VIII, IX, X, XI como trabajo futuro.

Esta guía sirve como **cuaderno de fondo**: el becado la consulta para no perderse, pero no la copia al informe. Si el informe necesita cubrir explícitamente alguno de los temas que aquí están, cita los libros directamente.

---

## Pregunta guía final

> Si el director me pregunta de improviso "¿por qué necesitamos un convertidor Buck-Boost y no alcanza con un Buck?", ¿tengo la respuesta en una frase?
>
> Si la respuesta es "porque necesitamos invertir el flujo de potencia en frenado regenerativo, y eso requiere elevar la tensión generada por el motor para que cargue una batería que tiene mayor tensión nominal que la back-EMF en velocidades bajas de frenado", entonces el marco teórico lo entendí.
>
> Si la respuesta es "porque está en el PID", todavía no.

Esa es la prueba que hay que repetir con cada uno de los once temas de esta guía.
