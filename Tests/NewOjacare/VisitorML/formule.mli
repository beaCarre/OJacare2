type top;;
type _jni_jFormule;;
type _jni_jConstante;;
type _jni_jVar;;
type _jni_jNon;;
type _jni_jOpBin;;
type _jni_jEt;;
type _jni_jOu;;
type _jni_jVisiteur;;
type _jni_jVisiteurTS;;
type _jni_jVisiteurML;;
type _jni_jMainML;;
type _jni_jMainJava;;
class type jFormule =
  object
    method _get_jni_jFormule : _jni_jFormule
    method accepte : jVisiteur -> unit
  end
and jConstante =
  object
    inherit jFormule
    method _get_jni_jConstante : _jni_jConstante
    method valeur : unit -> bool
    method accepte : jVisiteur -> unit
  end
and jVar =
  object
    inherit jFormule
    method _get_jni_jVar : _jni_jVar
    method ident : unit -> string
    method accepte : jVisiteur -> unit
  end
and jNon =
  object
    inherit jFormule
    method _get_jni_jNon : _jni_jNon
    method sous_formule : unit -> jFormule
    method accepte : jVisiteur -> unit
  end
and jOpBin =
  object
    inherit jFormule
    method _get_jni_jOpBin : _jni_jOpBin
    method sous_formule_g : unit -> jFormule
    method sous_formule_d : unit -> jFormule
  end
and jEt =
  object
    inherit jOpBin
    method _get_jni_jEt : _jni_jEt
    method accepte : jVisiteur -> unit
  end
and jOu =
  object
    inherit jOpBin
    method _get_jni_jOu : _jni_jOu
    method accepte : jVisiteur -> unit
  end
and jVisiteur =
  object
    method _get_jni_jVisiteur : _jni_jVisiteur
    method visite_cst : jConstante -> unit
    method visite_non : jNon -> unit
    method visite_et : jEt -> unit
    method visite_ou : jOu -> unit
    method visite_var : jVar -> unit
  end
and jVisiteurTS =
  object
    inherit jVisiteur
    method _get_jni_jVisiteurTS : _jni_jVisiteurTS
    method get_res : unit -> string
    method visite_cst : jConstante -> unit
    method visite_non : jNon -> unit
    method visite_et : jEt -> unit
    method visite_ou : jOu -> unit
    method visite_var : jVar -> unit
  end
and jVisiteurML =
  object
    inherit jVisiteur
    method _get_jni_jVisiteurML : _jni_jVisiteurML
    method get_res : unit -> string
  end
and jMainML =
  object
    method _get_jni_jMainML : _jni_jMainML
    method cree_visiteur : unit -> jVisiteurML
  end
and jMainJava = object method _get_jni_jMainJava : _jni_jMainJava end;;
class constante : bool -> jConstante;;
class var : string -> jVar;;
class non : jFormule -> jNon;;
class et : jFormule -> jFormule -> jEt;;
class ou : jFormule -> jFormule -> jOu;;
class visiteurTS : unit -> jVisiteurTS;;
class virtual _stub_jVisiteurML :
  unit ->
    object
      method _get_jni_jVisiteur : _jni_jVisiteur
      method _get_jni_jVisiteurML : _jni_jVisiteurML
      method _stub_get_res : java'lang'String java_instance
      method _stub_visite_var : _jni_jVar  -> unit
      method _stub_visite_ou : _jni_jOu -> unit
      method _stub_visite_et : _jni_jEt  -> unit
      method _stub_visite_non : _jni_jNon -> unit
      method _stub_visite_cst : _jni_jConstante -> unit
      method virtual get_res : unit -> string
      method virtual visite_var : jVar -> unit
      method virtual visite_ou : jOu -> unit
      method virtual visite_et : jEt -> unit
      method virtual visite_non : jNon -> unit
      method virtual visite_cst : jConstante -> unit
    end;;
val fr_upmc_infop6_mlo_jMainJava__main : jMainML -> unit;;
