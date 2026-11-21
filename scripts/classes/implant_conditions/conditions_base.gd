extends Resource
class_name ImplantCondition

signal abort

## Retorna true se a condição permite o efeito disparar
func is_met(_context = null) -> bool:
	push_error("is_met() não implementado em %s" % get_script().resource_path)
	return false
