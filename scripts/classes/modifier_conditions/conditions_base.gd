extends Resource
class_name ModifierCondition

## Retorna true se a condição permite o efeito disparar
func is_met() -> bool:
	push_error("is_met() não implementado em %s" % get_script().resource_path)
	return false
