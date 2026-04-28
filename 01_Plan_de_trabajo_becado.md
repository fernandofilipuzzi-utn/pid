# Plan de trabajo para el cierre del avance del becado

**Proyecto:** Sistema de movilidad urbana con control adaptativo topográfico (PID UTN — AMUTNPA0007734)
**Becado:** Esteban Fidel Sian (BINID)
**Tema del avance:** Modelado en variables de estado de una bicicleta eléctrica con freno regenerativo, orientado a control adaptativo según topografía.

---

## Cómo usar este documento

Cada tarea está acompañada de **preguntas guía** que el becado debe poder responder con confianza antes de pasar a la siguiente, y **ejemplos ilustrativos** simples que muestran cómo se ve una respuesta correcta. Si una pregunta no se puede responder, esa es la próxima tarea pendiente.

---

## 0. Marco y alcance del avance

El becado ya entregó:

- Un borrador en Word con el desarrollo analítico del modelo en variables de estado.
- Un script `Modelado_V1.m` que arma `A`, `B`, `C`, `D`, calcula la función de transferencia, y evalúa controlabilidad, observabilidad y estabilidad por criterio de Kalman.

El cierre del avance debe consolidar **un modelo en variables de estado verificado, con análisis numérico, contextualizado en el eje del PID (control adaptativo topográfico y recuperación de energía)**, y dejarlo listo para que en la siguiente etapa del proyecto se diseñe el controlador adaptativo y se calibre contra el banco de pruebas.

No se pide al becado que diseñe el controlador adaptativo final ni que construya el banco — eso corresponde a las etapas 2 y 3 del cronograma del PID. Sí se le pide que su modelo sea **utilizable** como insumo de esas etapas.

**Preguntas guía iniciales:**

- ¿Puedo explicarle a un compañero, sin mirar el documento, qué problema resuelve este avance y para qué sirve dentro del PID?
- ¿Qué cosas del PID **no** voy a abordar en este avance, y por qué? (Acotar es tan importante como hacer.)
- Si me preguntan "¿por qué la pendiente es central en este modelo?", ¿tengo una respuesta de dos frases?

**Ejemplo ilustrativo — el alcance bien acotado:**

> *"En este avance modelo la dinámica de una bicicleta eléctrica con freno regenerativo en variables de estado, incluyendo la pendiente como entrada de perturbación medible. El modelo permite analizar controlabilidad, observabilidad y balance energético en frenado regenerativo, y es el insumo para el diseño del controlador adaptativo que se aborda en la etapa 2 del PID. No incluye el diseño del controlador, ni la identificación experimental de parámetros del motor real (eso corresponde a la siguiente etapa)."*

---

## 1. Correcciones al modelo existente (prioridad alta)

Estas tareas resuelven errores conceptuales del borrador inicial y son condición para que lo simulado sea válido.

### 1.1. Re-clasificar el sistema y agregar la pendiente θ como segunda entrada

El modelo actual tiene una sola entrada (`V_bat`) y dos estados (`v`, `i`). Por construcción es **SIMO**, no MIMO como afirma el borrador. Para que sea coherente con el espíritu del PID (control adaptativo topográfico) la pendiente debe entrar al modelo como **entrada de perturbación medible**:

```
ẋ = A·x + B_u·u + B_d·d
```

donde `u = V_bat` (entrada de control, comanda el convertidor Buck-Boost) y `d = sin(θ)` (perturbación topográfica medible, con θ obtenido de un acelerómetro/IMU o un mapa). Con esta formulación el sistema queda con **2 entradas, 2 salidas y 2 estados**, alineado con el objetivo del proyecto y abordable como MIMO.

**Preguntas guía:**

- ¿Cuántas entradas controlo? ¿Cuántas mido como perturbación? ¿Cuántas salidas tengo?
- ¿Qué pasa si la pendiente no la mido y la dejo como perturbación no medida? (Pista: cambia el tipo de control que puedo diseñar después.)
- ¿La pendiente es realmente una "entrada" o es un parámetro variable del modelo? ¿Cuál es la diferencia para el control?

