# Primero Bienvenid@!

# Reglas
```
Regla número 1, acá hay que LEER y prestar atención a lo que hacemos en la pc y lo que nos "dice" la pc con cada mensaje en pantalla, hay que leer TODA la pantalla, parece algo obvio, pero me van a escuchar hasta el hartazgo el decirles "NO LEEN".
Regla número 2, Slack es nuestra herramienta de comunicación con el resto del equipo Flow, es básicamente nuestro puesto de trabajo en la oficina, pero en casa, por eso hay que leer cada mensaje de los distintos canales para estar al tando de lo que pasa con el resto de los equipos.
Regla número 3, acá TODOS podemos mejorar lo existente y aprender, la idea de todos los miembros del equipo es hacer del día a día algo que nos guste y no se sienta un trabajo sino algo que nos guste hacer, hay muchísimas cosas para elegir encargarse y eso hay que aprovecharlo, no porque 
```

## Ingresamos a éste sitio para que te demos la bienvenida al equipo
```
https://meet.jit.si/tecoFlowQaAutomationRoom2
```

## Crear cuenta Slack
```
https://app.slack.com/client/TC3EB5KC7/GN0H6M1M3/
```

# Creamos un usb booteable de endeavourOS para formatear la pc que viene con Ubuntu Linux (utilizamos todos la misma distribución y es muy facil resolver inconvenientes de esa manera)
## Descargar la imagen de ISO del intalador de EndeavourOS (Github direct link or Torrent file)
```
https://endeavouros.com/latest-release/
```

## Guía para crear USB booteable endeavourOS
```
https://endeavouros.com/docs/installation/create-install-media-usb-stick/
```

# Instalación
## Guía de instalación (leer antes de realizarla)
```
https://endeavouros.com/docs/installation/encrypted-installation-for-notebook-laptop/
```

## Una vez iniciado con el instalador de endeavourOS en la pc, es posible acceder desde el navegador incluído en la sesión "live" (previo a la instalación del mismo en la pc) a éste sitio para que nos ayuden a hacerlo otro miembro del equipo
```
https://meet.jit.si/tecoFlowQaAutomationRoom2
```

# Post instalación
## Una vez finalizada la instalación en la pc, y reiniciarla desde el disco duro, abrir una terminal y ejecutar el siguiente comando:
(El signo '$' es el prompt y no se agrega, pero lo incluímos en la documentación para dar a entender que se trata de un comando a ejecutar por terminal)
```
$ mkdir -p ~/script && cd ~/script && curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch-post-install-script-00-get_scripts.sh" && chmod +x ./*.sh
```
Ésto nos crea un directorio "script" en nuestro directorio personal en la pc, y dentro descarga un script que mantengo, el cual nos descarga varios otros scripts para automatizar y agilizar la configuración del sistema 

## Luego, ejecutar los siguientes comandos en orden:
(éstos scripts de instalación nos hacen preguntas las cuales ya nos indican con mayúscula la opción por defecto para cada pregunta, es mejor ejecutarlos con ayuda de alguien del equipo por si surge algún inconveniente)
```
$ ./arch-post-install-script-01-set_basic_config.sh
$ ./arch-post-install-script-02-install_pacman_packages.sh
$ ./arch-post-install-script-03-install_aur_packages.sh
$ ./arch-post-install-script-04-clone_repositories.sh
$ ./arch-post-install-script-05-configure_applications.sh
```
Con ésto ya tendríamos todas las herramientas que utilizamos en el equipo para realizar cualquier tarea e incluso los repositorios ya clonados


# Creación de otras cuentas
## Crear cuenta Gitlab (requiere conexión a la vpn) (Omitir, ya realizado en el script 'arch-post-install-script-04-clone_repositories.sh')
```
http://10.200.172.71/
```
Pedir a un miembro del equipo que nos agregue al grupo de "automation" dentro de gitlab, para poder acceder a todos los repositorios

## Pedir a otro miembro del equipo que nos cree una cuenta en nuestro Jenkins (requiere conexión a la vpn)
```
http://10.200.172.73:8080/
```

## Bitrise
```
Crear cuenta en https://app.bitrise.io/
```

### Solicitar el usuario sea agregado al grupo de Flow de TECO a los siguientes correos o por Microsoft Teams:
```
CMLopez@teco.com.ar
faRodriguez@proveedor.teco.com.ar
```


# Herramientas que utilizamos con el resto del equipo 
```
(algunas como el IDE pueden usar otras, pero al igual que la distribución de linux, si utilizamos todos la misma, es mas fácil arreglar los problemas entre todos)
```
## Código de tests automatizados:
```
Lenguaje: Java (OpenJDK 11)
IDE: Intellij-Idea
Pruebas de stress y performance: Jmeter o wrk
Frontends web: Selenium Webdriver
Frontends mobile: Appium
APIs: Rest-Assured
```

## Ejecución:
```
Ejecución de las pruebas: Maven, con posibilidad de ejecutar con docker
Ejecución desde servidor: Jenkins, con Browserstack para mobile cloud devices
```


