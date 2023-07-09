
    # Recorrer
    #lista_cursos = ["Curso1", "Curso2", "Curso3", "Curso4", "Curso5", "Curso6"]
    #IO.inspect(datos_alma)
#------------------------------------------------------------------------
defmodule FileReader do
  @lista_cursos ["Comunicacion", "Estructuras Discretas I", "Introduccion a la Vida Universitaria", "Matematica I","Metodologia del Estudio","Programacion de Video Juegos", "Apreciacion Musical","Ciencia de la Computacion I"]
  
  def read_and_print_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        IO.puts(content)
      {:error, reason} ->
        IO.puts("Error al leer el txt #{reason}")
    end
  end

  def read_numbers(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  
  
  #----------------------- avance curricular----------------
  def read_and_process_file(file_path) do
    datos_alma = []

    datos_alma = File.stream!(file_path) |> Stream.map(&String.trim/1) |>Enum.into([])
    
  
    #longitud del array datos_alma
    longitud = length(datos_alma)

    #Indices para los nombres de los cursos
    indices = :lists.seq(1, longitud-5, 6) #[1, 7, 13, 19, 25, 31]
    lista_nombresCursos = Enum.map(indices, &(&1))

    #indices para los creditos
    indicesCred = :lists.seq(3,longitud-3,6) #[3,9,15,21,27,33]
    lista_indicesCred = Enum.map(indicesCred, &(&1))

    #indices para las veces cursadas
    indicesVecesCursadas = :lists.seq(4,longitud-2,6) #[4,10,16,22,28,34]
    lista_indicesVecesCursadas = Enum.map(indicesVecesCursadas, &(&1))

    #indices para los promedios
    indicesPromedios = :lists.seq(5,longitud-1,6) #[5,11,17,23,29,35]
    lista_indicesPromedios = Enum.map(indicesPromedios, &(&1))

    IO.puts("Longitud array: #{longitud}")
    
    Enum.each(Enum.with_index(datos_alma), fn {value, index} ->
        #nombre del curso
        if index in lista_nombresCursos do
          #valor = String.to_integer(Enum.at(datos_alma, index))
          
          #elemento = Enum.at(@lista_cursos, valor)
          IO.puts(value)

        else
          if index in lista_indicesCred do
            IO.puts("Creditos: #{value}")
          else
            if index in lista_indicesVecesCursadas do
              IO.puts("Veces cursado: #{value}")
            else
              if index in lista_indicesPromedios  do
                IO.puts("Promedio: #{value}")
              else
                IO.puts(value)
              end
            end
          end
        end
    end)
  end


#--------------------------------- CursosEq --------------------------
  def read_and_process_file_cursos(file_path) do
    datos_alma = []

    # ver enq ue semestre esta el alumno--------------
    datos_alma = File.stream!(file_path) |> Stream.map(&String.trim/1) |>Enum.into([])
    datos_datos = File.stream!("Datos.txt") |> Stream.map(&String.trim/1) |>Enum.into([])

    
    semestre=Enum.at(datos_datos,1)
    semestreActual = String.to_integer(String.at(semestre,String.length(semestre)-1))
    IO.puts(semestreActual)
    IO.puts("-------Semestre arriba----")

    indices_Semestres_actuales = :lists.seq(semestreActual, rem(semestreActual+3,11), 1)
    #---------------------seesmtre del alumno-FIN-------------


    #----------filtrar cursos llevado---------
    
    datos_CursosLlevados = File.stream!("AvanceCurricular.txt") |> Stream.map(&String.trim/1) |>Enum.into([])

    #------indice
    longitud_Cursos = length(datos_CursosLlevados)
     #indices para los promedios
    indicesPromedios = :lists.seq(5,longitud_Cursos-1,6) #[5,11,17,23,29,35]
    lista_indicesPromedios = Enum.map(indicesPromedios, &(&1))
    
    #----
    lista_CursosAprobados = Enum.reduce(Enum.with_index(datos_CursosLlevados), [], fn {value, index}, lista_Acumulada ->
  if index in lista_indicesPromedios && String.to_float(value) >= 11.5 do
    [Enum.at(datos_CursosLlevados, index-4) |lista_Acumulada  ]
  else
    lista_Acumulada
  end
end)
    #IO.inspect(lista_CursosAprobados)
    #-----------filtrar cursos llevados-FIN------------------



    
    #longitud del array datos_alma
    longitud = length(datos_alma)

    #Indices para los nombres de los cursos
    indices = :lists.seq(1, longitud-3, 4) 
    lista_nombresCursos = Enum.map(indices, &(&1))

    #indices para los creditos
    indicesCred = :lists.seq(2,longitud-2,4) 
    lista_indicesCred = Enum.map(indicesCred, &(&1))

    #indices para los semestres
    indicesSemestre = :lists.seq(0,longitud-4,4) 
    lista_indicesSemestre = Enum.map(indicesSemestre, &(&1))

    #indices para los Pre-requisitos
    indicesPreRequisitos = :lists.seq(3,longitud-1,4) 
    lista_indicesPreRequisitos = Enum.map(indicesPreRequisitos, &(&1))

    #-------------recorrer el CursoEq
    Enum.each(Enum.with_index(datos_alma), fn {value, index} ->
        #nombre del curso
          if not(value in lista_CursosAprobados) && index in lista_nombresCursos && String.to_integer(Enum.at(datos_alma, index-1)) in  indices_Semestres_actuales do
            valor = (Enum.at(datos_alma, index))
            IO.puts(valor)
  
          else
            if not(Enum.at(datos_alma, index+1) in lista_CursosAprobados) && index in lista_indicesSemestre && String.to_integer(Enum.at(datos_alma, index)) in indices_Semestres_actuales do
              IO.puts("Semestre: #{value}")
              
            else
              if not(Enum.at(datos_alma, index-1) in lista_CursosAprobados) && index in lista_indicesCred && String.to_integer(Enum.at(datos_alma, index-2)) in indices_Semestres_actuales do
                IO.puts("Creditos: #{value}")
              else
                if not(Enum.at(datos_alma, index-2) in lista_CursosAprobados) && index in indicesPreRequisitos && String.to_integer(Enum.at(datos_alma, index-3)) in indices_Semestres_actuales do
                  IO.puts("Pre-requisitos: #{value}")
                
                end
              end
            end
          end
        
    end)
  end
end



  
  # def iniciar_sesion do
  #   IO.puts("Ingresar ID Alumno:")
  #   id = IO.gets("") |> String.trim() |> String.to_integer()
  #   case id do
  #     151515 ->
  #       display_menu()
  #   end
  # end


#----------------------NUESTROS MENUS----------------------------
defmodule Menu do
  def iniciar_sesion do
    IO.puts("___PORTAL ACADEMICO___")
    IO.puts("1. Iniciar sesión:")
    IO.puts("2. Salir")
    read_option()
  end

  def read_option do
    input = IO.gets("") |> String.trim() |> String.to_integer()
    case input do
      1 ->
        IO.puts("1. Ingresar ID Alumno:")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        numbers=FileReader.read_numbers("DNI.txt")
        case Enum.member?(numbers, id) do
          true ->
            display_menu()
          false ->
            IO.puts("ID de alumno no válido")
            read_option()
        end
      2 ->
        IO.puts("Adios")
        :ok
      _ ->
        IO.puts("Opción inválida")
        read_option()
    end
  end

  def display_menu do
    IO.puts("\n-----------MENU---------")
    IO.puts("1. Ingresar a los cursos correspondientes")
    IO.puts("2. Ver tus datos")
    IO.puts("3. Notas semestre actual")
    IO.puts("4. Ver avance curricular")
    IO.puts("5. Matricularse")
    IO.puts("6. Cerrar sesión")
    IO.puts("Ingresa opción:")
    leer_opcion()
  end


  def leer_opcion do
    #gets: para leer consola, trim: para eliminar espacios
    input = IO.gets("") |> String.trim() |> String.to_integer()
    case input do
      1 -> 
        IO.puts("\n--------CURSOS--------")
        FileReader.read_and_print_file("Cursos.txt")
        display_menu()

      2 -> 
        IO.puts("\n---------DATOS--------")
        FileReader.read_and_print_file("Datos.txt")
        display_menu()

      3 -> 
        IO.puts("\n-------NOTAS--------")
        FileReader.read_and_print_file("Notas.txt")
        display_menu()

      4 -> 
        IO.puts("\n-------AVANCE CURRICULAR--------")
        FileReader.read_and_process_file("AvanceCurricular.txt")
        display_menu()
      5 -> 
        IO.puts("\n---------MATRICULA-----------")
        FileReader.read_and_process_file_cursos("CursoEq.txt")
        display_menu()
      6 -> 
        IO.puts("Adios")
        :ok

    end
  end
end

Menu.iniciar_sesion()

#_cursos_lista = FileReader.read_cursos("CursoEq.txt")

#Enum.each(cursos_lista, fn(x) -> IO.puts(x) end)
