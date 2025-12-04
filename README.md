## Guía de instalación y compilación desde cero en MSYS2 MinGW (Windows)

### 1. Instalar MSYS2

- Descarga e instala MSYS2 desde [https://www.msys2.org/](https://www.msys2.org/).
- Abre la terminal **MSYS2 MinGW 64-bit** (o 32-bit si tu sistema es de 32 bits).

### 2. Actualizar el entorno y el gestor de paquetes

```bash
pacman -Syu
# Cierra la terminal si te lo pide y vuelve a abrir MSYS2 MinGW 64-bit
pacman -Syu
```

### 3. Instalar todas las herramientas y librerías necesarias

```bash
pacman -S --needed base-devel \
	mingw-w64-x86_64-toolchain \
	mingw-w64-x86_64-pkg-config \
	mingw-w64-x86_64-SDL2 \
	mingw-w64-x86_64-SDL2_image \
	mingw-w64-x86_64-libpng \
	mingw-w64-x86_64-libjpeg-turbo \
	mingw-w64-x86_64-libogg \
	mingw-w64-x86_64-libvorbis
```

> Si quieres soporte para MT-32/FluidSynth (audio especial), instala también:

```bash
pacman -S mingw-w64-x86_64-munt mingw-w64-x86_64-fluidsynth
```

### 4. Compilar el proyecto

Desde la raíz del proyecto, ejecuta:

```bash
./configure --prefix=/mingw64
make -j$(nproc)
```

> Si existe el script `./tools/build_mingw.sh`, puedes usarlo para automatizar el proceso.

### 5. Colocar los datos del juego

- Copia los archivos de datos originales en la carpeta `bin/data/` (por ejemplo, `ATRE.PAK`, etc.).
- Asegúrate de tener el archivo de configuración `opendune.ini` en `bin/`.

### 6. Ejecutar el juego

```bash
cd bin
./opendune.exe
```

---

**Descripción técnica del contenido del repositorio**

- Este `README` contiene una guía detallada (orientada a desarrolladores) acerca de qué contiene el repositorio y qué responsabilidad tiene cada carpeta y archivo importante. Está pensado como referencia para navegación y análisis del código, no incluye instrucciones de instalación.

- Agregar carpeta bin, dentro de ella agregar una llamada data y ahi pegar los archivos del juego, en esa mismas carpeta estara el .exe ejecutable para iniciar el juego

**Carpetas y archivos raíz (qué hacen)**

- `src/` — Código fuente del motor: contiene la lógica del juego, los subsistemas (gráficos, audio, entrada), utilidades y módulos por responsabilidad. Dentro de `src` hay tanto archivos monolíticos (`*.c`, `*.h`) como subdirectorios especializados donde viven implementaciones y adaptadores.

- `include/` — Cabeceras compartidas y tipos: define tipos comunes, macros y utilidades que son referenciadas desde varios módulos (`types.h`, `multichar.h`). Es el sitio a revisar cuando buscas definiciones de estructuras usadas a nivel global.

- `bin/` — Recursos de distribución: ejemplos de configuración (`opendune.ini.sample`) y archivos de datos auxiliares. No contienen código, pero sirven como referencia para formatos y valores por defecto.

- `bundle/` — Archivos para empaquetado: copias de licencias, README y ejemplos que acompañan paquetes listos para distribución.

- `projects/` — Proyectos de Visual Studio y herramientas Windows: contiene soluciones y proyectos para compilar con MSVC en distintas versiones; útil para desarrolladores Windows.

- `objs/` — Carpetas con artefactos de compilación: puede contener objetos y builds parciales. No modificar manualmente.

- `tools/` — Scripts y utilidades de desarrollo: scripts de extracción/conversión (`extract*.py` y `build_mingw.sh`) y utilidades para preparar assets o builds.

- `os/` — Código específico por plataforma: adaptadores para Win32, macOS y otros, y código que encapsula diferencias entre sistemas operativos.

- Otros archivos raíz visibles (`Makefile*`, `configure`, `Doxyfile`, `CONTRIBUTING.md`, `COPYING`): metadatos del build, configuración y documentación de proyecto.

**`src/` — descripción por subsistema y por archivo relevante**

Nota: la carpeta `src/` contiene numerosos archivos. Aquí se describen los subsistemas y los archivos más relevantes, con una breve explicación de la responsabilidad de cada uno.

- `opendune.c` — Punto de entrada del programa. Inicializa subsistemas (configuración, video/audio, entrada), parsea parámetros, entra en el bucle principal del juego y despacha eventos. Es el mejor lugar para comenzar a entender el flujo global.

- `load.c` / `load.h` — Funciones de carga de recursos en tiempo de ejecución: sprites, tiles, mapas y datos de escenarios. Implementa formatos de fichero propios y rutinas de inicialización de recursos.

- `save.c` / `save.h` — Persiste el estado de la partida (guardado). Incluye serialización de unidades/estructuras/mapa y lectura inversa.

- `saveload/` — Submódulo que agrupa utilidades y formatos relativos al guardado y carga de partidas; ofrece formatos empaquetados y control de versiones de saves.

- `map.c` / `map.h` — Representación y manipulación de mapas: estructuras de tiles, consultas de colisión/ocupación, lectura/escritura de mapas y utilidades de pathfinding o acceso a vecinos (si están implementadas aquí o delegadas a otro módulo).

- `tile.c` / `tile.h` — Representación de tiles individuales, índices a sprites, propiedades de terreno (costes, colisiones) y mapas de atributos por tile.

- `unit.c` / `unit.h` — Lógica de unidades móviles: definición de tipos de unidades, estados (idle, move, attack), órdenes, actualizaciones por tick, salud y efectos.

- `structure.c` / `structure.h` — Lógica de edificios/estructuras: construcción, producción, salud, interacción con unidades y tile occupation.

- `object.c` / `object.h` — Representación genérica de objetos en el mundo (items, projectiles, recursos). Suele ser la abstracción padre para unidades y estructuras.

- `team.c` / `team.h` — Gestión de equipos/jugadores: propiedades del equipo, diplomacia/alianzas, colores, control y asignación de unidades.

- `house.c` / `house.h` — Facciones o casas del juego: datos que definen facciones (costos, sprites por unidad, comportamiento por facción).

- `map` / `scenario.c` / `scenario.h` — Lógica de escenarios: condiciones de victoria, inicialización de mapas con estados predefinidos, triggers y sucesos de escenario.

- `sprites.c` / `sprites.h` — Carga y gestión de conjuntos de sprites, animaciones y atlas. Se encarga de traducir índices de sprite a superficies/rects para el renderer.

- `gfx.c` / `gfx.h` — Abstracción y utilidades gráficas: inicialización del sistema de render (backend), funciones de dibujo de primitivas y composición de capas (tilemap, entities, HUD).

- `video/` — Backend(s) de vídeo / adaptadores: implementaciones dependientes de la librería gráfica usada (p. ej. SDL). Aquí puede estar el code que crea ventanas, cambia modos de pantalla y presenta buffers.

- `audio/` y `codec/` — Motor de audio y decodificación: reproducción de efectos y música, manejo de prioridades de canales, mezcla y decodificación de formatos (si hay soporte de codecs propios o integraciones con bibliotecas externas).

- `input/` — Abstracciones de entrada: traducción de eventos OS (teclado, ratón, joystick) a comandos del juego, mapeo configurable y tratamiento de eventos continuos (hold) o pulsaciones.

- `gui/` — Implementación de la interfaz: menús, HUD, popups y widgets reutilizables. Contiene renderizado de texto, botones y lógica de navegación de menús.

- `ini.c`, `inifile.c`, `ini.h`, `inifile.h` — Funciones y utilidades para parsear archivos INI y configuración: lectura segura, escritura y defaults. Usado para opciones del usuario, remapeo y parámetros globales.

- `file.c` / `file.h` — Utilidades de I/O: envoltorios para lectura/escritura de ficheros binarios, manejo de paths relativos a recursos y abstracciones para acceder a paquetes/bundles.

- `tools.c` / `tools.h` — Funciones utilitarias varias: logging, manipulación de cadenas, conversión de formatos y utilidades que no encajan en otros subsistemas.

- `string.c` / `string.h` — Implementaciones de utilidades de cadena (posiblemente helpers para multibyte, formateo o compatibilidad entre plataformas).

- `timer.c` / `timer.h` — Control de tiempo y ticks del motor: funciones para medir delta time, controlar el loop principal a una frecuencia deseada y temporizadores por evento.

- `wsa.c` / `wsa.h` — (Probablemente) utilidades relacionadas con el subsistema de red o con adaptaciones Windows Sockets/compatibilidad; revisar implementación para confirmar su uso.

- `rev.c` / ` rev.h`` — Puede almacenar revisión/versión del motor o utilidades de versionado (hay un  `rev.c.in` en la raíz). Revisa internals para confirmar cómo se expone la versión.

- `cutscene.c` / `cutscene.h` y `animation.c` / `animation.h` — Control de cinemáticas y animaciones por trama: reproducen secuencias de eventos predefinidos en escenarios o transiciones.

- `explosion.c` / `explosion.h` — Efectos de explosión y su lógica (daño, animación, efecto en el mundo).

- `file.c`, `load.c` y `save.c` trabajan juntos para serializar recursos y datos de partida. `inifile.c` gestiona opciones/config por INI.

- `pool/` — Utilería para pools de objetos (reutilización de estructuras en lugar de malloc/free frecuente). Revisa para ver patrones de rendimiento y gestión de memoria.

- `table/` — Tablas de datos estáticas o runtime que representan parámetros de juego (costos, stats, tasas). Importante para equilibrado y lógica de cálculo.

- `script/` — Motor o cargador de scripts para eventos de escenario y comportamiento que se definen externamente (si está presente, revisa cómo se integran los scripts con la lógica core).

- `crashlog/` — Módulo de captura y persistencia de errores/fallos (trazas, dumps). Útil para depuración post-mortem.