# 'Mandamientos' de QA Automation
```
- Los nombres de los métodos tienen que dar a entender qué hacen sólo con el nombre.
- Los nombres de las variables de los locators deben incluir el tipo de elemento en el nombre. (Ej. 'buttonAccept')
- Los nombres de las ramas deben comenzar por feature/ o bugfix/ y resumir el cambio que se va a mergear. (Ej. 'feature/addNewAwesomeFeature')
- El flujo que manejamos todos en el equipo en cuanto a ramas de los repositorios es el siguiente, creamos una rama nueva partiendo de la rama 'develop' actualizada, realizamos los cambios necesarios, hacemos commit y push a esa rama, y desde Gitlab realizamos el merge request, pudiendo hacer que otro miembro del equipo le pegue una mirada, despues, se realiza el merge request desde develop a la rama master según se requiera. 
- Los métodos de tests no deben tener líneas de código que no estén dentro de una page object. (Ej. no usar métodos de clases 'utils' directamente en los tests)
- Los métodos de page objects utilizados en los tests, siempre deben tener un @Step ya que sino no se guardan los logs en los reportes en caso de falla.
- Las descripciones de los steps, deben describir la acción del método y comprensibles para otros equipos. (Mas info en 'automation-wiki' > 'Allure.-Annotations-guide.md')
- Nuestras fuentes de información para resolver problemas son: código/stacktrace/logs > análisis del error > automation-wiki > internet > Resto del equipo
- Los scripts de ejecución del repo 'automation-tools' descargan la rama develop de los tests en un directorio temporal, no sirven para probar cambios en una rama en la que esté trabajando, sin haberla mergeado a develop previamente.
- Nuestras tareas mínimas incluyen ejecución de los tests, fixing de tests, reporte de bugs encontrados, participar en las reuniones de los demás equipos, etc... Pero lo que nos enriquece a nosotros y al equipo de automation, es aportar investigación, posibles mejoras, y aprender del resto de herramientas que utilizamos.
- Somos los dueños y responsables de los tests automatizados y de todo su ecosistema, mejorarlos es aprender, y aprender es valor que adquirimos como equipo y como personas.
- No hay apuro alguno para aprender lo que todavía no sepamos, pero si pasa el tiempo y nos sentimos aburridos con las tareas, es que estamos yendo demasiado lento.
```

# Arch Linux
```
Todo linux tiene un "repositorio" de donde el "administrador de paquetes" descarga los "binarios" para instalarlos en el sistema.

En el caso de Arch, los repositorios son "core/extra/community/multilib", (EndeavourOS, agrega uno propio con algunas cosas extras),

El administrador de paquetes es el comando "pacman" y los binarios, son las aplicaciones que ya fueron compiladas desde el codigo fuente,
por eso no hace falta compilarlas UNO MISMO para instalar desde los repositorios con pacman,
cuando hacemos "$ pacman -S aplicación" está descargando el paquete compilado de la aplicación,
que fue compilado por los desarrolladores de arch desde el codigo fuente de la aplicación y subido a sus repositorios,
y lo instala en el sistema.

Por eso al hacer "$ sudo pacman -Syu",
"-S" es una operación desde los repositorios,
"y" es actualizar los paquetes de los repositorios,
y "u" es actualizar los paquetes instalados en caso de haber nuevas versiones.

Ahora desde AUR la cosa cambia, "Arch User Repository" es un repositorio APARTE, que tiene SCRIPTS de instalación de aplicaciones
que NO ESTAN en los repositorios de Arch oficiales (core/extra/community/multilib),
es mantenido por y para los usuarios de Arch, con lo que los desarrolladores oficiales no meten mano para nada,
cualquiera puede hacerse "mantenedor" de un script de instalación de una aplicación o librería que use,
crear el script, y/o mantenerlo actualizado con los cambios de las versiones que van saliendo para que cualquiera pueda instalar esa aplicacion.
Un ejemplo es, si yo necesito usar Jmeter, y no está en los repos oficiales "core/extra/community/multilib", y si está el script de instalación en AUR porque alguien lo creó,
me clono el repo de ESE SCRIPT dentro del directorio ~/aur/ y puedo instalar jmeter con un simple "$ makepkg -si",
donde "makepkg" compila la aplicación con las instrucciones del script,
"-s" descargar dependencias si hicieran falta para la compilación o ejecución de la aplicación,
y "i" instala la aplicación compilada en el sistema (por eso pide la contraseña de sudo si hiciera falta)

El script que yo hice 'aur_update.sh', lo que hace es, chequear si de todos los repositorios clonados de AUR que se hayan clonado,
hay cambios en el repositorio del paquete que contiene el script de instalación de la aplicación, y de haber cambios, los trae,
ejecuta el comando "$ makepkg -si --noconfirm" para que no pida confirmación, y lo instala directamente,
y continúa con el siguiente directorio de repositorio dentro del directorio '~/aur/' que se haya clonado

Entonces, si quiero buscar una aplicación para nuestro linux en arch linux o derivadas como endeavourOS, tenemos los siguiente comandos:

Buscar el paquete en los repositorios oficiales (core/extra/community/multilib):
$ pacman -Ss paquete

Instalar el paquete
$ sudo pacman -S paquete

Si la aplicación no existe en los repositorios oficiales lo buscamos en AUR:

- Accedemos desde el navegador en 'https://aur.archlinux.org/'
- Buscamos el nombre de la aplicación deseada
- Podemos verificar qué hace el script de instalación del paquete (para mayor seguridad) en el link a la derecha 'Package Actions > View PKGBUILD'
- Accedemos al directorio aur de nuestro directorio personal:
$ cd ~/aur
- Copiamos la dirección de 'Git Clone URL' de la aplicación
- Clonamos el repositorio del paquete en un subdirectorio:
$ git clone https://aur.archlinux.org/<aplicación>.git
- Accedemos al subdirectorio de instalación del paquete:
$ cd <aplicación>
- Compilamos e instalamos la aplicación con el script PKGBUILD del repositorio, donde los parámetros '-sic' significan:
's' > instalar dependencias si hicieran falta
'i' > instalar el paquete una vez compilada/descargada
'c' > realizar una limpieza de los archivos temporales luego de la compilación del paquete
$ makepkg -sic
```