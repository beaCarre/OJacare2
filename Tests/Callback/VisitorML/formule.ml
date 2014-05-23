type _jni_jFormule = Jni.obj;;
type _jni_jConstante = Jni.obj;;
type _jni_jVar = Jni.obj;;
type _jni_jNon = Jni.obj;;
type _jni_jOpBin = Jni.obj;;
type _jni_jEt = Jni.obj;;
type _jni_jOu = Jni.obj;;
type _jni_jVisiteur = Jni.obj;;
type _jni_jVisiteurTS = Jni.obj;;
type _jni_jVisiteurML = Jni.obj;;
type _jni_jMainML = Jni.obj;;
type _jni_jMainJava = Jni.obj;;
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
let __jni_obj_of_jni_jFormule (java_obj : _jni_jFormule) =
  (Obj.magic : _jni_jFormule -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jConstante (java_obj : _jni_jConstante) =
  (Obj.magic : _jni_jConstante -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jVar (java_obj : _jni_jVar) =
  (Obj.magic : _jni_jVar -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jNon (java_obj : _jni_jNon) =
  (Obj.magic : _jni_jNon -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jOpBin (java_obj : _jni_jOpBin) =
  (Obj.magic : _jni_jOpBin -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jEt (java_obj : _jni_jEt) =
  (Obj.magic : _jni_jEt -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jOu (java_obj : _jni_jOu) =
  (Obj.magic : _jni_jOu -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jVisiteur (java_obj : _jni_jVisiteur) =
  (Obj.magic : _jni_jVisiteur -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jVisiteurTS (java_obj : _jni_jVisiteurTS) =
  (Obj.magic : _jni_jVisiteurTS -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jVisiteurML (java_obj : _jni_jVisiteurML) =
  (Obj.magic : _jni_jVisiteurML -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jMainML (java_obj : _jni_jMainML) =
  (Obj.magic : _jni_jMainML -> Jni.obj) java_obj;;
let __jni_obj_of_jni_jMainJava (java_obj : _jni_jMainJava) =
  (Obj.magic : _jni_jMainJava -> Jni.obj) java_obj;;
let __jni_jFormule_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/Formule"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.Formule."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then failwith "``cast error'' : jFormule (fr/upmc/infop6/mlo/Formule)"
      else (Obj.magic java_obj : _jni_jFormule);;
let __jni_jConstante_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/Constante"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.Constante."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then
        failwith "``cast error'' : jConstante (fr/upmc/infop6/mlo/Constante)"
      else (Obj.magic java_obj : _jni_jConstante);;
let __jni_jVar_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/Var"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.Var."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then failwith "``cast error'' : jVar (fr/upmc/infop6/mlo/Var)"
      else (Obj.magic java_obj : _jni_jVar);;
let __jni_jNon_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/Non"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.Non."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then failwith "``cast error'' : jNon (fr/upmc/infop6/mlo/Non)"
      else (Obj.magic java_obj : _jni_jNon);;
let __jni_jOpBin_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/OpBin"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.OpBin."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then failwith "``cast error'' : jOpBin (fr/upmc/infop6/mlo/OpBin)"
      else (Obj.magic java_obj : _jni_jOpBin);;
let __jni_jEt_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/Et"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.Et."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then failwith "``cast error'' : jEt (fr/upmc/infop6/mlo/Et)"
      else (Obj.magic java_obj : _jni_jEt);;
let __jni_jOu_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/Ou"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.Ou."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then failwith "``cast error'' : jOu (fr/upmc/infop6/mlo/Ou)"
      else (Obj.magic java_obj : _jni_jOu);;
let __jni_jVisiteur_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/Visiteur"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.Visiteur."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then
        failwith "``cast error'' : jVisiteur (fr/upmc/infop6/mlo/Visiteur)"
      else (Obj.magic java_obj : _jni_jVisiteur);;
let __jni_jVisiteurTS_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/VisiteurTS"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.VisiteurTS."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then
        failwith
          "``cast error'' : jVisiteurTS (fr/upmc/infop6/mlo/VisiteurTS)"
      else (Obj.magic java_obj : _jni_jVisiteurTS);;
let __jni_jVisiteurML_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/VisiteurML"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.VisiteurML."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then
        failwith
          "``cast error'' : jVisiteurML (fr/upmc/infop6/mlo/VisiteurML)"
      else (Obj.magic java_obj : _jni_jVisiteurML);;
let __jni_jMainML_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/MainML"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.MainML."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then failwith "``cast error'' : jMainML (fr/upmc/infop6/mlo/MainML)"
      else (Obj.magic java_obj : _jni_jMainML);;
let __jni_jMainJava_of_jni_obj =
  let clazz =
    try Jni.find_class "fr/upmc/infop6/mlo/MainJava"
    with | _ -> failwith "Class not found : fr.upmc.infop6.mlo.MainJava."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then
        failwith "``cast error'' : jMainJava (fr/upmc/infop6/mlo/MainJava)"
      else (Obj.magic java_obj : _jni_jMainJava);;
let _alloc_jFormule =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Formule"
  in fun () -> (Jni.alloc_object clazz : _jni_jFormule);;
let _alloc_jConstante =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Constante"
  in fun () -> (Jni.alloc_object clazz : _jni_jConstante);;
let _alloc_jVar =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Var"
  in fun () -> (Jni.alloc_object clazz : _jni_jVar);;
let _alloc_jNon =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Non"
  in fun () -> (Jni.alloc_object clazz : _jni_jNon);;
let _alloc_jOpBin =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/OpBin"
  in fun () -> (Jni.alloc_object clazz : _jni_jOpBin);;
let _alloc_jEt =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Et"
  in fun () -> (Jni.alloc_object clazz : _jni_jEt);;
let _alloc_jOu =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Ou"
  in fun () -> (Jni.alloc_object clazz : _jni_jOu);;
let _alloc_jVisiteurTS =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/VisiteurTS"
  in fun () -> (Jni.alloc_object clazz : _jni_jVisiteurTS);;
let _alloc_jMainJava =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/MainJava"
  in fun () -> (Jni.alloc_object clazz : _jni_jMainJava);;
let _alloc__stub_jVisiteurML =
  let clazz =
    try Jni.find_class "callback/fr/upmc/infop6/mlo/VisiteurML"
    with
    | _ ->
        failwith "Class not found : callback.fr.upmc.infop6.mlo.VisiteurML."
  in fun () -> (Jni.alloc_object clazz : _jni_jVisiteurML);;
let _alloc__stub_jMainML =
  let clazz =
    try Jni.find_class "callback/fr/upmc/infop6/mlo/MainML"
    with
    | _ -> failwith "Class not found : callback.fr.upmc.infop6.mlo.MainML."
  in fun () -> (Jni.alloc_object clazz : _jni_jMainML);;
class _capsule_jFormule =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Formule"
  in
    let __mid_accepte =
      try Jni.get_methodID clazz "accepte" "(Lfr/upmc/infop6/mlo/Visiteur;)V"
      with
      | _ ->
          failwith
            "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Formule\" : \"void accepte(fr.upmc.infop6.mlo.Visiteur)\"."
    in
      fun (jni_ref : _jni_jFormule) ->
        let _ =
          if Jni.is_null jni_ref
          then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/Formule")
          else ()
        in
          object (self)
            method accepte =
              fun (_p0 : jVisiteur) ->
                let _p0 = _p0#_get_jni_jVisiteur
                in
                  Jni.call_void_method jni_ref __mid_accepte
                    [| Jni.Obj _p0 |]
            method _get_jni_jFormule = jni_ref
            inherit JniHierarchy.top jni_ref
          end
and _capsule_jConstante =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Constante"
  in
    let _ =
      if
        not
          (Jni.is_assignable_from clazz
             (Jni.find_class "fr/upmc/infop6/mlo/Formule"))
      then
        failwith
          "Wrong super class in IDL : fr.upmc.infop6.mlo.Constante not extends fr.upmc.infop6.mlo.Formule."
      else ()
    in
      let __mid_valeur =
        try Jni.get_methodID clazz "valeur" "()Z"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Constante\" : \"boolean valeur()\"."
      in
        let __mid_accepte =
          try
            Jni.get_methodID clazz "accepte"
              "(Lfr/upmc/infop6/mlo/Visiteur;)V"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Constante\" : \"void accepte(fr.upmc.infop6.mlo.Visiteur)\"."
        in
          fun (jni_ref : _jni_jConstante) ->
            let _ =
              if Jni.is_null jni_ref
              then
                raise
                  (JniHierarchy.Null_object "fr/upmc/infop6/mlo/Constante")
              else ()
            in
              object (self)
                method valeur =
                  fun () ->
                    Jni.call_boolean_method jni_ref __mid_valeur [|  |]
                method accepte =
                  fun (_p0 : jVisiteur) ->
                    let _p0 = _p0#_get_jni_jVisiteur
                    in
                      Jni.call_void_method jni_ref __mid_accepte
                        [| Jni.Obj _p0 |]
                method _get_jni_jConstante = jni_ref
                method _get_jni_jFormule = jni_ref
                inherit JniHierarchy.top jni_ref
              end
and _capsule_jVar = let clazz = Jni.find_class "fr/upmc/infop6/mlo/Var"
  in
    let _ =
      if
        not
          (Jni.is_assignable_from clazz
             (Jni.find_class "fr/upmc/infop6/mlo/Formule"))
      then
        failwith
          "Wrong super class in IDL : fr.upmc.infop6.mlo.Var not extends fr.upmc.infop6.mlo.Formule."
      else ()
    in
      let __mid_ident =
        try Jni.get_methodID clazz "ident" "()Ljava/lang/String;"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Var\" : \"string ident()\"."
      in
        let __mid_accepte =
          try
            Jni.get_methodID clazz "accepte"
              "(Lfr/upmc/infop6/mlo/Visiteur;)V"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Var\" : \"void accepte(fr.upmc.infop6.mlo.Visiteur)\"."
        in
          fun (jni_ref : _jni_jVar) ->
            let _ =
              if Jni.is_null jni_ref
              then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/Var")
              else ()
            in
              object (self)
                method ident =
                  fun () ->
                    Jni.string_from_java
                      (Jni.call_object_method jni_ref __mid_ident [|  |])
                method accepte =
                  fun (_p0 : jVisiteur) ->
                    let _p0 = _p0#_get_jni_jVisiteur
                    in
                      Jni.call_void_method jni_ref __mid_accepte
                        [| Jni.Obj _p0 |]
                method _get_jni_jVar = jni_ref
                method _get_jni_jFormule = jni_ref
                inherit JniHierarchy.top jni_ref
              end
and _capsule_jNon = let clazz = Jni.find_class "fr/upmc/infop6/mlo/Non"
  in
    let _ =
      if
        not
          (Jni.is_assignable_from clazz
             (Jni.find_class "fr/upmc/infop6/mlo/Formule"))
      then
        failwith
          "Wrong super class in IDL : fr.upmc.infop6.mlo.Non not extends fr.upmc.infop6.mlo.Formule."
      else ()
    in
      let __mid_sous_formule =
        try
          Jni.get_methodID clazz "sous_formule"
            "()Lfr/upmc/infop6/mlo/Formule;"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Non\" : \"fr.upmc.infop6.mlo.Formule sous_formule()\"."
      in
        let __mid_accepte =
          try
            Jni.get_methodID clazz "accepte"
              "(Lfr/upmc/infop6/mlo/Visiteur;)V"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Non\" : \"void accepte(fr.upmc.infop6.mlo.Visiteur)\"."
        in
          fun (jni_ref : _jni_jNon) ->
            let _ =
              if Jni.is_null jni_ref
              then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/Non")
              else ()
            in
              object (self)
                method sous_formule =
                  fun () ->
                    (new _capsule_jFormule
                       (Jni.call_object_method jni_ref __mid_sous_formule
                          [|  |]) :
                      jFormule)
                method accepte =
                  fun (_p0 : jVisiteur) ->
                    let _p0 = _p0#_get_jni_jVisiteur
                    in
                      Jni.call_void_method jni_ref __mid_accepte
                        [| Jni.Obj _p0 |]
                method _get_jni_jNon = jni_ref
                method _get_jni_jFormule = jni_ref
                inherit JniHierarchy.top jni_ref
              end
and _capsule_jOpBin = let clazz = Jni.find_class "fr/upmc/infop6/mlo/OpBin"
  in
    let _ =
      if
        not
          (Jni.is_assignable_from clazz
             (Jni.find_class "fr/upmc/infop6/mlo/Formule"))
      then
        failwith
          "Wrong super class in IDL : fr.upmc.infop6.mlo.OpBin not extends fr.upmc.infop6.mlo.Formule."
      else ()
    in
      let __mid_sous_formule_d =
        try
          Jni.get_methodID clazz "sous_formule_d"
            "()Lfr/upmc/infop6/mlo/Formule;"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.OpBin\" : \"fr.upmc.infop6.mlo.Formule sous_formule_d()\"."
      in
        let __mid_sous_formule_g =
          try
            Jni.get_methodID clazz "sous_formule_g"
              "()Lfr/upmc/infop6/mlo/Formule;"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.OpBin\" : \"fr.upmc.infop6.mlo.Formule sous_formule_g()\"."
        in
          let __mid_accepte =
            try
              Jni.get_methodID clazz "accepte"
                "(Lfr/upmc/infop6/mlo/Visiteur;)V"
            with
            | _ ->
                failwith
                  "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Formule\" : \"void accepte(fr.upmc.infop6.mlo.Visiteur)\"."
          in
            fun (jni_ref : _jni_jOpBin) ->
              let _ =
                if Jni.is_null jni_ref
                then
                  raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/OpBin")
                else ()
              in
                object (self)
                  method sous_formule_d =
                    fun () ->
                      (new _capsule_jFormule
                         (Jni.call_object_method jni_ref __mid_sous_formule_d
                            [|  |]) :
                        jFormule)
                  method sous_formule_g =
                    fun () ->
                      (new _capsule_jFormule
                         (Jni.call_object_method jni_ref __mid_sous_formule_g
                            [|  |]) :
                        jFormule)
                  method accepte =
                    fun (_p0 : jVisiteur) ->
                      let _p0 = _p0#_get_jni_jVisiteur
                      in
                        Jni.call_void_method jni_ref __mid_accepte
                          [| Jni.Obj _p0 |]
                  method _get_jni_jOpBin = jni_ref
                  method _get_jni_jFormule = jni_ref
                  inherit JniHierarchy.top jni_ref
                end
and _capsule_jEt = let clazz = Jni.find_class "fr/upmc/infop6/mlo/Et"
  in
    let _ =
      if
        not
          (Jni.is_assignable_from clazz
             (Jni.find_class "fr/upmc/infop6/mlo/OpBin"))
      then
        failwith
          "Wrong super class in IDL : fr.upmc.infop6.mlo.Et not extends fr.upmc.infop6.mlo.OpBin."
      else ()
    in
      let __mid_sous_formule_d =
        try
          Jni.get_methodID clazz "sous_formule_d"
            "()Lfr/upmc/infop6/mlo/Formule;"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.OpBin\" : \"fr.upmc.infop6.mlo.Formule sous_formule_d()\"."
      in
        let __mid_sous_formule_g =
          try
            Jni.get_methodID clazz "sous_formule_g"
              "()Lfr/upmc/infop6/mlo/Formule;"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.OpBin\" : \"fr.upmc.infop6.mlo.Formule sous_formule_g()\"."
        in
          let __mid_accepte =
            try
              Jni.get_methodID clazz "accepte"
                "(Lfr/upmc/infop6/mlo/Visiteur;)V"
            with
            | _ ->
                failwith
                  "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Et\" : \"void accepte(fr.upmc.infop6.mlo.Visiteur)\"."
          in
            fun (jni_ref : _jni_jEt) ->
              let _ =
                if Jni.is_null jni_ref
                then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/Et")
                else ()
              in
                object (self)
                  method sous_formule_d =
                    fun () ->
                      (new _capsule_jFormule
                         (Jni.call_object_method jni_ref __mid_sous_formule_d
                            [|  |]) :
                        jFormule)
                  method sous_formule_g =
                    fun () ->
                      (new _capsule_jFormule
                         (Jni.call_object_method jni_ref __mid_sous_formule_g
                            [|  |]) :
                        jFormule)
                  method accepte =
                    fun (_p0 : jVisiteur) ->
                      let _p0 = _p0#_get_jni_jVisiteur
                      in
                        Jni.call_void_method jni_ref __mid_accepte
                          [| Jni.Obj _p0 |]
                  method _get_jni_jEt = jni_ref
                  method _get_jni_jFormule = jni_ref
                  method _get_jni_jOpBin = jni_ref
                  inherit JniHierarchy.top jni_ref
                end
and _capsule_jOu = let clazz = Jni.find_class "fr/upmc/infop6/mlo/Ou"
  in
    let _ =
      if
        not
          (Jni.is_assignable_from clazz
             (Jni.find_class "fr/upmc/infop6/mlo/OpBin"))
      then
        failwith
          "Wrong super class in IDL : fr.upmc.infop6.mlo.Ou not extends fr.upmc.infop6.mlo.OpBin."
      else ()
    in
      let __mid_sous_formule_d =
        try
          Jni.get_methodID clazz "sous_formule_d"
            "()Lfr/upmc/infop6/mlo/Formule;"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.OpBin\" : \"fr.upmc.infop6.mlo.Formule sous_formule_d()\"."
      in
        let __mid_sous_formule_g =
          try
            Jni.get_methodID clazz "sous_formule_g"
              "()Lfr/upmc/infop6/mlo/Formule;"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.OpBin\" : \"fr.upmc.infop6.mlo.Formule sous_formule_g()\"."
        in
          let __mid_accepte =
            try
              Jni.get_methodID clazz "accepte"
                "(Lfr/upmc/infop6/mlo/Visiteur;)V"
            with
            | _ ->
                failwith
                  "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Ou\" : \"void accepte(fr.upmc.infop6.mlo.Visiteur)\"."
          in
            fun (jni_ref : _jni_jOu) ->
              let _ =
                if Jni.is_null jni_ref
                then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/Ou")
                else ()
              in
                object (self)
                  method sous_formule_d =
                    fun () ->
                      (new _capsule_jFormule
                         (Jni.call_object_method jni_ref __mid_sous_formule_d
                            [|  |]) :
                        jFormule)
                  method sous_formule_g =
                    fun () ->
                      (new _capsule_jFormule
                         (Jni.call_object_method jni_ref __mid_sous_formule_g
                            [|  |]) :
                        jFormule)
                  method accepte =
                    fun (_p0 : jVisiteur) ->
                      let _p0 = _p0#_get_jni_jVisiteur
                      in
                        Jni.call_void_method jni_ref __mid_accepte
                          [| Jni.Obj _p0 |]
                  method _get_jni_jOu = jni_ref
                  method _get_jni_jFormule = jni_ref
                  method _get_jni_jOpBin = jni_ref
                  inherit JniHierarchy.top jni_ref
                end
and _capsule_jVisiteur =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Visiteur"
  in
    let __mid_visite_var =
      try Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Var;)V"
      with
      | _ ->
          failwith
            "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Var)\"."
    in
      let __mid_visite_ou =
        try Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Ou;)V"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Ou)\"."
      in
        let __mid_visite_et =
          try Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Et;)V"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Et)\"."
        in
          let __mid_visite_non =
            try Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Non;)V"
            with
            | _ ->
                failwith
                  "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Non)\"."
          in
            let __mid_visite_cst =
              try
                Jni.get_methodID clazz "visite"
                  "(Lfr/upmc/infop6/mlo/Constante;)V"
              with
              | _ ->
                  failwith
                    "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Constante)\"."
            in
              fun (jni_ref : _jni_jVisiteur) ->
                let _ =
                  if Jni.is_null jni_ref
                  then
                    raise
                      (JniHierarchy.Null_object "fr/upmc/infop6/mlo/Visiteur")
                  else ()
                in
                  object (self)
                    method visite_var =
                      fun (_p0 : jVar) ->
                        let _p0 = _p0#_get_jni_jVar
                        in
                          Jni.call_void_method jni_ref __mid_visite_var
                            [| Jni.Obj _p0 |]
                    method visite_ou =
                      fun (_p0 : jOu) ->
                        let _p0 = _p0#_get_jni_jOu
                        in
                          Jni.call_void_method jni_ref __mid_visite_ou
                            [| Jni.Obj _p0 |]
                    method visite_et =
                      fun (_p0 : jEt) ->
                        let _p0 = _p0#_get_jni_jEt
                        in
                          Jni.call_void_method jni_ref __mid_visite_et
                            [| Jni.Obj _p0 |]
                    method visite_non =
                      fun (_p0 : jNon) ->
                        let _p0 = _p0#_get_jni_jNon
                        in
                          Jni.call_void_method jni_ref __mid_visite_non
                            [| Jni.Obj _p0 |]
                    method visite_cst =
                      fun (_p0 : jConstante) ->
                        let _p0 = _p0#_get_jni_jConstante
                        in
                          Jni.call_void_method jni_ref __mid_visite_cst
                            [| Jni.Obj _p0 |]
                    method _get_jni_jVisiteur = jni_ref
                    inherit JniHierarchy.top jni_ref
                  end
and _capsule_jVisiteurTS =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/VisiteurTS"
  in
    let _ =
      if
        not
          (Jni.is_assignable_from clazz
             (Jni.find_class "fr/upmc/infop6/mlo/Visiteur"))
      then
        failwith
          "Wrong implemented interface in IDL : fr.upmc.infop6.mlo.VisiteurTS does not implements fr.upmc.infop6.mlo.Visiteur."
      else ()
    in
      let __mid_get_res =
        try Jni.get_methodID clazz "get_res" "()Ljava/lang/String;"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.VisiteurTS\" : \"string get_res()\"."
      in
        let __mid_visite_var =
          try Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Var;)V"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.VisiteurTS\" : \"void visite(fr.upmc.infop6.mlo.Var)\"."
        in
          let __mid_visite_ou =
            try Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Ou;)V"
            with
            | _ ->
                failwith
                  "Unknown method from IDL in class \"fr.upmc.infop6.mlo.VisiteurTS\" : \"void visite(fr.upmc.infop6.mlo.Ou)\"."
          in
            let __mid_visite_et =
              try
                Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Et;)V"
              with
              | _ ->
                  failwith
                    "Unknown method from IDL in class \"fr.upmc.infop6.mlo.VisiteurTS\" : \"void visite(fr.upmc.infop6.mlo.Et)\"."
            in
              let __mid_visite_non =
                try
                  Jni.get_methodID clazz "visite"
                    "(Lfr/upmc/infop6/mlo/Non;)V"
                with
                | _ ->
                    failwith
                      "Unknown method from IDL in class \"fr.upmc.infop6.mlo.VisiteurTS\" : \"void visite(fr.upmc.infop6.mlo.Non)\"."
              in
                let __mid_visite_cst =
                  try
                    Jni.get_methodID clazz "visite"
                      "(Lfr/upmc/infop6/mlo/Constante;)V"
                  with
                  | _ ->
                      failwith
                        "Unknown method from IDL in class \"fr.upmc.infop6.mlo.VisiteurTS\" : \"void visite(fr.upmc.infop6.mlo.Constante)\"."
                in
                  fun (jni_ref : _jni_jVisiteurTS) ->
                    let _ =
                      if Jni.is_null jni_ref
                      then
                        raise
                          (JniHierarchy.Null_object
                             "fr/upmc/infop6/mlo/VisiteurTS")
                      else ()
                    in
                      object (self)
                        method get_res =
                          fun () ->
                            Jni.string_from_java
                              (Jni.call_object_method jni_ref __mid_get_res
                                 [|  |])
                        method visite_var =
                          fun (_p0 : jVar) ->
                            let _p0 = _p0#_get_jni_jVar
                            in
                              Jni.call_void_method jni_ref __mid_visite_var
                                [| Jni.Obj _p0 |]
                        method visite_ou =
                          fun (_p0 : jOu) ->
                            let _p0 = _p0#_get_jni_jOu
                            in
                              Jni.call_void_method jni_ref __mid_visite_ou
                                [| Jni.Obj _p0 |]
                        method visite_et =
                          fun (_p0 : jEt) ->
                            let _p0 = _p0#_get_jni_jEt
                            in
                              Jni.call_void_method jni_ref __mid_visite_et
                                [| Jni.Obj _p0 |]
                        method visite_non =
                          fun (_p0 : jNon) ->
                            let _p0 = _p0#_get_jni_jNon
                            in
                              Jni.call_void_method jni_ref __mid_visite_non
                                [| Jni.Obj _p0 |]
                        method visite_cst =
                          fun (_p0 : jConstante) ->
                            let _p0 = _p0#_get_jni_jConstante
                            in
                              Jni.call_void_method jni_ref __mid_visite_cst
                                [| Jni.Obj _p0 |]
                        method _get_jni_jVisiteurTS = jni_ref
                        method _get_jni_jVisiteur = jni_ref
                        inherit JniHierarchy.top jni_ref
                      end
and _capsule_jVisiteurML =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/VisiteurML"
  in
    let _ =
      if
        not
          (Jni.is_assignable_from clazz
             (Jni.find_class "fr/upmc/infop6/mlo/Visiteur"))
      then
        failwith
          "Wrong implemented interface in IDL : fr.upmc.infop6.mlo.VisiteurML does not implements fr.upmc.infop6.mlo.Visiteur."
      else ()
    in
      let __mid_get_res =
        try Jni.get_methodID clazz "get_res" "()Ljava/lang/String;"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"fr.upmc.infop6.mlo.VisiteurML\" : \"string get_res()\"."
      in
        let __mid_visite_var =
          try Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Var;)V"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Var)\"."
        in
          let __mid_visite_ou =
            try Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Ou;)V"
            with
            | _ ->
                failwith
                  "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Ou)\"."
          in
            let __mid_visite_et =
              try
                Jni.get_methodID clazz "visite" "(Lfr/upmc/infop6/mlo/Et;)V"
              with
              | _ ->
                  failwith
                    "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Et)\"."
            in
              let __mid_visite_non =
                try
                  Jni.get_methodID clazz "visite"
                    "(Lfr/upmc/infop6/mlo/Non;)V"
                with
                | _ ->
                    failwith
                      "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Non)\"."
              in
                let __mid_visite_cst =
                  try
                    Jni.get_methodID clazz "visite"
                      "(Lfr/upmc/infop6/mlo/Constante;)V"
                  with
                  | _ ->
                      failwith
                        "Unknown method from IDL in class \"fr.upmc.infop6.mlo.Visiteur\" : \"void visite(fr.upmc.infop6.mlo.Constante)\"."
                in
                  fun (jni_ref : _jni_jVisiteurML) ->
                    let _ =
                      if Jni.is_null jni_ref
                      then
                        raise
                          (JniHierarchy.Null_object
                             "fr/upmc/infop6/mlo/VisiteurML")
                      else ()
                    in
                      object (self)
                        method get_res =
                          fun () ->
                            Jni.string_from_java
                              (Jni.call_object_method jni_ref __mid_get_res
                                 [|  |])
                        method visite_var =
                          fun (_p0 : jVar) ->
                            let _p0 = _p0#_get_jni_jVar
                            in
                              Jni.call_void_method jni_ref __mid_visite_var
                                [| Jni.Obj _p0 |]
                        method visite_ou =
                          fun (_p0 : jOu) ->
                            let _p0 = _p0#_get_jni_jOu
                            in
                              Jni.call_void_method jni_ref __mid_visite_ou
                                [| Jni.Obj _p0 |]
                        method visite_et =
                          fun (_p0 : jEt) ->
                            let _p0 = _p0#_get_jni_jEt
                            in
                              Jni.call_void_method jni_ref __mid_visite_et
                                [| Jni.Obj _p0 |]
                        method visite_non =
                          fun (_p0 : jNon) ->
                            let _p0 = _p0#_get_jni_jNon
                            in
                              Jni.call_void_method jni_ref __mid_visite_non
                                [| Jni.Obj _p0 |]
                        method visite_cst =
                          fun (_p0 : jConstante) ->
                            let _p0 = _p0#_get_jni_jConstante
                            in
                              Jni.call_void_method jni_ref __mid_visite_cst
                                [| Jni.Obj _p0 |]
                        method _get_jni_jVisiteurML = jni_ref
                        method _get_jni_jVisiteur = jni_ref
                        inherit JniHierarchy.top jni_ref
                      end
and _capsule_jMainML = let clazz = Jni.find_class "fr/upmc/infop6/mlo/MainML"
  in
    let __mid_cree_visiteur =
      try
        Jni.get_methodID clazz "cree_visiteur"
          "()Lfr/upmc/infop6/mlo/VisiteurML;"
      with
      | _ ->
          failwith
            "Unknown method from IDL in class \"fr.upmc.infop6.mlo.MainML\" : \"fr.upmc.infop6.mlo.VisiteurML cree_visiteur()\"."
    in
      fun (jni_ref : _jni_jMainML) ->
        let _ =
          if Jni.is_null jni_ref
          then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/MainML")
          else ()
        in
          object (self)
            method cree_visiteur =
              fun () ->
                (new _capsule_jVisiteurML
                   (Jni.call_object_method jni_ref __mid_cree_visiteur [|  |]) :
                  jVisiteurML)
            method _get_jni_jMainML = jni_ref
            inherit JniHierarchy.top jni_ref
          end
and _capsule_jMainJava =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/MainJava"
  in
    fun (jni_ref : _jni_jMainJava) ->
      let _ =
        if Jni.is_null jni_ref
        then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/MainJava")
        else ()
      in
        object (self)
          method _get_jni_jMainJava = jni_ref
          inherit JniHierarchy.top jni_ref
        end
and virtual _souche_jVisiteurML =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/VisiteurML"
  in
    fun (jni_ref : _jni_jVisiteurML) ->
      let _ =
        if Jni.is_null jni_ref
        then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/VisiteurML")
        else ()
      in
        object (self)
          method _stub_get_res = Jni.string_to_java (self#get_res ())
          method _stub_visite_var =
            fun (_p0 : _jni_jVar) ->
              let _p0 : jVar = new _capsule_jVar _p0 in self#visite_var _p0
          method _stub_visite_ou =
            fun (_p0 : _jni_jOu) ->
              let _p0 : jOu = new _capsule_jOu _p0 in self#visite_ou _p0
          method _stub_visite_et =
            fun (_p0 : _jni_jEt) ->
              let _p0 : jEt = new _capsule_jEt _p0 in self#visite_et _p0
          method _stub_visite_non =
            fun (_p0 : _jni_jNon) ->
              let _p0 : jNon = new _capsule_jNon _p0 in self#visite_non _p0
          method _stub_visite_cst =
            fun (_p0 : _jni_jConstante) ->
              let _p0 : jConstante = new _capsule_jConstante _p0
              in self#visite_cst _p0
          method virtual get_res : unit -> string
          method virtual visite_var : jVar -> unit
          method virtual visite_ou : jOu -> unit
          method virtual visite_et : jEt -> unit
          method virtual visite_non : jNon -> unit
          method virtual visite_cst : jConstante -> unit
          method _get_jni_jVisiteurML = jni_ref
          method _get_jni_jVisiteur = jni_ref
          inherit JniHierarchy.top jni_ref
        end
and virtual _souche_jMainML =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/MainML"
  in
    fun (jni_ref : _jni_jMainML) ->
      let _ =
        if Jni.is_null jni_ref
        then raise (JniHierarchy.Null_object "fr/upmc/infop6/mlo/MainML")
        else ()
      in
        object (self)
          method _stub_cree_visiteur =
            (self#cree_visiteur ())#_get_jni_jVisiteurML
          method virtual cree_visiteur : unit -> jVisiteurML
          method _get_jni_jMainML = jni_ref
          inherit JniHierarchy.top jni_ref
        end;;
let jFormule_of_top (o : JniHierarchy.top) : jFormule =
  new _capsule_jFormule (__jni_jFormule_of_jni_obj o#_get_jniobj);;
let jConstante_of_top (o : JniHierarchy.top) : jConstante =
  new _capsule_jConstante (__jni_jConstante_of_jni_obj o#_get_jniobj);;
let jVar_of_top (o : JniHierarchy.top) : jVar =
  new _capsule_jVar (__jni_jVar_of_jni_obj o#_get_jniobj);;
let jNon_of_top (o : JniHierarchy.top) : jNon =
  new _capsule_jNon (__jni_jNon_of_jni_obj o#_get_jniobj);;
let jOpBin_of_top (o : JniHierarchy.top) : jOpBin =
  new _capsule_jOpBin (__jni_jOpBin_of_jni_obj o#_get_jniobj);;
let jEt_of_top (o : JniHierarchy.top) : jEt =
  new _capsule_jEt (__jni_jEt_of_jni_obj o#_get_jniobj);;
let jOu_of_top (o : JniHierarchy.top) : jOu =
  new _capsule_jOu (__jni_jOu_of_jni_obj o#_get_jniobj);;
let jVisiteur_of_top (o : JniHierarchy.top) : jVisiteur =
  new _capsule_jVisiteur (__jni_jVisiteur_of_jni_obj o#_get_jniobj);;
let jVisiteurTS_of_top (o : JniHierarchy.top) : jVisiteurTS =
  new _capsule_jVisiteurTS (__jni_jVisiteurTS_of_jni_obj o#_get_jniobj);;
let jVisiteurML_of_top (o : JniHierarchy.top) : jVisiteurML =
  new _capsule_jVisiteurML (__jni_jVisiteurML_of_jni_obj o#_get_jniobj);;
let jMainML_of_top (o : JniHierarchy.top) : jMainML =
  new _capsule_jMainML (__jni_jMainML_of_jni_obj o#_get_jniobj);;
let jMainJava_of_top (o : JniHierarchy.top) : jMainJava =
  new _capsule_jMainJava (__jni_jMainJava_of_jni_obj o#_get_jniobj);;
let _instance_of_jFormule =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Formule"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jConstante =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Constante"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jVar =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Var"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jNon =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Non"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jOpBin =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/OpBin"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jEt =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Et"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jOu =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Ou"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jVisiteur =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Visiteur"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jVisiteurTS =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/VisiteurTS"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jVisiteurML =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/VisiteurML"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jMainML =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/MainML"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _instance_of_jMainJava =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/MainJava"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _new_jArray_jFormule size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/Formule")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jFormule jniobj)
      (fun obj -> obj#_get_jni_jFormule) java_obj;;
let jArray_init_jFormule size f =
  let a = _new_jArray_jFormule size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jConstante size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/Constante")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jConstante jniobj)
      (fun obj -> obj#_get_jni_jConstante) java_obj;;
let jArray_init_jConstante size f =
  let a = _new_jArray_jConstante size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jVar size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/Var")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jVar jniobj)
      (fun obj -> obj#_get_jni_jVar) java_obj;;
let jArray_init_jVar size f =
  let a = _new_jArray_jVar size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jNon size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/Non")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jNon jniobj)
      (fun obj -> obj#_get_jni_jNon) java_obj;;
let jArray_init_jNon size f =
  let a = _new_jArray_jNon size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jOpBin size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/OpBin")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jOpBin jniobj)
      (fun obj -> obj#_get_jni_jOpBin) java_obj;;
let jArray_init_jOpBin size f =
  let a = _new_jArray_jOpBin size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jEt size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/Et")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jEt jniobj)
      (fun obj -> obj#_get_jni_jEt) java_obj;;
let jArray_init_jEt size f =
  let a = _new_jArray_jEt size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jOu size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/Ou")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jOu jniobj)
      (fun obj -> obj#_get_jni_jOu) java_obj;;
let jArray_init_jOu size f =
  let a = _new_jArray_jOu size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jVisiteur size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/Visiteur")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jVisiteur jniobj)
      (fun obj -> obj#_get_jni_jVisiteur) java_obj;;
let jArray_init_jVisiteur size f =
  let a = _new_jArray_jVisiteur size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jVisiteurTS size =
  let java_obj =
    Jni.new_object_array size
      (Jni.find_class "fr/upmc/infop6/mlo/VisiteurTS")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element
      (fun jniobj -> new _capsule_jVisiteurTS jniobj)
      (fun obj -> obj#_get_jni_jVisiteurTS) java_obj;;
let jArray_init_jVisiteurTS size f =
  let a = _new_jArray_jVisiteurTS size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jVisiteurML size =
  let java_obj =
    Jni.new_object_array size
      (Jni.find_class "fr/upmc/infop6/mlo/VisiteurML")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element
      (fun jniobj -> new _capsule_jVisiteurML jniobj)
      (fun obj -> obj#_get_jni_jVisiteurML) java_obj;;
let jArray_init_jVisiteurML size f =
  let a = _new_jArray_jVisiteurML size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jMainML size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/MainML")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jMainML jniobj)
      (fun obj -> obj#_get_jni_jMainML) java_obj;;
let jArray_init_jMainML size f =
  let a = _new_jArray_jMainML size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _new_jArray_jMainJava size =
  let java_obj =
    Jni.new_object_array size (Jni.find_class "fr/upmc/infop6/mlo/MainJava")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jMainJava jniobj)
      (fun obj -> obj#_get_jni_jMainJava) java_obj;;
let jArray_init_jMainJava size f =
  let a = _new_jArray_jMainJava size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _init_constante =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Constante" in
  let id =
    try Jni.get_methodID clazz "<init>" "(Z)V"
    with
    | _ ->
        failwith
          "Unknown constructor from IDL in class \"fr.upmc.infop6.mlo.Constante\" : \"Constante(boolean)\"."
  in
    fun (java_obj : _jni_jConstante) _p0 ->
      let _p0 = _p0
      in
        Jni.call_nonvirtual_void_method java_obj clazz id
          [| Jni.Boolean _p0 |];;
let _init_var =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Var" in
  let id =
    try Jni.get_methodID clazz "<init>" "(Ljava/lang/String;)V"
    with
    | _ ->
        failwith
          "Unknown constructor from IDL in class \"fr.upmc.infop6.mlo.Var\" : \"Var(string)\"."
  in
    fun (java_obj : _jni_jVar) _p0 ->
      let _p0 = Jni.string_to_java _p0
      in Jni.call_nonvirtual_void_method java_obj clazz id [| Jni.Obj _p0 |];;
let _init_non =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Non" in
  let id =
    try Jni.get_methodID clazz "<init>" "(Lfr/upmc/infop6/mlo/Formule;)V"
    with
    | _ ->
        failwith
          "Unknown constructor from IDL in class \"fr.upmc.infop6.mlo.Non\" : \"Non(fr.upmc.infop6.mlo.Formule)\"."
  in
    fun (java_obj : _jni_jNon) (_p0 : jFormule) ->
      let _p0 = _p0#_get_jni_jFormule
      in Jni.call_nonvirtual_void_method java_obj clazz id [| Jni.Obj _p0 |];;
let _init_et =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Et" in
  let id =
    try
      Jni.get_methodID clazz "<init>"
        "(Lfr/upmc/infop6/mlo/Formule;Lfr/upmc/infop6/mlo/Formule;)V"
    with
    | _ ->
        failwith
          "Unknown constructor from IDL in class \"fr.upmc.infop6.mlo.Et\" : \"Et(fr.upmc.infop6.mlo.Formule,fr.upmc.infop6.mlo.Formule)\"."
  in
    fun (java_obj : _jni_jEt) (_p0 : jFormule) (_p1 : jFormule) ->
      let _p1 = _p1#_get_jni_jFormule in
      let _p0 = _p0#_get_jni_jFormule
      in
        Jni.call_nonvirtual_void_method java_obj clazz id
          [| Jni.Obj _p0; Jni.Obj _p1 |];;
let _init_ou =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/Ou" in
  let id =
    try
      Jni.get_methodID clazz "<init>"
        "(Lfr/upmc/infop6/mlo/Formule;Lfr/upmc/infop6/mlo/Formule;)V"
    with
    | _ ->
        failwith
          "Unknown constructor from IDL in class \"fr.upmc.infop6.mlo.Ou\" : \"Ou(fr.upmc.infop6.mlo.Formule,fr.upmc.infop6.mlo.Formule)\"."
  in
    fun (java_obj : _jni_jOu) (_p0 : jFormule) (_p1 : jFormule) ->
      let _p1 = _p1#_get_jni_jFormule in
      let _p0 = _p0#_get_jni_jFormule
      in
        Jni.call_nonvirtual_void_method java_obj clazz id
          [| Jni.Obj _p0; Jni.Obj _p1 |];;
let _init_visiteurTS =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/VisiteurTS" in
  let id =
    try Jni.get_methodID clazz "<init>" "()V"
    with
    | _ ->
        failwith
          "Unknown constructor from IDL in class \"fr.upmc.infop6.mlo.VisiteurTS\" : \"VisiteurTS()\"."
  in
    fun (java_obj : _jni_jVisiteurTS) ->
      Jni.call_nonvirtual_void_method java_obj clazz id [|  |];;
let _funinit__stub_jVisiteurML =
  let clazz = Jni.find_class "callback/fr/upmc/infop6/mlo/VisiteurML" in
  let id =
    Jni.get_methodID clazz "<init>" "(Lfr/inria/caml/camljava/Callback;)V"
  in
    fun (java_obj : _jni_jVisiteurML) _p0 ->
      let _p0 = Jni.wrap_object _p0
      in Jni.call_nonvirtual_void_method java_obj clazz id [| Jni.Obj _p0 |];;
let _funinit__stub_jMainML =
  let clazz = Jni.find_class "callback/fr/upmc/infop6/mlo/MainML" in
  let id =
    Jni.get_methodID clazz "<init>" "(Lfr/inria/caml/camljava/Callback;)V"
  in
    fun (java_obj : _jni_jMainML) _p0 ->
      let _p0 = Jni.wrap_object _p0
      in Jni.call_nonvirtual_void_method java_obj clazz id [| Jni.Obj _p0 |];;
class constante _p0 =
  let java_obj = _alloc_jConstante ()
  in let _ = _init_constante java_obj _p0
    in object (self) inherit _capsule_jConstante java_obj end;;
class var _p0 =
  let java_obj = _alloc_jVar ()
  in let _ = _init_var java_obj _p0
    in object (self) inherit _capsule_jVar java_obj end;;
class non _p0 =
  let java_obj = _alloc_jNon ()
  in let _ = _init_non java_obj _p0
    in object (self) inherit _capsule_jNon java_obj end;;
class et _p0 _p1 =
  let java_obj = _alloc_jEt ()
  in let _ = _init_et java_obj _p0 _p1
    in object (self) inherit _capsule_jEt java_obj end;;
class ou _p0 _p1 =
  let java_obj = _alloc_jOu ()
  in let _ = _init_ou java_obj _p0 _p1
    in object (self) inherit _capsule_jOu java_obj end;;
class visiteurTS () =
  let java_obj = _alloc_jVisiteurTS ()
  in let _ = _init_visiteurTS java_obj
    in object (self) inherit _capsule_jVisiteurTS java_obj end;;
class virtual _stub_jVisiteurML () =
  let java_obj = _alloc__stub_jVisiteurML ()
  in
    object (self)
      initializer
        _funinit__stub_jVisiteurML java_obj (self :> _stub_jVisiteurML)
      inherit _souche_jVisiteurML java_obj
    end;;
class virtual _stub_jMainML () =
  let java_obj = _alloc__stub_jMainML ()
  in
    object (self)
      initializer _funinit__stub_jMainML java_obj (self :> _stub_jMainML)
      inherit _souche_jMainML java_obj
    end;;
let fr_upmc_infop6_mlo_jMainJava__main =
  let clazz = Jni.find_class "fr/upmc/infop6/mlo/MainJava" in
  let id =
    try Jni.get_static_methodID clazz "main" "(Lfr/upmc/infop6/mlo/MainML;)V"
    with
    | _ ->
        failwith
          "Unknown static method from IDL in class \"fr.upmc.infop6.mlo.MainJava\" : \"void main(fr.upmc.infop6.mlo.MainML)\"."
  in
    fun (_p0 : jMainML) ->
      let _p0 = _p0#_get_jni_jMainML
      in Jni.call_static_void_method clazz id [| Jni.Obj _p0 |];;
