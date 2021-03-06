require 'haversine'

tienda1 = {
  :nombre => "oxxo odontologia",
  :latitud => 25.448665,
  :longitud => -101.025080,
  :cantidad => 200
}

tienda2 = {
  :nombre => "oxxo aquiles velas",
  :latitud => 25.453243,
  :longitud => -101.025315,
  :cantidad => 350
}

tienda3 = {
  :nombre => "oxxo calz Madero",
  :latitud => 25.444569,
  :longitud => -101.022286,
  :cantidad => 400
}

tienda4 = {
  :nombre => "oxxo sanJose",
  :latitud => 25.455042,
  :longitud => -101.028325,
  :cantidad => 560
}

tienda5 = {
  :nombre => "oxxo Jupiter",
  :latitud => 25.458210,
  :longitud =>  -101.018548,
  :cantidad => 255
}

tienda6 = {
  :nombre => "oxxo P.Insurgente",
  :latitud => 25.454832,
  :longitud =>  -101.010126,
  :cantidad => 175
}
tienda7 = {
  :nombre => "oxxo L.Echeverria",
  :latitud => 25.455705,
  :longitud =>  -101.010151,
  :cantidad => 387
}
deposito = {
  :nombre => "Bimbo",
  :latitud => 25.4561015,
  :longitud =>  -101.0166124,
  :cantidad => 0
}

capacidad_camion = 1000
#Solución inicial
s = [[deposito, tienda3, tienda1, tienda2, tienda5, deposito], [deposito, tienda6, tienda7,tienda4, deposito]]
#s_s = [[deposito, tienda3, tienda1, tienda2, tienda5, deposito], [deposito, tienda6, tienda7,tienda4, deposito]]

#calucular costo de solución#
cs = 0
max_cantidad = 0
s.each_index do |x|
  s[x].each_index do |y|
    if s[x][y+1] != nil
      distance = 0
      distance = Haversine.distance(s[x][y][:latitud], s[x][y][:longitud], s[x][y+1][:latitud], s[x][y+1][:longitud])
      cs = cs + distance.to_kilometers
      peso = 0
      peso = s[x][y][:cantidad]
      max_cantidad = max_cantidad + peso
    end
    #puts [:latitud]
  end
end
puts "****solución inicial******"
puts s
puts "#{cs}km"
puts "#{max_cantidad} bolsas"

#Mejor Solucion y mejor Costo
s_mejor = s
cs_mejor = cs
#valor inicial de temperatura
t = 1000
#factor de enfriamiento
x = 0.85
#temperatura final
tf = 0.001

while t >= tf
  n = 0
  while n < 200
    numero_azar = Random.new
    ruta = s[numero_azar.rand(0..1)]
    while ruta.size <= 2
      ruta = s[numero_azar.rand(0..1)]
    end
    s_new = s
    #Perturbar S
    if ruta == s[0]
      numero_azar_ruta1 = numero_azar.rand(1..ruta.size-2)
      if s_new[1].size == 2
        s_new[1].insert(1, ruta[numero_azar_ruta1])
      else
        s_new[1].insert(numero_azar.rand(1..s_new[1].size-2), ruta[numero_azar_ruta1])
      end
      s_new[0].delete_at(numero_azar_ruta1)
    else
      numero_azar_ruta2 = numero_azar.rand(1..ruta.size-2)
      if s_new[0].size == 2
        s_new[0].insert(1,ruta[numero_azar_ruta2])
      else
        s_new[0].insert(numero_azar.rand(1..s_new[0].size-2),ruta[numero_azar_ruta2])
      end
      s_new[1].delete_at(numero_azar_ruta2)
    end
    #Costo de s_new
    cs_new = 0
    s_new.each_index do |x|
      s_new[x].each_index do |y|
        if s_new[x][y+1] != nil
          distance = 0
          distance = Haversine.distance(s_new[x][y][:latitud], s_new[x][y][:longitud], s_new[x][y+1][:latitud], s_new[x][y+1][:longitud])
          cs_new = cs_new + distance.to_kilometers
        end
      end
    end
    if cs_new < cs
      s = s_new
      cs = cs_new
      if cs < cs_mejor
        s_mejor = s
        cs_mejor = cs
      end
    else
      p = Math.exp(-(cs_new - cs)/ t)
      num_rand = Random.new
      if p > num_rand.rand(0.0..1)
        s = s_new
        cs = cs_new
      end
    end
    n= n+1
  end
  t = x*t
end
puts "****solución más optima******"
puts "#{cs_mejor}km"
puts s_mejor
