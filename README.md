# Introduccion

Este proyecto consta de realizar un servidor Memcached usando protocolo TCP/IP. El servidor sera capaz de establecer conexiones con varios clientes como asi responder sus debidos requisitos.
Para este proyecto los comandos realizados son:
**Retrieval commands:**
get
gets

**Storage commands:**
set
add
replace
append
prepend
cas


### Pre-requisitos 📋
 
  Para poder usar dicho servidor sera necesario  descagar y ejecutar en terminal (cmd en caso de usar windows), el archivo Serverm.rb. Luego para poder comunicarse como cliente al servido previamente establecido es necesario conectarse al puerto por el cual el servidor estara trabajando que es el puerto 3000.
  Como se ve en los siguientes ejemplos:

```
ruby Documents/Memcached/Serverm.rb 
```
```
telnet localhost 3000
```

## Ejecutando las pruebas ⚙️

Al momento de utilizar este servidor,el cliente debera enviar comandos de la siguiente forma:  < command name> < key>  < flags>  < exptime>  < bytes> o en caso de usar el comando cas debera ser asi: cas < key>  < flags>  < exptime>  < bytes> < cas unique> **COMANDOS para guardar informacion**
get < key> o get < key1 key2 ...  keyn>  **Comandos de recuperacion**
* Para usar comandos sera necesario que haya entre simbolos < cm> < key> un espacio y que dentro de los simbolos este la palabra sin espacios
Una vez haya una comunicacion entre el cliente y el servidor, este mismo dara una respuesta ya sea dando el dato pedido, avisando que se guardo la informacion que corresponde o indicando un error. Una vez realizada la peticion para volver a realizar un nuevo pedido sera necesario volver a conectarse al servidor. A modo de ejemplo la comunicacion sera asi: 
```
<set> <clave> <123> <0> <8> 
DATO 
STORED
```
Como se ve en el ejemplo hay una comunicacion establecida cliente/servidor donde el cliente envia una solicitud(en este caso usa el comando set) el servidor recibe dicho comando y espera que envie el dato, si guardo el dato responde STORED, en caso de ocurrir algun error la respuesta seria ERROR 


## Construido con 

Este proyecto fue construido con lenguaje Ruby utilizando el IDE ATOM


## Wiki 📖

Mas informacion sobre Memcached: https://github.com/memcached/memcached/blob/master/doc/protocol.txt