**Ejemplo ilustrativo — diferenciar SISO, SIMO y MIMO con un caso cotidiano:**

> Un termotanque con resistencia eléctrica controlada y termómetro: SISO (1 entrada — potencia; 1 salida — temperatura).
>
> El mismo termotanque, pero ahora me interesa medir simultáneamente la temperatura del agua y la del exterior del tanque: SIMO (1 entrada, 2 salidas).
>
> Si le agrego una bomba con caudal controlable, además de la resistencia: ahora controlo 2 cosas (potencia y caudal) y mido 2 (temperatura del agua y caudal de salida): MIMO (2 entradas, 2 salidas).
>
> En la bicicleta: si solo controlo el ciclo de trabajo D, es SIMO. Si además trato la pendiente θ como una segunda entrada porque la voy a medir y compensar, el sistema **se vuelve MIMO en sentido formal** y eso me habilita a diseñar control adaptativo en función de θ.

### 1.2. Linealización con punto de operación explícito

Reescribir el desarrollo trabajando en variables de desviación respecto a un punto de operación `(v₀, i₀)`:

- Definir `v₀` como la velocidad de crucero típica (ejemplo: 5 m/s ≈ 18 km/h, valor compatible con uso urbano).
- Linealizar `F_aero(v) = ½·ρ·A·Cd·v²` en `v₀` → `B_aero ≈ ρ·A·Cd·v₀`.
- Reconocer explícitamente que `F_roll = Crr·m·g·cos(θ)` no es proporcional a `v`: aporta un término constante en el modelo lineal, no un coeficiente viscoso.
- Construir el coeficiente `B = B_aero` (solo el aerodinámico depende de v) y dejar las componentes constantes de la fuerza resistiva como `F₀` o absorbidas en el punto de equilibrio.

**Preguntas guía:**

- ¿Cuál es mi `v₀` y por qué elegí ese valor y no otro?
- Si pongo `v = v₀` en mi modelo lineal, ¿el sistema queda en equilibrio (ẋ = 0)? Si no, hay un error en la linealización.
- ¿Qué tan lejos de `v₀` puede operar mi bici antes de que el modelo lineal sea pobre? (Una regla práctica: dentro del ±30 % de `v₀` el error de linealización es chico.)

**Ejemplo ilustrativo — linealización con números:**

> Tomando `ρ = 1.2 kg/m³`, `A = 0.5 m²`, `Cd = 1.0`, `v₀ = 5 m/s`:
>
> - Fuerza aerodinámica en el punto de operación:
>   `F_aero(v₀) = ½ · 1.2 · 0.5 · 1.0 · 5² = 7.5 N`
> - Pendiente local de la fuerza:
>   `dF_aero/dv|_{v₀} = ρ · A · Cd · v₀ = 1.2 · 0.5 · 1.0 · 5 = 3 N·s/m → éste es el coeficiente B_aero`
> - Linealización: `F_aero(v) ≈ 7.5 + 3·(v − 5)` para v cerca de 5 m/s.
>
> Verificación rápida: en `v = 6 m/s`, el modelo no lineal da `F_aero = 10.8 N` y el lineal da `7.5 + 3·1 = 10.5 N`. Error de 3 %, aceptable.
> En `v = 10 m/s`, el modelo no lineal da `30 N` y el lineal da `7.5 + 3·5 = 22.5 N`. Error de 25 %, **ya no es aceptable** — fuera del rango de validez.
>
> Para la rodadura, con `Crr = 0.007`, `m = 95 kg`, `g = 9.81 m/s²`, `θ = 0`:
> `F_roll = 0.007 · 95 · 9.81 · 1 ≈ 6.5 N` (constante, no depende de v).

### 1.3. Corregir el signo del acoplamiento mecánico-eléctrico en `A`

En `Modelado_V1.m` hay que verificar que la matriz `A` sea consistente con el sentido físico del frenado regenerativo:

