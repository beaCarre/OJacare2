type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jFormule = fr'upmc'infop6'mlo'Formule java_instance;;
type _jni_jConstante = fr'upmc'infop6'mlo'Constante java_instance;;
type _jni_jVar = fr'upmc'infop6'mlo'Var java_instance;;
type _jni_jNon = fr'upmc'infop6'mlo'Non java_instance;;
type _jni_jOpBin = fr'upmc'infop6'mlo'OpBin java_instance;;
type _jni_jEt = fr'upmc'infop6'mlo'Et java_instance;;
type _jni_jOu = fr'upmc'infop6'mlo'Ou java_instance;;
type _jni_jVisiteur = fr'upmc'infop6'mlo'Visiteur java_instance;;
type _jni_jVisiteurTS = fr'upmc'infop6'mlo'VisiteurTS java_instance;;
type _jni_jVisiteurML = fr'upmc'infop6'mlo'VisiteurML java_instance;;
type _jni_jMainML = fr'upmc'infop6'mlo'MainML java_instance;;
type _jni_jMainJava = fr'upmc'infop6'mlo'MainJava java_instance;;
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
class _capsule_jFormule (jni_ref : _jni_jFormule) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Formule")
    else ()
  in
    object (self)
      method accepte =
        fun (_p0 : jVisiteur) ->
          let _p0 = _p0#_get_jni_jVisiteur
          in
            Java.call
              "fr.upmc.infop6.mlo.Formule.accepte(fr.upmc.infop6.mlo.Visiteur):void"
              jni_ref _p0
      method _get_jni_jFormule = jni_ref
    end
and _capsule_jConstante (jni_ref : _jni_jConstante) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Constante")
    else ()
  in
    object (self)
      method valeur =
        fun () ->
          Java.call "fr.upmc.infop6.mlo.Constante.valeur():boolean" jni_ref
      method accepte =
        fun (_p0 : jVisiteur) ->
          let _p0 = _p0#_get_jni_jVisiteur
          in
            Java.call
              "fr.upmc.infop6.mlo.Constante.accepte(fr.upmc.infop6.mlo.Visiteur):void"
              jni_ref _p0
      method _get_jni_jConstante = jni_ref
      method _get_jni_jFormule = (jni_ref :> _jni_jFormule)
    end
and _capsule_jVar (jni_ref : _jni_jVar) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Var")
    else ()
  in
    object (self)
      method ident =
        fun () ->
          JavaString.to_string
            (Java.call "fr.upmc.infop6.mlo.Var.ident():java.lang.String"
               jni_ref)
      method accepte =
        fun (_p0 : jVisiteur) ->
          let _p0 = _p0#_get_jni_jVisiteur
          in
            Java.call
              "fr.upmc.infop6.mlo.Var.accepte(fr.upmc.infop6.mlo.Visiteur):void"
              jni_ref _p0
      method _get_jni_jVar = jni_ref
      method _get_jni_jFormule = (jni_ref :> _jni_jFormule)
    end
and _capsule_jNon (jni_ref : _jni_jNon) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Non")
    else ()
  in
    object (self)
      method sous_formule =
        fun () ->
          (new _capsule_jFormule
             (Java.call
                "fr.upmc.infop6.mlo.Non.sous_formule():fr.upmc.infop6.mlo.Formule"
                jni_ref) :
            jFormule)
      method accepte =
        fun (_p0 : jVisiteur) ->
          let _p0 = _p0#_get_jni_jVisiteur
          in
            Java.call
              "fr.upmc.infop6.mlo.Non.accepte(fr.upmc.infop6.mlo.Visiteur):void"
              jni_ref _p0
      method _get_jni_jNon = jni_ref
      method _get_jni_jFormule = (jni_ref :> _jni_jFormule)
    end
and _capsule_jOpBin (jni_ref : _jni_jOpBin) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/OpBin")
    else ()
  in
    object (self)
      method sous_formule_d =
        fun () ->
          (new _capsule_jFormule
             (Java.call
                "fr.upmc.infop6.mlo.OpBin.sous_formule_d():fr.upmc.infop6.mlo.Formule"
                jni_ref) :
            jFormule)
      method sous_formule_g =
        fun () ->
          (new _capsule_jFormule
             (Java.call
                "fr.upmc.infop6.mlo.OpBin.sous_formule_g():fr.upmc.infop6.mlo.Formule"
                jni_ref) :
            jFormule)
      method accepte =
        fun (_p0 : jVisiteur) ->
          let _p0 = _p0#_get_jni_jVisiteur
          in
            Java.call
              "fr.upmc.infop6.mlo.Formule.accepte(fr.upmc.infop6.mlo.Visiteur):void"
              jni_ref _p0
      method _get_jni_jOpBin = jni_ref
      method _get_jni_jFormule = (jni_ref :> _jni_jFormule)
    end
