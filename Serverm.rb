#!/usr/bin/env ruby -w
 require "socket"

class Server
    def initialize(port,ip)
      @server = TCPServer.open(ip,port)
      @connections = Hash.new
      @clients = Hash.new
      @connections[:server] = @server
      @connections[:clients] = @clients
      @data = Hash.new
      @flag = Hash.new
      @time_exp = Hash.new
      @time_req = Hash.new
      @cas_unica =  Hash.new
      run
    end

  def run
    loop{
      Thread.start(@server.accept) do | client |
        request = client.gets.chomp
        sep = request.split(" ")
        if sep.length == 6 && sep[0] == "cas"
          key = sep[1].scan(/\w+/)
          flag_i = sep[2].scan(/\w+/)
          time_expirado = sep[3].scan(/\w+/)
          time_expirado_i = time_expirado[0].to_i
          max_byte = sep[4].scan(/\w+/)
          max_byte_i = max_byte[0].to_i
          cas_unica_cm = sep[5].scan(/\w+/)
          cas_unica_cm_i = cas_unica_cm[0].to_i
          tiempo_ahora = Time.now.to_i
            if @data.has_key?(key)
              client.puts  @cas_unica
              cas_aux = @cas_unica[key]

              if cas_unica_cm_i == cas_aux
                resp = client.gets.chomp
                datablock = resp.scan(/\w+/)
                datablock_s = datablock[0].to_s
                if datablock_s.length > max_byte_i
                  aux = ""
                  largo_in = max_byte_i
                  chars = datablock_s.chars
                  chars.each do |char|
                    if largo_in > 0
                    aux << char
                    largo_in = largo_in - 1
                    end
                  end
                  datablock = aux
                end
                @data[key] = datablock
                @time_exp[key] = time_expirado_i
                @time_req[key] = tiempo_ahora
                @flag[key] =  flag_i
                client.puts "STORED: \r\n "
              end
            else
              client.puts "CLIENT_ERROR [key doesn't exists]\r\n"
            end
        end
        if sep.length == 5
          comando = sep[0]
          case comando
          when "<set>"
            key = sep[1].scan(/\w+/)
            flag_i = sep[2].scan(/\w+/)
            max_byte = sep[4].scan(/\w+/)
            max_byte_i = max_byte[0].to_i
            time_expirado = sep[3].scan(/\w+/)
            time_expirado_i = time_expirado[0].to_i
            tiempo_ahora = Time.now.to_i
            resp = client.gets.chomp
            datablock = resp.scan(/\w+/)
            datablock_s = datablock[0].to_s
            if datablock_s.length > max_byte_i
              aux = ""
              largo_in = max_byte_i
              chars = datablock_s.chars
              chars.each do |char|
                if largo_in > 0
                aux << char
                largo_in = largo_in - 1
                end
              end
              datablock = aux
            end
              if @data.has_key?(key)
                client.puts "CLIENT_ERROR [key already exists]\r\n"
                Thread.kill self
              end
              client.puts "flag de 0: #{flag_i} "
              banderita = flag_i[0].to_i
              client.puts "banderita es: #{banderita}"
              if banderita < 0 || banderita > 255
                  client.puts "CLIENT_ERROR [flag out of range]\r\n"
                  Thread.kill self
              end
            @flag[key] =  flag_i
            @data[key] = datablock
            @time_exp[key] = time_expirado_i
            @time_req[key] = tiempo_ahora
            client.puts "STORED: \r\n "
          when "<add>"
            #separo la entrada en datos utiles
            key = sep[1].scan(/\w+/)
            flag_i = sep[2].scan(/\w+/)
            max_byte = sep[4].scan(/\w+/)
            max_byte_i = max_byte[0].to_i
            time_expirado = sep[3].scan(/\w+/)
            time_expirado_i = time_expirado[0].to_i
            tiempo_ahora = Time.now.to_i
            client.puts "MANDAME EL DATA BLOCK : "
            resp = client.gets.chomp
            datablock = resp.scan(/\w+/)
            datablock_s = datablock[0].to_s
            #controlo que flag entre en el rango
            banderita = flag_i[0].to_i
            if banderita < 0 || banderita > 255
                client.puts "CLIENT_ERROR [flag out of range]\r\n"
                Thread.kill self
            end
            #verifico que lo ingresado no pase el maximo de bytes puesto en la entrada ademas de que la clave exista
            if @data.has_key?(key)
              if @data[key] == nil
                if datablock_s.length > max_byte_i
                  aux = ""
                  largo_in = max_byte_i
                  chars = datablock_s.chars
                  chars.each do |char|
                    if largo_in > 0
                    aux << char
                    largo_in = largo_in - 1
                    end
                  end
                  datablock = aux
                end
                # almaceno los datos necesarios
                @flag[key] =  flag_i
                @data[key] = datablock
                @time_exp[key] = time_expirado_i
                @time_req[key] = tiempo_ahora
                client.puts "STORED: \r\n "
                client.puts @data
              else client.puts "NOT_STORED\r\n"
              end
            else client.puts "NOT_STORED\r\n"
            end

          when "<replace>"
              key = sep[1].scan(/\w+/)
              flag_i = sep[2].scan(/\w+/)
              max_byte = sep[4].scan(/\w+/)
              max_byte_i = max_byte[0].to_i
              time_expirado = sep[3].scan(/\w+/)
              time_expirado_i = time_expirado[0].to_i
              tiempo_ahora = Time.now.to_i
              resp = client.gets.chomp
              datablock = resp.scan(/\w+/)
              datablock_s = datablock[0].to_s
              if datablock_s.length > max_byte_i
                aux = ""
                largo_in = max_byte_i
                chars = datablock_s.chars
                chars.each do |char|
                  if largo_in > 0
                  aux << char
                  largo_in = largo_in - 1
                  end
                end
                datablock = aux
              end
              #controlo que flag entre en el rango
              banderita = flag_i[0].to_i
              if banderita < 0 || banderita > 255
                  client.puts "CLIENT_ERROR [flag out of range]\r\n"
                  Thread.kill self
              end
            if @data.has_key?(key)
              if @data[key] != nil
                @flag[key] =  flag_i
                @data[key] = datablock
                @time_exp[key] = time_expirado_i
                @time_req[key] = tiempo_ahora
                client.puts "STORED: \r\n "
              else client.puts "NOT_STORED\r\n"
              end
            else
              client.puts "NOT_STORED\r\n"
            end
          when "<append>"
                key = sep[1].scan(/\w+/)
                max_byte = sep[4].scan(/\w+/)
                max_byte_i = max_byte[0].to_i
                resp = client.gets.chomp
                datablock = resp.scan(/\w+/)
                datablock_s = datablock[0].to_s
                if datablock_s.length > max_byte_i
                  aux = ""
                  largo_in = max_byte_i
                  chars = datablock_s.chars
                  chars.each do |char|
                    if largo_in > 0
                    aux << char
                    largo_in = largo_in - 1
                    end
                  end
                  datablock = aux
                end
              if @data.has_key?(key)
                if @data[key] != nil
                  @data[key] = datablock
                  client.puts "STORED: \r\n "
                else client.puts "NOT_STORED\r\n"
                end
              else client.puts "NOT_STORED\r\n"
              end
          when "<prepend>"
            key = sep[1].scan(/\w+/)
            max_byte = sep[4].scan(/\w+/)
            max_byte_i = max_byte[0].to_i
            resp = client.gets.chomp
            datablock = resp.scan(/\w+/)
            datablock_s = datablock[0].to_s
            if datablock_s.length > max_byte_i
              aux = ""
              largo_in = max_byte_i
              chars = datablock_s.chars
              chars.each do |char|
                if largo_in > 0
                aux << char
                largo_in = largo_in - 1
                end
              end
              datablock = aux
            end
              if @data.has_key?(key)
                if @data[key] == nil
                  @data[key] = datablock
                  client.puts "STORED: \r\n "
                else client.puts "NOT_STORED\r\n"
                end
              else client.puts "NOT_STORED\r\n"
              end
          else
            client.puts "ERROR\r\n"
            Thread.exit self
          end
        end
          if sep.length == 2
          # es un comando retrival, busco por key y devuelvo datos
            if sep[0] == "get"
              key_uno = sep[1].scan(/\w+/)
              if @data.has_key?(key_uno)
                if @time_exp[key_uno] == 0 || Time.now.to_i - @time_req[key_uno].to_i <= @time_exp[key_uno]
                cas_unique = rand(9223372036854775807) #tipo LONG
                client.puts "VALUE: < #{key_uno} > < #{@flag[key_uno]} > < BYTES > < #{cas_unique}> "
                client.puts @data[key_uno]
                #cas_unique_i = cas_unique
                @cas_unica[key_uno] = cas_unique
                client.puts @cas_unica[key_uno]
                else
                client.puts "CLIENT_ERROR <no paso el tiempo de expirado>\r\n"
                client.puts "RESTA: "
                client.puts Time.now.to_i - @time_req[key_uno].to_i
                client.puts "tiempo de expirado del hash: "
                client.puts @time_exp[key_uno]
                Thread.exit self
                end
              else client.puts key_uno
                client.puts "zero"
              end
            end
          end
        if  sep[0] == "gets"
          i = 1
          max_de_key = sep.length
          client.puts max_de_key
          until i > max_de_key do
            key_out = sep[i].scan(/\w+/)
            if @data.has_key?(key_out)
              cas_unique = rand(9223372036854775807) #tipo LONG
              client.puts "VALUE <#{key_out}> < #{@flag[key_out]} > <BYTES> <#{cas_unique}>"
            else
              client.puts "CLIENT_ERROR <key doesn't exists>\r\n"
            end
            i +=1;
          end
        end
          if sep.length!=6 && sep.length!=5 && sep[0]!= "gets"
            client.puts "CLIENT_ERROR <error>\r\n"
            Thread.exit self
          end
      end

    }.join
  end


end
 Server.new(3000, "localhost") # (ip, port) in each machine "localhost" = 127.0.0.1
