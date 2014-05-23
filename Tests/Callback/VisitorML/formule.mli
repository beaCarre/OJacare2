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
    inherit JniHierarchy.top
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
    inherit JniHierarchy.top
    method _get_jni_jVisiteur : _jni_jVisiteur
    method visite_cst : jConstante -> unit
    method visite_non : jNon -> unit
    method visite_et : jEt -> unit
    method visite_ou : jOu -> unit
    method visite_var : jVar -> unit
  end
and jVisiteurTS =
  object
    inherit JniHierarchy.top
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
    inherit JniHierarchy.top
    inherit jVisiteur
    method _get_jni_jVisiteurML : _jni_jVisiteurML
    method get_res : unit -> string
  end
and jMainML =
  object
    inherit JniHierarchy.top
    method _get_jni_jMainML : _jni_jMainML
    method cree_visiteur : unit -> jVisiteurML
  end
and jMainJava =
  object inherit JniHierarchy.top method _get_jni_jMainJava : _jni_jMainJava
  end;;
val jFormule_of_top : JniHierarchy.top -> jFormule;;
val jConstante_of_top : JniHierarchy.top -> jConstante;;
val jVar_of_top : JniHierarchy.top -> jVar;;
val jNon_of_top : JniHierarchy.top -> jNon;;
val jOpBin_of_top : JniHierarchy.top -> jOpBin;;
val jEt_of_top : JniHierarchy.top -> jEt;;
val jOu_of_top : JniHierarchy.top -> jOu;;
val jVisiteur_of_top : JniHierarchy.top -> jVisiteur;;
val jVisiteurTS_of_top : JniHierarchy.top -> jVisiteurTS;;
val jVisiteurML_of_top : JniHierarchy.top -> jVisiteurML;;
val jMainML_of_top : JniHierarchy.top -> jMainML;;
val jMainJava_of_top : JniHierarchy.top -> jMainJava;;
val _instance_of_jFormule : JniHierarchy.top -> bool;;
val _instance_of_jConstante : JniHierarchy.top -> bool;;
val _instance_of_jVar : JniHierarchy.top -> bool;;
val _instance_of_jNon : JniHierarchy.top -> bool;;
val _instance_of_jOpBin : JniHierarchy.top -> bool;;
val _instance_of_jEt : JniHierarchy.top -> bool;;
val _instance_of_jOu : JniHierarchy.top -> bool;;
val _instance_of_jVisiteur : JniHierarchy.top -> bool;;
val _instance_of_jVisiteurTS : JniHierarchy.top -> bool;;
val _instance_of_jVisiteurML : JniHierarchy.top -> bool;;
val _instance_of_jMainML : JniHierarchy.top -> bool;;
val _instance_of_jMainJava : JniHierarchy.top -> bool;;
val jArray_init_jFormule :
  int -> (int -> jFormule) -> jFormule JniArray.jArray;;
val jArray_init_jConstante :
  int -> (int -> jConstante) -> jConstante JniArray.jArray;;
val jArray_init_jVar : int -> (int -> jVar) -> jVar JniArray.jArray;;
val jArray_init_jNon : int -> (int -> jNon) -> jNon JniArray.jArray;;
val jArray_init_jOpBin : int -> (int -> jOpBin) -> jOpBin JniArray.jArray;;
val jArray_init_jEt : int -> (int -> jEt) -> jEt JniArray.jArray;;
val jArray_init_jOu : int -> (int -> jOu) -> jOu JniArray.jArray;;
val jArray_init_jVisiteur :
  int -> (int -> jVisiteur) -> jVisiteur JniArray.jArray;;
val jArray_init_jVisiteurTS :
  int -> (int -> jVisiteurTS) -> jVisiteurTS JniArray.jArray;;
val jArray_init_jVisiteurML :
  int -> (int -> jVisiteurML) -> jVisiteurML JniArray.jArray;;
val jArray_init_jMainML :
  int -> (int -> jMainML) -> jMainML JniArray.jArray;;
val jArray_init_jMainJava :
  int -> (int -> jMainJava) -> jMainJava JniArray.jArray;;
class constante : bool -> jConstante;;
class var : string -> jVar;;
class non : jFormule -> jNon;;
class et : jFormule -> jFormule -> jEt;;
class ou : jFormule -> jFormule -> jOu;;
class visiteurTS : unit -> jVisiteurTS;;
class virtual _stub_jVisiteurML :
  unit ->
    object
      inherit JniHierarchy.top
      method _get_jni_jVisiteur : _jni_jVisiteur
      method _get_jni_jVisiteurML : _jni_jVisiteurML
      method _stub_get_res : Jni.obj
      method _stub_visite_var : Jni.obj -> unit
      method _stub_visite_ou : Jni.obj -> unit
      method _stub_visite_et : Jni.obj -> unit
      method _stub_visite_non : Jni.obj -> unit
      method _stub_visite_cst : Jni.obj -> unit
      method virtual get_res : unit -> string
      method virtual visite_var : jVar -> unit
      method virtual visite_ou : jOu -> unit
      method virtual visite_et : jEt -> unit
      method virtual visite_non : jNon -> unit
      method virtual visite_cst : jConstante -> unit
    end;;
class virtual _stub_jMainML :
  unit ->
    object
      inherit JniHierarchy.top
      method _get_jni_jMainML : _jni_jMainML
      method _stub_cree_visiteur : Jni.obj
      method virtual cree_visiteur : unit -> jVisiteurML
    end;;
val fr_upmc_infop6_mlo_jMainJava__main : jMainML -> unit;;