```matlab
A = [-B/m,      Kt/(m*r);
     -Ke/(L*r), -R/L      ];
```

Esta forma corresponde al modo **motor** (corriente positiva genera torque acelerador). Para frenado regenerativo, conviene aclarar en el script —con un comentario y/o con un parámetro de modo— cuál es el signo de `i` esperado y qué convención de signos se usa. Si se elige una sola convención que cubra ambos modos, hay que dejarlo escrito explícitamente.

**Preguntas guía:**

- Si en `t = 0` aplico `V_bat = 24 V` con `v = 0, i = 0`, ¿qué espero ver? (Pista: la corriente debe crecer y la velocidad debe aumentar. Si la simulación da algo distinto, hay un error de signo.)
- En modo regenerativo, con `v = 5 m/s` e `i = 0`, ¿qué pasa si pongo `V_bat = 0`? (Pista: la bici debe frenarse y la corriente debe ir hacia la batería, es decir, ser de signo opuesto al de modo motor.)
- ¿Tengo escrito en el documento cuál es la convención de signos que adopté?

**Ejemplo ilustrativo — test de signos en MATLAB:**

```matlab
% Test 1: respuesta al escalón en modo motor (debe acelerar)
[y, t] = step(sys, 5);   % 5 segundos
plot(t, y(:,1));
% Esperado: v(t) crece monotónicamente desde 0 hasta valor de equilibrio positivo.

% Test 2: frenado libre (debe desacelerar, i debe ser negativa)
[y, t] = initial(sys, [5; 0], 5);
% Esperado: v(t) decrece desde 5 hasta valor menor; i(t) toma valores negativos.
```

Si v(t) sale negativo en el test 1, o si v(t) crece en el test 2, **hay un error de signo** y hay que revisar A.

### 1.4. Modelar el convertidor Buck-Boost (al menos en estado promediado)

`V_bat` en el modelo no es la tensión nominal de la batería, es la tensión que el convertidor impone en bornes del motor. Modelar el convertidor en estado promediado:

```
V_motor = D · V_bateria_real    (modo Buck, descarga al motor)
V_motor = V_bateria_real / (1 - D)   (modo Boost, regenerativo)
```

Con esto la entrada de control real es el ciclo de trabajo `D ∈ [0, 1]`, no una tensión arbitraria. Es lo que después comandará el controlador en el banco de pruebas.

**Preguntas guía:**

- ¿La tensión que aparece en mi modelo es la de la batería o la que el convertidor impone en el motor? ¿Cómo se relacionan?
- ¿Mi entrada de control puede tomar cualquier valor o tiene saturación? (Pista: D vive en [0, 1], no es libre.)
- En modo regenerativo, ¿qué condición de tensión hace que la corriente fluya **hacia** la batería y no al revés?

**Ejemplo ilustrativo — el convertidor con números:**

> Batería de 36 V nominal. Motor con back-EMF que en `v = 5 m/s` vale `Ke·ω = 1.2 · (5/0.33) ≈ 18.2 V`.
>
> - **Modo motor a velocidad baja** (v = 2 m/s, back-EMF ≈ 7.3 V): para inyectar corriente al motor con `V_motor = 12 V`, el convertidor en modo Buck necesita `D = V_motor/V_bat = 12/36 ≈ 0.33`.
> - **Modo regenerativo en bajada** (v = 8 m/s, back-EMF ≈ 29 V): para que la corriente fluya hacia la batería, la tensión generada por el motor debe ser convertida a un valor superior a 36 V. El convertidor en modo Boost cumple ese rol regulando la corriente de carga.
>
> Lo importante: el lazo de corriente del frenado regenerativo se cierra ajustando D, y la dinámica de ese lazo depende de la velocidad (porque la back-EMF depende de v). Eso es justamente lo que hace al sistema **no lineal en sentido estricto** y motiva el control adaptativo.

### 1.5. Escribir explícitamente la ecuación de salida

Agregar en el documento y en el script:

```
y = C·x + D·u    con C = I (identidad 2×2),  D = 0
```

con salidas `y = [v; i]ᵀ`. Si se quiere controlar la corriente de carga a la batería (no la corriente del motor), agregar la relación entre `i_motor` e `i_bateria` impuesta por el convertidor.

**Preguntas guía:**

- ¿Cuáles son las variables que efectivamente puedo medir con sensores en el banco de pruebas? (Eso debe coincidir con mi C.)
- Si solo midiera la velocidad y no la corriente, ¿el sistema seguiría siendo observable?
- La corriente que mido en el motor, ¿es la misma que carga la batería? Si no, ¿cuál es la relación?

**Ejemplo ilustrativo — observabilidad parcial:**

> Si pongo `C = [1, 0]` (solo mido velocidad), MATLAB devuelve `obsv(A, C) = [1 0; -B/m  Kt/(m·r)]`. El rango es 2 (con Kt ≠ 0), así que el sistema **es observable solo midiendo v**, gracias al acoplamiento mecánico-eléctrico. Probarlo en el script:
>
> ```matlab
> C_solo_v = [1, 0];
> rank(obsv(A, C_solo_v))   % debe dar 2
> ```
>
> Si da rango 1, el sistema no es observable con esa medición y necesito agregar un sensor.

---

## 2. Mejoras a la simulación (`Modelado_V2.m`)

Estas tareas convierten el script actual en una herramienta de evaluación útil.

### 2.1. Parametrizar con valores realistas y trazables

Reemplazar los valores arbitrarios por valores con fuente. Tomar como referencia:

- Masa total `m = 95–100 kg` (bicicleta + ciclista promedio, según Oman & Morchin cap. 2).
- Radio de rueda `r = 0.33 m` (rodado 26'') o `r = 0.35 m` (rodado 27.5''). Está bien.
- Coeficiente aerodinámico `Cd ≈ 1` y área frontal `A ≈ 0.5 m²` (Oman & Morchin Tabla 2.1 y 2.2).
- Densidad del aire `ρ = 1.2 kg/m³` (Paraná, baja altitud).
- `Crr = 0.007` para neumáticos a 35 psi (Oman & Morchin Tabla 2.3).
- `R`, `L`, `Kt`, `Ke` del motor brushless real disponible en el laboratorio (consultar al director Ing. Yarce — la beca BINID anterior trabajó sobre el mismo tipo de motor). Si no hay datos, usar valores típicos de motor BLDC de hub 250–500 W.

Cada valor debe quedar comentado en el script con su fuente, así:

```matlab
m  = 95;     % kg, masa total ciclista+bici (Oman & Morchin, 2006, p.30)
Cd = 1.0;    % coef. arrastre ciclista urbano (Oman & Morchin, 2006, Tabla 2.1)
```

**Preguntas guía:**

- Para cada parámetro de mi script, ¿puedo nombrar la fuente (libro, página, fabricante, medición propia)?
- ¿Las unidades en el comentario coinciden con las que asumo en las ecuaciones?
- Si alguien me pregunta "¿de dónde sacaste Kt = 1.2?", ¿tengo respuesta o lo inventé?

**Ejemplo ilustrativo — parámetros con y sin fuente:**

> ❌ Mal:
> ```matlab
> Kt = 1.2;
> ```
>
> ✅ Bien:
> ```matlab
> Kt = 1.2;   % N·m/A, motor BLDC hub 350W 36V (datasheet MXUS XF08)
> ```
>
> Si no hay datasheet, lo correcto es:
> ```matlab
> Kt = 1.2;   % N·m/A, valor estimado por orden de magnitud para motor BLDC
>             % de bicicleta 250-500W. A identificar experimentalmente en
>             % etapa 2 del PID.
> ```

### 2.2. Agregar la pendiente como entrada y su efecto

Con θ como segundo input, el modelo aumentado queda:

```
ẋ = A·x + B_u·u + B_d·sin(θ)
```

