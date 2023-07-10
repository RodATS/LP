
    
#------------------------------------------------------------------------
defmodule FileReader do
  

  #----------para leer los txt normales------------
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

#------------------END ---- Avance Curricular ------------------------------------

#------------- colocarle un ID a los cursos para escoger la matricula
def identificacion_Cursos(cursos_EnOrden) do
  # cursos = ["Programacion de videojuegos", "2", "Matematica", "3"]
  
 # cursos_EnOrden = Enum.reverse(cursos)
   Enum.each(Enum.with_index(cursos_EnOrden), fn {value, index} ->
    if rem(index,2) == 0 do
      IO.puts("id: #{div(index,2)} - : #{value}")
    else
      IO.puts("Creditos: #{value}")
    end
    
  end)
end
#----------------END--colocar ID


#----------------------Agregar cursos a matricula---------------
def matricula(cursos,matricula_actual \\ [], contador \\ 0) do

IO.puts("----------PROCESO DE MATRICULA------------")
# cursos = ["Programacion de videojuegos", "2", "Matematica", "3"]
IO.puts("\e[H\e[2J")
IO.puts("Creditos disponibles: #{22-contador}  ----")
IO.puts("Cursos agregados por el momento")
IO.inspect(Enum.reverse(matricula_actual))

IO.puts("----------------------------------------------------")
IO.puts("Cursos disponibles")
identificacion_Cursos(cursos)

IO.puts("----------------------------------------------------")
IO.puts("Ingresar el numero del curso que se quiere agregar (-1 para finalizar el proceso:")

input = IO.gets("") |> String.trim() |> String.to_integer()
if(input < (length(cursos))/2) do
creditoSeleccionado=String.to_integer(Enum.at(cursos,input*2+1))
  if(input==-1) do
    IO.puts("Finalizando matricula")
    IO.puts("-----Los cursos seleccionados son:-----")
    IO.inspect(Enum.reverse(matricula_actual))
  else
    if(22-contador - creditoSeleccionado >= 0) do
      cursoSeleccionado=Enum.at(cursos,input*2) 
      delete1=Enum.at(cursos,input*2)
      delete2=input*2
      cursos=List.delete(cursos,delete1)
      cursos=List.delete_at(cursos,delete2)
      matricula(cursos,[cursoSeleccionado|matricula_actual],contador+creditoSeleccionado)
    else
      IO.puts("Se han agotado los creditos disponibles")
      IO.puts("----Los cursos seleccionados son:----")
      IO.inspect(Enum.reverse(matricula_actual))
      #nou, creoq ue defrente imprima tus cursos son: y te mande al menu
    end
  end
else
IO.puts("Esa no es una opcion valida")
matricula(cursos,matricula_actual,contador)
end
end
#----------------------END--Matricula-----------------------------

#--------------------------------- CursosEq --------------------------
  def read_and_process_file_cursos(file_path) do
    datos_alma = []

    # ver enq ue semestre esta el alumno--------------
    datos_alma = File.stream!(file_path) |> Stream.map(&String.trim/1) |>Enum.into([])
    datos_datos = File.stream!("Datos.txt") |> Stream.map(&String.trim/1) |>Enum.into([])

    
    semestre=Enum.at(datos_datos,1)
    semestreActual = String.to_integer(String.at(semestre,String.length(semestre)-1))
    #IO.puts(semestreActual)
    #IO.puts("-------Semestre arriba----")

    indices_Semestres_actuales = :lists.seq(semestreActual, rem(semestreActual+3,11), 1)
    #---------------------seesmtre del alumno-FIN-------------


  #---------------filtrar cursos llevado---------
    
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

  #-----------recorrer el CursoEq y filtrarla-------
  
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

#IO.inspect(lista_CursosAprobados)