and _capsule_jEt (jni_ref : _jni_jEt) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Et")
    else ()
  in
    object (self)
      method sous_formule_d =
        fun () ->
          (new _capsule_jFormule
             (Java.call
                "fr.upmc.infop6.mlo.OpBin.sous_formule_d():fr.upmc.infop6.mlo.Formule"
                jni_ref) :
            jFormule)
      method sous_formule_g =
        fun () ->
          (new _capsule_jFormule
             (Java.call
                "fr.upmc.infop6.mlo.OpBin.sous_formule_g():fr.upmc.infop6.mlo.Formule"
                jni_ref) :
            jFormule)
      method accepte =
        fun (_p0 : jVisiteur) ->
          let _p0 = _p0#_get_jni_jVisiteur
          in
            Java.call
              "fr.upmc.infop6.mlo.Et.accepte(fr.upmc.infop6.mlo.Visiteur):void"
              jni_ref _p0
      method _get_jni_jEt = jni_ref
      method _get_jni_jFormule = (jni_ref :> _jni_jFormule)
      method _get_jni_jOpBin = (jni_ref :> _jni_jOpBin)
    end
and _capsule_jOu (jni_ref : _jni_jOu) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Ou")
    else ()
  in
    object (self)
      method sous_formule_d =
        fun () ->
          (new _capsule_jFormule
             (Java.call
                "fr.upmc.infop6.mlo.OpBin.sous_formule_d():fr.upmc.infop6.mlo.Formule"
                jni_ref) :
            jFormule)
      method sous_formule_g =
        fun () ->
          (new _capsule_jFormule
             (Java.call
                "fr.upmc.infop6.mlo.OpBin.sous_formule_g():fr.upmc.infop6.mlo.Formule"
                jni_ref) :
            jFormule)
      method accepte =
        fun (_p0 : jVisiteur) ->
          let _p0 = _p0#_get_jni_jVisiteur
          in
            Java.call
              "fr.upmc.infop6.mlo.Ou.accepte(fr.upmc.infop6.mlo.Visiteur):void"
              jni_ref _p0
      method _get_jni_jOu = jni_ref
      method _get_jni_jFormule = (jni_ref :> _jni_jFormule)
      method _get_jni_jOpBin = (jni_ref :> _jni_jOpBin)
    end
and _capsule_jVisiteur (jni_ref : _jni_jVisiteur) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Visiteur")
    else ()
  in
    object (self)
      method visite_var =
        fun (_p0 : jVar) ->
          let _p0 = _p0#_get_jni_jVar
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Var):void"
              jni_ref _p0
      method visite_ou =
        fun (_p0 : jOu) ->
          let _p0 = _p0#_get_jni_jOu
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Ou):void"
              jni_ref _p0
      method visite_et =
        fun (_p0 : jEt) ->
          let _p0 = _p0#_get_jni_jEt
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Et):void"
              jni_ref _p0
      method visite_non =
        fun (_p0 : jNon) ->
          let _p0 = _p0#_get_jni_jNon
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Non):void"
              jni_ref _p0
      method visite_cst =
        fun (_p0 : jConstante) ->
          let _p0 = _p0#_get_jni_jConstante
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Constante):void"
              jni_ref _p0
      method _get_jni_jVisiteur = jni_ref
    end
and _capsule_jVisiteurTS (jni_ref : _jni_jVisiteurTS) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/VisiteurTS")
    else ()
  in
    object (self)
      method get_res =
        fun () ->
          JavaString.to_string
            (Java.call
               "fr.upmc.infop6.mlo.VisiteurTS.get_res():java.lang.String"
               jni_ref)
      method visite_var =
        fun (_p0 : jVar) ->
          let _p0 = _p0#_get_jni_jVar
          in
            Java.call
              "fr.upmc.infop6.mlo.VisiteurTS.visite(fr.upmc.infop6.mlo.Var):void"
              jni_ref _p0
      method visite_ou =
        fun (_p0 : jOu) ->
          let _p0 = _p0#_get_jni_jOu
          in
            Java.call
              "fr.upmc.infop6.mlo.VisiteurTS.visite(fr.upmc.infop6.mlo.Ou):void"
              jni_ref _p0
      method visite_et =
        fun (_p0 : jEt) ->
          let _p0 = _p0#_get_jni_jEt
          in
            Java.call
              "fr.upmc.infop6.mlo.VisiteurTS.visite(fr.upmc.infop6.mlo.Et):void"
              jni_ref _p0
      method visite_non =
        fun (_p0 : jNon) ->
          let _p0 = _p0#_get_jni_jNon
          in
            Java.call
              "fr.upmc.infop6.mlo.VisiteurTS.visite(fr.upmc.infop6.mlo.Non):void"
              jni_ref _p0
      method visite_cst =
        fun (_p0 : jConstante) ->
          let _p0 = _p0#_get_jni_jConstante
          in
            Java.call
              "fr.upmc.infop6.mlo.VisiteurTS.visite(fr.upmc.infop6.mlo.Constante):void"
              jni_ref _p0
      method _get_jni_jVisiteurTS = jni_ref
      method _get_jni_jVisiteur = (jni_ref :> _jni_jVisiteur)
    end
