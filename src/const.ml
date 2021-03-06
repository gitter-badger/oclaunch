(******************************************************************************)
(* Copyright © Joly Clément, 2014-2015                                        *)
(*                                                                            *)
(*  leowzukw@vmail.me                                                         *)
(*                                                                            *)
(*  Ce logiciel est un programme informatique servant à exécuter              *)
(*  automatiquement des programmes à l'ouverture du terminal.                 *)
(*                                                                            *)
(*  Ce logiciel est régi par la licence CeCILL soumise au droit français et   *)
(*  respectant les principes de diffusion des logiciels libres. Vous pouvez   *)
(*  utiliser, modifier et/ou redistribuer ce programme sous les conditions    *)
(*  de la licence CeCILL telle que diffusée par le CEA, le CNRS et l'INRIA    *)
(*  sur le site "http://www.cecill.info".                                     *)
(*                                                                            *)
(*  En contrepartie de l'accessibilité au code source et des droits de copie, *)
(*  de modification et de redistribution accordés par cette licence, il n'est *)
(*  offert aux utilisateurs qu'une garantie limitée.  Pour les mêmes raisons, *)
(*  seule une responsabilité restreinte pèse sur l'auteur du programme,  le   *)
(*  titulaire des droits patrimoniaux et les concédants successifs.           *)
(*                                                                            *)
(*  A cet égard  l'attention de l'utilisateur est attirée sur les risques     *)
(*  associés au chargement,  à l'utilisation,  à la modification et/ou au     *)
(*  développement et à la reproduction du logiciel par l'utilisateur étant    *)
(*  donné sa spécificité de logiciel libre, qui peut le rendre complexe à     *)
(*  manipuler et qui le réserve donc à des développeurs et des professionnels *)
(*  avertis possédant  des  connaissances  informatiques approfondies.  Les   *)
(*  utilisateurs sont donc invités à charger  et  tester  l'adéquation  du    *)
(*  logiciel à leurs besoins dans des conditions permettant d'assurer la      *)
(*  sécurité de leurs systèmes et ou de leurs données et, plus généralement,  *)
(*  à l'utiliser et l'exploiter dans les mêmes conditions de sécurité.        *)
(*                                                                            *)
(*  Le fait que vous puissiez accéder à cet en-tête signifie que vous avez    *)
(*  pris connaissance de la licence CeCILL, et que vous en avez accepté les   *)
(*  termes.                                                                   *)
(******************************************************************************)

(* File to stock configuration variables *)

open Core.Std;;

(* General function to get environment variables
 * exp: exception*)
let get_var ?(exp=false) ?default name =
    let msg =
        lazy (sprintf "ERROR: Couldn't get %s. Please consider setting it." name)
    in
    (* Return value or exception *)
    let run_exn () =
        match exp with
        | true -> failwith (Lazy.force msg)
        | false -> print_endline (Lazy.force msg); ""
    in
    (* Get the var *)
    Sys.getenv name
    |> (function
        | Some x -> x
        | None ->
                match default with
                | None -> run_exn ()
                | Some default -> default)
;;

(* Get current home *)
let home =
    lazy (get_var ~exp:true "HOME")
;;

(* Get default editor *)
let editor = (* If editor is not set, it gets "", but an exception is raised *)
    lazy (get_var ~exp:true "EDITOR")
;;

(* Level of verbosity, used by Messages module *)
let verbosity = ref 4;;
(* Use do not use colors *)
let no_color = ref false;;

(* Default place to read settings *)
let rc_file_default = Lazy.(home >>| (fun home -> home ^ "/" ^
    ".oclaunch_rc.json"));;
(* Current place to read settings, maybe modified from command line argument *)
let rc_file = ref rc_file_default;;
(* Set tmp file, in witch stock launches, in biniou format *)
let tmp_file = get_var ~default:"/tmp/.oclaunch_trace.dat" "OC_TMP";; (* File where launch are logged *)
