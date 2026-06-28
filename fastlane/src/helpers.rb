# fastlane/helpers.rb
# Helpers compartidos entre plataformas

# Parsea un valor entero de las opciones, variables de entorno o un valor por defecto.
def integer_option(options, key, env_var: nil, default: nil, required: false)
  if required && !options.key?(key) && !(env_var && ENV.key?(env_var)) && default.nil?
    UI.user_error!("La opción '#{key}' es requerida pero no se proporcionó ningún valor.")
  end

  value = nil
  if options.key?(key)
    value = Integer(options[key]) rescue default
  elsif env_var && ENV.key?(env_var)
    value = Integer(ENV[env_var]) rescue default
  else
    value = default
  end

  UI.user_error!("Valor inválido para la opción '#{key}': #{value}. Se esperaba un valor entero.") unless value.is_a?(Integer)

  value
end

# Parsea un valor de cadena de las opciones, variables de entorno o un valor por defecto.
def string_option(options, key, env_var: nil, default: nil, required: false)
  if required && !options.key?(key) && !(env_var && ENV.key?(env_var)) && default.nil?
    UI.user_error!("La opción '#{key}' es requerida pero no se proporcionó ningún valor.")
  end

  if options.key?(key)
    value = options[key].to_s
  elsif env_var && ENV.key?(env_var)
    value = ENV[env_var]
  else
    value = default
  end

  value
end

# Parsea un valor de arreglo de las opciones, variables de entorno o un valor por defecto.
def array_option(options, key, env_var: nil, default: [], required: false)
  if required && !options.key?(key) && !(env_var && ENV.key?(env_var)) && default.empty?
    UI.user_error!("La opción '#{key}' es requerida pero no se proporcionó ningún valor.")
  end

  if options.key?(key)
    value = Array(options[key])
  elsif env_var && ENV.key?(env_var)
    value = ENV[env_var].split(",").map(&:strip)
  else
    value = default
  end

  value
end

# Parsea un valor booleano de las opciones (1,0,true,false,y,n), variables de entorno o un valor por defecto.
def bool_option(options, key, env_var: nil, default: false, required: false)
  if required && !options.key?(key) && !(env_var && ENV.key?(env_var)) && default.nil?
    UI.user_error!("La opción '#{key}' es requerida pero no se proporcionó ningún valor.")
  end

  if options.key?(key)
    value = options[key].to_s.downcase
  elsif env_var && ENV.key?(env_var)
    value = ENV[env_var].to_s.downcase
  else
    value = default.to_s.downcase
  end

  case value
  when "1", "true", "y", "yes"
    true
  when "0", "false", "n", "no"
    false
  else
    UI.user_error!("Valor inválido para la opción '#{key}': #{value}. Se esperaba un valor booleano (1,0,true,false,y,n).")
  end
end