and _capsule_jVisiteurML (jni_ref : _jni_jVisiteurML) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/VisiteurML")
    else ()
  in
    object (self)
      method get_res =
        fun () ->
          JavaString.to_string
            (Java.call
               "fr.upmc.infop6.mlo.VisiteurML.get_res():java.lang.String"
               jni_ref)
      method visite_var =
        fun (_p0 : jVar) ->
          let _p0 = _p0#_get_jni_jVar
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Var):void"
              jni_ref _p0
      method visite_ou =
        fun (_p0 : jOu) ->
          let _p0 = _p0#_get_jni_jOu
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Ou):void"
              jni_ref _p0
      method visite_et =
        fun (_p0 : jEt) ->
          let _p0 = _p0#_get_jni_jEt
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Et):void"
              jni_ref _p0
      method visite_non =
        fun (_p0 : jNon) ->
          let _p0 = _p0#_get_jni_jNon
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Non):void"
              jni_ref _p0
      method visite_cst =
        fun (_p0 : jConstante) ->
          let _p0 = _p0#_get_jni_jConstante
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite(fr.upmc.infop6.mlo.Constante):void"
              jni_ref _p0
      method _get_jni_jVisiteurML = jni_ref
      method _get_jni_jVisiteur = (jni_ref :> _jni_jVisiteur)
    end
and _capsule_jMainML (jni_ref : _jni_jMainML) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/MainML")
    else ()
  in
    object (self)
      method cree_visiteur =
        fun () ->
          (new _capsule_jVisiteurML
             (Java.call
                "fr.upmc.infop6.mlo.MainML.cree_visiteur():fr.upmc.infop6.mlo.VisiteurML"
                jni_ref) :
            jVisiteurML)
      method _get_jni_jMainML = jni_ref
    end
and _capsule_jMainJava (jni_ref : _jni_jMainJava) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/MainJava")
    else ()
  in object (self) method _get_jni_jMainJava = jni_ref end