#Hallando que cursos se pueden llevar, debido a que cumple con los pre-requisitos y agregarlo a una lista----------------------------
    nuevaListaIndices = Enum.reduce(Enum.with_index(datos_alma), [], fn {value, index}, lista_Acumulada1 ->
  preRequisitos=String.split(value,",")
  if index in lista_indicesPreRequisitos && String.to_integer(List.first(preRequisitos))!=-1  do
  #IO.puts( Enum.at(datos_alma, String.to_integer(List.first(preRequisitos))))
    if length(preRequisitos)==1 && Enum.at(datos_alma, String.to_integer(List.first(preRequisitos))) in lista_CursosAprobados do
      [Enum.at(datos_alma, index-2) |lista_Acumulada1  ]
      #IO.puts(Enum.at(datos_alma, index-2))
    else
      if Enum.at(datos_alma, String.to_integer(List.first(preRequisitos))) in lista_CursosAprobados && Enum.at(datos_alma, String.to_integer(List.last(preRequisitos))) in lista_CursosAprobados do
      [Enum.at(datos_alma, index-2) |lista_Acumulada1  ]
      else
       lista_Acumulada1
      end
    end
  else
    lista_Acumulada1
  end
end)

    #-------------recorrer el CursoEq---y agregarlo a una lista para pasar a las matriculas-----------
    #Enum.each
    lista_CursosDisponibles =  Enum.reduce(Enum.with_index(datos_alma), [], fn {value, index}, lista_agregarDatos ->

      #--------guardar el nombre del curso
      if not(value in lista_CursosAprobados) && index in lista_nombresCursos && String.to_integer(Enum.at(datos_alma, index-1)) in indices_Semestres_actuales && (Enum.at(datos_alma, index+2)=="-1" || value in nuevaListaIndices) do
          valor = Enum.at(datos_alma, index)
          IO.puts(valor)
          [valor | lista_agregarDatos]

          #--------------guardar el semestre---------------
        else if not(Enum.at(datos_alma, index+1) in lista_CursosAprobados) && index in lista_indicesSemestre && String.to_integer(Enum.at(datos_alma, index)) in indices_Semestres_actuales && (Enum.at(datos_alma, index+3)=="-1" || Enum.at(datos_alma, index+1) in nuevaListaIndices) do
            IO.puts("Semestre: #{value}")
            lista_agregarDatos

          #----guardar la lista de creditos del curso
          else if not(Enum.at(datos_alma, index-1) in lista_CursosAprobados) && index in lista_indicesCred && String.to_integer(Enum.at(datos_alma, index-2)) in indices_Semestres_actuales && (Enum.at(datos_alma, index+1)=="-1" || Enum.at(datos_alma, index-1) in nuevaListaIndices) do
              IO.puts("Creditos: #{value}")
              [value | lista_agregarDatos]

            #------saber que cursos son pre-requisito-----------
            else if not(Enum.at(datos_alma, index-2) in lista_CursosAprobados) && index in indicesPreRequisitos && String.to_integer(Enum.at(datos_alma, index-3)) in indices_Semestres_actuales && (Enum.at(datos_alma, index)=="-1" || Enum.at(datos_alma, index-2) in nuevaListaIndices) do
                preRequisitos = String.split(value, ",")
                if length(preRequisitos) == 1 do
                  if List.first(preRequisitos) == "-1" do
                    IO.puts("Pre-requisitos: #{value}")
                  else
                    IO.puts("Pre-requisitos: #{Enum.at(datos_alma, String.to_integer(List.first(preRequisitos)))}")
                  end
                else
                  IO.puts("Pre-requisitos: #{Enum.at(datos_alma, String.to_integer(List.first(preRequisitos)))}, #{Enum.at(datos_alma, String.to_integer(List.last(preRequisitos)))}")
                end
                lista_agregarDatos
              else
                lista_agregarDatos
              end
          end
        end #end del semestre
      end #end nombre del curso
    end)



    #Agregacion de cursos a matricula

    #IO.puts("-------------PROCESO DE MATRICULA----")
    #IO.inspect(lista_CursosDisponibles)
    matricula(Enum.reverse(lista_CursosDisponibles))
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


#--------------------------NUESTROS MENUS----------------------------
defmodule Menu do
  def iniciar_sesion do
    IO.puts("_______PORTAL ACADEMICO________")
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
    IO.puts("\n--------------MENU------------")
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