donde `B_d = [-g; 0]` (la gravedad descompuesta sobre el plano frena cuando subimos, acelera cuando bajamos). Simular escenarios:

- **θ = 0°** (plano): respuesta nominal.
- **θ = +5°** (subida típica de Paraná): consumo extra.
- **θ = −5°** (bajada): potencial de regeneración.

**Preguntas guía:**

- Para `θ = +5°`, ¿qué velocidad de equilibrio espero si dejo `V_bat` constante? ¿Coincide con la simulación?
- En `θ = −5°` con `V_bat` apagado, ¿hasta qué velocidad acelera la bici libremente? ¿Es físicamente razonable o me da 200 km/h?
- ¿El cambio de signo de θ produce comportamiento simétrico en mi modelo? ¿Debería?

**Ejemplo ilustrativo — velocidad de equilibrio en bajada libre:**

> En `θ = −5°` con `V_bat = 0` (motor desconectado), la bici termina rodando a velocidad constante donde la fuerza gravitatoria iguala las resistencias:
>
> `m·g·sin(5°) = ½·ρ·A·Cd·v² + Crr·m·g·cos(5°)`
> `95 · 9.81 · 0.087 = 0.3·v² + 0.007 · 95 · 9.81 · 0.996`
> `81.1 ≈ 0.3·v² + 6.5`
> `v² ≈ 248 → v ≈ 15.7 m/s ≈ 56 km/h`
>
> Si la simulación me da algo cercano (digamos 14–17 m/s), está bien. Si me da 50 m/s o 5 m/s, hay un error.

### 2.3. Calcular y graficar respuestas representativas

Mínimo a incluir:

| # | Análisis | Comando MATLAB clave |
|---|----------|-----------------------|
| 1 | Polos y ceros, mapa pole-zero | `pzmap(sys)` |
| 2 | Respuesta al escalón en V_bat (modo motor) | `step(sys)` |
| 3 | Respuesta a condición inicial v₀ con V_bat=0 (frenado libre) | `initial(sys, [v0; 0])` |
| 4 | Respuesta a frenado regenerativo (V_bat reducido bruscamente) | simulación con `lsim` |
| 5 | Comparación de bajada con/sin regeneración | `lsim` con dos escenarios |
| 6 | Diagrama de Bode | `bode(sys)` |

Cada figura debe guardarse en `.png` y `.fig` con resolución ≥ 300 dpi y nombres descriptivos (`fig01_polos.png`, `fig02_step_vbat.png`, etc.).

**Preguntas guía para cada figura:**

- ¿Esta figura responde una pregunta concreta? ¿Cuál?
- Si alguien la mira sin texto alrededor, ¿entiende qué representa?
- ¿Las constantes de tiempo y los valores estacionarios son razonables físicamente?

**Ejemplo ilustrativo — chequeo de constantes de tiempo:**

> Polos del sistema con los parámetros del script V1: MATLAB devuelve aproximadamente `λ₁ ≈ -0.026`, `λ₂ ≈ -50`. Esto significa:
>
> - Modo eléctrico rápido: `τ_e ≈ 1/50 = 20 ms` (constante L/R = 0.01/0.5 = 20 ms ✓ coincide con la inductancia y resistencia)
> - Modo mecánico lento: `τ_m ≈ 1/0.026 ≈ 38 s` — **suena demasiado lento** para una bici. Con B = 2.5 N·s/m y m = 85 kg, da `m/B = 34 s`, coincide con lo simulado, pero **2.5 N·s/m es muy poco** para representar la realidad. La fricción aerodinámica en `v₀ = 5 m/s` debería dar `B_aero ≈ 3 N·s/m` y la rodadura aporta otra parte. Un valor de B más realista da una constante de tiempo menor.
>
> Ese tipo de razonamiento es lo que la sección de discusión del paper debe contener.

### 2.4. Análisis energético del frenado regenerativo

Agregar un script anexo (`Analisis_energia.m`) que calcule, sobre la simulación de un frenado:

- Energía cinética inicial: `Ek = ½·m·v₀²`.
- Energía disipada en `R` (efecto Joule): `∫ R·i² dt`.
- Energía disipada en `B` (rozamiento+aire): `∫ B·v² dt`.
- Energía recuperada en la batería: `∫ V_bat · i dt` cuando i tiene signo de carga.
- Eficiencia de regeneración: `η_reg = E_recuperada / Ek`.

Comparar con los valores típicos del cap. 4.9 de Oman & Morchin (40–60 % es realista; 100 % es ideal teórico).

**Preguntas guía:**

- ¿La suma de energías cierra (`Ek_inicial = Ek_final + E_R + E_B + E_recuperada`)? Si no cierra, hay error.
- ¿La eficiencia de regeneración me da un valor realista o un absurdo (negativo, mayor a 100 %)?
- ¿Qué fracción de la energía cinética se va por cada vía? ¿Cuál es la pérdida más grande?

**Ejemplo ilustrativo — orden de magnitud:**

> Frenado de `v₀ = 8 m/s` a `v_f = 2 m/s` para una bici+ciclista de 95 kg:
>
> `ΔE_k = ½ · 95 · (8² − 2²) = ½ · 95 · 60 = 2850 J ≈ 0.79 Wh`
>
> Con eficiencia ideal (100 %), recupero 0.79 Wh. Con eficiencia realista de 50 %, recupero 0.40 Wh.
>
> Para una batería de 250 Wh, son 0.16 % de la capacidad — **chico**. Coincide con el comentario del Oman & Morchin de que la regeneración en bicicleta no es por ahorro grande, sino por el efecto sumado en muchos frenados y por aprovechar bajadas largas.
>
> Esto es valioso ponerlo en la discusión: **el frenado regenerativo en bici no es una mina de oro energética; lo interesante es la integración con el control para frenado controlado**.

### 2.5. Análisis de sensibilidad

Variar uno por uno los parámetros más inciertos (`Kt`, `Ke`, `R`, `B`) en ±20 % y mostrar cómo cambian:

- Los autovalores del sistema.
- La constante de tiempo dominante.
- La ganancia estática.

Esto justifica la necesidad de un control **adaptativo** (núcleo del PID): los parámetros varían y un control fijo no alcanza.

**Preguntas guía:**

- ¿Cuál es el parámetro más sensible? ¿Y el menos sensible?
- ¿Una variación de ±20 % en Kt mueve los polos lo suficiente como para volver inestable un control PI fijo? Si es así, queda justificado el control adaptativo.
- ¿Qué parámetros van a cambiar realmente durante el uso (temperatura del motor, carga de la batería, etc.) y cuáles son fijos?

**Ejemplo ilustrativo — formato de tabla de sensibilidad:**

> | Parámetro | Valor nominal | Variación | λ_dominante (1/s) | Δ% |
> |-----------|---------------|-----------|--------------------|------|
> | (nominal) | —             | —         | −0.026             | —    |
> | Kt        | 1.2           | +20 %     | −0.024             | −8 % |
> | Kt        | 1.2           | −20 %     | −0.029             | +12 %|
> | R         | 0.5           | +20 %     | −0.027             | +4 % |
> | B         | 2.5           | +20 %     | −0.031             | +19 %|
> | …         | …             | …         | …                  | …    |

### 2.6. Mejoras técnicas al script

Sobre el código actual:

- Cambiar `clear all` por `clear` (más rápido y suficiente).
- Cambiar el nombre `B_mat` por `Bu` y reservar `B` para el coeficiente viscoso, o renombrar el coeficiente viscoso a `b` minúscula. El choque de nombres es confuso.
- Encapsular la construcción del modelo en una función `function sys = modelo_bici(params)` para poder llamarla con distintos parámetros.
- Agregar guardado automático de figuras y de variables en `.mat`.
- Incluir el header del archivo con autor, fecha, versión, descripción y dependencias.

**Preguntas guía:**

