# fastlane/helpers.rb
# Helpers compartidos entre plataformas

# Parsea un valor booleano de las opciones, variables de entorno o un valor por defecto.
def bool_option(options, key, env_var: nil, default: false)
  accepted_values = [true, false, "true", "false", 1, 0, "1", "0"]
  value = nil
  if options.key?(key)
    value = options[key]
  elsif env_var && ENV.key?(env_var)
    value = ENV[env_var]
  else
    value = default
  end

  unless accepted_values.include?(value)
    UI.user_error!("Valor inválido para la opción '#{key}': #{value}. Se esperaba un valor booleano (true/false).")
  end

  # Convertir a booleano
  case value
  when true, "true", 1, "1"
    true
  when false, "false", 0, "0"
    false
  else
    default
  end
end

# Parsea un valor entero de las opciones, variables de entorno o un valor por defecto.
def integer_option(options, key, env_var: nil, default: nil)
  if options.key?(key)
    Integer(options[key]) rescue default
  elsif env_var && ENV.key?(env_var)
    Integer(ENV[env_var]) rescue default
  else
    default
  end
end

# Parsea un valor de cadena de las opciones, variables de entorno o un valor por defecto.
def string_option(options, key, env_var: nil, default: nil)
  if options.key?(key)
    options[key].to_s
  elsif env_var && ENV.key?(env_var)
    ENV[env_var]
  else
    default
  end
end

# Parsea un valor de arreglo de las opciones, variables de entorno o un valor por defecto.
def array_option(options, key, env_var: nil, default: [])
  if options.key?(key)
    Array(options[key])
  elsif env_var && ENV.key?(env_var)
    ENV[env_var].split(",").map(&:strip)
  else
    default
  end
end