and virtual _souche_jVisiteurML = 
  let jni_ref = ref Java.null
  in
    object (self)
      initializer
	jni_ref := 
	  Java.proxy "fr.upmc.infop6.mlo.VisiteurML"
	  (
	  object
	    method get_res = JavaString.of_string (self#get_res ())
	    method visite_5 =
              fun (_p0 : _jni_jVar) ->
		let _p0 : jVar = new _capsule_jVar _p0 in self#visite_var _p0
	    method visite_4 =
              fun (_p0 : _jni_jOu) ->
		let _p0 : jOu = new _capsule_jOu _p0 in self#visite_ou _p0
	    method visite_2 =
              fun (_p0 : _jni_jEt) ->
		let _p0 : jEt = new _capsule_jEt _p0 in self#visite_et _p0
	    method visite_3 =
              fun (_p0 : _jni_jNon) ->
		let _p0 : jNon = new _capsule_jNon _p0 in self#visite_non _p0
	    method visite =
              fun (_p0 : _jni_jConstante) ->
		let _p0 : jConstante = new _capsule_jConstante _p0
		in self#visite_cst _p0
	  end)
      method virtual get_res : unit -> string
      method virtual visite_var : jVar -> unit
      method virtual visite_ou : jOu -> unit
      method virtual visite_et : jEt -> unit
      method virtual visite_non : jNon -> unit
      method virtual visite_cst : jConstante -> unit
      method _get_jni_jVisiteurML = (!jni_ref : _jni_jVisiteurML)
      method _get_jni_jVisiteur = (!jni_ref :> _jni_jVisiteur)
    end
and virtual _souche_jMainML  =
  let jni_ref = ref Java.null 
  in
    object (self)
      initializer
	  jni_ref := 
	    Java.proxy "fr.upmc.infop6.mlo.MainML"
	    (
	    object
	      method cree_visiteur =
		(self#cree_visiteur ())#_get_jni_jVisiteurML
	    end)
      method virtual cree_visiteur : unit -> jVisiteurML
      method _get_jni_jMainML = (!jni_ref : _jni_jMainML)
    end;;
let jFormule_of_top (o : top) : jFormule =
  new _capsule_jFormule (Java.cast "fr.upmc.infop6.mlo.Formule" o);;
let jConstante_of_top (o : top) : jConstante =
  new _capsule_jConstante (Java.cast "fr.upmc.infop6.mlo.Constante" o);;
let jVar_of_top (o : top) : jVar =
  new _capsule_jVar (Java.cast "fr.upmc.infop6.mlo.Var" o);;
let jNon_of_top (o : top) : jNon =
  new _capsule_jNon (Java.cast "fr.upmc.infop6.mlo.Non" o);;
let jOpBin_of_top (o : top) : jOpBin =
  new _capsule_jOpBin (Java.cast "fr.upmc.infop6.mlo.OpBin" o);;
let jEt_of_top (o : top) : jEt =
  new _capsule_jEt (Java.cast "fr.upmc.infop6.mlo.Et" o);;
let jOu_of_top (o : top) : jOu =
  new _capsule_jOu (Java.cast "fr.upmc.infop6.mlo.Ou" o);;
let jVisiteur_of_top (o : top) : jVisiteur =
  new _capsule_jVisiteur (Java.cast "fr.upmc.infop6.mlo.Visiteur" o);;
let jVisiteurTS_of_top (o : top) : jVisiteurTS =
  new _capsule_jVisiteurTS (Java.cast "fr.upmc.infop6.mlo.VisiteurTS" o);;
let jVisiteurML_of_top (o : top) : jVisiteurML =
  new _capsule_jVisiteurML (Java.cast "fr.upmc.infop6.mlo.VisiteurML" o);;
let jMainML_of_top (o : top) : jMainML =
  new _capsule_jMainML (Java.cast "fr.upmc.infop6.mlo.MainML" o);;
let jMainJava_of_top (o : top) : jMainJava =
  new _capsule_jMainJava (Java.cast "fr.upmc.infop6.mlo.MainJava" o);;
let _instance_of_jFormule (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.Formule" o;;
let _instance_of_jConstante (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.Constante" o;;
let _instance_of_jVar (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.Var" o;;
let _instance_of_jNon (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.Non" o;;
let _instance_of_jOpBin (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.OpBin" o;;
let _instance_of_jEt (o : top) = Java.instanceof "fr.upmc.infop6.mlo.Et" o;;
let _instance_of_jOu (o : top) = Java.instanceof "fr.upmc.infop6.mlo.Ou" o;;
let _instance_of_jVisiteur (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.Visiteur" o;;
let _instance_of_jVisiteurTS (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.VisiteurTS" o;;
let _instance_of_jVisiteurML (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.VisiteurML" o;;
let _instance_of_jMainML (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.MainML" o;;
let _instance_of_jMainJava (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.MainJava" o;;
class constante _p0 =
  let _p0 = _p0
  in let java_obj = Java.make "fr.upmc.infop6.mlo.Constante(boolean)" _p0
    in object (self) inherit _capsule_jConstante java_obj end;;
class var _p0 =
  let _p0 = JavaString.of_string _p0
  in let java_obj = Java.make "fr.upmc.infop6.mlo.Var(java.lang.String)" _p0
    in object (self) inherit _capsule_jVar java_obj end;;
class non _p0 =
  let _p0 = _p0#_get_jni_jFormule
  in
    let java_obj =
      Java.make "fr.upmc.infop6.mlo.Non(fr.upmc.infop6.mlo.Formule)" _p0
    in object (self) inherit _capsule_jNon java_obj end;;
class et _p0 _p1 =
  let _p1 = _p1#_get_jni_jFormule
  in let _p0 = _p0#_get_jni_jFormule
    in
      let java_obj =
        Java.make
          "fr.upmc.infop6.mlo.Et(fr.upmc.infop6.mlo.Formule,fr.upmc.infop6.mlo.Formule)"
          _p0 _p1
      in object (self) inherit _capsule_jEt java_obj end;;
class ou _p0 _p1 =
  let _p1 = _p1#_get_jni_jFormule
  in let _p0 = _p0#_get_jni_jFormule
    in
      let java_obj =
        Java.make
          "fr.upmc.infop6.mlo.Ou(fr.upmc.infop6.mlo.Formule,fr.upmc.infop6.mlo.Formule)"
          _p0 _p1
      in object (self) inherit _capsule_jOu java_obj end;;
class visiteurTS () =
  let java_obj = Java.make "fr.upmc.infop6.mlo.VisiteurTS()" ()
  in object (self) inherit _capsule_jVisiteurTS java_obj end;;

class virtual _stub_jVisiteurML =
    object (self)
      inherit _souche_jVisiteurML 
    end;;

class virtual _stub_jMainML =
    object (self)
      inherit _souche_jMainML 
    end;;

let fr_upmc_infop6_mlo_jMainJava__main =
    fun (_p0 : jMainML) ->
      let _p0 = _p0#_get_jni_jMainML
      in Java.call "fr.upmc.infop6.mlo.MainJava.main(fr.upmc.infop6.mlo.MainML)" _p0