- ¿Si entrego este código a otra persona y ejecuta `Modelado_V2`, sale corriendo sin pedir nada manual?
- ¿Si quiero cambiar la masa, tengo que tocar un solo lugar o muchos?
- ¿Hay nombres de variables que se solapan o confunden?

---

## 3. Conexión con el control adaptativo (entregable conceptual)

Esta sección es la bisagra hacia la siguiente etapa del PID y muestra que el modelo del becado **es útil**. No requiere implementar el controlador, solo dejar planteado por qué y cómo:

### 3.1. Justificar la necesidad de adaptación

Mostrar con dos o tres simulaciones que un controlador con ganancias fijas (por ejemplo un PI básico sobre la corriente) no funciona igual de bien para θ = −5° que para θ = +5°. Bastan dos figuras y un párrafo de comentario.

**Preguntas guía:**

- ¿Mi simulación muestra que un PI fijo funciona en plano pero falla (oscila, se satura, queda lento) en pendiente? Si todo funciona igual de bien, no hay razón para adaptar.
- ¿Qué métrica uso para decir "funciona peor"? (Tiempo de establecimiento, sobrepico, error en régimen permanente, energía consumida.)

**Ejemplo ilustrativo — qué se espera ver:**

> Con un PI sintonizado para θ = 0° (Kp = 0.5, Ki = 2):
>
> - En θ = 0°: tiempo de establecimiento ≈ 1.5 s, sobrepico < 5 %.
> - En θ = +5°: tiempo de establecimiento ≈ 4 s, error en régimen del 8 % (saturación de la entrada).
> - En θ = −5°: sobrepico del 25 %, oscilaciones (sistema cerca de la inestabilidad).
>
> Conclusión: las mismas ganancias no sirven en los tres escenarios → necesidad de adaptar.

### 3.2. Plantear el esquema adaptativo a futuro

Describir en una página, sin implementarlo:

- **Variable medida para adaptar:** θ (pendiente, vía IMU).
- **Estructura propuesta:** Gain Scheduling sobre las ganancias del controlador en función de θ. Mencionar como alternativa MRAC (Model Reference Adaptive Control) ya que el PID tiene como bibliografía disponible *System Identification and Adaptive Control* (Yiannnis et al.).
- **Identificación de parámetros:** una vez disponible el banco, los parámetros R, L, Kt, Ke se identificarán experimentalmente. El modelo del avance sirve de estructura.

**Preguntas guía:**

- ¿Por qué Gain Scheduling y no otra estrategia? (Justificar en una frase: "porque la pendiente es medible y conocida, y los parámetros varían lentamente con ella".)
- ¿Cuántos puntos de operación voy a programar? ¿Cómo interpolo entre ellos?

### 3.3. Identificar los parámetros que requerirán medición experimental

Hacer una tabla con:

| Parámetro | Valor inicial usado | Cómo se mide en el banco | Etapa del PID |
|-----------|--------------------|--------------------------|---------------|
| R | 0.5 Ω | Multímetro entre fases | 2 |
| L | 0.01 H | LCR / respuesta al escalón | 2 |
| Kt | 1.2 N·m/A | Curva torque vs. corriente con freno calibrado | 2 |
| Ke | 1.2 V·s/rad | Tensión generada vs. ω (ensayo en vacío) | 2 |
| B | 2.5 N·s/m | Coast-down test (ver Oman & Morchin cap. 7) | 2/3 |

Esto cierra el ciclo: muestra que el modelo del becado **anticipa** los ensayos del banco de pruebas y guía qué hay que medir.

**Pregunta guía:**

- ¿Cada parámetro de mi modelo tiene un procedimiento experimental concreto para medirlo en el banco? Si no lo tiene, el modelo no es identificable.

---

## 4. Verificación y consistencia

Antes de cerrar, ejecutar las verificaciones siguientes:

- **Dimensional:** chequear que cada término de cada ecuación tenga unidades consistentes (las matrices A y B_u/B_d tienen unidades; conviene escribirlas en el documento). Una matriz de estado es dimensionalmente *no homogénea* y eso confunde — escribir las unidades de cada elemento.
- **Coherencia:** que los autovalores tengan parte real negativa (estabilidad). Si dan inestables, hay un error de signo.
- **Energía:** la suma de energías debe cerrar dentro del 1–2 % en simulación. Si no cierra, hay un error en la convención de signos del frenado.
- **Comparación cualitativa con literatura:** las velocidades de equilibrio en bajada y los porcentajes de energía recuperable deben caer en el rango de la Tabla 4.2 de Oman & Morchin.

**Preguntas guía finales:**

- ¿Pasé los cuatro chequeos (dimensional, coherencia, energía, literatura)?
- Si un revisor externo (que no conoce el trabajo) me pide demostrar que el modelo no tiene errores de signo, ¿qué le muestro en 30 segundos?
- ¿Qué pasa si me equivoqué en algún signo y nadie lo detecta? (Pista: el control adaptativo que se diseñe sobre este modelo va a fallar en el banco real.)

**Ejemplo ilustrativo — chequeo dimensional rápido:**

> En la ecuación `m·dv/dt + B·v = (Kt/r)·i`, las unidades deben dar Newton:
>
> - `m·dv/dt`: kg · m/s² = N ✓
> - `B·v`: (N·s/m) · (m/s) = N ✓
> - `(Kt/r)·i`: ((N·m/A)/m) · A = N ✓
>
> Las tres dan N. Si en alguna parte aparece, por ejemplo, `Kt·i` (sin el /r), las unidades dan N·m, no N — es torque, no fuerza, y hay que dividir por r.

---

## 5. Cronograma sugerido para el cierre

Asumiendo dedicación de 10 hs/semana (carga horaria del becario BINID):

| Semana | Tareas |
|--------|--------|
| 1 | §1.1, §1.2, §1.5 (correcciones del modelo en papel). |
| 2 | §1.3, §1.4 (correcciones en `Modelado_V2.m`) y §2.1 (parámetros con fuente). |
| 3 | §2.2, §2.3 (simulaciones y figuras). |
| 4 | §2.4 (análisis energético), §2.5 (sensibilidad). |
| 5 | §3 (conexión con control adaptativo) y §4 (verificación). |
| 6 | Redacción del informe final (ver guía 2). |
| 7 | Revisión con el director (Ing. Katzenelson) y co-director (Ing. Maxit). |
| 8 | Versión final y entrega. |

**Preguntas guía de seguimiento (al final de cada semana):**

- ¿Completé todo lo de la semana? Si no, ¿qué bloqueó el avance?
- ¿Lo que hice esta semana puedo defenderlo si me preguntan? (Si la respuesta es "lo hice porque sí", todavía no lo entendí.)
- ¿La próxima semana arranca con una tarea clara o con "ver qué hago"?

---

## 6. Entregables finales del avance

Al cerrar, el becado debe entregar:

1. **Informe técnico** en formato paper IEEE (ver guía 2).
2. **`Modelado_V2.m`** — script principal del modelo.
3. **`Analisis_energia.m`** — script anexo de balance energético.
4. **`Sensibilidad.m`** — script anexo de análisis paramétrico.
5. **Carpeta `figuras/`** con todas las figuras generadas en `.png` (300 dpi) y `.fig`.
6. **Tabla de parámetros** con fuentes (en formato Excel o tabla embebida en el informe).
7. **README.md** del repositorio con instrucciones de ejecución.

Todo el material, en un repositorio git (o como mínimo una carpeta versionada con sufijos `_v1`, `_v2`, etc.), entregado al director del proyecto.

**Pregunta guía final — el test de la silla vacía:**

> Imaginá que el director te dice: "no voy a estar disponible la próxima semana, dejame todo lo que hiciste como para que otro investigador lo retome donde vos lo dejaste". ¿Tu entrega pasa esa prueba? Si la respuesta es no, el avance todavía está abierto.
